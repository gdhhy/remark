package com.zcreate.review.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-1-4
 * Time: 下午9:10
 */
public class SampleBatch implements Serializable {
    private Integer sampleBatchID;
    private Integer remarkType;
    private String sampleNo;
    private Integer year;
    private Integer month;
    private Integer num;//抽样数量
    private String name;
    private Integer type;//住院、门诊
    private String department;
    private String doctor;//对应医生姓名
    private Integer doctorID;
    private Integer western;
    private Integer sampleType;//抽样算法
    private Timestamp createDate;
    private String createUser;
    private Integer clinicType;//普通、急诊
    private String fromDate;
    private String toDate;
    private String medicine;
    private Integer goodsID;
    private Integer special;
    private Integer incision;
    private Integer surgery;
    private Integer outPatientNum;
    private Integer total;
    private List<Integer> ids;

    public Integer getSampleBatchID() {
        return sampleBatchID;
    }

    public void setSampleBatchID(Integer sampleBatchID) {
        this.sampleBatchID = sampleBatchID;
    }

    public Integer getRemarkType() {
        return remarkType;
    }

    public void setRemarkType(Integer remarkType) {
        this.remarkType = remarkType;
    }

    public String getSampleNo() {
        return sampleNo;
    }

    public void setSampleNo(String sampleNo) {
        this.sampleNo = sampleNo;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    /* public void setYear(String year) {
        System.out.println("year string = " + year);
        this.year = Integer.parseInt(year);
    }*/

    public Integer getMonth() {
        return month;
    }

    public void setMonth(Integer month) {
        this.month = month;
    }

    public Integer getNum() {
        return num;
    }

    public void setNum(Integer num) {
        this.num = num;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    /*  public void setType(String type) {
        System.out.println("type string = " + type);
        this.type = Integer.parseInt(type);
    }*/

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }

    /*   public int hashCode() {
        int result = 17;
        result += month * 37;
        result += year * 37;
        result += type;
        return result;
    }*/
    public String getTypeString() {
        if (type != null) {
            if (type == 1)
                return "门诊";
            else if (type == 2)
                return "住院";
        }
        return "";
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        if (!"全部".equals(department))
            this.department = department;
    }

    public String getDoctor() {
        return doctor;
    }

    public void setDoctor(String doctor) {
        this.doctor = doctor;
    }

    public Integer getWestern() {
        return western;
    }

    public void setWestern(Integer western) {
        this.western = western;
    }

    public Integer getSampleType() {
        return sampleType;
    }

    public void setSampleType(Integer sampleType) {
        System.out.println("--------------------------sampleType = " + sampleType);
        this.sampleType = sampleType;
    }

    public Integer getDoctorID() {
        return doctorID;
    }

    public void setDoctorID(Integer doctorID) {
        this.doctorID = doctorID;
    }

    public Integer getClinicType() {
        return clinicType;
    }

    public void setClinicType(Integer clinicType) {
        this.clinicType = clinicType;
    }

    public String getFromDate() {
        return fromDate;
    }

    public void setFromDate(String fromDate) {
        this.fromDate = fromDate;
    }

    public String getToDate() {
        return toDate;
    }

    public void setToDate(String toDate) {
        this.toDate = toDate;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser;
    }

    public Integer getGoodsID() {
        return goodsID;
    }

    public void setGoodsID(Integer goodsID) {
        this.goodsID = goodsID;
    }

    public Integer getSpecial() {
        return special;
    }

    public void setSpecial(Integer special) {
        this.special = special;
    }

    public Integer getIncision() {
        return incision;
    }

    public void setIncision(Integer incision) {
        this.incision = incision;
    }

    public String getMedicine() {
        return medicine;
    }

    public void setMedicine(String medicine) {
        this.medicine = medicine;
    }

    public List<Integer> getIds() {
        return ids;
    }

    public void setIds(List<Integer> ids) {
        this.ids = ids;
    }

    public Integer getOutPatientNum() {
        return outPatientNum;
    }

    public void setOutPatientNum(Integer outPatientNum) {
        this.outPatientNum = outPatientNum;
    }

    public Integer getSurgery() {
        return surgery;
    }

    public void setSurgery(Integer surgery) {
        this.surgery = surgery;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }
}
