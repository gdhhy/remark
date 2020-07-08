package com.zcreate.review.model;


import com.zcreate.security.pojo.User;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Created by hhy on 2014/10/11.
 */
public class Untoward implements Serializable {
    private Integer untowardID;
    private Integer objectID; //执行clinicID或inPatientID
    private Integer objectType; //1门诊，2：住院
    private String untowardNo;
    private Integer untowardType;    //头部选项（首次报告、报告类型等）
    private String department;
    private String departPhone;
    //报告单位：默认医疗机构
    private String patientName;
    private String patientNo;
    private String age;
    private Integer boy;
    private String year;
    private String birthDate;
    private String nation;//民族
    private String weight; //体重
    private String patientLink;
    private String disease; //疾病
    private Integer historyUntoward; //既往、家族：有、无、不详
    private String historyEvent;
    private String familyEvent;
    private Integer important;
    private String allergicHistory;
    private String otherInfo;
    private String eventName;
    private String eventTime;
    private String eventHour;
    private String eventDesc;
    private Integer eventResult;//事件结果
    private String sequela; //后遗症
    private String deadCause;
    private String deadTime;
    private String deadHour;
    private Integer stopRetry; //停药或减量、再次使用
    private Integer diseaseEffect; //对原患疾病的影响
    private Integer relevance;//关联性评价
    private String relevanceSign1;
    private String relevanceSign2;
    private String declarerPhone; //报告人电话
    private Integer declarerType;
    private String declarerDepart;
    private String declarerTitle;
    private String declarerEmail;
    private String declarerSign;
    private Integer declarerUserID;
    private String declarerLink;
    private String declarerLinkPhone;
    private Timestamp declareDate;
    private String doubtDrugJson;
    private String parallelDrugJson;
    private String course1;
    private String course2;
    private String course3;
    private String course4;
    private String course5;
    private String course6;
    private String course7;
    private String course8;
    private String course9;
    private String course10;
    private Integer courseInt;
    private String memo;
    private Integer workflow;//0：新建编辑，1，提交， 2，退回（可重新编辑提交），3，接受（完毕） mode 4
    //alter table Untoward add workflowNote varchar(255);
    private String workflowNote;

    private User declareUser;
    private String doubtDrugString;
    private InPatient inPatient;
    private Clinic clinic;

    public Integer getUntowardID() {
        return untowardID;
    }

    public void setUntowardID(Integer untowardID) {
        this.untowardID = untowardID;
    }

    public Integer getObjectID() {
        return objectID;
    }

    public void setObjectID(Integer objectID) {
        this.objectID = objectID;
    }

    public Integer getObjectType() {
        return objectType;
    }

    public void setObjectType(Integer objectType) {
        this.objectType = objectType;
    }

    public String getUntowardNo() {
        return untowardNo;
    }

    public void setUntowardNo(String untowardNo) {
        this.untowardNo = untowardNo;
    }

    public Integer getUntowardType() {
        return untowardType;
    }

    public void setUntowardType(Integer untowardType) {
        this.untowardType = untowardType;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getDepartPhone() {
        return departPhone;
    }

    public void setDepartPhone(String departPhone) {
        this.departPhone = departPhone;
    }

    public String getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(String birthDate) {
        this.birthDate = birthDate;
    }

    public String getAge() {
        return age;
    }

    public void setAge(String age) {
        this.age = age;
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

    public Integer getBoy() {
        return boy;
    }

    public void setBoy(Integer boy) {
        this.boy = boy;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public String getNation() {
        return nation;
    }

    public void setNation(String nation) {
        this.nation = nation;
    }

    public String getWeight() {
        return weight;
    }

    public void setWeight(String weight) {
        this.weight = weight;
    }

    public String getPatientLink() {
        return patientLink;
    }

    public void setPatientLink(String patientLink) {
        this.patientLink = patientLink;
    }

    public String getDisease() {
        return disease;
    }

    public void setDisease(String disease) {
        this.disease = disease;
    }

    public Integer getHistoryUntoward() {
        return historyUntoward;
    }

    public void setHistoryUntoward(Integer historyUntoward) {
        this.historyUntoward = historyUntoward;
    }

    public String getHistoryEvent() {
        return historyEvent;
    }

    public void setHistoryEvent(String historyEvent) {
        this.historyEvent = historyEvent;
    }

    public String getFamilyEvent() {
        return familyEvent;
    }

    public void setFamilyEvent(String familyEvent) {
        this.familyEvent = familyEvent;
    }

    public Integer getImportant() {
        return important;
    }

    public void setImportant(Integer important) {
        this.important = important;
    }

    public String getAllergicHistory() {
        return allergicHistory;
    }

    public void setAllergicHistory(String allergicHistory) {
        this.allergicHistory = allergicHistory;
    }

    public String getOtherInfo() {
        return otherInfo;
    }

    public void setOtherInfo(String otherInfo) {
        this.otherInfo = otherInfo;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public String getEventTime() {
        return eventTime;
    }

    public void setEventTime(String eventTime) {
        this.eventTime = eventTime;
    }

    public String getEventHour() {
        return eventHour;
    }

    public void setEventHour(String eventHour) {
        this.eventHour = eventHour;
    }

    public String getEventDesc() {
        return eventDesc;
    }

    public void setEventDesc(String eventDesc) {
        this.eventDesc = eventDesc;
    }

    public Integer getEventResult() {
        return eventResult;
    }

    public void setEventResult(Integer eventResult) {
        this.eventResult = eventResult;
    }

    public String getSequela() {
        return sequela;
    }

    public void setSequela(String sequela) {
        this.sequela = sequela;
    }

    public String getDeadCause() {
        return deadCause;
    }

    public void setDeadCause(String deadCause) {
        this.deadCause = deadCause;
    }

    public String getDeadTime() {
        return deadTime;
    }

    public void setDeadTime(String deadTime) {
        this.deadTime = deadTime;
    }

    public String getDeadHour() {
        return deadHour;
    }

    public void setDeadHour(String deadHour) {
        this.deadHour = deadHour;
    }

    public Integer getStopRetry() {
        return stopRetry;
    }

    public void setStopRetry(Integer stopRetry) {
        this.stopRetry = stopRetry;
    }

    public Integer getDiseaseEffect() {
        return diseaseEffect;
    }

    public void setDiseaseEffect(Integer diseaseEffect) {
        this.diseaseEffect = diseaseEffect;
    }

    public Integer getRelevance() {
        return relevance;
    }

    public void setRelevance(Integer relevance) {
        this.relevance = relevance;
    }

    public String getRelevanceSign1() {
        return relevanceSign1;
    }

    public void setRelevanceSign1(String relevanceSign1) {
        this.relevanceSign1 = relevanceSign1;
    }

    public String getRelevanceSign2() {
        return relevanceSign2;
    }

    public void setRelevanceSign2(String relevanceSign2) {
        this.relevanceSign2 = relevanceSign2;
    }

    public String getDeclarerPhone() {
        return declarerPhone;
    }

    public void setDeclarerPhone(String declarerPhone) {
        this.declarerPhone = declarerPhone;
    }

    public Integer getDeclarerType() {
        return declarerType;
    }

    public void setDeclarerType(Integer declarerType) {
        this.declarerType = declarerType;
    }

    public String getDeclarerDepart() {
        return declarerDepart;
    }

    public void setDeclarerDepart(String declarerDepart) {
        this.declarerDepart = declarerDepart;
    }

    public String getDeclarerTitle() {
        return declarerTitle;
    }

    public void setDeclarerTitle(String declarerTitle) {
        this.declarerTitle = declarerTitle;
    }

    public String getDeclarerEmail() {
        return declarerEmail;
    }

    public void setDeclarerEmail(String declarerEmail) {
        this.declarerEmail = declarerEmail;
    }

    public String getDeclarerSign() {
        return declarerSign;
    }

    public void setDeclarerSign(String declarerSign) {
        this.declarerSign = declarerSign;
    }

    public Integer getDeclarerUserID() {
        return declarerUserID;
    }

    public void setDeclarerUserID(Integer declarerUserID) {
        this.declarerUserID = declarerUserID;
    }

    public String getDeclarerLink() {
        return declarerLink;
    }

    public void setDeclarerLink(String declarerLink) {
        this.declarerLink = declarerLink;
    }

    public String getDeclarerLinkPhone() {
        return declarerLinkPhone;
    }

    public void setDeclarerLinkPhone(String declarerLinkPhone) {
        this.declarerLinkPhone = declarerLinkPhone;
    }

    public Timestamp getDeclareDate() {
        return declareDate;
    }

    public void setDeclareDate(Timestamp declareDate) {
        this.declareDate = declareDate;
    }

    public String getDoubtDrugJson() {
        return doubtDrugJson;
    }

    public void setDoubtDrugJson(String doubtDrugJson) {
        this.doubtDrugJson = doubtDrugJson;
    }

    public String getParallelDrugJson() {
        return parallelDrugJson;
    }

    public void setParallelDrugJson(String parallelDrugJson) {
        this.parallelDrugJson = parallelDrugJson;
    }

    public String getCourse1() {
        return course1;
    }

    public void setCourse1(String course1) {
        this.course1 = course1;
    }

    public String getCourse2() {
        return course2;
    }

    public void setCourse2(String course2) {
        this.course2 = course2;
    }

    public String getCourse3() {
        return course3;
    }

    public void setCourse3(String course3) {
        this.course3 = course3;
    }

    public String getCourse4() {
        return course4;
    }

    public void setCourse4(String course4) {
        this.course4 = course4;
    }

    public String getCourse5() {
        return course5;
    }

    public void setCourse5(String course5) {
        this.course5 = course5;
    }

    public String getCourse6() {
        return course6;
    }

    public void setCourse6(String course6) {
        this.course6 = course6;
    }

    public String getCourse7() {
        return course7;
    }

    public void setCourse7(String course7) {
        this.course7 = course7;
    }

    public String getCourse8() {
        return course8;
    }

    public void setCourse8(String course8) {
        this.course8 = course8;
    }

    public String getCourse9() {
        return course9;
    }

    public void setCourse9(String course9) {
        this.course9 = course9;
    }

    public String getCourse10() {
        return course10;
    }

    public void setCourse10(String course10) {
        this.course10 = course10;
    }

    public Integer getCourseInt() {
        return courseInt;
    }

    public void setCourseInt(Integer courseInt) {
        this.courseInt = courseInt;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public User getDeclareUser() {
        return declareUser;
    }

    public void setDeclareUser(User declareUser) {
        this.declareUser = declareUser;
    }

    public String getDoubtDrugString() {
        return doubtDrugString;
    }

    public void setDoubtDrugString(String doubtDrugString) {
        this.doubtDrugString = doubtDrugString;
    }

    public InPatient getInPatient() {
        return inPatient;
    }

    public void setInPatient(InPatient inPatient) {
        this.inPatient = inPatient;
    }

    public Clinic getClinic() {
        return clinic;
    }

    public void setClinic(Clinic clinic) {
        this.clinic = clinic;
    }

    public Integer getWorkflow() {
        return workflow;
    }

    public void setWorkflow(Integer workflow) {
        this.workflow = workflow;
    }

    public String getWorkflowNote() {
        return workflowNote;
    }

    public void setWorkflowNote(String workflowNote) {
        this.workflowNote = workflowNote;
    }
}
