package com.zcreate.pinyin;


import com.zcreate.common.DictService;
import com.zcreate.common.pojo.Dict;
import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;
import org.apache.commons.beanutils.BeanUtils;

import java.lang.reflect.InvocationTargetException;
import java.util.*;

/**
 * className:PinyingUtil.java
 * classDescription:拼音操作工具类
 *
 * @author: 黄海晏 createTime:2010-10-21
 */

public class PinyinUtil {
    private static DictService dictServer;
    private List<ChineseWord> list = new ArrayList<ChineseWord>(3000);

    public void setDictServer(DictService dictServer) {
        PinyinUtil.dictServer = dictServer;
    }

    public void addWords(String str, Object ref) {
        list.add(new ChineseWord(str, ref));
    }

    public void clear() {
        list.clear();
    }

    public ChineseWord[] distinguish(String searchString) {
        List<ChineseWord> wordList = new ArrayList<>(20);
        if (searchString == null || "".equals(searchString))
            wordList.addAll(list);
        else if (PinyinUtil.isFullEnglish(searchString)) {
            char ch[] = searchString.toCharArray();
            for (ChineseWord word : list)
                for (int i = 0; i < word.getPinyin().length; i++)
                    if (distinguish(ch, 0, word.getPinyin()[i], 0, 0)) {
                        wordList.add(word);
                        break;
                    }
        } else {//中文
            for (ChineseWord word : list)
                if (word.getObjRef().toString().startsWith(searchString))
                    wordList.add(word);
        }

        ChineseWord[] words = new ChineseWord[wordList.size()];
        wordList.toArray(words);
        return words;
    }

    /**
     * 不完整拼音匹配算法，可用到汉字词组的自动完成
     * 拼音搜索匹配 huang hai yan  => huhy,hhy
     * 通过递归方法实现
     *
     * @param search 输入的拼音字母
     * @param pinyin 汉字拼音数组，通过pinyin4j获取汉字拼音 @see http://pinyin4j.sourceforge.net/
     * @return 匹配成功返回 true
     * @author 黄海晏
     */
    public static boolean distinguish(char[] search, int searchIndex, String pinyin[], int wordIndex, int wordStart) {
        if (searchIndex == 0)
            return search[0] == pinyin[0].charAt(0) &&//第一个必须匹配
                    (search.length == 1 || distinguish(search, 1, pinyin, 0, 1));//如果仅是1个字符，算匹配，否则从第二个字符开始比较

        if (pinyin[wordIndex].length() > wordStart//判断不越界
                && search[searchIndex] == pinyin[wordIndex].charAt(wordStart))//判断匹配
            return searchIndex == search.length - 1 ? distinguish(search, pinyin, wordIndex)//如果这是最后一个字符，检查之前的声母是否依次出现
                    : distinguish(search, searchIndex + 1, pinyin, wordIndex, wordStart + 1);//同一个字拼音连续匹配
        else if (pinyin.length > wordIndex + 1 //判断不越界
                && search[searchIndex] == pinyin[wordIndex + 1].charAt(0)) //不能拼音连续匹配的情况下，看看下一个字拼音的首字母是否能匹配
            return searchIndex == search.length - 1 ? distinguish(search, pinyin, wordIndex) //如果这是最后一个字符，检查之前的声母是否依次出现
                    : distinguish(search, searchIndex + 1, pinyin, wordIndex + 1, 1);//去判断下一个字拼音的第二个字母
        else if (pinyin.length > wordIndex + 1)//回退试试看  对于zhuang an lan  searchIndex > 1 &&
            for (int i = 1; i < searchIndex; i++)
                if (distinguish(search, searchIndex - i, pinyin, wordIndex + 1, 0)) return true;
        return false;
    }

    //优化：混合中文、拼音
    public static boolean distinguishExt(char[] search, int searchIndex, char[] chn, String pinyin[], int wordIndex, int wordStart) {
        if (searchIndex == 0)
            return (search[0] == pinyin[0].charAt(0) || search[0] == chn[0]) &&//第一个必须匹配
                    (search.length == 1 || distinguishExt(search, 1, chn, pinyin, 0, 1));//如果仅是1个字符，算匹配，否则从第二个字符开始比较

        if (pinyin[wordIndex].length() > wordStart//判断不越界
                && search[searchIndex] == pinyin[wordIndex].charAt(wordStart))//判断匹配
            return searchIndex == search.length - 1 ? distinguishExt(search, chn, pinyin, wordIndex)//如果这是最后一个字符，检查之前的声母是否依次出现
                    : distinguishExt(search, searchIndex + 1, chn, pinyin, wordIndex, wordStart + 1);//同一个字拼音连续匹配
        else if (pinyin.length > wordIndex + 1 //判断不越界
                && search[searchIndex] == pinyin[wordIndex + 1].charAt(0)) //不能拼音连续匹配的情况下，看看下一个字拼音的首字母是否能匹配
            return searchIndex == search.length - 1 ? distinguishExt(search, chn, pinyin, wordIndex) //如果这是最后一个字符，检查之前的声母是否依次出现
                    : distinguishExt(search, searchIndex + 1, chn, pinyin, wordIndex + 1, 1);//去判断下一个字拼音的第二个字母
        else if (pinyin.length > wordIndex + 1)//回退试试看  对于zhuang an lan  searchIndex > 1 &&
            for (int i = 1; i < searchIndex; i++)
                if (distinguishExt(search, searchIndex - i, chn, pinyin, wordIndex + 1, 0)) return true;
        return false;
    }

    /**
     * 辅佐函数，确保pinyin[n].charAt(0)(n<=wordIndex)都按顺序依次出现在search里面
     * 防止zhou ming zhong匹配zz，跳过了ming
     *
     * @param search
     * @param pinyin
     * @param wordIndex 已经匹配到拼音索引
     * @return 都按顺序依次出现了，返回true
     */
    private static boolean distinguish(char[] search, String pinyin[], int wordIndex) {
        String searchString = new String(search);
        int lastIndex = 0, i;
        for (i = 0; i < wordIndex; i++) {
            lastIndex = searchString.indexOf(pinyin[i].charAt(0), lastIndex);
            if (lastIndex == -1) return false;
            lastIndex++;
        }
        return true;
    }

    private static boolean distinguishExt(char[] search, char[] chn, String pinyin[], int wordIndex) {
        String searchString = new String(search);
        int lastIndex = 0,lastIndex2=0, i;
        for (i = 0; i < wordIndex; i++) {
            lastIndex = searchString.indexOf(pinyin[i].charAt(0), lastIndex);
            //lastIndex2 = searchString.indexOf(chn(i), lastIndex2);
            if (lastIndex == -1 && lastIndex2 == -1) return false;
            lastIndex++;
        }
        return true;
    }

    /**
     * 类似distinguish，任意匹配，不要求每个字第一个拼音必须匹配
     * 不完整拼音匹配算法，可用到汉字词组的自动完成
     * 拼音搜索匹配 huang hai yan  => huhy,hhy
     * 通过递归方法实现
     *
     * @param search 输入的拼音字母
     * @param pinyin 汉字拼音数组，通过pinyin4j获取汉字拼音 @see http://pinyin4j.sourceforge.net/
     * @return 匹配成功返回 true
     * @author 黄海晏
     */
   /* public static boolean distinguish2(char[] search, int searchIndex, String pinyin[], int wordIndex, int wordStart) {
        //if (searchIndex == 0)
        //  return  distinguish2(search, 1, pinyin, 0, 1);//如果仅是1个字符，算匹配，否则从第二个字符开始比较

        if (pinyin[wordIndex].length() > wordStart//判断不越界
                && search[searchIndex] == pinyin[wordIndex].charAt(wordStart))//判断匹配
            return distinguish2(search, searchIndex + 1, pinyin, wordIndex, wordStart + 1);//同一个字拼音连续匹配
        else if (pinyin.length > wordIndex + 1 //判断不越界
                && search[searchIndex] == pinyin[wordIndex + 1].charAt(0)) //不能拼音连续匹配的情况下，看看下一个字拼音的首字母是否能匹配
            return distinguish2(search, searchIndex + 1, pinyin, wordIndex + 1, 1);//去判断下一个字拼音的第二个字母
        else if (pinyin.length > wordIndex + 1)//回退试试看  对于zhuang an lan  searchIndex > 1 &&
            for (int i = 1; i < searchIndex; i++)
                if (distinguish2(search, searchIndex - i, pinyin, wordIndex + 1, 0)) return true;
        return false;
    }*/

    /**
     * 辅佐函数，确保pinyin[n].charAt(0)(n<=wordIndex)都按顺序依次出现在search里面
     * 防止zhou ming zhong匹配zz，跳过了ming
     *
     * @return 都按顺序依次出现了，返回true
     */
    /* private static boolean distinguish2(char[] search, String pinyin[], int wordIndex) {
            String searchString = new String(search);
            int lastIndex = 0;
            int i = 0;
            for (i = 0; i < wordIndex; i++) {
                lastIndex = searchString.indexOf(pinyin[i].charAt(0), lastIndex);
                if (lastIndex == -1) return false;
                lastIndex++;
            }
            return true;
        }
    */
    //test
    public static void main(String[] args) {
        String sd = "中国ab";
        char[] a = sd.toCharArray();
        for (char c : a) System.out.println("c = " + c);
        String pinyin[] = getPinyinInitial("曾长");
        for (String s : pinyin) System.out.println("s = " + s);
        //ChineseWord word = new ChineseWord("注射用氨苄西林钠氯唑西林钠");
        /*  boolean b = distinguish2("anb".toCharArray(), 0, word.getPinyin()[0], 0, 0);
    System.out.println("anb = " + b);
    b = distinguish2("xilin".toCharArray(), 0, word.getPinyin()[0], 0, 0);
    System.out.println("xilin = " + b);
    b = distinguish2("anxi".toCharArray(), 0, word.getPinyin()[0], 0, 0);
    System.out.println("anxi = " + b);
    b = distinguish2("zhuanl".toCharArray(), 0, word.getPinyin()[0], 0, 0);
    System.out.println("zhuanl = " + b);
    b = distinguish2("zs".toCharArray(), 0, word.getPinyin()[0], 0, 0);
    System.out.println("zs = " + b);//false，非连续匹配，跳过了安*/
    }

    public static String[] charToPinyin(char src) {
        // 创建汉语拼音处理类
        HanyuPinyinOutputFormat defaultFormat = new HanyuPinyinOutputFormat();
        // 输出设置，大小写，音标方式
        defaultFormat.setCaseType(HanyuPinyinCaseType.LOWERCASE);
        defaultFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE);

        // 如果是中文
        if (src > 128) {
            try {
                // 转换得出结果
                String[] strs = PinyinHelper.toHanyuPinyinStringArray(src, defaultFormat);
                if (strs == null) return new String[0];
                Map<String, String> map = new HashMap<String, String>();
                for (String str : strs) map.put(str, str);
                strs = new String[map.size()];
                map.values().toArray(strs);
                return strs;
            } catch (BadHanyuPinyinOutputFormatCombination e) {
                e.printStackTrace();
            }
        }

        return new String[0];
    }

    /**
     * @param pinyin 非矩形二维数组，一维代表汉字，二维代表该汉字的拼音
     * @param index  初始化全为0，长度等于pinyin的一位长度
     * @param list   存引用返回，递归调用
     * @return 矩形二维数组，各拼音的全组合
     */
    private static void combination(String[][] pinyin, int index[], List<String[]> list) {
        //先提取一行
        String[] comb1 = new String[index.length];
        for (int i = 0; i < index.length; i++) {
            comb1[i] = pinyin[i][index[i]];
        }
        list.add(comb1);
        //index增长
        for (int i = 0; i < index.length; i++)
            if (index[i] < pinyin[i].length - 1) {
                index[i]++;
                for (int j = 0; j < i; j++)  //之前的需要复位为0
                    index[j] = 0;
                combination(pinyin, index, list);
                break;
            }
    }

    public static String[] getPinyinInitial(String src) {
        char[] srcChar = src.toCharArray();
        //String wordPinyin[][] = new String[srcChar.length][];//每个字的拼音，单音字长度为1
        List<String[]> pinyinList = new ArrayList<String[]>();

        //获取各字的拼音
        for (char c : srcChar) {
            //for (int i = 0; i < srcChar.length; i++) {
            // wordPinyin[i] = PinyinUtil.charToPinyin(srcChar[i]);
            if (c > 128) {
                String[] py = PinyinUtil.charToPinyin(c);
                if (py.length > 0) pinyinList.add(py);
            } else if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')) {
                String[] s = new String[1];
                s[0] = c + "";
                pinyinList.add(s);
            }
        }
        String[][] wordPY = new String[pinyinList.size()][];
        pinyinList.toArray(wordPY);

        //组合
        int[] index = new int[wordPY.length];
        // for (int i = 0; i < index.length; i++) index[i] = 0;
        List<String[]> list = new ArrayList<String[]>();
        combination(wordPY, index, list);

        /* String pinyin[][] = new String[list.size()][];
        list.toArray(pinyin);*/
        Set<String> initialSet = new HashSet<String>(list.size());
        // String[] initialArray = new String[list.size()];
        for (String[] str : list) {
            byte[] initial = new byte[str.length];
            for (int j = 0; j < str.length; j++) initial[j] = str[j].getBytes()[0];
            initialSet.add(new String(initial));
        }
        String[] initialArray = new String[initialSet.size()];
        initialSet.toArray(initialArray);
        return initialArray;
    }

    public static boolean isFullEnglish(String s) {
        return s == null || s.length() == s.getBytes().length;
    }

    @SuppressWarnings("unchecked")
    public static void replaceName(List list, String propertyName) {
        Dict dict = dictServer.getDictByNo("44444");
        if (dict != null && "1".equals(dict.getValue()))
            try {
                for (int i = 0; i < list.size(); i++) {
                    Object obj = list.get(i);
                    if (obj instanceof HashMap) {
                        String name = (String) ((HashMap) obj).get(propertyName);
                        if (name != null) {
                            String pinyin[] = getPinyinInitial(name);
                            name = name.substring(0, 1) + pinyin[0].substring(1);
                            // System.out.println("name = " + name);
                            ((HashMap) obj).put(propertyName, name);
                            list.set(i, obj);
                        }
                    } else {
                        String name = BeanUtils.getProperty(obj, propertyName);
                        // System.out.println("name = " + name);
                        if (name != null && name.length() > 1) {
                            String pinyin[] = getPinyinInitial(name);
                            name = name.substring(0, 1) + pinyin[0].substring(1);
                            //System.out.println("name = " + name);
                            BeanUtils.setProperty(obj, propertyName, name);
                            list.set(i, obj);
                        }
                    }
                }
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (InvocationTargetException e) {
                e.printStackTrace();
            } catch (NoSuchMethodException e) {
                e.printStackTrace();
            }
    }

    public static String replaceName(String name) {
        if (name == null || name.length() <= 1) return name;
        Dict dict = dictServer.getDictByNo("44444");
        if (dict != null && "1".equals(dict.getValue())) {
            String pinyin[] = getPinyinInitial(name);
            return name.substring(0, 1) + pinyin[0].substring(1);
        } else return name;
    }
}
