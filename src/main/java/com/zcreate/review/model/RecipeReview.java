package com.zcreate.review.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-9-5
 * Time: 下午4:16
 */
public class RecipeReview implements Serializable {
    private Integer recipeReviewID=0;
    private String serialNo;
    private Integer germCheck = 0;
    private String sample;
    private String checkDate;
    private String germName;
    private String sensitiveDrugs;
    private String surgeryName;
    private String surgeryDate;
    private String incision;
    private String beforeDrug;
    private Integer appendDrug;
    private String surgeryConsumingTime;
    private String afterStopDrug;
    private String symptom;
    private String symptom2;
    private String review;
    private String reviewUser;
    private Timestamp reviewTime;
    private Integer interDepart = 2;//1是内科，2是外科
    private List<HashMap<String, Object>> diagnosis;
    /*private List<RecipeItemReview> longAdvice;
    private List<RecipeItemReview> shortAdvice;*/
    private String reviewJson;

    public Integer getRecipeReviewID() {
        return recipeReviewID;
    }

    public void setRecipeReviewID(Integer recipeReviewID) {
        this.recipeReviewID = recipeReviewID;
    }

    public String getSerialNo() {
        return serialNo;
    }

    public void setSerialNo(String serialNo) {
        this.serialNo = serialNo;
    }

    public Integer getGermCheck() {
        return germCheck;
    }

    public void setGermCheck(Integer germCheck) {
        this.germCheck = germCheck;
    }

    public String getSample() {
        return sample;
    }

    public void setSample(String sample) {
        this.sample = sample;
    }

    public String getCheckDate() {
        return checkDate;
    }

    public void setCheckDate(String checkDate) {
        this.checkDate = checkDate;
    }

    public String getGermName() {
        return germName;
    }

    public void setGermName(String germName) {
        this.germName = germName;
    }

    public String getSensitiveDrugs() {
        return sensitiveDrugs;
    }

    public void setSensitiveDrugs(String sensitiveDrugs) {
        this.sensitiveDrugs = sensitiveDrugs;
    }

    public String getSurgeryName() {
        return surgeryName;
    }

    public void setSurgeryName(String surgeryName) {
        this.surgeryName = surgeryName;
    }

    public String getSurgeryDate() {
        return surgeryDate;
    }

    public void setSurgeryDate(String surgeryDate) {
        this.surgeryDate = surgeryDate;
    }

    public String getIncision() {
        return incision;
    }

    public void setIncision(String incision) {
        this.incision = incision;
    }

    public String getBeforeDrug() {
        return beforeDrug;
    }

    public void setBeforeDrug(String beforeDrug) {
        this.beforeDrug = beforeDrug;
    }

    public Integer getAppendDrug() {
        return appendDrug;
    }

    public void setAppendDrug(Integer appendDrug) {
        this.appendDrug = appendDrug;
    }

    public String getSurgeryConsumingTime() {
        return surgeryConsumingTime;
    }

    public void setSurgeryConsumingTime(String surgeryConsumingTime) {
        this.surgeryConsumingTime = surgeryConsumingTime;
    }

    public String getAfterStopDrug() {
        return afterStopDrug;
    }

    public void setAfterStopDrug(String afterStopDrug) {
        this.afterStopDrug = afterStopDrug;
    }

    public String getSymptom() {
        return symptom;
    }

    public void setSymptom(String symptom) {
        this.symptom = symptom;
    }

    public String getSymptom2() {
        return symptom2;
    }

    public void setSymptom2(String symptom2) {
        this.symptom2 = symptom2;
    }

    public String getReview() {
        return review;
    }

    public void setReview(String review) {
        this.review = review;
    }

    public String getReviewUser() {
        return reviewUser;
    }

    public void setReviewUser(String reviewUser) {
        this.reviewUser = reviewUser;
    }

    public Timestamp getReviewTime() {
        return reviewTime;
    }

    public void setReviewTime(Timestamp reviewTime) {
        this.reviewTime = reviewTime;
    }
/*
    public List<RecipeItemReview> getLongAdvice() {
        return longAdvice;
    }

    public void setLongAdvice(List<RecipeItemReview> longAdvice) {
        this.longAdvice = longAdvice;
    }

    public List<RecipeItemReview> getShortAdvice() {
        return shortAdvice;
    }

    public void setShortAdvice(List<RecipeItemReview> shortAdvice) {
        this.shortAdvice = shortAdvice;
    }*/

    public List<HashMap<String, Object>> getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(List<HashMap<String, Object>> diagnosis) {
        this.diagnosis = diagnosis;
    }

    public Integer getInterDepart() {
        return interDepart;
    }

    public void setInterDepart(Integer interDepart) {
        this.interDepart = interDepart;
    }

    public String getReviewJson() {
        return reviewJson;
    }

    public void setReviewJson(String reviewJson) {
        this.reviewJson = reviewJson;
    }
}
