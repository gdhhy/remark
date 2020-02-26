package com.zcreate.review.dao;

import com.zcreate.ReviewConfig;
import com.zcreate.review.model.Recipe;
import com.zcreate.review.model.RecipeItem;
import com.zcreate.review.model.RecipeItemReview;
import com.zcreate.review.model.RecipeReview;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 11-12-26
 * Time: 下午8:27
 */
public interface RecipeDAO {
    void setReviewConfig(ReviewConfig reviewConfig);

    List<HashMap<String, Object>> getRecipeList(Map<String, Object> param);

    Recipe getRecipe(int recipeID);

    int getRecipeCount(Map param);

    List<Integer> getRandomRecipeID(Map param);

    List<Integer> selectRecipeIDForLinear(Map param);

    List<Recipe> getRecipeByIDList(List<Integer> ids);

    int save(Recipe recipe);

    //boolean insertRecipeReview(RecipeReview review);

    int saveRecipeReview(RecipeReview review);

    List<HashMap<String, Object>> bypass(Map param);

    List<RecipeItem> getRecipeItemList(Map param);

    String getDepartCode(String department);

    List<HashMap<String, Object>> getRecipeItemCount(Integer serialNo);

    List<HashMap<String, Object>> getRecipeListForExcel(Map<String, Object> param);

    List<HashMap<String, Object>> getRecipeItemForExcel(Map<String, Object> param);

    List<HashMap<String, Object>> selectSurgery(Integer serialNo);

    int getSurgeryCount(Integer serialNo);

    int saveRecipeItemReview(RecipeItemReview reviewItem);

    int saveDiagnosis(List<Map> diagnosisMap);

    int deleteDiagnosis(Integer serialNo, int choose);

    //List<Map<String,Object>> selectDiagnosis(Integer serialNo);

    int chooseDiagnosisForResearch(Integer serialNo, List<HashMap<String, Object>> ids);

    List<HashMap<String, Object>> getRecipeAntiStat(Map param);

    List<HashMap<String, Object>> getRecipeWithSurgery(Map param);
}
