package com.zcreate.review.logic;

import com.zcreate.ReviewConfig;
import com.zcreate.remark.dao.DrugRecordsMapper;
import com.zcreate.remark.dao.SunningMapper;
import com.zcreate.remark.util.ParamUtils;
import com.zcreate.review.dao.DailyDAO;
import com.zcreate.review.dao.DailyDAOImpl;
import com.zcreate.review.dao.StatDAO;
import com.zcreate.review.dao.StatDAOImpl;
import com.zcreate.util.StatMath;
import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;

import static com.zcreate.remark.util.ParamUtils.produceMap;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-2-11
 * Time: 下午4:27
 */
public class StatServiceImpl implements StatService {
    static Logger logger = Logger.getLogger(StatServiceImpl.class);

    private static StatDAO statDao;
    private static DailyDAO dailyDao;
    @Autowired
    private DrugRecordsMapper drugRecordsMapper;
    @Autowired
    private SunningMapper sunningMapper;
    @Autowired
    private ReviewConfig reviewConfig;

    public StatServiceImpl() {
    }

    public StatServiceImpl(SqlSessionTemplate sqlMapClient) {
        StatDAOImpl statDao = new StatDAOImpl();
        statDao.setSqlSessionTemplate(sqlMapClient);
        StatServiceImpl.statDao = statDao;

        DailyDAOImpl dailyDao = new DailyDAOImpl();
        dailyDao.setSqlSessionTemplate(sqlMapClient);
        StatServiceImpl.dailyDao = dailyDao;
    }

    public HashMap<String, Object> summary(String fromDate, String toDate) {
        HashMap<String, Object> param = produceMap(fromDate, toDate);

        HashMap<String, Object> sunning = sunningMapper.getSunning(param);
        HashMap<String, Object> inOutPatient = sunningMapper.getSunningInPatient(param);

        sunning.putAll(inOutPatient);
        return sunning;
    }

    public List<HashMap<String, Object>> global(String fromDate, String toDate, String department) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department);
        List<HashMap<String, Object>> result = statDao.global(param);
        StatMath.sum(result, "clinicAmount", "hospitalAmount", "amount");
        StatMath.sum(result, "clinicAntiAmount", "hospitalAntiAmount", "antiAmount");
        return result;
    }

    public List<HashMap<String, Object>> healthAnalysis(String fromDate, String toDate, String healthNo, String department, int type) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department);
        //if(healthNo!=null)
        param.put("healthNo", healthNo);
        List<HashMap<String, Object>> result = statDao.healthAnalysis(param);
        //BigDecimal totalMoney=statDao.statMoney(param);
        // logger.debug("totalMoney="+totalMoney);
        StatMath.sumAndCalcRatio(result, "amount", "ratio");

        return result;
    }


    public List<HashMap<String, Object>> byMedicine(String fromDate, String toDate, String healthNo, Integer goodsID, String department,
                                                    int type, boolean top3, String special, int start, int limit) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department, type);
        param.put("start", start);
        param.put("limit", limit);
        param.put("likeHealthNo", healthNo);
        param.put("goodsID", goodsID);

        /*if (medicineNo.getBytes().length == medicineNo.length())
            param.put("medicineNo", medicineNo);
        else
            param.put("likeMedicineName", medicineNo);*/

        if ("anti".equals(special))
            param.put("antiClass", 0);
        if ("assist".equals(special))
            param.put("assist", true);
        if ("mental".equals(special))
            param.put("mental", true);
        if ("base1".equals(special))
            param.put("baseType", 1);
        if ("base2".equals(special))
            param.put("base", 2);
        if ("base3".equals(special))
            param.put("base", 3);
        if ("analgesics".equals(special))
            param.put("likeHealthNo", "4004");
        param.put("top3", top3);
        param.put("prefix", reviewConfig.getPrefixRBAC());
        List<HashMap<String, Object>> result;
        /*if ((department == null || "".equals(department)) && type <= 0)//无科室、全院
            result = statDao.dailyMedicine(param); //分页取
        else*/
        result = drugRecordsMapper.byMedicine(param); //取全部
        //logger.debug("result.size()=" + result.size());
        param.remove("likeHealthNo");
        param.remove("assist");
        param.remove("mental");
        //HashMap global = statDao.statMoneyAndRxCount(param);

        HashMap summary = drugRecordsMapper.dailySummary(ParamUtils.produceMap(fromDate, toDate, ""));

        for (HashMap<String, Object> aMap : result) {
            aMap.put("amountRatio", ((BigDecimal) aMap.get("amount")).divide(((BigDecimal) summary.get("clinicAmount")).add((BigDecimal) summary.get("hospitalAmount")), 5, BigDecimal.ROUND_HALF_UP));
            aMap.put("patientRatio", ((Integer) aMap.get("patient")) * 1.0 / ((Integer) summary.get("clinicPatient") + (Integer) summary.get("hospitalPatient")));
        }
        return result;
    }


    public List<HashMap<String, Object>> getDepartDetail(String fromDate, String toDate, String depart, int type, String healthNo, int antiClass) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, depart, -1);
        param.put("antiClass", antiClass);
        param.put("healthNo", healthNo);
        List<HashMap<String, Object>> result = dailyDao.getMedicineListByDepart(param);

        StatMath.sumAndCalcRatio(result, "amount", "ratioInDepart");
        return result;
    }

    public List<HashMap<String, Object>> getDailyInOut(int recordCount) {
        HashMap<String, Object> param = new HashMap<String, Object>(1);
        param.put("recordCount", recordCount);
        return dailyDao.getDailyInOut(param);
    }

    @Override
    public List<HashMap<String, Object>> getAntiGroupDepartment(String fromDate, String toDate) {
        HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate);
        List<HashMap<String, Object>> list = drugRecordsMapper.selectAntiGroupDepartment(param);

        StatMath.ratio(list, "antiAmount", "amount", "amountRatio");
        StatMath.ratio(list, "outAntiPatient", "outPatient", "antiPatientRatio");
        StatMath.sumAndCalcRatio(list, "antiAmount", "antiAmountRatio");
        StatMath.ratio(list, "clinicAntiPatient", "clinicPatient", "clinicAntiPatientRatio");
        StatMath.sumAndCalcRatio(list, "clinicAntiPatient", "clinicAntiCompose");
        StatMath.sumAndCalcRatio(list, "AUD", "AUDRatio");

        return list;
    }

    @Override
    public List<HashMap<String, Object>> getAntiGroupDoctor(String fromDate, String toDate) {
        HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate);
        List<HashMap<String, Object>> list = drugRecordsMapper.selectAntiGroupDoctor(param);

        StatMath.ratio(list, "antiAmount", "amount", "amountRatio");
        StatMath.ratio(list, "outAntiPatient", "outPatient", "antiPatientRatio");
        StatMath.sumAndCalcRatio(list, "antiAmount", "antiAmountRatio");
        StatMath.ratio(list, "clinicAntiPatient", "clinicPatient", "clinicAntiPatientRatio");
        StatMath.sumAndCalcRatio(list, "clinicAntiPatient", "clinicAntiCompose");
        StatMath.sumAndCalcRatio(list, "AUD", "AUDRatio");

        return list;
    }
}
