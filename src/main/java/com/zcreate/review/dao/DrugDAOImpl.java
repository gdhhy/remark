package com.zcreate.review.dao;

import com.zcreate.ReviewConfig;
import com.zcreate.review.model.Drug;
import com.zcreate.review.model.DrugDose;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 11-11-16
 * Time: 下午4:06
 */
public class DrugDAOImpl extends SqlSessionDaoSupport implements DrugDAO, Serializable {
    private static ReviewConfig reviewConfig;
    // static Logger logger = Logger.getLogger(DrugDAOImpl.class);
    static int tmpHasData;

    @Autowired
    public void setReviewConfig(ReviewConfig reviewConfig) {
        DrugDAOImpl.reviewConfig = reviewConfig;
    }

    public int save(Drug drug) {
        drug.setDeployLocation(reviewConfig.getDeployLocation());
        return getSqlSession().update("Drug.updateDrugByPrimaryKeySelective", drug);
    }

    public int deleteByPrimaryKey(Integer drugID) {
        return getSqlSession().delete("Drug.deleteDrug", drugID);
    }

    public boolean restore(Integer drugID) {
        return getSqlSession().update("Drug.restoreDrug", drugID) == 1;
    }

    public boolean invalid(Integer drugID) {
        return getSqlSession().update("Drug.invalidDrug", drugID) == 1;
    }

    public int insert(Drug drug) {
        drug.setDeployLocation(reviewConfig.getDeployLocation());
        return getSqlSession().insert("Drug.insertDrug", drug);
    }

   /* @SuppressWarnings("unchecked")
    public List<Drug> selectByParentID(Integer parentID) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("parentID", parentID);
        return getSqlSession().selectList("Drug.selectDrug", param);
    }*/

    public Drug getDrug(Integer drugID) {
        return (Drug) getSqlSession().selectOne("Drug.selectDrug", drugID);
    }


    public List<HashMap> query(Map<String,Object> param) {
        decideRefreshTmpIncomp();

        param.put("orderField", "drugID");
        return getSqlSession().selectList("Drug.queryDrug", param);
    }


   /* public List<Drug> liveDrug(Map param) {
        decideRefreshTmpIncomp();

        param.put("orderField", "drugID");
        param.put("live", Boolean.TRUE);
        return getSqlSession().selectList("Drug.queryDrug", param);
    }*/

    public int queryCount(Map param) {
        return (Integer) getSqlSession().selectOne("Drug.queryDrugCount", param);
    }

    /**
     * @see IncompatibilityDAOImpl
     */
    public void decideRefreshTmpIncomp() {
        if (tmpHasData == 0) {
            logger.debug("IncompatibilityDAOImpl.createTmpIncompatibility");

            getSqlSession().update("Drug.truncateTmpIncompatibility");//清空
            int insertTmpCount = getSqlSession().insert("Drug.createTmpIncompatibility");//再创建

            logger.debug("insertTmpCount=" + insertTmpCount);
            tmpHasData = 1;
        }
    }

    public static void setTmpDataInvalid() {
        tmpHasData = 0;
    }
    //DrugDose

    public int insertDrugDose(DrugDose drugDose) {
        return getSqlSession().insert("Drug.insertDrugDose", drugDose);
    }

    public List<DrugDose> selectDrugDose(int drugID) {
        return getSqlSession().selectList("Drug.selectDrugDose", drugID);
    }

    public int deleteDrugDose(int drugDoseID) {
        return getSqlSession().delete("Drug.deleteDrugDose", drugDoseID);
    }

    public int saveDrugDose(DrugDose drugDose) {
        return getSqlSession().update("Drug.updateDrugDose", drugDose);
    }
}
