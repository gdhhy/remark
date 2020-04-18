package com.zcreate.review.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * User: 黄海晏
 * Date: 11-11-19
 * instructionID自增长分配：
 * 翁源30万-31万：300000-309999
 * 粤北二院31万-32万：310000-319999
 * 潮州32万-33万：320000-329999
 * 南雄33万-34万：330000-339999
 * 新丰34万-35万：340000-349999
 */
public class Instruction implements Serializable {
    private Integer instructionID;
    private String healthNo;
    private String chnName;
    private String engName;
    private String pinyin;
    //是否有说明书
    private Boolean hasInstruction = false;
    //说明书
    private String instruction;
    //适应症
    private String indication;
    //药理毒理
    private String pharmacology;
    //不良反应
    private String untowardEffect;
    //禁忌
    private String taboo;
    //作用与用途
    private String usage;
    //相互作用
    private String reciprocity;
    //用法用量
    private String dosage;
    //剂型,！！！通用名不要剂型
    private String dose;
    //匹配通用名
    //注意：通用名可以有多个
    private Integer generalInstrID;
    //是通用名
    private int general = 0;
    //是否完成
    private int finish = 0;
    private Timestamp updateTime;
    private Timestamp createDate;
    private String createUser;
    private String updateUser;
    //来源：现代临床药物大典，厂家说明书等
    private String source;
    private String authCode;
    private String deployLocation;
    private Integer refID;
    //
    private String producer;
    private String healthName;
    //查询用
    private String matchGeneralName;
    /*  private String matchSource;
private String matchProducer;
private Boolean matchInstruction;  */

    public Integer getInstructionID() {
        return instructionID;
    }

    public void setInstructionID(Integer instructionID) {
        this.instructionID = instructionID;
    }

    public String getHealthNo() {
        return healthNo;
    }

    public void setHealthNo(String healthNo) {
        this.healthNo = healthNo;
    }

    public String getChnName() {
        return chnName;
    }

    public void setChnName(String chnName) {
        this.chnName = chnName;
    }

    public String getEngName() {
        return engName;
    }

    public void setEngName(String engName) {
        this.engName = engName;
    }

    public String getPinyin() {
        return pinyin;
    }

    public void setPinyin(String pinyin) {
        this.pinyin = pinyin;
    }

    public Boolean getHasInstruction() {
        return hasInstruction;
    }

    public void setHasInstruction(Boolean hasInstruction) {
        this.hasInstruction = hasInstruction;
    }

    public String getInstruction() {
        return instruction;
    }

    public void setInstruction(String instruction) {
        this.instruction = instruction;
    }

    public String getIndication() {
        return indication;
    }

    public void setIndication(String indication) {
        this.indication = indication;
    }

    public String getPharmacology() {
        return pharmacology;
    }

    public void setPharmacology(String pharmacology) {
        this.pharmacology = pharmacology;
    }

    public String getUntowardEffect() {
        return untowardEffect;
    }

    public void setUntowardEffect(String untowardEffect) {
        this.untowardEffect = untowardEffect;
    }

    public String getTaboo() {
        return taboo;
    }

    public void setTaboo(String taboo) {
        this.taboo = taboo;
    }

    public String getUsage() {
        return usage;
    }

    public void setUsage(String usage) {
        this.usage = usage;
    }

    public String getReciprocity() {
        return reciprocity;
    }

    public void setReciprocity(String reciprocity) {
        this.reciprocity = reciprocity;
    }

    public String getDosage() {
        return dosage;
    }

    public void setDosage(String dosage) {
        this.dosage = dosage;
    }

    public String getDose() {
        return dose;
    }

    public void setDose(String dose) {
        this.dose = dose;
    }

    public Integer getGeneralInstrID() {
        return generalInstrID;
    }

    public void setGeneralInstrID(Integer generalInstrID) {
        this.generalInstrID = generalInstrID;
    }

    public int getGeneral() {
        return general;
    }

    public void setGeneral(int generalName) {
        general = generalName;
    }

    public int getFinish() {
        return finish;
    }

    public void setFinish(int finish) {
        this.finish = finish;
    }

    public Timestamp getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Timestamp updateTime) {
        this.updateTime = updateTime;
    }

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getProducer() {
        return producer;
    }

    public void setProducer(String producer) {
        this.producer = producer;
    }

    public String getHealthName() {
        return healthName;
    }

    public void setHealthName(String healthName) {
        this.healthName = healthName;
    }

    //----------------
    public String getMatchGeneralName() {
        return matchGeneralName;
    }

    public void setMatchGeneralName(String matchGeneralName) {
        this.matchGeneralName = matchGeneralName;
    }

    /*
 public Boolean getMatchInstruction() {
     return matchInstruction;
 }

 public void setMatchInstruction(Boolean matchInstruction) {
     this.matchInstruction = matchInstruction;
 }

 public String getMatchSource() {
     return matchSource;
 }

 public void setMatchSource(String matchSource) {
     this.matchSource = matchSource;
 }

 public String getMatchProducer() {
     return matchProducer;
 }

 public void setMatchProducer(String matchProducer) {
     this.matchProducer = matchProducer;
 }   */
    public static void main(String[] args) {
        String a = "?阿斯顿发顺丰";
        if (a.startsWith("\\?")) System.out.println("a.substring(1) = " + a.substring(1));
        else System.out.println("a = " + a);
    }

    public String getDeployLocation() {
        return deployLocation;
    }

    public void setDeployLocation(String deployLocation) {
        this.deployLocation = deployLocation;
    }

    public Integer getRefID() {
        return refID;
    }

    public void setRefID(Integer refID) {
        this.refID = refID;
    }

    public String getAuthCode() {
        return authCode;
    }

    public void setAuthCode(String authCode) {
        this.authCode = authCode;
    }
}
