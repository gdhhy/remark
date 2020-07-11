package com.zcreate.review.dao;

import com.zcreate.review.model.Clinic;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-10-27
 * Time: 上午0:08
 */
public interface ClinicDAO {
    List<Clinic> getClinicList(Map<String, Object> param);

    Clinic getClinic(int clinicID);

    int getClinicCount(Map param);

    int save(Clinic clinic);

    List<Integer> getRandomClinicID(Map param);

    List<Integer> selectClinicIDForLinear(Map param);

    List<Clinic> getClinicByIDList(List<Integer> ids);

    List<HashMap<String, Object>> bypass(Map param);

    List<HashMap<String, Object>> selectClinicForExcel(Map param);

    List<HashMap<String, Object>> getReviewStat(Map param);

    List<HashMap<String, Object>> clinicSpecAnti(Map param);

    boolean publish(Map param);
}
