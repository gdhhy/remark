package com.zcreate.review.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * User: 黄海晏
 * Date: 12-8-15
 */
public class RecipeItem implements Serializable {
    private Integer recipeItemID;
    private String serialNo;
    //private String recipeNo;    //住院：领用单号，门诊：空白
    private Integer longAdvice;//长期医嘱：1,   临时医嘱：2
    private Timestamp recipeDate;//对应 kyzsj
    private String advice;//医嘱信息 ，对应yzxx
    private Integer goodsID;
    private String doctorName;//开医嘱医生
    private String nurseName;
    private Timestamp endDate;  //医嘱结束日期
    private String endDoctorName;//停医嘱医生
    private String endNurseName;
    private String quantity;//数量---对应：Sl
    private String unit;
    private String problemCode;
    private String problemDesc;
    private String dose;
    private String producer;

    public Integer getAntiClass() {
        return antiClass;
    }

    public void setAntiClass(Integer antiClass) {
        this.antiClass = antiClass;
    }

    private Integer antiClass; //药品类型
    //医嘱类型
    private String adviceType;  //对应 yfbz

    private Integer orderID;
    private Integer groupID;
    //private Integer groupNum = 0; //本组数量
    //查询
    private Integer instructionID;
    private String medicineName;
    private Double contents;//药品含量

    private Boolean incompatibility;
    private String taboo;

    public Integer getRecipeItemID() {
        return recipeItemID;
    }

    public void setRecipeItemID(Integer recipeItemID) {
        this.recipeItemID = recipeItemID;
    }

    public String getSerialNo() {
        return serialNo;
    }

    public void setSerialNo(String serialNo) {
        this.serialNo = serialNo;
    }


    public Integer getLongAdvice() {
        return longAdvice;
    }

    public void setLongAdvice(Integer longAdvice) {
        this.longAdvice = longAdvice;
    }

    public Timestamp getRecipeDate() {
        return recipeDate;
    }

    public void setRecipeDate(Timestamp recipeDate) {
        this.recipeDate = recipeDate;
    }

    public String getAdvice() {
        return advice;
    }

    public void setAdvice(String advice) {
        this.advice = advice;
    }

    public Integer getGoodsID() {
        return goodsID;
    }

    public void setGoodsID(Integer goodsID) {
        this.goodsID = goodsID;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public String getNurseName() {
        return nurseName;
    }

    public void setNurseName(String nurseName) {
        this.nurseName = nurseName;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public String getEndDoctorName() {
        return endDoctorName;
    }

    public void setEndDoctorName(String endDoctorName) {
        this.endDoctorName = endDoctorName;
    }

    public String getEndNurseName() {
        return endNurseName;
    }

    public void setEndNurseName(String endNurseName) {
        this.endNurseName = endNurseName;
    }

    public String getQuantity() {
        return quantity;
    }

    public void setQuantity(String quantity) {
        this.quantity = quantity;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getAdviceType() {
        return adviceType;
    }

    public void setAdviceType(String adviceType) {
        this.adviceType = adviceType;
    }

    public Integer getOrderID() {
        return orderID;
    }

    public void setOrderID(Integer orderID) {
        this.orderID = orderID;
    }

    public Integer getGroupID() {
        return groupID;
    }

    public void setGroupID(Integer groupID) {
        this.groupID = groupID;
    }

    /*public Integer getGroupNum() {
        return groupNum;
    }

    public void setGroupNum(Integer groupNum) {
        this.groupNum = groupNum;
    }*/

    public Integer getInstructionID() {
        return instructionID;
    }

    public void setInstructionID(Integer instructionID) {
        this.instructionID = instructionID;
    }

    public String getMedicineName() {
        return medicineName;
    }

    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }

    public Boolean getIncompatibility() {
        return incompatibility;
    }

    public void setIncompatibility(Boolean incompatibility) {
        this.incompatibility = incompatibility;
    }

    public String getTaboo() {
        return taboo;
    }

    public void setTaboo(String taboo) {
        this.taboo = taboo;
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

    public Double getContents() {
        return contents;
    }

    public void setContents(Double contents) {
        this.contents = contents;
    }

    public String getDose() {
        return dose;
    }

    public void setDose(String dose) {
        this.dose = dose;
    }

    public String getProducer() {
        return producer;
    }

    public void setProducer(String producer) {
        this.producer = producer;
    }
}
