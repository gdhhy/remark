package com.zcreate.review.model;

import java.io.Serializable;

/**
 * User: 黄海晏
 * Date: 11-11-19
 */
public class RxDetail implements Serializable {
    private Integer rxDetailID;
    private Integer hospID;
    private Integer rxNo;
    private Integer goodsID;
    private String medicineName;
    private Integer quantity;//数量---对应：Sl
    private Double money;
    private String frequency;//频率：对应YF，门诊是单次用量，例如儿科每次不足一最小单位时，再分时的量
    //次数
    private Integer freqNum;
    private String unit;
    //用法用量
    private String dosage;  //不要了 ，修改为对应cfxx
    //每次量
    private Float eachQuantity;//对应每次量
    private String eachUnit;//对应每次量单位


    //医嘱类型
    private String usage;  //对应 yztype
    //用药天数
    private Integer dayNum;
    //包装转换比
    private Integer minOfpack;
    private Double price;
    private String spec;
    private Integer orderID;
    private Integer groupID;
    private Integer antiClass;

    //显示处方组号、组内号
    private String num1;
    private String num2;
    private Integer instructionID;
    private Boolean incompatibility;
    private String taboo;//配伍禁忌
    private String audit;//慎用、禁用
    private String producer;//生产厂家
    private String generalName;//药品通用名
    private String dose;//剂型
    private Integer medicineID;//剂型


    //处方显示药品用法用量上，依次显示：总数量，用药频率，每次用量，次数， 医嘱其他内容
    public Integer getRxDetailID() {
        return rxDetailID;
    }

    public void setRxDetailID(Integer rxDetailID) {
        this.rxDetailID = rxDetailID;
    }

    public Integer gethospID() {
        return hospID;
    }

    public void sethospID(Integer hospID) {
        this.hospID = hospID;
    }

    public Integer getRxNo() {
        return rxNo;
    }

    public void setRxNo(Integer rxNo) {
        this.rxNo = rxNo;
    }

    public Integer getGoodsID() {
        return goodsID;
    }

    public void setGoodsID(Integer goodsID) {
        this.goodsID = goodsID;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Double getMoney() {
        return money;
    }

    public void setMoney(Double money) {
        this.money = money;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public Integer getFreqNum() {
        return freqNum;
    }

    public void setFreqNum(Integer freqNum) {
        this.freqNum = freqNum;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getDosage() {
        return dosage;
    }

    public void setDosage(String dosage) {
        this.dosage = dosage;
    }

    public Float getEachQuantity() {
        return eachQuantity;
    }

    public void setEachQuantity(Float eachQuantity) {
        this.eachQuantity = eachQuantity;
    }

    public String getEachUnit() {
        return eachUnit;
    }

    public void setEachUnit(String eachUnit) {
        this.eachUnit = eachUnit;
    }

    public String getUsage() {
        return usage;
    }

    public void setUsage(String usage) {
        this.usage = usage;
    }

    public Integer getDayNum() {
        return dayNum;
    }

    public void setDayNum(Integer dayNum) {
        this.dayNum = dayNum;
    }

    public Integer getMinOfpack() {
        return minOfpack;
    }

    public void setMinOfpack(Integer minOfpack) {
        this.minOfpack = minOfpack;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getSpec() {
        return spec;
    }

    public void setSpec(String spec) {
        this.spec = spec;
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

    public String getNum1() {
        return num1;
    }

    public void setNum1(String num1) {
        this.num1 = num1;
    }

    public String getNum2() {
        return num2;
    }

    public void setNum2(String num2) {
        this.num2 = num2;
    }

    public Boolean getIncompatibility() {
        return incompatibility;
    }

    public void setIncompatibility(Boolean incompatibility) {
        this.incompatibility = incompatibility;
    }

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

    public String getTaboo() {
        return taboo;
    }

    public void setTaboo(String taboo) {
        this.taboo = taboo;
    }

    public String getAudit() {
        return audit;
    }

    public void setAudit(String audit) {
        this.audit = audit;
    }

    public Integer getAntiClass() {
        return antiClass;
    }

    public void setAntiClass(Integer antiClass) {
        this.antiClass = antiClass;
    }

    public String getProducer() {
        return producer;
    }

    public void setProducer(String producer) {
        this.producer = producer;
    }

    public String getGeneralName() {
        return generalName;
    }

    public void setGeneralName(String generalName) {
        this.generalName = generalName;
    }

    public String getDose() {
        return dose;
    }

    public void setDose(String dose) {
        this.dose = dose;
    }

    public Integer getMedicineID() {
        return medicineID;
    }

    public void setMedicineID(Integer medicineID) {
        this.medicineID = medicineID;
    }
}
