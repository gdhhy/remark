package com.zcreate.review.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Remark implements Serializable {
    private int remarkID;
    private int objectID;
    private String objectType;
    private String remarkType;
    private String remark;
    private Timestamp remartTime;

    public int getRemarkID() {
        return remarkID;
    }

    public void setRemarkID(int remarkID) {
        this.remarkID = remarkID;
    }

    public int getObjectID() {
        return objectID;
    }

    public void setObjectID(int objectID) {
        this.objectID = objectID;
    }

    public String getObjectType() {
        return objectType;
    }

    public void setObjectType(String objectType) {
        this.objectType = objectType;
    }

    public String getRemarkType() {
        return remarkType;
    }

    public void setRemarkType(String remarkType) {
        this.remarkType = remarkType;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public Timestamp getRemartTime() {
        return remartTime;
    }

    public void setRemartTime(Timestamp remartTime) {
        this.remartTime = remartTime;
    }
}
