package com.zcreate.common.pojo;

import java.io.Serializable;

/**
 * 药品类别
 * User: 黄海晏
 * Date: 11-11-14
 * Time: 下午2:58
 */
public class Dict implements Comparable, Serializable {
    private Integer dictID;
    private Integer appID;
    private String dictNo;
    private String name;
    private String value;
    private String note;
    private Integer parentID;
    private Boolean hasChild = false;
    private Integer layer;
    private Double orderNum;

    public Integer getDictID() {
        return dictID;
    }

    public void setDictID(Integer dictID) {
        this.dictID = dictID;
    }

    public Integer getParentID() {
        return parentID;
    }

    public void setParentID(Integer parentID) {
        this.parentID = parentID;
    }

    public String getDictNo() {
        return dictNo;
    }

    public void setDictNo(String dictNo) {
        this.dictNo = dictNo;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Boolean getHasChild() {
        return hasChild;
    }

    public void setHasChild(Boolean hasChild) {
        this.hasChild = hasChild;
    }

    public Integer getLayer() {
        return layer;
    }

    public void setLayer(Integer layer) {
        this.layer = layer;
    }

    public Integer getAppID() {
        return appID;
    }

    public void setAppID(Integer appID) {
        this.appID = appID;
    }

    public Double getOrderNum() {
        return orderNum;
    }

    public void setOrderNum(Double orderNum) {
        this.orderNum = orderNum;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public int compareTo(Object object) {
        if (this == object) {
            return 0;
        }
        if (object != null && object instanceof Dict) {
            Dict dict = (Dict) object;
            if (getLayer() < dict.getLayer()) return 1;
            if (getLayer().equals(dict.getLayer())) {
                if (getOrderNum() < dict.getOrderNum()) return 1;
                else return -1;
            } else
                return -1;
        } else
            return 1;
    }
}
