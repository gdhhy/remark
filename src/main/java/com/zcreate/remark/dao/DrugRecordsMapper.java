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
    HashMap<String, Object> dailySummary(Map<String, Object> param);

    List<HashMap<String, Object>> byMedicine(Map<String, Object> param);

    List<HashMap<String, Object>> byDoctor(Map<String, Object> param);

    //HashMap<String, Object> summaryHospitalDrugNum(Map<String, Object> param);

    List<HashMap<String, Object>> medicineList(Map<String, Object> param);

    List<HashMap<String, Object>> statMedicineGroupByDepart(Map<String, Object> param);

    List<HashMap<String, Object>> medicineDay(Map<String, Object> param);

    List<HashMap<String, Object>> bypass(Map<String, Object> param);

    // HashMap<String, Object> summaryBase(Map<String, Object> param);

    List<HashMap<String, Object>> antiDrug(Map<String, Object> param);

    List<HashMap<String, Object>> departBase(Map<String, Object> param);

    List<HashMap<String, Object>> departMedicine(Map<String, Object> param);

    List<HashMap<String, Object>> doctorBase(Map<String, Object> param);

    //lijin
    List<HashMap<String, Object>> selectAntiGroupDepartment(Map<String, Object> param);
    List<HashMap<String, Object>> selectAntiGroupDoctor(Map<String, Object> param);
}
