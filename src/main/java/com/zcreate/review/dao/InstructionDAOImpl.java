package com.zcreate.review.dao;

import com.zcreate.ReviewConfig;
import com.zcreate.common.DictService;
import com.zcreate.common.pojo.Dict;
import com.zcreate.review.model.Instruction;
import com.zcreate.util.StringUtils;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 11-12-1
 * Time: 下午9:28
 */
public class InstructionDAOImpl extends SqlSessionDaoSupport implements InstructionDAO, Serializable {
    //static Logger logger = Logger.getLogger(InstructionDAOImpl.class);
    private static ReviewConfig reviewConfig;

    private DictService dictServer;

    @Autowired
    public void setReviewConfig(ReviewConfig reviewConfig) {
        InstructionDAOImpl.reviewConfig = reviewConfig;
    }

    public void setDictServer(DictService dictServer) {
        this.dictServer = dictServer;
    }

    public int save(Instruction instruction) {
        instruction.setDeployLocation(reviewConfig.getDeployLocation());
        instruction.setInstruction(instruction.getInstruction().replaceAll("\n\n", "\n"));
        instruction.setInstruction(instruction.getInstruction().replaceAll("((?i)<br>\\s*){2,}", "<br>"));//(?i)abc 表示abc都忽略大小写
        return getSqlSession().update("Instruction.updateInstructionByPrimaryKeySelective", instruction);
    }

    public int deleteByPrimaryKey(Integer instructionID) {
        return getSqlSession().delete("Instruction.deleteInstruction", instructionID);
    }

    public void insert(Instruction instruction) {
        instruction.setDeployLocation(reviewConfig.getDeployLocation());
        instruction.setInstruction(instruction.getInstruction().replaceAll("\n\n", "\n"));
        instruction.setInstruction(instruction.getInstruction().replaceAll("((?i)<br>\\s*){2,}", "<br>"));
        getSqlSession().insert("Instruction.insertInstruction", instruction);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String,Object>> query(Map param) {
        if (param.size() <= 2 && ((param.get("start")) == null || ((Integer) param.get("start")) < 1000 || param.get("start") == null))//后面的日期比较集中，更新时间难以分页标识
            param.put("orderField", "updateTime");
        else
            param.put("orderField", "instructionID");
        return getSqlSession().selectList("Instruction.queryInstruction", param);
    }

    public int queryCount(Map param) {
        return (Integer) getSqlSession().selectOne("Instruction.queryInstructionCount", param);
    }

    /**
     * 提取编缉用
     *
     * @return 说明书原文
     */
    public Instruction getInstruction(Integer instructionID) {
        Instruction inst = getSqlSession().selectOne("Instruction.viewInstructionByID", instructionID);
        Dict dict = dictServer.getDictByNo("44446");
        if (dict != null && inst != null && inst.getInstruction() != null) {
            inst.setInstruction(inst.getInstruction().replaceAll("((【|\\[).{1,10}?(】|\\]))(?!((?i)</font>|(?i)</div>|(?i)</span>))", dict.getValue()));//<br>$1
            inst.setInstruction(inst.getInstruction().replaceAll("(?i)</P>\\s*(?i)<P>", "<br>"));
            inst.setInstruction(inst.getInstruction().replaceAll("((?i)<br>\\s*){2,}", "<br>"));
            inst.setInstruction(inst.getInstruction().replaceAll("(?i)<P>", ""));
        }
        return inst;
    }

    /**
     * 显示说明书
     *
     * @return 美化一下说明书
     */
    public Instruction viewInstruction(Integer instructionID) {
        Instruction inst = getSqlSession().selectOne("Instruction.viewInstructionByID", instructionID);
        Dict dict = dictServer.getDictByNo("44445");
        if (dict != null && inst != null && inst.getInstruction() != null)
            // if (inst.getChnName())
            //包含【】但不紧跟 </font>、</div>、</span>,即是说被富文本编缉包含的，不再用蓝色,   (?i)为忽略大小写
            inst.setInstruction(inst.getInstruction().replaceAll("((【|\\[).{1,10}?(】|\\]))(?!((?i)</font>|(?i)</div>|(?i)</span>))", dict.getValue()));//<div style='color:blue;font-size: 12;font-weight: bold'>$1</div>

        //splitProducer();
        return inst;
    }

    public Instruction viewInstrByGeneralInstrID(Integer instructionID) {
        Instruction inst = getSqlSession().selectOne("Instruction.viewInstrByGeneralInstrID", instructionID);
        Dict dict = dictServer.getDictByNo("44445");
        if (dict != null && inst != null && inst.getInstruction() != null)
            inst.setInstruction(inst.getInstruction().replaceAll("((【|\\[).{1,10}?(】|\\]))(?!((?i)</font>|(?i)</div>|(?i)</span>))", dict.getValue()));

        return inst;
    }

    public int doSetNewGeneral(Integer newGeneralID, Integer oldGeneralID) {
        Map<String, Integer> param = new HashMap<>();
        param.put("newGeneralID", newGeneralID);
        param.put("oldGeneralID", oldGeneralID);
        return getSqlSession().update("Instruction.setNewGeneral", param);
    }

    public int splitProducer() {
        /*Pattern regex = Pattern.compile("(?:【生(?:.{1,6}?)】|【厂家】|【企业名称】|\\[生产企业\\]|生产企业(?:|：) |企业名称(?:|：))\\s*(?:.{0,7}：)?" +
                "([\\u4E00-\\u9FA5|。|\\(|\\)|、]{2,30}|(?:\\w+| |-|\\.|/){2,10})(?:\\s+|\\(|$)");*/    //成功，2400多条
        Pattern regex = Pattern.compile("(?:【生(?:.{1,6}?)】|【厂家】|【企业名称】|\\[生产企业\\]|生产企业[:：] |企业名称[:：])" +
                "\\s*(?:[\\u4E00-\\u9FA5]{1,6}[:：])?(.{2,100}?)(?:\n|\r|【|$)");//3009
        Map<String, Object> param = new HashMap<>();
        param.put("hasInstruction", 1);
        param.put("nullSource", 1);
        param.put("limit", 20000);
        List<HashMap<String,Object>> list = query(param);
        for (HashMap inst : list) {
            String producer = "";
            Matcher m = regex.matcher(StringUtils.replaceHtml(inst.get("instruction").toString().replaceAll("<br>|<br/>|<br />|<p>|</p>", "\n")));
            while (m.find() && m.groupCount() == 1)
                if (m.group(1).trim().length() > producer.length())
                    producer = m.group(1).trim();

            if (producer.length() > 0) {
                System.out.println(", producer:" + producer);
                Instruction instruction = new Instruction();
                instruction.setInstructionID((Integer) inst.get("instructionID"));
                instruction.setProducer(producer);
                save(instruction);
            } else
                System.out.println(", not found producer");
        }
        return 0;
    }

    @SuppressWarnings("unchecked")
    public List<String> getSourceList() {
        return getSqlSession().selectList("Instruction.selectSource");
    }

    @SuppressWarnings("unchecked")
    public List<String> getProducerList() {
        return getSqlSession().selectList("Instruction.selectProducer");
    }
}
