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

    InPatient getInPatient(int recipeID, int reviewType);

    boolean saveClinic(Clinic clinic);

    List<Integer> createSampling(SampleBatch sampleBatch);

    int doSaveSampling(SampleBatch sampleBatch, List<Integer> ids);//todo 事务没调通

    int doDeleteSampleBatch(int sampleBatchID);

    int deleteSample(int sampleBatchID, int objectID);

    List getObjectByIDs(List<Integer> ids, int type);

  /*  int getClinicCount(Map<String, Object> param);

    int getInPatientCount(Map<String, Object> param);*/

    boolean saveInPatientReview(InPatientReview review);

    List<AdviceItem> getAdviceItemList(Integer hospID, int longAdvice, String year);

    List<AdviceItem> getDrugList(Integer hospID, String year);
}
