package com.zcreate.review.model;

import java.io.Serializable;

/**
 * Created by hhy on 2015/5/7.
 */
public class Infectious implements Serializable {
    private int infectiousID;
    private int objectType; //1门诊，2：住院
    private String serialNo;//门诊号或住院号
    private int patientID;
    private String reportNo;
    private int reportType;
    private String patientName;
    private String patientParent;
    private String idCardNo;
    private int boy;
    private String birthday;
    private String age;
    private String ageUnit;
    private String workplace;//工作单位
    private String linkPhone;
    private String belongTo;
    private String address;
    private int occupation;//change int
    private String occupationElse;
    private int caseClass;
    private String accidentDate;
    private String diagnosisDate;
    private String diagnosisHour;
    private String deathDate;
    private int infectiousClass;
    private String infectiousName;
    private String correctName;
    private String cancelCause;
    private String reportUnit;
    private String doctorPhone;
    private String reportDoctor;
    private int doctorUserID;
    private String memo;
    //传染病增加
    private int marital;
    private int nation;
    private String nationElse;
    private String education;
    private String venerismHis;
    private String registerAddr;
    private int touchHis;
    private String touchElse;
    private String infectRoute;
    private String sampleSource;
    private String conclusion;
    private String checkConfirmDate;
    private String hivConfirmDate;
    private String checkUnit;

    private String fillTime;
    private int workflow=0;//0：新建编辑，1，提交， 2，退回（可重新编辑提交），3，接受（完毕） mode 4
    private String workflowChn;
    private String workflowNote;

    public int getInfectiousID() {
        return infectiousID;
    }

    public void setInfectiousID(int infectiousID) {
        this.infectiousID = infectiousID;
    }

    public int getObjectType() {
        return objectType;
    }

    public void setObjectType(int objectType) {
        this.objectType = objectType;
    }

    public String getSerialNo() {
        return serialNo;
    }

    public void setSerialNo(String serialNo) {
        this.serialNo = serialNo;
    }

    public int getPatientID() {
        return patientID;
    }

    public void setPatientID(int patientID) {
        this.patientID = patientID;
    }

    public String getCorrectName() {
        return correctName;
    }

    public void setCorrectName(String correctName) {
        this.correctName = correctName;
    }

    public String getReportNo() {
        return reportNo;
    }

    public void setReportNo(String reportNo) {
        this.reportNo = reportNo;
    }

    public int getReportType() {
        return reportType;
    }

    public void setReportType(int reportType) {
        this.reportType = reportType;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getPatientParent() {
        return patientParent;
    }

    public void setPatientParent(String patientParent) {
        this.patientParent = patientParent;
    }

    public String getIdCardNo() {
        return idCardNo;
    }

    public void setIdCardNo(String idCardNo) {
        this.idCardNo = idCardNo;
    }

    public int getBoy() {
        return boy;
    }

    public void setBoy(int boy) {
        this.boy = boy;
    }

    public String getBirthday() {
        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public String getAgeUnit() {
        return ageUnit;
    }

    public void setAgeUnit(String ageUnit) {
        this.ageUnit = ageUnit;
    }

    public String getAge() {
        return age;
    }

    public void setAge(String age) {
        this.age = age;
    }

    public String getWorkplace() {
        return workplace;
    }

    public void setWorkplace(String workplace) {
        this.workplace = workplace;
    }

    public String getLinkPhone() {
        return linkPhone;
    }

    public void setLinkPhone(String linkPhone) {
        this.linkPhone = linkPhone;
    }

    public String getBelongTo() {
        return belongTo;
    }

    public void setBelongTo(String belongTo) {
        this.belongTo = belongTo;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getOccupation() {
        return occupation;
    }

    public void setOccupation(int occupation) {
        this.occupation = occupation;
    }

    public String getOccupationElse() {
        return occupationElse;
    }

    public void setOccupationElse(String occupationElse) {
        this.occupationElse = occupationElse;
    }

    public int getCaseClass() {
        return caseClass;
    }

    public void setCaseClass(int caseClass) {
        this.caseClass = caseClass;
    }

    public String getAccidentDate() {
        return accidentDate;
    }

    public void setAccidentDate(String accidentDate) {
        this.accidentDate = accidentDate;
    }

    public String getDiagnosisDate() {
        return diagnosisDate;
    }

    public void setDiagnosisDate(String diagnosisDate) {
        this.diagnosisDate = diagnosisDate;
    }

    public String getDiagnosisHour() {
        return diagnosisHour;
    }

    public void setDiagnosisHour(String diagnosisHour) {
        this.diagnosisHour = diagnosisHour;
    }

    public String getDeathDate() {
        return deathDate;
    }

    public void setDeathDate(String deathDate) {
        this.deathDate = deathDate;
    }

    public int getInfectiousClass() {
        return infectiousClass;
    }

    public void setInfectiousClass(int infectiousClass) {
        this.infectiousClass = infectiousClass;
    }

    public String getInfectiousName() {
        return infectiousName;
    }

    public void setInfectiousName(String infectiousName) {
        this.infectiousName = infectiousName;
    }

    public String getCancelCause() {
        return cancelCause;
    }

    public void setCancelCause(String cancelCause) {
        this.cancelCause = cancelCause;
    }

    public String getReportUnit() {
        return reportUnit;
    }

    public void setReportUnit(String reportUnit) {
        this.reportUnit = reportUnit;
    }

    public String getDoctorPhone() {
        return doctorPhone;
    }

    public void setDoctorPhone(String doctorPhone) {
        this.doctorPhone = doctorPhone;
    }

    public String getReportDoctor() {
        return reportDoctor;
    }

    public void setReportDoctor(String reportDoctor) {
        this.reportDoctor = reportDoctor;
    }

    public int getDoctorUserID() {
        return doctorUserID;
    }

    public void setDoctorUserID(int doctorUserID) {
        this.doctorUserID = doctorUserID;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public String getFillTime() {
        return fillTime;
    }

    public void setFillTime(String fillTime) {
        this.fillTime = fillTime;
    }

    public int getWorkflow() {
        return workflow;
    }

    public void setWorkflow(int workflow) {
        this.workflow = workflow;
    }

    public String getWorkflowChn() {
        return workflowChn;
    }

    public void setWorkflowChn(String workflowChn) {
        this.workflowChn = workflowChn;
    }

    public String getWorkflowNote() {
        return workflowNote;
    }

    public void setWorkflowNote(String workflowNote) {
        this.workflowNote = workflowNote;
    }

    public int getMarital() {
        return marital;
    }

    public void setMarital(int marital) {
        this.marital = marital;
    }

    public int getNation() {
        return nation;
    }

    public void setNation(int nation) {
        this.nation = nation;
    }

    public String getNationElse() {
        return nationElse;
    }

    public void setNationElse(String nationElse) {
        this.nationElse = nationElse;
    }

    public String getEducation() {
        return education;
    }

    public void setEducation(String education) {
        this.education = education;
    }

    public String getVenerismHis() {
        return venerismHis;
    }

    public void setVenerismHis(String venerismHis) {
        this.venerismHis = venerismHis;
    }

    public String getRegisterAddr() {
        return registerAddr;
    }

    public void setRegisterAddr(String registerAddr) {
        this.registerAddr = registerAddr;
    }

    public int getTouchHis() {
        return touchHis;
    }

    public void setTouchHis(int touchHis) {
        this.touchHis = touchHis;
    }

    public String getTouchElse() {
        return touchElse;
    }

    public void setTouchElse(String touchElse) {
        this.touchElse = touchElse;
    }

    public String getInfectRoute() {
        return infectRoute;
    }

    public void setInfectRoute(String infectRoute) {
        this.infectRoute = infectRoute;
    }

    public String getSampleSource() {
        return sampleSource;
    }

    public void setSampleSource(String sampleSource) {
        this.sampleSource = sampleSource;
    }

    public String getConclusion() {
        return conclusion;
    }

    public void setConclusion(String conclusion) {
        this.conclusion = conclusion;
    }

    public String getCheckConfirmDate() {
        return checkConfirmDate;
    }

    public void setCheckConfirmDate(String checkConfirmDate) {
        this.checkConfirmDate = checkConfirmDate;
    }

    public String getHivConfirmDate() {
        return hivConfirmDate;
    }

    public void setHivConfirmDate(String hivConfirmDate) {
        this.hivConfirmDate = hivConfirmDate;
    }

    public String getCheckUnit() {
        return checkUnit;
    }

    public void setCheckUnit(String checkUnit) {
        this.checkUnit = checkUnit;
    }
}
