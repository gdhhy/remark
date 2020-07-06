package com.zcreate.review.dao;

import com.zcreate.ReviewConfig;
import com.zcreate.review.model.AdviceItem;
import com.zcreate.review.model.InPatientReview;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

//import com.zcreate.review.model.AdviceItemReview;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 11-12-26
 * Time: 下午8:27
 */
public interface InPatientDAO {
    void setReviewConfig(ReviewConfig reviewConfig);

    List<HashMap<String, Object>> getInPatientList(Map<String, Object> param);

    com.zcreate.review.model.InPatient getInPatient(int inPatientID, int reviewType);

    int getInPatientCount(Map param);

    List<Integer> getRandomInPatientID(Map param);

    List<Integer> selectInPatientIDForLinear(Map param);

    List<com.zcreate.review.model.InPatient> getInPatientByIDList(List<Integer> ids);

    int save(com.zcreate.review.model.InPatient inPatient);


    int saveInPatientReview(InPatientReview review);

    List<HashMap<String, Object>> bypass(Map param);

    List<AdviceItem> getAdviceItemList(Map param);

    List<AdviceItem> selectDrug(Map param);

    List<HashMap<String, Object>> getAdviceItemCount(Integer hospID);

    List<HashMap<String, Object>> getInPatientListForExcel(Map<String, Object> param);

    List<HashMap<String, Object>> getAdviceItemForExcel(Map<String, Object> param);

    List<HashMap<String, Object>> selectSurgery(Integer hospID);

    int getSurgeryCount(Integer hospID);

    //int saveAdviceItemReview(AdviceItemReview reviewItem);

    int saveDiagnosis(List<Map> diagnosisMap);

    int deleteDiagnosis(Integer hospID, int choose);

    //List<Map<String,Object>> selectDiagnosis(Integer hospID);

    int chooseDiagnosisForResearch(Integer hospID, List<HashMap<String, Object>> ids);

    List<HashMap<String, Object>> getInPatientAntiStat(Map param);

    List<HashMap<String, Object>> getInPatientWithSurgery(Map param);
}
