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

    Recipe getRecipe(int recipeID);

   // int getObjectCount(int type, String fromDate, String toDate, int clinicType, String department, String doctorNo, int western, String medicineNo, int special, int incision);

    boolean saveClinic(Clinic clinic);

    boolean saveRecipe(Recipe recipe);

    List<Integer> createSampling(SampleBatch sampleBatch);

    int doSaveSampling(SampleBatch sampleBatch, List<Integer> ids);//todo 事务没调通

    int doDeleteSampleBatch(int sampleBatchID);

    List getObjectByIDs(List<Integer> ids, int type);

    List getClinicList(Map<String, Object> param);

    List getRecipeList(Map<String, Object> param);

    List<HashMap<String, Object>> getRecipeListForExcel(Map<String, Object> param);

    List<HashMap<String, Object>> getRecipeItemForExcel(Integer serialNo, int medicineType);

  /*  int getClinicCount(Map<String, Object> param);

    int getRecipeCount(Map<String, Object> param);*/

    int addSampleToBatch(SampleBatch sampleBatch, String clinicIDs);

    boolean publishClinic(int clinicID, int publishType);

    boolean publishRecipe(int recipeID, int publishType);

    boolean saveRecipeReview(RecipeReview review);

    List<RecipeItem> getRecipeItemList(Integer serialNo, int longAdvice,String year);

    List<HashMap<String, Object>> getLastReview(int topRecount);

    List<HashMap<String, Object>> getLastReviewByDoctor(int topRecount);

    int getSurgeryCount(Integer serialNo);

    List<HashMap<String, Object>> getRecipeItemCount(Integer serialNo);

    int saveDiagnosis(Integer serialNo, String diagnosisNos, String diseases);
}
