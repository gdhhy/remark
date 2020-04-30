package com.zcreate.review.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 11-12-26
 * Time: 下午4:54
 */
public class Incompatibility implements Serializable {
    private Integer incompatibilityID;
    private Integer drugID1;
    private Integer drugID2;
    private String level;
    private Integer inBody;
    private String result;
    private String mechanism;
    private String source;
    private Timestamp updateTime;
    private Integer warning;
    //扩展属性
  /*  private String medicine1Name;
    private String medicine2Name;*/

    public Integer getIncompatibilityID() {
        return incompatibilityID;
    }

    public void setIncompatibilityID(Integer incompatibilityID) {
        this.incompatibilityID = incompatibilityID;
    }

    public Integer getDrugID1() {
        return drugID1;
    }

    public void setDrugID1(Integer drugID1) {
        this.drugID1 = drugID1;
    }

    public Integer getDrugID2() {
        return drugID2;
    }

    public void setDrugID2(Integer drugID2) {
        this.drugID2 = drugID2;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getMechanism() {
        return mechanism;
    }

    public void setMechanism(String mechanism) {
        this.mechanism = mechanism;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public Timestamp getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Timestamp updateTime) {
        this.updateTime = updateTime;
    }

    public Integer getInBody() {
        return inBody;
    }

    public void setInBody(Integer inBody) {
        this.inBody = inBody;
    }
/*  public String getMedicine1Name() {
        return medicine1Name;
    }

    public void setMedicine1Name(String medicine1Name) {
        this.medicine1Name = medicine1Name;
    }

    public String getMedicine2Name() {
        return medicine2Name;
    }

    public void setMedicine2Name(String medicine2Name) {
        this.medicine2Name = medicine2Name;
    }*/

    public Integer getWarning() {
        return warning;
    }

    public void setWarning(Integer warning) {
        this.warning = warning;
    }
}
