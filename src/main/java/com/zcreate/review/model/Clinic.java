package com.zcreate.review.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;

/**
 * 门诊处方
 * User: 黄海晏
 * Date: 2012-10-27
 */
public class Clinic implements Serializable {
    private Integer clinicID;
    //-----------------原始资料
    private Integer hospID;//对应入院号
    private String mzNo;//门诊流水号
    private Integer rxCount;    //处方张数
    private String clinicType; //''空白,儿科方、早药方、精二、普通方、急诊方、其他方
    //处方日期
    private Timestamp clinicDate;
    private Integer patientID;
    private String patientName;
    private Boolean sex;
    //显示用，保持原样
    private String age;

    //计算用
    //private Double dAge;
    private String department;
    //诊断结果
    private String diagnosis;
    private Double money;
    private String address;

    //开药处方医生
    private Integer doctorID;
    //审核药师
    private String confirmNo;
    //调配药师
    private String apothecaryNo;
    private String doctorName;
    private String confirmName;
    private String apothecaryName;
    private Integer western;
    private Integer copyNum;
    private String memo;

    //----------------------基本统计
    private Integer drugNum;
    private Integer baseDrugNum;
    private Double baseDrugMoney;
    //抗菌药数量
    private Integer antiNum;
    private Double antiMoney;
    //医保药品金额
    private Double insuranceMoney;

    //-------------------复杂统计 ,todo 其实可以不要，点评用不上，统计不用这个对象
    //注射抗菌要数量
    /*private Integer injectionAntiNum;
    private Double injectionAntiMoney;
    //口服抗菌数量
    private Integer orallyAntiNum;
    //口服抗菌药金额
    private Double orallyAntiMoney;
    private Integer injectionNum;

    //同类抗菌药数量
    private Integer sameAntiNum;
    //同类口服抗菌
    private Integer sameInjectAntiNum;
    //同类注射抗菌
    private Integer sameOrallyAntiNum;
    private Double specAntiMoney;
    */

    //------------------点评
    //点评日期
    private Timestamp reviewDate;
    private String reviewUser;
    private Integer publish;
    private String result;
    //disType= appeal
    private Integer appealState;//申诉状态：0,1,2分别是：无，有，已复

    //不合理项目
    private String disItem;
    //最后判定，合理或不合理
    private Integer rational;

    //-----------------关联
    private List<RxDetail> details;
    //private Integer detailCount = 0;
    private List<HashMap<String, Object>> incompatibilitys;

    public Integer getClinicID() {
        return clinicID;
    }

    public void setClinicID(Integer clinicID) {
        this.clinicID = clinicID;
    }

    public Integer getHospID() {
        return hospID;
    }

    public void setHospID(Integer hospID) {
        this.hospID = hospID;
    }

    public String getMzNo() {
        return mzNo;
    }

    public void setMzNo(String mzNo) {
        this.mzNo = mzNo;
    }

    public Integer getRxCount() {
        return rxCount;
    }

    public void setRxCount(Integer rxCount) {
        this.rxCount = rxCount;
    }

    public String getClinicType() {
        return clinicType;
    }

    public void setClinicType(String clinicType) {
        this.clinicType = clinicType;
    }

    public Timestamp getClinicDate() {
        return clinicDate;
    }

    public void setClinicDate(Timestamp clinicDate) {
        this.clinicDate = clinicDate;
    }

    public Integer getPatientID() {
        return patientID;
    }

    public void setPatientID(Integer patientID) {
        this.patientID = patientID;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public Boolean getSex() {
        return sex;
    }

    public void setSex(Boolean sex) {
        this.sex = sex;
    }

    public String getAge() {
        return age;
    }

    public void setAge(String age) {
        this.age = age;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public Double getMoney() {
        return money;
    }

    public void setMoney(Double money) {
        this.money = money;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Integer getDoctorID() {
        return doctorID;
    }

    public void setDoctorID(Integer doctorID) {
        this.doctorID = doctorID;
    }

    public String getConfirmNo() {
        return confirmNo;
    }

    public void setConfirmNo(String confirmNo) {
        this.confirmNo = confirmNo;
    }

    public String getApothecaryNo() {
        return apothecaryNo;
    }

    public void setApothecaryNo(String apothecaryNo) {
        this.apothecaryNo = apothecaryNo;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public String getConfirmName() {
        return confirmName;
    }

    public void setConfirmName(String confirmName) {
        this.confirmName = confirmName;
    }

    public String getApothecaryName() {
        return apothecaryName;
    }

    public void setApothecaryName(String apothecaryName) {
        this.apothecaryName = apothecaryName;
    }

    public Integer getWestern() {
        return western;
    }

    public void setWestern(Integer western) {
        this.western = western;
    }

    public Integer getCopyNum() {
        return copyNum;
    }

    public void setCopyNum(Integer copyNum) {
        this.copyNum = copyNum;
    }

    public Integer getDrugNum() {
        return drugNum;
    }

    public void setDrugNum(Integer drugNum) {
        this.drugNum = drugNum;
    }

    public Integer getBaseDrugNum() {
        return baseDrugNum;
    }

    public void setBaseDrugNum(Integer baseDrugNum) {
        this.baseDrugNum = baseDrugNum;
    }

    public Double getBaseDrugMoney() {
        return baseDrugMoney;
    }

    public void setBaseDrugMoney(Double baseDrugMoney) {
        this.baseDrugMoney = baseDrugMoney;
    }

    public Integer getAntiNum() {
        return antiNum;
    }

    public void setAntiNum(Integer antiNum) {
        this.antiNum = antiNum;
    }

    public Double getAntiMoney() {
        return antiMoney;
    }

    public void setAntiMoney(Double antiMoney) {
        this.antiMoney = antiMoney;
    }

    public Double getInsuranceMoney() {
        return insuranceMoney;
    }

    public void setInsuranceMoney(Double insuranceMoney) {
        this.insuranceMoney = insuranceMoney;
    }


    public Timestamp getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Timestamp reviewDate) {
        this.reviewDate = reviewDate;
    }

    public String getReviewUser() {
        return reviewUser;
    }

    public void setReviewUser(String reviewUser) {
        this.reviewUser = reviewUser;
    }

    public Integer getPublish() {
        return publish;
    }

    public void setPublish(Integer publish) {
        this.publish = publish;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public Integer getAppealState() {
        return appealState;
    }

    public void setAppealState(Integer appealState) {
        this.appealState = appealState;
    }

    public String getDisItem() {
        return disItem;
    }

    public void setDisItem(String disItem) {
        this.disItem = disItem;
    }

    public Integer getRational() {
        return rational;
    }

    public void setRational(Integer rational) {
        this.rational = rational;
    }

    public List<RxDetail> getDetails() {
        return details;
    }

    public void setDetails(List<RxDetail> details) {
        this.details = details;
    }

    /*public Integer getDetailCount() {
        if (details != null)
            detailCount = details.size();
        return detailCount;*/


    public List<HashMap<String, Object>> getIncompatibilitys() {
        return incompatibilitys;
    }

    public void setIncompatibilitys(List<HashMap<String, Object>> incompatibilitys) {
        this.incompatibilitys = incompatibilitys;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }
}