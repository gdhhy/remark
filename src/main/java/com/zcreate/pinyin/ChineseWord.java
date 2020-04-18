package com.zcreate.pinyin;


import java.util.ArrayList;
import java.util.List;

/**
 * User: 黄海晏
 * Date: 2010-12-6
 * Time: 20:28:03
 */
public class ChineseWord {
    private String chinese;
    private String[][] pinyin;//多音字，曾长，曾2个音，长也2个音，数组的1维长度为4
    private Object objRef;

    ChineseWord(String str, Object ref) {
        chinese = str;
        objRef=ref;
        char[] srcChar = str.toCharArray();
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

        pinyin = new String[list.size()][];
        list.toArray(pinyin);
    }

    /**
     * @param pinyin 非矩形二维数组，一维代表汉字，二维代表该汉字的拼音
     * @param index  初始化全为0，长度等于pinyin的一位长度
     * @return 矩形二维数组，各拼音的全组合
     */
    private void combination(String[][] pinyin, int index[], List<String[]> list) {
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

    @Override
    public String toString() {
        return chinese;
    }

    public String[][] getPinyin() {
        return pinyin;
    }/*

    public static void main(String[] args) {
        ChineseWord word = new ChineseWord("长曾和");
    }*/

    public Object getObjRef() {
        return objRef;
    }
}
