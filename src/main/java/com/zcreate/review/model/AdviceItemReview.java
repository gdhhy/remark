package com.zcreate.review.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Created with IntelliJ IDEA.
 * User: hhy
 * Date: 14-1-5
 * Time: 下午6:37
 * @deprecated
 */
public class AdviceItemReview implements Serializable {
    private Integer adviceItemReviewID;
    private String hospID;
    private Integer orderID;
    private Integer groupID;
    private Integer longAdvice;
    private String advice;//医嘱内容（药品名称）
    private String usage;//用法,抄adviceType原来Sig:后面的
    private Float quantity;//每次量（支、片的数量）

    private Float dosis;//一次剂量,要么用s，use……，要么用每次量*含量，单位g，遇到mg，转换为g
    private String frequency;//频率
    private Integer dayNum;//用药天数，通过adviceDate,endDate计算
    private Float totalQuantity;//总用量=dosis*frequency*dayNum
    private String route;//给药途径
    private String menstruum;//溶媒
    private Integer purpose = 0;//预防、治疗
    private String problemCode;
    private String problemDesc;
    //sql：adviceItemReviewID,hospID,orderID,groupID,longAdvice,advice,usage,quantity,dosis,frequency,dayNum,totalQuantity,route,menstruum,purpose,problemCode,problemDesc
    ////////////////////////////
    private Timestamp adviceDate;
    private Timestamp endDate;
    private String adviceType;//准备删除 用法,抄原来Sig:后面的

    public Integer getAdviceItemReviewID() {
        return adviceItemReviewID;
    }

    public void setAdviceItemReviewID(Integer adviceItemReviewID) {
        this.adviceItemReviewID = adviceItemReviewID;
    }

    public String gethospID() {
        return hospID;
    }

    public void sethospID(String hospID) {
        this.hospID = hospID;
    }

    public Integer getOrderID() {
        return orderID;
    }

    public void setOrderID(Integer orderID) {
        this.orderID = orderID;
    }

    public Integer getLongAdvice() {
        return longAdvice;
    }

    public void setLongAdvice(Integer longAdvice) {
        this.longAdvice = longAdvice;
    }

    public String getProblemCode() {
        return problemCode;
    }

    public void setProblemCode(String problemCode) {
        this.problemCode = problemCode;
    }

    public String getProblemDesc() {
        return problemDesc;
    }

    public void setProblemDesc(String problemDesc) {
        this.problemDesc = problemDesc;
    }

    public Integer getPurpose() {
        return purpose;
    }

    public void setPurpose(Integer purpose) {
        this.purpose = purpose;
    }

    public String getMenstruum() {
        return menstruum;
    }

    public void setMenstruum(String menstruum) {
        this.menstruum = menstruum;
    }
    ////////////////////////////

    public Long getAdviceDate() {
        if (adviceDate != null)
            return adviceDate.getTime();
        else return 0L;
    }

    public void setAdviceDate(Timestamp adviceDate) {
        this.adviceDate = adviceDate;
    }

    public Long getEndDate() {
        if (endDate != null)
            return endDate.getTime();
        else
            return 0L;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public String getAdvice() {
        return advice;
    }

    public void setAdvice(String advice) {
        this.advice = advice;
    }

    public String getAdviceType() {
        return adviceType;
    }

    public void setAdviceType(String adviceType) {
        this.adviceType = adviceType;
    }

    public Integer getDayNum() {
        return dayNum;
    }

    public void setDayNum(Integer dayNum) {
        this.dayNum = dayNum;
    }

    public Float getQuantity() {
        return quantity;
    }

    public void setQuantity(Float quantity) {
        this.quantity = quantity;
    }

    public String getRoute() {
        return route;
    }

    public void setRoute(String route) {
        this.route = route;
    }

    /*
        public Float getEachQuantity() {
            return eachQuantity;
        }

        public void setEachQuantity(Float eachQuantity) {
            this.eachQuantity = eachQuantity;
        }
    */
    public Integer getGroupID() {
        return groupID;
    }

    public void setGroupID(Integer groupID) {
        this.groupID = groupID;
    }

    public Float getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(Float totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public Float getDosis() {
        return dosis;
    }

    public String getUsage() {
        return usage;
    }

    public void setUsage(String usage) {
        this.usage = usage;
    }

    public void setDosis(Float dosis) {
        this.dosis = dosis;
    }
}
