package com.zcreate.review.dao;

import com.zcreate.ReviewConfig;
import com.zcreate.pinyin.PinyinUtil;
import com.zcreate.review.model.Clinic;
import com.zcreate.review.model.PatientInfo;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-10-27
 * Time: 上午0:08
 */
public class PatientInfoDAOImpl extends SqlSessionDaoSupport implements PatientInfoDAO, Serializable {
    private static ReviewConfig reviewConfig;


    public void setReviewConfig(ReviewConfig reviewConfig) {
        PatientInfoDAOImpl.reviewConfig = reviewConfig;
    }

    @Override
    public Map<String,Object> getPatientInfo(int patientID) {
        return getSqlSession().selectOne("PatientInfo.selectPatient", patientID);
    }

    @Override
    public List<Map<String,Object>> getClinicPatient(String queryItem, String clinicNo, String timeFrom, String timeTo) {
        Map<String, Object> param = new HashMap<>(3);
        param.put(queryItem, clinicNo);
        param.put("timeFrom", timeFrom);
        param.put("timeTo", timeTo);
        logger.debug("deploy:" + reviewConfig.getDeployLocation());

        param.put("prefix", reviewConfig.getPrefixBD1000());
        return getSqlSession().selectList("PatientInfo.selectClinicPatient", param);

    }

    @Override
    public List<Map<String,Object>> getHospitalPatient(String queryItem, String serialNo, String timeFrom, String timeTo) {
        Map<String, Object> param = new HashMap<>(3);
        param.put(queryItem, serialNo);
        param.put("timeFrom", timeFrom);
        param.put("timeTo", timeTo);

        param.put("prefix", reviewConfig.getPrefixHospital(false));
        param.put("hPrefix", reviewConfig.getPrefixHospital(true));
        return getSqlSession().selectList("PatientInfo.selectHospitalPatient", param);

    }
}
