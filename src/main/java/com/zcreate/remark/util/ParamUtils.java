package com.zcreate.remark.util;

import com.zcreate.util.DateUtils;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

public class ParamUtils {
    public static HashMap<String, Object> produceMap(String fromDate, String toDate, String department, int type) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department);
        param.put("type", type);
        return param;
    }

    public static HashMap<String, Object> produceMap(String fromDate, String toDate, String department) {
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

    public static HashMap<String, Object> produceMap(String fromDate, String toDate, String department, int type, String tablePrefix) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department, tablePrefix);
        param.put("type", type);
        return param;
    }

    public static HashMap<String, Object> produceMap(String fromDate, String toDate, String department, String tablePrefix) {
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
        param.put("DrugRecordTable", tablePrefix + "_" + fromDate.substring(0, 4));

        return param;
    }
}
