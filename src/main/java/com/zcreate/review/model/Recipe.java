package com.zcreate.review.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;

/**
 * User: 黄海晏
 * Date: 12-8-15
 */
public class Recipe implements Serializable {
    private Integer recipeID;
    private String serialNo;    //住院：入院号，标识病人，门诊：就诊标识
    /*病人资料*/
    private String patientNo;
    private String patientName;
    private Boolean sex;
    private String age;

    /*处方原始信息*/
    //处方日期
    private Timestamp inDate;
    private Timestamp outDate;
    private Integer inHospitalDay;
    private String department;

    //诊断结果
    private String diagnosis;  //入院诊断
    private String diagnosis2;  //出院诊断
    private Double money;  //金额要累加
    private Double medicineMoney;  //金额要累加
    private Integer drugNum;

    //住院主管医生
    private String masterDoctorNo;
    private String masterDoctorName;

    /*点评信息*/
    //点评日期
    private Timestamp reviewDate;
    private String reviewUser;
    //点评结果
    //private String result;
    //不合理项目
    private String disItem;
    private Integer rational;
    private Integer publish;

    private Integer antiNum;
    private Integer concurAntiNum;

    /*private List<RecipeItem> longItems;
    private List<RecipeItem> shortItems;*/
    private List<HashMap<String, Object>> surgerys;
    // private List<HashMap<String, Object>> incompatibilitys;
    private RecipeReview review;
    //private List<Course> course;
    //private History History;
    /*private Integer longItemNum;
    private Integer shortItemNum;*/
    private Integer courseNum;
    private Integer incompatNum;
    private Integer microbeCheck;
    private Integer archive;//0:编辑中，1：已归档，-1：退回重新编辑
    //仅展示时用,ReviewAction.viewRecipe
    private String departCode;
    private int queryTimes = 0;
    private Integer appealState;
    private Appeal appeal;
    private AntiResearch research;
    private String year;

    public Integer getRecipeID() {
        return recipeID;
    }

    public void setRecipeID(Integer recipeID) {
        this.recipeID = recipeID;
    }

    public String getSerialNo() {
        return serialNo;
    }

    public void setSerialNo(String serialNo) {
        this.serialNo = serialNo;
    }

    public String getPatientNo() {
        return patientNo;
    }

    public void setPatientNo(String patientNo) {
        this.patientNo = patientNo;
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

    public Timestamp getInDate() {
        return inDate;
    }

    public void setInDate(Timestamp inDate) {
        this.inDate = inDate;
    }

    public Timestamp getOutDate() {
        return outDate;
    }

    public void setOutDate(Timestamp outDate) {
        this.outDate = outDate;
    }

    public Integer getInHospitalDay() {
        return inHospitalDay;
    }

    public void setInHospitalDay(Integer inHospitalDay) {
        this.inHospitalDay = inHospitalDay;
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

    public String getDiagnosis2() {
        return diagnosis2;
    }

    public void setDiagnosis2(String diagnosis2) {
        this.diagnosis2 = diagnosis2;
    }

    public Double getMoney() {
        return money;
    }

    public void setMoney(Double money) {
        this.money = money;
    }

    public Double getMedicineMoney() {
        return medicineMoney;
    }

    public void setMedicineMoney(Double medicineMoney) {
        this.medicineMoney = medicineMoney;
    }

    public Integer getDrugNum() {
        return drugNum;
    }

    public void setDrugNum(Integer drugNum) {
        this.drugNum = drugNum;
    }

    public String getMasterDoctorNo() {
        return masterDoctorNo;
    }

    public void setMasterDoctorNo(String masterDoctorNo) {
        this.masterDoctorNo = masterDoctorNo;
    }

    public String getMasterDoctorName() {
        return masterDoctorName;
    }

    public void setMasterDoctorName(String masterDoctorName) {
        this.masterDoctorName = masterDoctorName;
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

   /* public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }*/

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

    public Integer getPublish() {
        return publish;
    }

    public void setPublish(Integer publish) {
        this.publish = publish;
    }

    public Integer getAntiNum() {
        return antiNum;
    }

    public void setAntiNum(Integer antiNum) {
        this.antiNum = antiNum;
    }

    public Integer getConcurAntiNum() {
        return concurAntiNum;
    }

    public void setConcurAntiNum(Integer concurAntiNum) {
        this.concurAntiNum = concurAntiNum;
    }

    public Integer getArchive() {
        return archive;
    }

    public void setArchive(Integer archive) {
        this.archive = archive;
    }

    public List<HashMap<String, Object>> getSurgerys() {
        return surgerys;
    }

    public void setSurgerys(List<HashMap<String, Object>> surgerys) {
        this.surgerys = surgerys;
    }

    public RecipeReview getReview() {
        return review;
    }

    public void setReview(RecipeReview review) {
        this.review = review;
    }
/*
    public List<Course> getCourse() {
        return course;
    }

    public void setCourse(List<Course> course) {
        this.course = course;
    }

    public  History  getHistory() {
        return History;
    }

    public void setHistory( History  history) {
        History = history;
    }*/
/*
    public Integer getLongItemNum() {
        return longItemNum;
    }

    public void setLongItemNum(Integer longItemNum) {
        this.longItemNum = longItemNum;
    }

    public Integer getShortItemNum() {
        return shortItemNum;
    }

    public void setShortItemNum(Integer shortItemNum) {
        this.shortItemNum = shortItemNum;
    }*/

    public Integer getCourseNum() {
        return courseNum;
    }

    public void setCourseNum(Integer courseNum) {
        this.courseNum = courseNum;
    }

    public Integer getIncompatNum() {
        return incompatNum;
    }

    public void setIncompatNum(Integer incompatNum) {
        this.incompatNum = incompatNum;
    }

    public Integer getMicrobeCheck() {
        return microbeCheck;
    }

    public void setMicrobeCheck(Integer microbeCheck) {
        this.microbeCheck = microbeCheck;
    }

    public String getDepartCode() {
        return departCode;
    }

    public void setDepartCode(String departCode) {
        this.departCode = departCode;
    }

    public void setQueryTimes(int queryTimes) {
        this.queryTimes = queryTimes;
    }

    public int getQueryTimes() {
        return queryTimes;
    }

    public Integer getAppealState() {
        return appealState;
    }

    public void setAppealState(Integer appealState) {
        this.appealState = appealState;
    }

    public Appeal getAppeal() {
        return appeal;
    }

    public void setAppeal(Appeal appeal) {
        this.appeal = appeal;
    }

    public AntiResearch getResearch() {
        return research;
    }

    public void setResearch(AntiResearch research) {
        this.research = research;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }
}