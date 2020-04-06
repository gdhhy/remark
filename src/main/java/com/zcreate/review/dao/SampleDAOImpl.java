package com.zcreate.review.dao;

import com.zcreate.pinyin.PinyinUtil;
import com.zcreate.review.model.SampleBatch;
import com.zcreate.review.model.SampleList;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-1-5
 * Time: 上午8:31
 */
public class SampleDAOImpl extends SqlSessionDaoSupport implements SampleDAO, Serializable {


    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getSampleList(int sampleBatchID, int type, int start, int limit) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("start", start);
        param.put("limit", limit);
        param.put("sampleBatchID", sampleBatchID);
        List<HashMap<String, Object>> list;
        if (type == 1) {
            list = getSqlSession().selectList("SampleList.selectSampleClinic", param);
            PinyinUtil.replaceName(list, "doctorName");
            PinyinUtil.replaceName(list, "apothecaryName");
            PinyinUtil.replaceName(list, "confirmName");
        } else {
            list = getSqlSession().selectList("SampleList.selectSampleInPatient", param);
            PinyinUtil.replaceName(list, "masterDoctorName");
        }

        return list;
    }

    public int getSampleDetailCount(int sampleBatchID) {
        return (Integer) getSqlSession().selectOne("SampleList.selectSampleDetailCount", sampleBatchID);
    }

    @SuppressWarnings("unchecked")
    public List<SampleBatch> getSampleBatchList(Map param) {
        /* Map<String, Object> param = new HashMap<String, Object>();
       param.put("start", start);
       param.put("limit", limit);*/
        return getSqlSession().selectList("SampleBatch.selectSampleBatchList", param);
    }

    public SampleBatch getSampleBatch(int sampleBatchID) {
        return (SampleBatch) getSqlSession().selectOne("SampleBatch.selectSampleBatch", sampleBatchID);
    }

    public int getSampleBatchCount(Map param) {
        return (Integer) getSqlSession().selectOne("SampleBatch.selectSampleBatchCount", param);
    }

    /* public int getSampleDetailCount(HashMap param) {
        return (Integer) getSqlSession().selectOne("SampleBatch.selectSampleCount", param);
    }

    public int saveSampleBatch(SampleBatch sampleBatch) {
        return getSqlSession().update("SampleBatch.updateSampleBatch", sampleBatch);
    }*/

    public int insertSampleDetail(SampleList detail) {
        return getSqlSession().insert("SampleList.insertSampleDetail", detail);
    }
/*
    public int saveSampleDetail(SampleList detail) {
        return getSqlSession().update("SampleList.updateSampleDetail", detail);
    }*/

    public void insert(SampleBatch sampleBatch) {
        int insertReturn = getSqlSession().insert("SampleBatch.insertSampleBatch", sampleBatch);
        // sampleBatch.setSampleBatchID(insertReturn);
        //logger.debug("insertReturn="+insertReturn);
        //logger.debug("sampleBatch.getSampleBatchID()="+sampleBatch.getSampleBatchID());
    }

    public int deleteByPrimaryKey(Integer sampleBatchID) {
        return getSqlSession().delete("SampleBatch.deleteSampleBatch", sampleBatchID);
    }

    public int deleteDetailBySampleBatchID(Integer sampleBatchID) {
        return getSqlSession().delete("SampleList.deleteSampleDetailByBatchID", sampleBatchID);
    }

    @SuppressWarnings("unchecked")
    public HashMap<String, Object> statSampleBatch(int sampleBatchID) {
        return (HashMap<String, Object>) getSqlSession().selectOne("SampleBatch.statBatch", sampleBatchID);
    }

    public int deleteDetail(List<String> detailIDs) {
        return getSqlSession().delete("SampleList.deleteSampleDetail", detailIDs);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getLastReview(int topRecord) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("recordCount", topRecord);
        return getSqlSession().selectList("SampleList.selectLastReview", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getLastReviewByDoctor(int topRecord) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("recordCount", topRecord);
        return getSqlSession().selectList("SampleList.selectLastReviewByDoctor", param);
    }

    @Override
    public int deleteSample(Map<String, Object> param) {
        return getSqlSession().delete("SampleList.deleteSample", param);
    }
    /*  @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getReviewClinic(Map param) {
        return getSqlSession().selectList("SampleList.selectReviewClinic", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getReviewHospital(Map param) {
        return getSqlSession().selectList("SampleList.selectReviewHospital", param);
    }

    @SuppressWarnings("unchecked")
    public int getReviewClinicCount(Map param) {
        return getSqlSession().selectOne("SampleList.selectReviewClinicCount", param);
    }*/


   /* public int getReviewHospitalCount(Map param) {
        return getSqlSession().selectOne("SampleList.selectReviewHospitalCount", param);
    }*/
}
