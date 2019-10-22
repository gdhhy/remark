package com.zcreate.review.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Created by hhy on 2015/5/7.
 */
public class Contagion implements Serializable {
    private Integer contagionID;
    private Integer objectType; //1门诊，2：住院
    private String serialNo;//门诊号或住院号
    private String department;
    private String patientName;
    private String idNo;
    private Integer boy;
    private String age;
    private String inDate; //入院日期
    private String hospitalDay; //住院天数
    private String baseDiagnosis1;
    private String baseDiagnosis2;
    private String baseDiagnosis3;
    private String baseDiagnosis4;
    private String hospitalInfect1;
    private String occurDay1;
    private String hospitalInfect2;
    private String occurDay2;
    private String factor;
    private String surgeryName;
    private Integer emergency; //急诊
    private String surgeryDate;
    private String surgeryDoctor;
    private String lastTime1; //持续时间
    private String lastTime2; //持续时间
    private Integer anaesthesia; //麻醉方式
    private Integer cut; // 切开
    private Integer feature;
    private String time1;
    private String time2;
    private String time3;
    private String drainage;
    private String hormone;
    private String time4;
    private String time5;
    private String microbe;
    private String sample;
    private String bAntiDrug;
    private String aAntiDrug;
    private String pAntiDrug;
    private Integer antiItem;
    private String masterDoctor;
    private String monitorDoctor;
    private Integer doctorUserID;
    private Timestamp reportTime;
    private Integer workflow;
    private String workflowChn;
    private String workflowNote;

    public Integer getContagionID() {
        return contagionID;
    }

    public void setContagionID(Integer contagionID) {
        this.contagionID = contagionID;
    }

    public Integer getObjectType() {
        return objectType;
    }

    public void setObjectType(Integer objectType) {
        this.objectType = objectType;
    }

    public String getSerialNo() {
        return serialNo;
    }

    public void setSerialNo(String serialNo) {
        this.serialNo = serialNo;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getIdNo() {
        return idNo;
    }

    public void setIdNo(String idNo) {
        this.idNo = idNo;
    }

    public Integer getBoy() {
        return boy;
    }

    public void setBoy(Integer boy) {
        this.boy = boy;
    }

    public String getAge() {
        return age;
    }

    public void setAge(String age) {
        this.age = age;
    }

    public String getInDate() {
        return inDate;
    }

    public void setInDate(String inDate) {
        this.inDate = inDate;
    }

    public String getHospitalDay() {
        return hospitalDay;
    }

    public void setHospitalDay(String hospitalDay) {
        this.hospitalDay = hospitalDay;
    }

    public String getBaseDiagnosis1() {
        return baseDiagnosis1;
    }

    public void setBaseDiagnosis1(String baseDiagnosis1) {
        this.baseDiagnosis1 = baseDiagnosis1;
    }

    public String getBaseDiagnosis2() {
        return baseDiagnosis2;
    }

    public void setBaseDiagnosis2(String baseDiagnosis2) {
        this.baseDiagnosis2 = baseDiagnosis2;
    }

    public String getBaseDiagnosis3() {
        return baseDiagnosis3;
    }

    public void setBaseDiagnosis3(String baseDiagnosis3) {
        this.baseDiagnosis3 = baseDiagnosis3;
    }

    public String getBaseDiagnosis4() {
        return baseDiagnosis4;
    }

    public void setBaseDiagnosis4(String baseDiagnosis4) {
        this.baseDiagnosis4 = baseDiagnosis4;
    }

    public String getHospitalInfect1() {
        return hospitalInfect1;
    }

    public void setHospitalInfect1(String hospitalInfect1) {
        this.hospitalInfect1 = hospitalInfect1;
    }

    public String getOccurDay1() {
        return occurDay1;
    }

    public void setOccurDay1(String occurDay1) {
        this.occurDay1 = occurDay1;
    }

    public String getHospitalInfect2() {
        return hospitalInfect2;
    }

    public void setHospitalInfect2(String hospitalInfect2) {
        this.hospitalInfect2 = hospitalInfect2;
    }

    public String getOccurDay2() {
        return occurDay2;
    }

    public void setOccurDay2(String occurDay2) {
        this.occurDay2 = occurDay2;
    }

    public String getFactor() {
        return factor;
    }

    public void setFactor(String factor) {
        this.factor = factor;
    }

    public String getSurgeryName() {
        return surgeryName;
    }

    public void setSurgeryName(String surgeryName) {
        this.surgeryName = surgeryName;
    }

    public Integer getEmergency() {
        return emergency;
    }

    public void setEmergency(Integer emergency) {
        this.emergency = emergency;
    }

    public String getSurgeryDate() {
        return surgeryDate;
    }

    public void setSurgeryDate(String surgeryDate) {
        this.surgeryDate = surgeryDate;
    }

    public String getSurgeryDoctor() {
        return surgeryDoctor;
    }

    public void setSurgeryDoctor(String surgeryDoctor) {
        this.surgeryDoctor = surgeryDoctor;
    }

    public String getLastTime1() {
        return lastTime1;
    }

    public void setLastTime1(String lastTime1) {
        this.lastTime1 = lastTime1;
    }

    public String getLastTime2() {
        return lastTime2;
    }

    public void setLastTime2(String lastTime2) {
        this.lastTime2 = lastTime2;
    }

    public Integer getAnaesthesia() {
        return anaesthesia;
    }

    public void setAnaesthesia(Integer anaesthesia) {
        this.anaesthesia = anaesthesia;
    }

    public Integer getCut() {
        return cut;
    }

    public void setCut(Integer cut) {
        this.cut = cut;
    }

    public Integer getFeature() {
        return feature;
    }

    public void setFeature(Integer feature) {
        this.feature = feature;
    }

    public String getTime1() {
        return time1;
    }

    public void setTime1(String time1) {
        this.time1 = time1;
    }

    public String getTime2() {
        return time2;
    }

    public void setTime2(String time2) {
        this.time2 = time2;
    }

    public String getTime3() {
        return time3;
    }

    public void setTime3(String time3) {
        this.time3 = time3;
    }

    public String getDrainage() {
        return drainage;
    }

    public void setDrainage(String drainage) {
        this.drainage = drainage;
    }

    public String getHormone() {
        return hormone;
    }

    public void setHormone(String hormone) {
        this.hormone = hormone;
    }

    public String getTime4() {
        return time4;
    }

    public void setTime4(String time4) {
        this.time4 = time4;
    }

    public String getTime5() {
        return time5;
    }

    public void setTime5(String time5) {
        this.time5 = time5;
    }

    public String getMicrobe() {
        return microbe;
    }

    public void setMicrobe(String microbe) {
        this.microbe = microbe;
    }

    public String getSample() {
        return sample;
    }

    public void setSample(String sample) {
        this.sample = sample;
    }

    public String getbAntiDrug() {
        return bAntiDrug;
    }

    public void setbAntiDrug(String bAntiDrug) {
        this.bAntiDrug = bAntiDrug;
    }

    public String getaAntiDrug() {
        return aAntiDrug;
    }

    public void setaAntiDrug(String aAntiDrug) {
        this.aAntiDrug = aAntiDrug;
    }

    public String getpAntiDrug() {
        return pAntiDrug;
    }

    public void setpAntiDrug(String pAntiDrug) {
        this.pAntiDrug = pAntiDrug;
    }

    public Integer getAntiItem() {
        return antiItem;
    }

    public void setAntiItem(Integer antiItem) {
        this.antiItem = antiItem;
    }

    public String getMasterDoctor() {
        return masterDoctor;
    }

    public void setMasterDoctor(String masterDoctor) {
        this.masterDoctor = masterDoctor;
    }

    public String getMonitorDoctor() {
        return monitorDoctor;
    }

    public void setMonitorDoctor(String monitorDoctor) {
        this.monitorDoctor = monitorDoctor;
    }

    public Integer getDoctorUserID() {
        return doctorUserID;
    }

    public void setDoctorUserID(Integer doctorUserID) {
        this.doctorUserID = doctorUserID;
    }

    public Timestamp getReportTime() {
        return reportTime;
    }

    public void setReportTime(Timestamp reportTime) {
        this.reportTime = reportTime;
    }

    public Integer getWorkflow() {
        return workflow;
    }

    public void setWorkflow(Integer workflow) {
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
}
