package com.zcreate.review.logic;

import java.util.HashMap;
import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-2-4
 * Time: 上午12:19
 */
public interface StatService {
    HashMap<String, Object> summary(String fromDate, String toDate);

    List<HashMap<String, Object>> global(String fromDate, String toDate, String department);

    List<HashMap<String, Object>> byMedicine(String fromDate, String toDate, String healthNo, Integer goodsID, String department, int type, boolean top3, String special, int start, int limit);

    List<HashMap<String, Object>> getDepartDetail(String fromDate, String toDate, String depart, int type, String healthNo, int antiClass);

    List<HashMap<String, Object>> getDailyInOut(int recordCount);
}
