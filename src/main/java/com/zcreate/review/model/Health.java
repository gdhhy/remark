package com.zcreate.review.model;

import java.io.Serializable;

/**
 * 药理分类
 * User: 黄海晏
 * Date: 11-11-14
 * Time: 下午2:58
 */
public class Health implements Comparable, Serializable {
    private Integer healthID;
    private Integer parentID;
    private String healthNo;
    private String chnName;
    private String engName;
    private String pinyin;
    private Boolean hasChild=false;
    private Integer layer;
    private Integer orderID;

    public Integer getHealthID() {
        return healthID;
    }

    public void setHealthID(Integer healthID) {
        this.healthID = healthID;
    }

    public Integer getParentID() {
        return parentID;
    }

    public void setParentID(Integer parentID) {
        this.parentID = parentID;
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

    public Integer getOrderID() {
        return orderID;
    }

    public void setOrderID(Integer orderID) {
        this.orderID = orderID;
    }

    public int compareTo(Object object) {
        if (this == object) {
            return 0;
        }
        if (object != null && object instanceof Health) {
            Health health = (Health) object;
            if (getLayer() < health.getLayer()) return 1;
            if (getLayer().equals(health.getLayer())) {
                if (getOrderID() < health.getOrderID()) return 1;
                else if (getOrderID().equals(health.getOrderID())) {
                    if (getHealthID() < health.getHealthID()) return 1;
                    else if (getHealthID().equals(health.getHealthID())) return 0;
                    else return -1;
                } else return -1;
            } else
                return -1;
        } else
            return 1;
    }
}
