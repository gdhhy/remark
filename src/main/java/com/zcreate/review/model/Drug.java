package com.zcreate.review.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 11-12-12
 * Time: 下午2:53
 * DrugID：自增长设置
 * 翁源30K-31K：30000-30999
 * 粤北二院31K-32K：31000-31999
 * 潮州32K-33K：32000-32999
 * 南雄33K-34K：33000-33999
 * 新丰34K-35K：34000-34999
 */
public class Drug implements Serializable {
    private Integer drugID;
    private String pinyin;
    private String healthNo;
    private String chnName;
    private String engName;
    //--包装单位，瓶、盒、支
    private String packUnit;
    //private String dose;
    //孕妇
    private Integer gravida;
    //哺乳期
    private Integer lactation;
    //老年人
    private Integer oldFolks;
    private Integer children;
    //肝功能不全
    private Integer liver;
    //肾功能不全
    private Integer kidney;
    //最大剂量：最大有效量
    private Float maxEffectiveDose;
    //极量   http://210.36.99.24/jpkc1/jcnr/02_02.htm
    private Float maxDose;
    //计量单位
    private String measureUnit;
    //--doseUnit  varchar(20), --剂量单位
    //极量时的频率
    private String frequency;
    //基本药物
    private Integer base;
    //是否通用名
    private Integer general;//todo: 这里不都是通用名吗？
    private Float ddd;
    //辅助用药
    private Integer adjuvantDrug;
    //抗菌药级别，是否限制使用
    private Integer antiClass;
    private String drugtype;
    //--说明书ID
    //private Integer instructionID;
    private Timestamp updateTime=new Timestamp(System.currentTimeMillis());
    private String memo;
    //非属性 ，查询用
    //private String instructionName;
    private String healthName;
    //具有配伍禁忌的药品数量
    private Integer incompNum;

    private String updateUser;
    private Boolean valid = Boolean.TRUE;
    private String deployLocation;
    private List<DrugDose> drugDose;

    public Integer getDrugID() {
        return drugID;
    }

    public void setDrugID(Integer drugID) {
        this.drugID = drugID;
    }

    public String getPinyin() {
        return pinyin;
    }

    public void setPinyin(String pinyin) {
        this.pinyin = pinyin;
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

    public String getPackUnit() {
        return packUnit;
    }

    public void setPackUnit(String packUnit) {
        this.packUnit = packUnit;
    }

    public String getDose() {
        String value = "";
        for (int i = 0; i < drugDose.size(); i++) {
            if (drugDose.get(i).getDose() != null) {
                value += drugDose.get(i).getDose();
                if (i != drugDose.size() - 1) value += ";";
            }
        }
        return value;
    }

    /* public void setDose(String dose) {
        this.dose = dose;
    }*/

    public Integer getGravida() {
        return gravida;
    }

    public void setGravida(Integer gravida) {
        this.gravida = gravida;
    }

    public Integer getLactation() {
        return lactation;
    }

    public void setLactation(Integer lactation) {
        this.lactation = lactation;
    }

    public Integer getOldFolks() {
        return oldFolks;
    }

    public void setOldFolks(Integer oldFolks) {
        this.oldFolks = oldFolks;
    }

    public Integer getChildren() {
        return children;
    }

    public void setChildren(Integer children) {
        //System.out.println("children = " + children);
        this.children = children;
    }

    public Integer getLiver() {
        return liver;
    }

    public void setLiver(Integer liver) {
        this.liver = liver;
    }

    public Integer getKidney() {
        return kidney;
    }

    public void setKidney(Integer kidney) {
        this.kidney = kidney;
    }

    public Float getMaxEffectiveDose() {
        return maxEffectiveDose;
    }

    public void setMaxEffectiveDose(Float maxEffectiveDose) {
        this.maxEffectiveDose = maxEffectiveDose;
    }

    public Float getMaxDose() {
        return maxDose;
    }

    public void setMaxDose(Float maxDose) {
        this.maxDose = maxDose;
    }

    public String getMeasureUnit() {
        return measureUnit;
    }

    public void setMeasureUnit(String measureUnit) {
        this.measureUnit = measureUnit;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public Integer getBase() {
        return base;
    }

    public void setBase(Integer base) {
        //  System.out.println("base = " + base);
        this.base = base;
    }

    public Integer getGeneral() {
        return general;
    }

    public void setGeneral(Integer general) {
        // System.out.println("general = " + general);
        this.general = general;
    }

    public Float getDdd() {
        return ddd;
    }

    public void setDdd(Float ddd) {
        this.ddd = ddd;
    }

    public Integer getAdjuvantDrug() {
        return adjuvantDrug;
    }

    public void setAdjuvantDrug(Integer adjuvantDrug) {
        this.adjuvantDrug = adjuvantDrug;
    }

    public Integer getAntiClass() {
        return antiClass;
    }

    public void setAntiClass(Integer antiClass) {
        this.antiClass = antiClass;
    }

    public String getDrugtype() {
        return drugtype;
    }

    public void setDrugtype(String drugtype) {
        this.drugtype = drugtype;
    }

    /* public Integer getInstructionID() {
        return instructionID;
    }

    public void setInstructionID(Integer instructionID) {
        this.instructionID = instructionID;
    }*/

    public Timestamp getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Timestamp updateTime) {
        this.updateTime = updateTime;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public String getInstructionName() {
        String value = "";
        for (int i = 0; i < drugDose.size(); i++) {
            if (drugDose.get(i).getInstructionName() != null) {
                value += drugDose.get(i).getInstructionName();
                if (i != drugDose.size() - 1) value += ";";
            }
        }
        return value;
    }

    /* public void setInstructionName(String instructionName) {
        this.instructionName = instructionName;
    }*/

    public String getHealthName() {
        return healthName;
    }

    public void setHealthName(String healthName) {
        this.healthName = healthName;
    }

    public Integer getIncompNum() {
        return incompNum;
    }

    public void setIncompNum(Integer incompNum) {
        this.incompNum = incompNum;
    }

    public Boolean getValid() {
        return valid;
    }

    public void setValid(Boolean valid) {
        this.valid = valid;
    }

    public List<DrugDose> getDrugDose() {
        return drugDose;
    }

    public void setDrugDose(List<DrugDose> drugDose) {
        this.drugDose = drugDose;
    }

    public String getDeployLocation() {
        return deployLocation;
    }

    public void setDeployLocation(String deployLocation) {
        this.deployLocation = deployLocation;
    }
}
