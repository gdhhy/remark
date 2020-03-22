package com.zcreate.review.logic;

import com.zcreate.review.model.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-1-17
 * Time: 上午11:14
 */
public interface ReviewService {
    Clinic getClinic(int clinicID);

    InPatient getInPatient(int recipeID,int reviewType);

   // int getObjectCount(int type, String fromDate, String toDate, int clinicType, String department, String doctorNo, int western, String medicineNo, int special, int incision);

    boolean saveClinic(Clinic clinic);

    boolean saveInPatient(InPatient recipe);

    List<Integer> createSampling(SampleBatch sampleBatch);

    int doSaveSampling(SampleBatch sampleBatch, List<Integer> ids);//todo 事务没调通

    int doDeleteSampleBatch(int sampleBatchID);

    List getObjectByIDs(List<Integer> ids, int type);

    List getClinicList(Map<String, Object> param);

    List getInPatientList(Map<String, Object> param);

    List<HashMap<String, Object>> getInPatientListForExcel(Map<String, Object> param);

    List<HashMap<String, Object>> getAdviceItemForExcel(Integer hospID, int medicineType);

  /*  int getClinicCount(Map<String, Object> param);

    int getInPatientCount(Map<String, Object> param);*/

    int addSampleToBatch(SampleBatch sampleBatch, String clinicIDs);

    boolean publishClinic(int clinicID, int publishType);

    boolean publishInPatient(int recipeID, int publishType);

    boolean saveInPatientReview(InPatientReview review);

    List<AdviceItem> getAdviceItemList(Integer hospID, int longAdvice,String year);

    List<HashMap<String, Object>> getLastReview(int topRecount);

    List<HashMap<String, Object>> getLastReviewByDoctor(int topRecount);

    int getSurgeryCount(Integer hospID);

    List<HashMap<String, Object>> getAdviceItemCount(Integer hospID);

    int saveDiagnosis(Integer hospID, String diagnosisNos, String diseases);
}
