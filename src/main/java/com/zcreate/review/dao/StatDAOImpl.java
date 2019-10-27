package com.zcreate.review.dao;

import com.zcreate.ReviewConfig;
import com.zcreate.pinyin.PinyinUtil;
import com.zcreate.util.Verify;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-2-11
 * Time: 下午4:21
 */
public class StatDAOImpl extends SqlSessionDaoSupport implements StatDAO, Serializable {
    private static ReviewConfig reviewConfig;

    public void setReviewConfig(ReviewConfig reviewConfig) {
        StatDAOImpl.reviewConfig = reviewConfig;
    }

    @SuppressWarnings("unchecked")
    public HashMap<String, Object> summary(Map param) {
        HashMap<String, Object> summary = getSqlSession().selectOne("DailySummary.summary", param);
        HashMap<String, Object> vdPatient = getSqlSession().selectOne("RxDetail.selectVDPatient", param);
        HashMap<String, Object> emeryPatient = getSqlSession().selectOne("RxDetail.selectEmergencyPatient", param);

        HashMap<String, Object> antiIncision = getSqlSession().selectOne("RecipeItem.antiIncision", param);
        summary.putAll(antiIncision);
        summary.putAll(emeryPatient);
        summary.putAll(vdPatient);

        if ((Integer) param.get("table") == 1) {
            HashMap<String, Object> summaryDrugNum = getSqlSession().selectOne("LYD.summaryHospitalDrugNum", param);
            HashMap<String, Object> summaryBase = getSqlSession().selectOne("LYD.summaryBase", param);
            summary.putAll(summaryDrugNum);
            summary.putAll(summaryBase);
        }

        return summary;
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> global(Map param) {
        if (Verify.isEmpty(param.get("department")) && Verify.isEmpty(param.get("departs")))
            return getSqlSession().selectList("DailySummary.chartTendency", param);
        else
            return getSqlSession().selectList("DailyDepart.chartTendency", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> healthAnalysis(Map param) {
        //System.out.println("param.get(\"department\") = " + param.get("department"));
        if (Verify.isEmpty(param.get("department")) && Verify.isEmpty(param.get("departs")))
            return getSqlSession().selectList("DailyMedicine.healthAnalysis", param);
        else
            return getSqlSession().selectList("LYD.healthAnalysis2", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> statMedicineByHealthNo(Map param) {
        if (Verify.isEmpty(param.get("department")) && Verify.isEmpty(param.get("departs")))
            return getSqlSession().selectList("DailyMedicine.statRxDetailByHealthNo", param);
        else
            return getSqlSession().selectList("LYD.statRxDetailByHealthNo2", param);
    }

    /*public Double useAntiDrugRatio(Map param) {
        return (Double) getSqlSession().selectOne("Stat.useAntiDrugRatio", param);
    }*/

    /* @SuppressWarnings("unchecked")
    public HashMap<String, Object> statMoneyAndRxCount(Map param) {
        if (((Integer) param.get("type")) == 0)
            return (HashMap<String, Object>) getSqlSession().selectOne("Stat.statMoneyAndRxCount", param);
        else
            return (HashMap<String, Object>) getSqlSession().selectOne("Stat.statMoneyAndRxCount2", param);
    }*/

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> statByMedicine(Map param) {
        param.put("prefix", reviewConfig.getPrefixRBAC());
        return getSqlSession().selectList("LYD.statByMedicine", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> statMedicineGroupByDepart(Map param) {
        return getSqlSession().selectList("LYD.statMedicineGroupByDepart", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> dailyMedicine(Map param) {
        return getSqlSession().selectList("DailyMedicine.dailyMedicine", param);
    }

    @SuppressWarnings("unchecked")
    public int dailyMedicineCount(Map param) {
        return (Integer) getSqlSession().selectOne("DailyMedicine.dailyMedicineCount", param);
    }

    @SuppressWarnings("unchecked")
    public HashMap<String, Object> dailySummary(Date dateFrom, Date dateTo) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("dateFrom", dateFrom);
        param.put("dateTo", dateTo);
        HashMap<String, Object> summary = getSqlSession().selectOne("DailySummary.summary", param);
        /*HashMap<String, Object> summaryDrugNum = (HashMap<String, Object>) getSqlSession().selectOne("LYD.summaryDrugNum", param);
        summary.putAll(summaryDrugNum);*/
        return summary;
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> statByDose(Map param) {
        if (Verify.isEmpty(param.get("department")) && Verify.isEmpty(param.get("departs")))
            return getSqlSession().selectList("DailyMedicine.statByDose", param);
        else
            return getSqlSession().selectList("DailyMedicine.statByDose2", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> queryPatientDrug(Map param) {
        List<HashMap<String, Object>> list = getSqlSession().selectList("LYD.queryPatientDrug", param);
        PinyinUtil.replaceName(list, "patientName");
        return list;
    }

    public int queryPatientDrugCount(Map param) {
        return (Integer) getSqlSession().selectOne("LYD.queryPatientDrugCount", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> monthKPI(Map param) {
        return getSqlSession().selectList("DailySummary.monthKPI", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> dailyKPI(Map param) {
        return getSqlSession().selectList("DailySummary.dailyKPI", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> medicineAmp(Map param) {
        return getSqlSession().selectList("DailyMedicine.medicineAmp", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> antiDrug(Map param) {
        return getSqlSession().selectList("LYD.antiDrug", param);
    }

    @Override
    public List<HashMap<String, Object>> queryMedicinePatient(Map<String, Object> param) {
        logger.debug("reviewConfig:" + reviewConfig);
        param.put("prefix", reviewConfig.getPrefixBD1000());
        param.put("prefix2", reviewConfig.getPrefixHospital(false));
        param.put("prefix3", reviewConfig.getPrefixHospital(true));
        return getSqlSession().selectList("LYD.selectMedicinePatient", param);
    }
}
