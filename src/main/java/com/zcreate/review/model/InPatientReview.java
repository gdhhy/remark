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
public class InPatientReview implements Serializable {
    private Integer inPatientReviewID = 0;
    private Integer hospID;
    private Integer reviewType;/*1:医嘱点评，2：抗菌药调查*/
    private String review;
    private String reviewUser;
    private Timestamp reviewTime;
    private Integer interDepart = 2;//1是内科，2是外科
    private List<HashMap<String, Object>> diagnosis;
    /*private List<AdviceItemReview> longAdvice;
    private List<AdviceItemReview> shortAdvice;*/
    private String reviewJson;

    public Integer getInPatientReviewID() {
        return inPatientReviewID;
    }

    public void setInPatientReviewID(Integer inPatientReviewID) {
        this.inPatientReviewID = inPatientReviewID;
    }

    public Integer getHospID() {
        return hospID;
    }

    public void setHospID(Integer hospID) {
        this.hospID = hospID;
    }

    public Integer getReviewType() {
        return reviewType;
    }

    public void setReviewType(Integer reviewType) {
        this.reviewType = reviewType;
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
    public List<AdviceItemReview> getLongAdvice() {
        return longAdvice;
    }

    public void setLongAdvice(List<AdviceItemReview> longAdvice) {
        this.longAdvice = longAdvice;
    }

    public List<AdviceItemReview> getShortAdvice() {
        return shortAdvice;
    }

    public void setShortAdvice(List<AdviceItemReview> shortAdvice) {
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
