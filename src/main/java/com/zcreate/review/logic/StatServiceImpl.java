package com.zcreate.review.logic;

import ChartDirector.XYChart;
import com.zcreate.remark.dao.DrugRecordsMapper;
import com.zcreate.review.dao.DailyDAO;
import com.zcreate.review.dao.DailyDAOImpl;
import com.zcreate.review.dao.StatDAO;
import com.zcreate.review.dao.StatDAOImpl;
import com.zcreate.util.DateUtils;
import com.zcreate.util.StatMath;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;

import java.math.BigDecimal;
import java.util.*;

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

    public HashMap<String, Object> summary(String fromDate, String toDate, String department, int type, int table) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department, type);
        param.put("table", table);

        if (table == 0) {
            param.put("RxDetailTable", "RxDetail_" + fromDate.substring(0, 4));
            param.put("DrugRecordsTable", "DrugRecords_" + fromDate.substring(0, 4));
            param.put("RecipeItemTable", "RecipeItem_" + fromDate.substring(0, 4));
        }
        HashMap<String, Object> result = statDao.summary(param);
        result.putAll(drugRecordsMapper.summaryHospitalDrugNum(param));
        result.putAll(drugRecordsMapper.summaryBase(param));
        return result;
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


    public List<HashMap<String, Object>> getMedicineByHealthNo(String fromDate, String toDate, String healthNo,
                                                               String department, int type) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department, type);
        param.put("healthNo", healthNo);
        List<HashMap<String, Object>> result = statDao.statMedicineByHealthNo(param);

        StatMath.sumAndCalcRatio(result, "amount", "ratio");
        return result;
    }

    public List<HashMap<String, Object>> statByHealthNo(int start, int limit, String fromDate, String toDate,
                                                        String healthNo, String medicineNo, String department, int type, boolean top3, String special) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department, type);
        param.put("start", start);
        param.put("limit", limit);
        param.put("likeHealthNo", healthNo);

        if (medicineNo.getBytes().length == medicineNo.length())
            param.put("medicineNo", medicineNo);
        else
            param.put("likeMedicineName", medicineNo);

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
        param.put("top3", top3);
        List<HashMap<String, Object>> result;
        /*if ((department == null || "".equals(department)) && type <= 0)//无科室、全院
            result = statDao.dailyMedicine(param); //分页取
        else*/
        result = drugRecordsMapper.statByMedicine(param); //取全部
        //logger.debug("result.size()=" + result.size());
        param.remove("likeHealthNo");
        param.remove("assist");
        param.remove("mental");
        //HashMap global = statDao.statMoneyAndRxCount(param);
        Date dateTo = null;
        if (!"".equals(toDate)) {
            Calendar cal = DateUtils.parseCalendarDayFormat(toDate);
            cal.add(Calendar.DATE, 1);
            dateTo = cal.getTime();
        }
        HashMap summary = statDao.dailySummary(DateUtils.parseDateDayFormat(fromDate), dateTo);

        for (HashMap<String, Object> aMap : result) {
            aMap.put("amountRatio", ((BigDecimal) aMap.get("amount")).divide(((BigDecimal) summary.get("clinicAmount")).add((BigDecimal) summary.get("hospitalAmount")), 5, BigDecimal.ROUND_HALF_UP));
            aMap.put("patientRatio", ((Integer) aMap.get("patient")) * 1.0 / ((Integer) summary.get("clinicPatient") + (Integer) summary.get("hospitalPatient")));
        }
        return result;
    }

    public List<HashMap<String, Object>> statMedicineGroupByDepart(String fromDate, String toDate, String medicineNo,
                                                                   String department, int type) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department, type);
        param.put("medicineNo", medicineNo);
        List<HashMap<String, Object>> result = statDao.statMedicineGroupByDepart(param);

        StatMath.sumAndCalcRatio(result, "amount", "ratio");
        return result;
    }

    public List<HashMap<String, Object>> getDoctorListByMedicine(String fromDate, String toDate, String medicineNo, String department, boolean viewDoctorNum) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department);
        param.put("medicineNo", medicineNo);
        List<HashMap<String, Object>> result = dailyDao.getDoctorListByMedicine(param);

        if (!viewDoctorNum)
            for (HashMap<String, Object> aMap : result) {
                aMap.put("amount", "-");
                aMap.put("quantity", "-");
            }
        return result;
    }


    public List<HashMap<String, Object>> statByDose(int start, int limit, String fromDate, String toDate, String healthNo, String department, int type) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department);
        param.put("start", start);
        param.put("limit", limit);
        param.put("healthNo", healthNo);

        List<HashMap<String, Object>> result = statDao.statByDose(param);
        StatMath.sumAndCalcRatio(result, "amount", "amountRatio");

        return result;
    }

    public XYChart statMedicineGroupByDate(int chartWidth, int chartHeight, String fromDate, String toDate, String medicineNo, String department, String doctorName, int type) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department, type);//本查询type没用到，for循环时用到
        param.put("medicineNo", medicineNo);
        param.put("doctorName", doctorName);
        List<HashMap<String, Object>> result = dailyDao.queryMedicine(param);
        return null;
        //return StatAction.createXYChart(chartWidth, chartHeight, result, "amount", "date", "元", Color.red.getRed());

    }

    public XYChart statMedicineGroupByMonth(int chartWidth, int chartHeight, String medicineNo, String department, String doctorName) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("department", department);
        param.put("doctorName", doctorName);
        param.put("medicineNo", medicineNo);
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, -6);
        cal = DateUtils.getFirstDayOfMonth(cal);
        param.put("fromDate", cal.getTime());
        List<HashMap<String, Object>> result = dailyDao.queryMedicineByMonth(param);
        return null;
        //return StatAction.createBarChart2(chartWidth, chartHeight, result, "amount", "month", "元", Color.red.getRed());

    }

    public XYChart statMultiMedicineGroupByDate(int chartWidth, int chartHeight, String fromDate, String toDate, String medicineNos, String department, int type) {
        String medicineNo[] = StringUtils.split(medicineNos, ";");
        List<List<HashMap<String, Object>>> multi = new ArrayList<List<HashMap<String, Object>>>(medicineNo.length);
        HashMap<String, Object> param = produceMap(fromDate, toDate, department, type);//本查询type没用到，for循环时用到
        for (String aMedicineNo : medicineNo) {
            param.put("medicineNo", aMedicineNo);
            List<HashMap<String, Object>> result = dailyDao.queryMedicine(param);
            multi.add(result);
        }
        return null;
        //return StatAction.createMultiXYChart(chartWidth, chartHeight, multi, "amount", "date", "元");
    }

    public XYChart doseTrend(int chartWidth, int chartHeight, String fromDate, String toDate, String dose, String healthNo, String department, int type) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department);//本查询type没用到，for循环时用到
        param.put("dose", dose);
        param.put("healthNo", healthNo);
        if (dose == null || "".equals(dose))
            param.put("nullDose", true);
        List<HashMap<String, Object>> result = dailyDao.trendByDose(param);
        return null;
        //return StatAction.createXYChart(chartWidth, chartHeight, result, "amount", "date", "元", Color.red.getRed());

    }

    public XYChart baseDoctorTrend(int chartWidth, int chartHeight, String fromDate, String toDate, String department, String doctorName, int baseType, int type) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department);
        param.put("doctorName", doctorName);
        param.put("baseType", baseType);
        // logger.debug("-----------------antibi osis=" + antib iosis);
        List<HashMap<String, Object>> result = dailyDao.baseDoctorTrend(param);
        //Medicine medicine = medicineDao.getMedicine(medicineNo);
        for (HashMap<String, Object> aMap : result)
            aMap.put("aaa", aMap.get("amount"));
        logger.debug("trend=" + result);
        return null;
        //return StatAction.createXYChart(chartWidth, chartHeight, result, "aaa", "date", "元", Color.red.getRed());

    }

    public XYChart baseDepartTrend(int chartWidth, int chartHeight, String fromDate, String toDate, String department, String doctorName, int baseType, int type) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department);
        param.put("doctorName", doctorName);
        param.put("baseType", baseType);
        // logger.debug("-----------------antibi osis=" + antib iosis);
        List<HashMap<String, Object>> result = dailyDao.baseDepartTrend(param);
        //Medicine medicine = medicineDao.getMedicine(medicineNo);
        for (HashMap<String, Object> aMap : result)
            aMap.put("aaa", aMap.get("amount"));
        return null;
        //return StatAction.createXYChart(chartWidth, chartHeight, result, "aaa", "date", "元", Color.red.getRed());

    }

    public XYChart doctorTrend(int chartWidth, int chartHeight, String fromDate, String toDate, String department, String doctorName, int antiClass, int type) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department);
        param.put("doctorName", doctorName);
        param.put("antiClass", antiClass);
        // logger.debug("-----------------antibi osis=" + antib iosis);
        List<HashMap<String, Object>> result = dailyDao.trendByDoctor(param);
        //Medicine medicine = medicineDao.getMedicine(medicineNo);
        for (HashMap<String, Object> aMap : result)
            aMap.put("aaa", aMap.get("amount"));
        return null;
        //return StatAction.createXYChart(chartWidth, chartHeight, result, "aaa", "date", "元", Color.red.getRed());

    }

    public XYChart multiDoctorTrend(int chartWidth, int chartHeight, String fromDate, String toDate, String department, String doctorNames, int antiClass, int type) {
        String doctorName[] = StringUtils.split(doctorNames, ";");
        List<List<HashMap<String, Object>>> multi = new ArrayList<List<HashMap<String, Object>>>(doctorName.length);
        for (String aDoctorName : doctorName) {
            HashMap<String, Object> param = produceMap(fromDate, toDate, department);
            param.put("doctorName", aDoctorName);
            param.put("antiClass", antiClass);
            // logger.debug("-----------------antibi osis=" + antib iosis);
            List<HashMap<String, Object>> result = dailyDao.trendByDoctor(param);

            //Medicine medicine = medicineDao.getMedicine(medicineNo);
            // for (HashMap<String, Object> aResult : result)
            result.get(0).put("chnName", aDoctorName);

            multi.add(result);
        }
        return null;
        //return StatAction.createMultiXYChart(chartWidth, chartHeight, multi, "amount", "date", "元");

    }

    public List<HashMap<String, Object>> byDepart(String fromDate, String toDate, int type, String healthNo, String medicineNo) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        if (medicineNo.getBytes().length == medicineNo.length())  //无汉字
            param.put("medicineNo", medicineNo);
        else
            param.put("medicineName", medicineNo);
        param.put("healthNo", healthNo);

        if (!"".equals(fromDate))
            param.put("fromDate", DateUtils.parseDateDayFormat(fromDate));
        if (!"".equals(toDate)) {
            Calendar cal = DateUtils.parseCalendarDayFormat(toDate);
            cal.add(Calendar.DATE, 1);
            param.put("toDate", cal.getTime());
        }
        param.put("orderField", "sum(clinicAmount+hospitalAmount)");

        List<HashMap<String, Object>> result = dailyDao.byDepart(param);
        StatMath.sumAndCalcRatio(result, "amount", "amountRatio");
        StatMath.ratio(result, "insuranceAmount", "amount", "insuranceRatio");

        return result;
    }

    public List<HashMap<String, Object>> antiByDepart(String fromDate, String toDate, int antiClass, String medicineNo) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("antiClass", antiClass);
        param.put("medicineNo", medicineNo);

        if (!"".equals(fromDate))
            param.put("fromDate", DateUtils.parseDateDayFormat(fromDate));
        if (!"".equals(toDate)) {
            Calendar cal = DateUtils.parseCalendarDayFormat(toDate);
            cal.add(Calendar.DATE, 1);
            param.put("toDate", cal.getTime());
        }
        //param.put("orderField", "antiAmount");
        return dailyDao.antiByDepart(param);
    }


    public List<HashMap<String, Object>> getDepartDetail(String fromDate, String toDate, String depart, int type, String healthNo, int antiClass) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, depart, -1);
        param.put("antiClass", antiClass);
        param.put("healthNo", healthNo);
        List<HashMap<String, Object>> result = dailyDao.getMedicineListByDepart(param);

        StatMath.sumAndCalcRatio(result, "amount", "ratioInDepart");
        return result;
    }

    //todo 上下两个函数代码可以合并
    public List<HashMap<String, Object>> getMedicineListByDoctor(String fromDate, String toDate, String department, String doctorName, int type, int antiClass, boolean hasViewProp) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department, -1);
        param.put("antiClass", antiClass);
        logger.debug("--antiClass=" + antiClass);
        param.put("doctorName", doctorName);
        List<HashMap<String, Object>> result = dailyDao.getMedicineListByDoctor(param);


        if (!hasViewProp)
            for (HashMap<String, Object> aMap : result) {
                aMap.put("amount", "-");
                aMap.put("quantity", "-");
                aMap.put("ratio", "-");
            }
        else {
            //计算各药品占总金额比例
            BigDecimal totalAmount = BigDecimal.ZERO;
            for (HashMap aMap : result)
                totalAmount = totalAmount.add((BigDecimal) aMap.get("amount"));
            for (HashMap<String, Object> aMap : result)
                if (totalAmount.compareTo(BigDecimal.ZERO) > 0)
                    aMap.put("ratio", ((BigDecimal) aMap.get("amount")).divide(totalAmount, 4, BigDecimal.ROUND_HALF_UP));
                else aMap.put("ratio", 0);
        }
        return result;
    }

    public List<HashMap<String, Object>> getBaseListByDoctor(String fromDate, String toDate, String department, String doctorName, int type, int baseType, boolean hasViewProp) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department, -1);

        param.put("doctorName", doctorName);
        List<HashMap<String, Object>> result = dailyDao.getBaseListByDoctor(param);


        if (!hasViewProp)
            for (HashMap<String, Object> aMap : result) {
                aMap.put("amount", "-");
                aMap.put("quantity", "-");
                aMap.put("ratio", "-");
            }
        else {
            //计算各药品占总金额比例
            BigDecimal totalAmount = BigDecimal.ZERO;
            for (HashMap aMap : result)
                totalAmount = totalAmount.add((BigDecimal) aMap.get("amount"));
            for (HashMap<String, Object> aMap : result)
                if (totalAmount.compareTo(BigDecimal.ZERO) > 0)
                    aMap.put("ratio", ((BigDecimal) aMap.get("amount")).divide(totalAmount, 4, BigDecimal.ROUND_HALF_UP));
                else aMap.put("ratio", 0);
        }
        return result;
    }

    public List<HashMap<String, Object>> getBaseListByDepart(String fromDate, String toDate, String department, int type, int baseType, boolean hasViewProp) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department, -1);


        param.put("baseType", baseType);
        List<HashMap<String, Object>> result = dailyDao.getBaseListByDepart(param);
        logger.debug("re11=" + result);


        if (!hasViewProp)
            for (HashMap<String, Object> aMap : result) {
                aMap.put("amount", "-");
                aMap.put("quantity", "-");
                aMap.put("ratio", "-");
            }
        else {
            //计算各药品占总金额比例
            BigDecimal totalAmount = BigDecimal.ZERO;
            for (HashMap aMap : result)
                totalAmount = totalAmount.add((BigDecimal) aMap.get("amount"));
            for (HashMap<String, Object> aMap : result)
                if (totalAmount.compareTo(BigDecimal.ZERO) > 0)
                    aMap.put("ratio", ((BigDecimal) aMap.get("amount")).divide(totalAmount, 4, BigDecimal.ROUND_HALF_UP));
                else aMap.put("ratio", 0);
        }
        return result;
    }

    public XYChart medicineTrend(int chartWidth, int chartHeight, String fromDate, String toDate, String department, String healthNo, String medicineNo, String fieldName, String unit) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department);
        param.put("healthNo", healthNo);
        param.put("medicineNo", medicineNo);
        logger.debug("fieldName=" + fieldName);
        List<HashMap<String, Object>> result = dailyDao.medicineTrend(param);
        return null;
        //return StatAction.createXYChart(chartWidth, chartHeight, result, fieldName, "date", unit, Color.blue.getRed());
    }

    public List<HashMap<String, Object>> byDoctor(String fromDate, String toDate, String department) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department);
        if (department != null && department.indexOf(",") <= 0)
            param.put("department", department);
        else if (department != null) {
            String[] departs = department.split(",");
            param.put("departs", departs);
            param.remove("department");
        }
        return dailyDao.statByDoctor(param);
    }

    public List<HashMap<String, Object>> baseState(String fromDate, String toDate, String department) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department);
        return dailyDao.baseState(param);
    }

    public List<HashMap<String, Object>> departBase(String fromDate, String toDate, String department) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department);
        return dailyDao.departBase(param);
    }
    /*public List<HashMap<String, Object>> byDepartDoctor(String fromDate, String toDate) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, null);
        return dailyDao.byDepartDoctor(param);
    }*/

    public List<HashMap<String, Object>> queryPatientDrug(int start, int limit, String fromDate, String toDate, int type, String patient, String healthNo, String medicineNo) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, "", type);
        param.put("start", start);
        param.put("limit", limit);
        param.put("healthNo", healthNo);
        param.put("patient", patient);
        if (medicineNo.getBytes().length == medicineNo.length())  //无汉字
            param.put("medicineNo", medicineNo);
        else
            param.put("medicineName", medicineNo);
        return statDao.queryPatientDrug(param);
    }

    public int queryPatientDrugCount(String fromDate, String toDate, int type, String patient, String healthNo, String medicineNo) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, "", type);
        param.put("healthNo", healthNo);
        param.put("patient", patient);
        if (medicineNo.getBytes().length == medicineNo.length())  //无汉字
            param.put("medicineNo", medicineNo);
        else
            param.put("medicineName", medicineNo);
        return statDao.queryPatientDrugCount(param);
    }

    public List<HashMap<String, Object>> getPatientInOut(String dailyDate) {
        HashMap<String, Object> param = new HashMap<String, Object>(2);
        param.put("dailyDate", dailyDate);
        Calendar cal = DateUtils.parseCalendarDayFormat(dailyDate);
        cal.add(Calendar.DATE, 1);
        param.put("dailyDate2", DateUtils.formatSqlDate(cal.getTime()));
        return dailyDao.getPatientInOut(param);
    }

    public List<HashMap<String, Object>> getDailyInOut(int recordCount) {
        HashMap<String, Object> param = new HashMap<String, Object>(1);
        param.put("recordCount", recordCount);
        return dailyDao.getDailyInOut(param);
    }

    public List<HashMap<String, Object>> monthKPI(int recordCount) {
        HashMap<String, Object> param = new HashMap<String, Object>(1);
        param.put("recordCount", recordCount);
        return statDao.monthKPI(param);
    }

    public List<HashMap<String, Object>> dailyKPI(int recordCount) {
        HashMap<String, Object> param = new HashMap<String, Object>(1);
        param.put("recordCount", recordCount);
        return statDao.dailyKPI(param);
    }

    public List<HashMap<String, Object>> medicineAmp(String month, double leastAmount) {
        HashMap<String, Object> param = new HashMap<String, Object>(1);
        param.put("thisMonth", month);
        Calendar calendar = DateUtils.parseCalendarDayFormat(month + "-1");
        calendar.add(Calendar.MONTH, -1);
        param.put("lastMonth", DateUtils.formatDate(calendar.getTime(), "yyyy-MM"));
        param.put("scopeDate", calendar.getTime());
        param.put("leastAmount", leastAmount);

        return statDao.medicineAmp(param);
    }

    @Override
    public List<HashMap<String, Object>> doctorMonthKPI(int recordCount, String doctorName) {
        HashMap<String, Object> param = new HashMap<String, Object>(2);
        param.put("limit", recordCount);
        param.put("doctorName", doctorName);
        return dailyDao.doctorMonthKPI(param);
    }

    @Override
    public List<HashMap<String, Object>> doctorDailyKPI(int recordCount, String doctorName) {
        HashMap<String, Object> param = new HashMap<String, Object>(2);
        param.put("limit", recordCount);
        param.put("doctorName", doctorName);
        return dailyDao.doctorDailyKPI(param);
    }

    @Override
    public Map<String, Object> departMedicineSummary(Map<String, Object> param) {
        List<HashMap<String, Object>> results;
        logger.debug("param.get(\"department\") =" + param.get("department"));
        if ("".equals(param.get("department")) || param.get("department") == null)
            results = dailyDao.antiAllDepart(param);
        else
            results = dailyDao.antiByDepart(param);

        HashMap<String, Object> model = new HashMap<>();
        if (results.size() == 1) {
            results.get(0).put("avgDay", (int) results.get(0).get("hospitalDay") * 1.0 / (int) results.get(0).get("hospitalPatient2"));
            results.get(0).put("antiRatio", ((BigDecimal) results.get(0).get("antiAmount")).floatValue() * 100 / ((BigDecimal) results.get(0).get("amount")).floatValue());
            model.put("results", results.get(0));
        }
        return model;
    }
}
