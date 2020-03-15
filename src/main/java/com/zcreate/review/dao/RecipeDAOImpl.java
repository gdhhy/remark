package com.zcreate.review.dao;

import com.zcreate.ReviewConfig;
import com.zcreate.review.model.Recipe;
import com.zcreate.review.model.RecipeItem;
//import com.zcreate.review.model.RecipeItemReview;
import com.zcreate.review.model.RecipeReview;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-1-5
 * Time: 上午8:31
 */
public class RecipeDAOImpl extends SqlSessionDaoSupport implements RecipeDAO, Serializable {
    private static ReviewConfig reviewConfig;

    public void setReviewConfig(ReviewConfig reviewConfig) {
        RecipeDAOImpl.reviewConfig = reviewConfig;
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getRecipeList(Map<String, Object> param) {
        return getSqlSession().selectList("Recipe.selectRecipeList", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getRecipeListForExcel(Map<String, Object> param) {
        return getSqlSession().selectList("Recipe.selectRecipeListForExcel", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getRecipeItemForExcel(Map<String, Object> param) {
        return getSqlSession().selectList("RecipeItem.selectRecipeItemForExcel", param);
    }

    @SuppressWarnings("unchecked")
    public Recipe getRecipe(int recipeID) {
        Recipe recipe = getSqlSession().selectOne("Recipe.selectRecipeByID", recipeID);

        if (recipe == null) return null;
        if (recipe.getOutDate() != null) {//按年在RecipeItem_year取明细
            SimpleDateFormat df = new SimpleDateFormat("yyyy");
            recipe.setYear(df.format(recipe.getOutDate()));
        } else {
            Calendar cal = Calendar.getInstance();
            recipe.setYear("" + cal.get(Calendar.YEAR));
        }
        Map<String, Object> param = new HashMap<>();
        //param.put("recipeID", recipeID);
        param.put("serialNo", recipe.getSerialNo());
        param.put("RecipeItemTable", "RecipeItem_" + recipe.getYear());

        recipe.setMicrobeCheck(getSqlSession().selectOne("Recipe.selectRecipeMicrobeCheck", param));
        recipe.setIncompatNum(getSqlSession().selectOne("Recipe.selectIncompatNum", recipe.getSerialNo()));
        recipe.setReview(getRecipeReview(param));

        return recipe;
    }

    private RecipeReview getRecipeReview(Map param) {
        RecipeReview review = getSqlSession().selectOne("Recipe.selectRecipeReview", param);
        if (review != null) {
            review.setDiagnosis(getSqlSession().selectList("RecipeItem.selectDiagnosis", param));
           /* review.setLongAdvice(getSqlSession().selectList("RecipeItem.selectLongRecipeItemReview", param));
            review.setShortAdvice(getSqlSession().selectList("RecipeItem.selectShortRecipeItemReview", param));*/
        }
        return review;
    }

    public int getRecipeCount(Map param) {
        return (Integer) getSqlSession().selectOne("Recipe.selectRecipeCount", param);
    }


    @SuppressWarnings("unchecked")
    public List<Integer> getRandomRecipeID(Map param) {
        return getSqlSession().selectList("Recipe.selectRandomRecipeID", param);
    }

    /*  public List<Integer> getLinearRecipeID(Map param) {
        getSqlSession().selectOne("Recipe.selectLinearRecipeID", param);
        System.out.println("--------------param result2= " + param.get("result2"));
        if (param.get("result2") == null || "".equals(param.get("result2")))
            return new ArrayList<Integer>(0);
        int result[] = StringUtils.splitToInts((String) param.get("result2"), ",");
        List<Integer> ret = new ArrayList<Integer>(result.length);
        for (int ii : result) ret.add(ii);
        return ret;
    }*/
    @SuppressWarnings("unchecked")
    public List<Integer> selectRecipeIDForLinear(Map param) {
        return getSqlSession().selectList("Recipe.selectRecipeIDForLinear", param);
    }

    @SuppressWarnings("unchecked")
    public List<Recipe> getRecipeByIDList(List<Integer> ids) {
        if (ids.size() > 0)
            return getSqlSession().selectList("Recipe.selectRecipeInIDs", ids);
        else
            return new ArrayList<>(0);
    }

    public int save(Recipe recipe) {
        return getSqlSession().update("Recipe.updateRecipe", recipe);
    }

    //------------RecipeReview
    /* public RecipeReview getRecipeReview(int reviewID) {
            return (RecipeReview) getSqlSession().selectOne("Recipe.selectRecipeReview", reviewID);
        }
    */
  /*  public boolean insertRecipeReview(RecipeReview review) {
        return getSqlSession().insert("Recipe.insertRecipeReview", review) == 1;
    }
*/

    public int saveRecipeReview(RecipeReview review) {
        int affectedRowCount = 0;
        if (review.getRecipeReviewID() != null && review.getRecipeReviewID() > 0) {
            affectedRowCount = getSqlSession().update("Recipe.updateRecipeReview", review);
            //组建存在的 ID 列表
            /*List<Integer> itemList = new ArrayList<>();
            if (review.getLongAdvice() != null)
                for (RecipeItemReview item : review.getLongAdvice())
                    if (item.getRecipeItemReviewID() > 0) itemList.add(item.getRecipeItemReviewID());
            if (review.getShortAdvice() != null)
                for (RecipeItemReview item : review.getShortAdvice())
                    if (item.getRecipeItemReviewID() > 0) itemList.add(item.getRecipeItemReviewID());

            Map<String, Object> param = new HashMap<>(2);
            param.put("serialNo", review.getSerialNo());
            param.put("recipeItemReviewList", itemList);
            affectedRowCount += getSqlSession().delete("RecipeItem.deleteRecipeItemReview", param);//删除不存在的ID*/
        } else {
            affectedRowCount = getSqlSession().insert("Recipe.insertRecipeReview", review);
        }

       /* if (affectedRowCount > 0) {
            if (review.getLongAdvice() != null)
                for (RecipeItemReview item : review.getLongAdvice())
                    affectedRowCount += saveRecipeItemReview(item);
            if (review.getShortAdvice() != null)
                for (RecipeItemReview item : review.getShortAdvice())
                    affectedRowCount += saveRecipeItemReview(item);
        }*/
        return affectedRowCount;
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> bypass(Map param) {
        return getSqlSession().selectList("Recipe.bypass", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getRecipeItemCount(Integer serialNo) {
        return getSqlSession().selectList("RecipeItem.selectRecipeItemCount", serialNo);
    }

    @SuppressWarnings("unchecked")
    public List<RecipeItem> getRecipeItemList(Map param) {
        if (((Integer) param.get("longAdvice")) == 1)
            return getSqlSession().selectList("RecipeItem.selectLongRecipeItem", param);
        else
            return getSqlSession().selectList("RecipeItem.selectShortRecipeItem", param);
    }

    public String getDepartCode(String department) {
        HashMap<String, String> param = new HashMap<>(2);
        param.put("departmentName", department);
        param.put("prefix", reviewConfig.getPrefixHospital(false));
        return (String) getSqlSession().selectOne("Recipe.selectDepartCode", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> selectSurgery(Integer serialNo) {
        return getSqlSession().selectList("RecipeItem.selectSurgery", serialNo);
    }

    public int getSurgeryCount(Integer serialNo) {
        return (Integer) getSqlSession().selectOne("RecipeItem.selectSurgeryCount", serialNo);
    }

   /* public int saveRecipeItemReview(RecipeItemReview reviewItem) {
        if (reviewItem.getRecipeItemReviewID() != null && reviewItem.getRecipeItemReviewID() > 0)
            return getSqlSession().update("RecipeItem.updateRecipeItemReview", reviewItem);
        else
            return getSqlSession().insert("RecipeItem.insertRecipeItemReview", reviewItem);
    }*/

    public int saveDiagnosis(List<Map> diagnosisMap) {
        int succeed = 0;
        for (Map map : diagnosisMap) {
            succeed += getSqlSession().insert("RecipeItem.insertDiagnosis", map);
        }
        return succeed;
    }

    @SuppressWarnings("unchecked")
    public int deleteDiagnosis(Integer serialNo, int choose) {
        Map param = new HashMap<>();
        param.put("serialNo", serialNo);
        param.put("choose", choose);
        return getSqlSession().delete("RecipeItem.deleteDiagnosis", param);
    }

    /*public List<Map<String, Object>> selectDiagnosis(Integer serialNo) {
        return getSqlSession().selectList("RecipeItem.selectDiagnosis", serialNo);
    }*/

    @Override
    @SuppressWarnings("unchecked")
    public int chooseDiagnosisForResearch(Integer serialNo, List<HashMap<String, Object>> ids) {
        int succeed = deleteDiagnosis(serialNo, 2);

        for (Map map : ids) {
            succeed += getSqlSession().insert("RecipeItem.insertDiagnosis", map);
        }

        //强逼Recipe重新加载
        if (succeed > 0) getSqlSession().update("Recipe.clearCache", serialNo);

        return succeed;
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getRecipeAntiStat(Map param) {
        return getSqlSession().selectList("Recipe.selectRecipeAntiStat", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getRecipeWithSurgery(Map param) {
        return getSqlSession().selectList("Recipe.selectRecipeWithSurgery", param);
    }
}
