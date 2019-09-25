package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.review.dao.DailyDAO;
import com.zcreate.review.dao.StatDAO;
import com.zcreate.review.logic.StatService;
import com.zcreate.util.DateUtils;
import com.zcreate.util.StatMath;
import org.apache.ibatis.annotations.Param;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.util.*;

@Controller
@RequestMapping("/sunning")
public class SunningController {
    private static Logger log = LoggerFactory.getLogger(SunningController.class);
    @Autowired
    private StatDAO statDao;
    @Autowired
    private DailyDAO dailyDao;
    @Autowired
    private StatService statService;
    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

    //药品分析（天） 按科室
    @ResponseBody
    @RequestMapping(value = "statMedicineGroupByDepart", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String statMedicineGroupByDepart(
            @RequestParam(value = "medicineNo", required = false, defaultValue = "") String medicineNo,
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate,
            @RequestParam(value = "draw", required = false) Integer draw,
            @RequestParam(value = "start", required = false, defaultValue = "0") int start,
            @RequestParam(value = "length", required = false, defaultValue = "1000") int limit) {
        HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate, null);
        param.put("medicineNo", medicineNo);
        List<HashMap<String, Object>> result = statDao.statMedicineGroupByDepart(param);
        StatMath.sumAndCalcRatio(result, "amount", "ratio");

        Map<String, Object> retMap = new HashMap<>();
        retMap.put("draw", draw);
        retMap.put("data", result.subList(start, Math.min(start + limit, result.size())));
        retMap.put("iTotalRecords", result.size());//todo 表的行数，未加任何调剂
        retMap.put("iTotalDisplayRecords", result.size());

        return gson.toJson(retMap);
    }

    @ResponseBody
    @RequestMapping(value = "getDoctorListByMedicine", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getDoctorListByMedicine(
            @RequestParam(value = "medicineNo", required = false, defaultValue = "") String medicineNo,
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate,
            @RequestParam(value = "draw", required = false) Integer draw,
            @RequestParam(value = "start", required = false, defaultValue = "0") int start,
            @RequestParam(value = "length", required = false, defaultValue = "1000") int limit) {
        HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate, null);
        param.put("medicineNo", medicineNo);
        List<HashMap<String, Object>> result = dailyDao.getDoctorListByMedicine(param);
        StatMath.sumAndCalcRatio(result, "amount", "ratio");

        Map<String, Object> retMap = new HashMap<>();
        retMap.put("draw", draw);
        retMap.put("data", result.subList(start, Math.min(start + limit, result.size())));
        retMap.put("iTotalRecords", result.size());//todo 表的行数，未加任何调剂
        retMap.put("iTotalDisplayRecords", result.size());

        return gson.toJson(retMap);
    }

    //药品分析（天）
    @ResponseBody
    @RequestMapping(value = "statMedicine", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String statMedicine(
            @RequestParam(value = "medicineNo", required = false, defaultValue = "") String medicineNo,
            @RequestParam(value = "department", required = false, defaultValue = "") String department,
            @RequestParam(value = "healthNo", required = false, defaultValue = "") String healthNo,
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate,
            @RequestParam(value = "type", required = false, defaultValue = "-1") Integer type,
            @RequestParam(value = "mental", required = false, defaultValue = "false") Boolean mental,
            @RequestParam(value = "assist", required = false, defaultValue = "false") Boolean assist,
            @RequestParam(value = "draw", required = false) Integer draw,
            @RequestParam(value = "start", required = false, defaultValue = "0") int start,
            @RequestParam(value = "length", required = false, defaultValue = "100") int limit) {

        HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate, department, type);
        param.put("start", start);
        param.put("limit", limit);
        param.put("likeHealthNo", healthNo);

        if (medicineNo.getBytes().length == medicineNo.length())
            param.put("medicineNo", medicineNo);
        else
            param.put("likeMedicineName", medicineNo);

        param.put("assist", assist);
        param.put("mental", mental);
        //log.debug("param:" + param);
        List<HashMap<String, Object>> result = statDao.statByMedicine(param); //取全部

        //todo 移动到外面计算
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

        Map<String, Object> retMap = new HashMap<>();
        retMap.put("draw", draw);
        retMap.put("data", result.subList(start, Math.min(start + limit, result.size())));
        retMap.put("iTotalRecords", result.size());//todo 表的行数，未加任何调剂
        retMap.put("iTotalDisplayRecords", result.size());

        return gson.toJson(retMap);
    }

    //药品分析（天）
    @ResponseBody
    @RequestMapping(value = "byDepart", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String byDepart(
            @RequestParam(value = "medicineNo", required = false, defaultValue = "") String medicineNo,
            @RequestParam(value = "healthNo", required = false, defaultValue = "") String healthNo,
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate,
            @RequestParam(value = "type", required = false, defaultValue = "-1") Integer type,
            @RequestParam(value = "draw", required = false) Integer draw,
            @RequestParam(value = "start", required = false, defaultValue = "0") int start,
            @RequestParam(value = "length", required = false, defaultValue = "1000") int limit) {
        List<HashMap<String, Object>> result = statService.byDepart(fromDate, toDate, type, healthNo, medicineNo);

        Map<String, Object> retMap = new HashMap<>();
        retMap.put("draw", draw);
        retMap.put("data", result.subList(start, Math.min(start + limit, result.size())));
        retMap.put("iTotalRecords", result.size());//todo 表的行数，未加任何调剂
        retMap.put("iTotalDisplayRecords", result.size());

        return gson.toJson(retMap);
    }

    @ResponseBody
    @RequestMapping(value = "byDepartDetail", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String byDepartDetail(
            @RequestParam(value = "medicineNo", required = false, defaultValue = "") String medicineNo,
            @RequestParam(value = "department", required = false, defaultValue = "") String department,
            @RequestParam(value = "healthNo", required = false, defaultValue = "") String healthNo,
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate,
            @RequestParam(value = "type", required = false, defaultValue = "-1") Integer type,
            @RequestParam(value = "antiClass", required = false, defaultValue = "-1") Integer antiClass,
            @RequestParam(value = "draw", required = false) Integer draw,
            @RequestParam(value = "start", required = false, defaultValue = "0") int start,
            @RequestParam(value = "length", required = false, defaultValue = "1000") int limit) {
        List<HashMap<String, Object>> result = statService.getDepartDetail(fromDate, toDate, department, type, healthNo, antiClass);

        Map<String, Object> retMap = new HashMap<>();
        retMap.put("draw", draw);
        retMap.put("data", result.subList(start, Math.min(start + limit, result.size())));
        retMap.put("iTotalRecords", result.size());
        retMap.put("iTotalDisplayRecords", result.size());

        return gson.toJson(retMap);
    }

    @ResponseBody
    @RequestMapping(value = "byDoctor", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String byDoctor(
            @RequestParam(value = "medicineNo", required = false, defaultValue = "") String medicineNo,
            @RequestParam(value = "department", required = false, defaultValue = "") String department,
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate,
            @RequestParam(value = "draw", required = false) Integer draw,
            @RequestParam(value = "start", required = false, defaultValue = "0") int start,
            @RequestParam(value = "length", required = false, defaultValue = "1000") int limit) {
        List<HashMap<String, Object>> result = statService.byDoctor(fromDate, toDate, department);

        Map<String, Object> retMap = new HashMap<>();
        retMap.put("draw", draw);
        retMap.put("data", result.subList(start, Math.min(start + limit, result.size())));
        retMap.put("iTotalRecords", result.size());//todo 表的行数，未加任何调剂
        retMap.put("iTotalDisplayRecords", result.size());

        return gson.toJson(retMap);
    }


}
