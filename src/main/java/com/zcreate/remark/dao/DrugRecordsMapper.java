package com.zcreate.remark.dao;

import org.apache.ibatis.annotations.Mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by hhy on 17-5-5.
 */
@Mapper
public interface DrugRecordsMapper {
    public  HashMap<String, Object> dailySummary(Map param);

    public List<HashMap<String, Object>> byMedicine(Map param);
    public List<HashMap<String, Object>> byDoctor(Map param);

    public HashMap<String, Object> summaryHospitalDrugNum(Map param);

    public List<HashMap<String, Object>> medicineList(Map param);

    //public List<HashMap<String, Object>> medicineList2(Map param);

    public List<HashMap<String, Object>> medicineTrend(Map param);

    public List<HashMap<String, Object>> healthAnalysis2(Map param);

    //public List<HashMap<String, Object>> statRxDetailByHealthNo2(Map param);

    public List<HashMap<String, Object>> queryPatientDrug(Map param);

    public List<HashMap<String, Object>> statMedicineGroupByDepart(Map param);

    public List<HashMap<String, Object>> queryDoctorByMedicine(Map param);

    public List<HashMap<String, Object>> medicineMonth(Map param);

    public List<HashMap<String, Object>> medicineDay(Map param);

    public List<HashMap<String, Object>> bypass(Map param);

    public HashMap<String, Object> summaryBase(Map param);

    public List<HashMap<String, Object>> antiDepart2(Map param);

    public List<HashMap<String, Object>> antiDrug(Map param);

    public List<HashMap<String, Object>> departBase(Map param);
    public List<HashMap<String, Object>> departMedicine(Map param);
    public List<HashMap<String, Object>> doctorBase(Map param);

    int queryPatientDrugCount(Map param);
}
