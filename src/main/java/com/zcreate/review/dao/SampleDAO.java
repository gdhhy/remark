package com.zcreate.review.dao;

import com.zcreate.review.model.SampleBatch;
import com.zcreate.review.model.SampleList;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 11-12-26
 * Time: 下午8:27
 */
public interface SampleDAO {

    List<HashMap<String, Object>> getSampleList(int sampleBatchID, int type, int start, int limit);

    //int getSampleDetailCount(int sampleBatchID);

    List<SampleBatch> getSampleBatchList(Map<String, Object> param);

    SampleBatch getSampleBatch(int sampleBatchID);

    int getSampleBatchCount(Map<String, Object> param);

    //int saveSampleBatch(SampleBatch sampleBatch);

    int insertSampleDetail(SampleList detail);

    void insert(SampleBatch sampleBatch);

    int deleteByPrimaryKey(Integer sampleBatchID);

    int deleteDetailBySampleBatchID(Integer sampleBatchID);

    int deleteSample(Map<String, Object> param);

    HashMap<String, Object> statSampleBatch(int sampleBatchID);

    //int deleteDetail(List<String> detailID);

    List<HashMap<String, Object>> getLastReview(int topRecord);

    List<HashMap<String, Object>> getLastReviewByDoctor(int topRecord);

   /*List<HashMap<String, Object>> getReviewClinic(Map param);

    List<HashMap<String, Object>> getReviewHospital(Map param);

    int getReviewClinicCount(Map param);*/

    //int getReviewHospitalCount(Map param);
}
