package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.review.dao.StatDAO;
import com.zcreate.util.DateUtils;
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
    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

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

        HashMap<String, Object> param = produceMap(fromDate, toDate, department, type);
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

    private HashMap<String, Object> produceMap(String fromDate, String toDate, String department, int type) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department);
        param.put("type", type);
        return param;
    }

    private HashMap<String, Object> produceMap(String fromDate, String toDate, String department) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        if (department != null && department.indexOf(',') > 0) {
            String[] departs = department.split(",");
            ArrayList<String> newDeparts = new ArrayList<String>(departs.length * 2);
            for (String s : departs) {
                newDeparts.add(s);
                if (!s.endsWith("门诊")) newDeparts.add(s + "门诊");
            }
            param.put("departs", newDeparts);
        } else
            param.put("department", department);
        if (!"".equals(fromDate))
            param.put("fromDate", DateUtils.parseDateDayFormat(fromDate));
        if (!"".equals(toDate)) {
            Calendar cal = DateUtils.parseCalendarDayFormat(toDate);
            cal.add(Calendar.DATE, 1);
            param.put("toDate", cal.getTime());
        }
        return param;
    }
}
