package com.zcreate.review.dao;

import com.zcreate.ReviewConfig;
import com.zcreate.review.model.Clinic;
import com.zcreate.review.model.PatientInfo;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-10-27
 * Time: 上午0:08
 */
public interface PatientInfoDAO {
    void setReviewConfig(ReviewConfig reviewConfig);

    Map<String,Object> getPatientInfo( int patientID);

    List<Map<String,Object>> getClinicPatient(String queryItem, String queryField, String timeFrom, String TimeTo);

    List<Map<String,Object>> getHospitalPatient(String queryItem, String queryField, String timeFrom, String TimeTo);
}
