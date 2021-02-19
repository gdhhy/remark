package com.zcreate.review.dao;

import com.zcreate.ReviewConfig;
import com.zcreate.pinyin.PinyinUtil;
import com.zcreate.review.model.Clinic;
import com.zcreate.review.model.RxDetail;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import java.io.Serializable;
import java.util.*;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-10-27
 * Time: 上午0:08
 */
public class ClinicDAOImpl extends SqlSessionDaoSupport implements ClinicDAO, Serializable {
    private static ReviewConfig reviewConfig;

    public void setReviewConfig(ReviewConfig reviewConfig) {
        ClinicDAOImpl.reviewConfig = reviewConfig;
    }

    @SuppressWarnings("unchecked")
    public List<Clinic> getClinicList(Map<String, Object> param) {
        List<Clinic> list = getSqlSession().selectList("Clinic.selectClinicList", param);
        PinyinUtil.replaceName(list, "doctorName");
        PinyinUtil.replaceName(list, "confirmName");
        PinyinUtil.replaceName(list, "apothecaryName");
        PinyinUtil.replaceName(list, "patientName");
        return list;
    }

    /**
     * 改用  getRxByhospID，废掉
     * 因为hospID可以唯一标识处方，个别医生为了规避药品处方数大于5，同一个病人开多张处方
     *
     * @param clinicID
     * @return
     */
    @SuppressWarnings("unchecked")
    public Clinic getClinic(int clinicID) {
        Clinic clinic = getSqlSession().selectOne("Clinic.selectClinic", clinicID);

        Map<String, Object> param = new HashMap<>();
        Calendar cal = Calendar.getInstance();
        cal.setTime(clinic.getClinicDate());
        param.put("RxDetailTable", "RxDetail_" + cal.get(Calendar.YEAR));//clinic.getClinicDate().getYear()+1900));
        param.put("clinicID", clinicID);//clinic.getClinicDate().getYear()+1900));
        clinic.setIncompatibilitys(queryIncompatibilitys(param));
        clinic.setDetails(selectRxDetail2Review(param));

        return clinic;
    }

    public List<HashMap<String, Object>> queryIncompatibilitys(Map param) {
        return getSqlSession().selectList("Drug.queryByClinicID", param);
    }

    public List<RxDetail> selectRxDetail2Review(Map param) {
        return getSqlSession().selectList("RxDetail.selectRxDetail2Review", param);
    }

    public int getClinicCount(Map param) {
        return (Integer) getSqlSession().selectOne("Clinic.selectClinicCount", param);
    }

    public int save(Clinic clinic) {
        return getSqlSession().update("Clinic.updateClinic", clinic);
    }

    public boolean publish(Map param) {
        return getSqlSession().update("Clinic.reviewAlertDoctor", param) == 1;
    }

    @SuppressWarnings("unchecked")
    public List<Integer> getRandomClinicID(Map param) {
        param.put("atLeastDrugNum", 0);
        param.put("notZeroMoney", true);
        return getSqlSession().selectList("Clinic.selectRandomClinicID", param);
    }

    @SuppressWarnings("unchecked")
    public List<Integer> selectClinicIDForLinear(Map param) {
        param.put("atLeastDrugNum", 0);
        param.put("notZeroMoney", true);
        return getSqlSession().selectList("Clinic.selectClinicIDForLinear", param);
    }


    /* public List<Integer> getLinearRxID(Map param) {
        getSqlSession().selectOne("Clinic.selectLinearRxID", param);
        System.out.println("--------------param result2= " + param.get("result2"));
        if (param.get("result2") == null || "".equals(param.get("result2")))
            return new ArrayList<Integer>(0);
        int result[] = StringUtils.splitToInts((String) param.get("result2"), ",");
        List<Integer> ret = new ArrayList<Integer>(result.length);
        for (int ii : result) ret.add(ii);
        return ret;
    }*/

    @SuppressWarnings("unchecked")
    public List<Clinic> getClinicByIDList(List<Integer> ids) {
        if (ids.size() > 0)
            return getSqlSession().selectList("Clinic.selectClinicInID", ids);
        else
            return new ArrayList<Clinic>(0);
    }

    /*  @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> selectPatientDrug(Map param) {
        return getSqlSession().selectList("RxDetail.selectPatientDrug", param);
    }*/

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> bypass(Map param) {
        return getSqlSession().selectList("Clinic.bypass", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> selectClinicForExcel(Map param) {
        return getSqlSession().selectList("Clinic.selectClinicForExcel", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getReviewStat(Map param) {
        if (reviewConfig.getDeployLocation().contains("xf"))
            param.put("largeAmount", 150);
        else
            param.put("largeAmount", 300);
        return getSqlSession().selectList("Clinic.selectClinicReviewStat", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> clinicSpecAnti(Map param) {
        return getSqlSession().selectList("Clinic.clinicSpecAnti", param);
    }
}
