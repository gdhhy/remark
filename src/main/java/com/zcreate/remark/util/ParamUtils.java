package com.zcreate.remark.util;

import com.zcreate.util.DateUtils;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;

public class ParamUtils {
    public static HashMap<String, Object> produceMap(String fromDate, String toDate, String department, int type) {
        HashMap<String, Object> param = produceMap(fromDate, toDate, department);
        param.put("type", type);
        return param;
    }

    public static HashMap<String, Object> produceMap(String fromDate, String toDate, String department) {
        HashMap<String, Object> param = produceMap(fromDate, toDate);
        if (department != null && department.indexOf(',') > 0) {
            String[] departs = department.split(",");
            ArrayList<String> newDeparts = new ArrayList<>(departs.length * 2);
            for (String s : departs) {
                newDeparts.add(s);
                if (!s.endsWith("门诊")) newDeparts.add(s + "门诊");
            }
            param.put("departs", newDeparts);
        } else
            param.put("department", department);

        return param;
    }

    public static HashMap<String, Object> produceMap(String fromDate, String toDate) {
        HashMap<String, Object> param = new HashMap<>();
        if (!"".equals(fromDate)) {
            param.put("fromDate", DateUtils.parseDateDayFormat(fromDate));

            param.put("RxDetailTable", "RxDetail_" + fromDate.substring(0, 4));
            param.put("DrugRecordsTable", "DrugRecords_" + fromDate.substring(0, 4));
            param.put("AdviceItemTable", "AdviceItem_" + fromDate.substring(0, 4));
        }
        if (!"".equals(toDate)) {
            Calendar cal = DateUtils.parseCalendarDayFormat(toDate);
            cal.add(Calendar.DATE, 1);
            param.put("toDate", cal.getTime());
        }
        return param;
    }
}
