package com.zcreate.remark.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Pacs implements Serializable {
    //select  A.xType,A.checkTime,A.checkBody, A.checkDesc,A.checkResult,B.Report_doc doctorName
    private Integer xType;
    private Timestamp checkTime;
    private String checkBody;
    private String checkDesc;
    private String checkResult;
    private String doctorName;

    public Integer getxType() {
        return xType;
    }

    public void setxType(Integer xType) {
        this.xType = xType;
    }

    public Timestamp getCheckTime() {
        return checkTime;
    }

    public void setCheckTime(Timestamp checkTime) {
        this.checkTime = checkTime;
    }

    public String getCheckBody() {
        return checkBody;
    }

    public void setCheckBody(String checkBody) {
        this.checkBody = checkBody;
    }

    public String getCheckDesc() {
        return checkDesc;
    }

    public void setCheckDesc(String checkDesc) {
        this.checkDesc = checkDesc;
    }

    public String getCheckResult() {
        return checkResult;
    }

    public void setCheckResult(String checkResult) {
        this.checkResult = checkResult;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }
}
