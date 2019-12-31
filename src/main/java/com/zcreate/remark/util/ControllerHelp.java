package com.zcreate.remark.util;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ControllerHelp {
    private static Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

    public static String wrap(List list) {
        Map<String, Object> result = new HashMap<>();
        result.put("data", list);

        result.put("iTotalRecords", list.size());
        result.put("iTotalDisplayRecords", list.size());
        return gson.toJson(result);
    }

    public static String wrap(List list, int start, int limit, int draw) {
        Map<String, Object> result = new HashMap<>();
        result.put("data", list.subList(start, Math.min(list.size(), start + limit)));
        result.put("draw", draw);

        result.put("iTotalRecords", list.size());
        result.put("iTotalDisplayRecords", list.size());
        return gson.toJson(result);
    }
}
