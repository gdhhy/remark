package com.zcreate.review.dao;

import com.zcreate.ReviewConfig;
import com.zcreate.review.model.InPatientReview;
import com.zcreate.review.model.AdviceItem;
//import com.zcreate.review.model.AdviceItemReview;
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
public class InPatientDAOImpl extends SqlSessionDaoSupport implements InPatientDAO, Serializable {
    private static ReviewConfig reviewConfig;

    public void setReviewConfig(ReviewConfig reviewConfig) {
        InPatientDAOImpl.reviewConfig = reviewConfig;
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getInPatientList(Map<String, Object> param) {
        return getSqlSession().selectList("InPatient.selectInPatientList", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getInPatientListForExcel(Map<String, Object> param) {
        return getSqlSession().selectList("InPatient.selectInPatientListForExcel", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getAdviceItemForExcel(Map<String, Object> param) {
        return getSqlSession().selectList("AdviceItem.selectAdviceItemForExcel", param);
    }

    @SuppressWarnings("unchecked")
    public com.zcreate.review.model.InPatient getInPatient(int inPatientID, int reviewType) {
        com.zcreate.review.model.InPatient inPatient = getSqlSession().selectOne("InPatient.selectInPatientByID", inPatientID);

        if (inPatient == null) return null;
        if (inPatient.getOutDate() != null) {//按年在AdviceItem_year取明细
            SimpleDateFormat df = new SimpleDateFormat("yyyy");
            inPatient.setYear(df.format(inPatient.getOutDate()));
        } else {
            Calendar cal = Calendar.getInstance();
            inPatient.setYear("" + cal.get(Calendar.YEAR));
        }
        Map<String, Object> param = new HashMap<>();
        //param.put("inPatientID", inPatientID);
        param.put("hospID", inPatient.getHospID());
        param.put("reviewType", reviewType);
        param.put("AdviceItemTable", "AdviceItem_" + inPatient.getYear());

        inPatient.setMicrobeCheck(getSqlSession().selectOne("InPatient.selectInPatientMicrobeCheck", param));
        inPatient.setIncompatNum(getSqlSession().selectOne("InPatient.selectIncompatNum", inPatient.getHospID()));
        inPatient.setReview(getInPatientReview(param));

        return inPatient;
    }

    private InPatientReview getInPatientReview(Map param) {
        return getSqlSession().selectOne("InPatient.selectInPatientReview", param);
    }

    public int getInPatientCount(Map param) {
        return (Integer) getSqlSession().selectOne("InPatient.selectInPatientCount", param);
    }


    @SuppressWarnings("unchecked")
    public List<Integer> getRandomInPatientID(Map param) {
        return getSqlSession().selectList("InPatient.selectRandomInPatientID", param);
    }

    @SuppressWarnings("unchecked")
    public List<Integer> selectInPatientIDForLinear(Map param) {
        return getSqlSession().selectList("InPatient.selectInPatientIDForLinear", param);
    }

    @SuppressWarnings("unchecked")
    public List<com.zcreate.review.model.InPatient> getInPatientByIDList(List<Integer> ids) {
        if (ids.size() > 0)
            return getSqlSession().selectList("InPatient.selectInPatientInIDs", ids);
        else
            return new ArrayList<>(0);
    }

    public int save(com.zcreate.review.model.InPatient inPatient) {
        return getSqlSession().update("InPatient.updateInPatient", inPatient);
    }

    public int saveInPatientReview(InPatientReview review) {
        int affectedRowCount = 0;
        if (review.getInPatientReviewID() != null && review.getInPatientReviewID() > 0) {
            affectedRowCount = getSqlSession().update("InPatient.updateInPatientReview", review);
            //组建存在的 ID 列表
            /*List<Integer> itemList = new ArrayList<>();
            if (review.getLongAdvice() != null)
                for (AdviceItemReview item : review.getLongAdvice())
                    if (item.getAdviceItemReviewID() > 0) itemList.add(item.getAdviceItemReviewID());
            if (review.getShortAdvice() != null)
                for (AdviceItemReview item : review.getShortAdvice())
                    if (item.getAdviceItemReviewID() > 0) itemList.add(item.getAdviceItemReviewID());

            Map<String, Object> param = new HashMap<>(2);
            param.put("hospID", review.gethospID());
            param.put("adviceItemReviewList", itemList);
            affectedRowCount += getSqlSession().delete("AdviceItem.deleteAdviceItemReview", param);//删除不存在的ID*/
        } else {
            affectedRowCount = getSqlSession().insert("InPatient.insertInPatientReview", review);
        }

       /* if (affectedRowCount > 0) {
            if (review.getLongAdvice() != null)
                for (AdviceItemReview item : review.getLongAdvice())
                    affectedRowCount += saveAdviceItemReview(item);
            if (review.getShortAdvice() != null)
                for (AdviceItemReview item : review.getShortAdvice())
                    affectedRowCount += saveAdviceItemReview(item);
        }*/
        return affectedRowCount;
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> bypass(Map param) {
        return getSqlSession().selectList("InPatient.bypass", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getAdviceItemCount(Integer hospID) {
        return getSqlSession().selectList("AdviceItem.selectAdviceItemCount", hospID);
    }

    @SuppressWarnings("unchecked")
    public List<AdviceItem> getAdviceItemList(Map param) {
        if (((Integer) param.get("longAdvice")) == 1)
            return getSqlSession().selectList("AdviceItem.selectLongAdviceItem", param);
        else
            return getSqlSession().selectList("AdviceItem.selectShortAdviceItem", param);
    }

    public List<AdviceItem> selectDrug(Map param) {
        return getSqlSession().selectList("AdviceItem.selectDrug", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> selectSurgery(Integer hospID) {
        return getSqlSession().selectList("AdviceItem.selectSurgery", hospID);
    }

    public int getSurgeryCount(Integer hospID) {
        return (Integer) getSqlSession().selectOne("AdviceItem.selectSurgeryCount", hospID);
    }

   /* public int saveAdviceItemReview(AdviceItemReview reviewItem) {
        if (reviewItem.getAdviceItemReviewID() != null && reviewItem.getAdviceItemReviewID() > 0)
            return getSqlSession().update("AdviceItem.updateAdviceItemReview", reviewItem);
        else
            return getSqlSession().insert("AdviceItem.insertAdviceItemReview", reviewItem);
    }*/

    public int saveDiagnosis(List<Map> diagnosisMap) {
        int succeed = 0;
        for (Map map : diagnosisMap) {
            succeed += getSqlSession().insert("AdviceItem.insertDiagnosis", map);
        }
        return succeed;
    }

    @SuppressWarnings("unchecked")
    public int deleteDiagnosis(Integer hospID, int choose) {
        Map param = new HashMap<>();
        param.put("hospID", hospID);
        param.put("choose", choose);
        return getSqlSession().delete("AdviceItem.deleteDiagnosis", param);
    }

    /*public List<Map<String, Object>> selectDiagnosis(Integer hospID) {
        return getSqlSession().selectList("AdviceItem.selectDiagnosis", hospID);
    }*/

    @Override
    @SuppressWarnings("unchecked")
    public int chooseDiagnosisForResearch(Integer hospID, List<HashMap<String, Object>> ids) {
        int succeed = deleteDiagnosis(hospID, 2);

        for (Map map : ids) {
            succeed += getSqlSession().insert("AdviceItem.insertDiagnosis", map);
        }

        //强逼InPatient重新加载
        if (succeed > 0) getSqlSession().update("InPatient.clearCache", hospID);

        return succeed;
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getInPatientAntiStat(Map param) {
        return getSqlSession().selectList("InPatient.selectInPatientAntiStat", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getInPatientWithSurgery(Map param) {
        return getSqlSession().selectList("InPatient.selectInPatientWithSurgery", param);
    }
}
