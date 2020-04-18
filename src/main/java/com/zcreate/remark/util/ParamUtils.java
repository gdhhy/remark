package com.zcreate.remark.util;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.util.DateUtils;

import java.util.*;

public class ParamUtils {

    private static Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

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


    public static String returnJson(List list, int totalCount) {
        Map<String, Object> result = new HashMap<>();
        result.put("data", list);
        result.put("iTotalRecords", totalCount);//todo 表的行数，未加任何调剂
        result.put("iTotalDisplayRecords", totalCount);

        return gson.toJson(result);
    }
}
