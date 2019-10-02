package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.remark.util.ParamUtils;
import com.zcreate.review.dao.TaskDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/monitor")
public class MonitorController {
    private static Logger log = LoggerFactory.getLogger(MonitorController.class);
    @Autowired
    private TaskDAO taskDao;

    private Map<String, Object> retMap;
    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

    @ResponseBody
    @RequestMapping(value = "getDataList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getDataList(@RequestParam(value = "fromDate") String fromDate,
                              @RequestParam(value = "toDate") String toDate,
                              @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                              @RequestParam(value = "length", required = false, defaultValue = "1000") int limit,
                              @RequestParam(value = "draw", required = false) Integer draw) {
        HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate, null);
        param.put("start", start);
        param.put("limit", limit);
        List<HashMap<String, Object>> dataList = taskDao.getDataList(param);

        retMap = new HashMap<>();
        retMap.put("draw", draw);
        retMap.put("data", dataList);
        retMap.put("iTotalRecords", dataList.size());//todo 表的行数，未加任何调剂
        retMap.put("iTotalDisplayRecords", dataList.size());

        return gson.toJson(retMap);
    }

    @ResponseBody
    @RequestMapping(value = "calcDataRowCount", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
    public String calcDataRowCount(@RequestParam(value = "fromDate") String fromDate,
                                   @RequestParam(value = "toDate") String toDate) {
        HashMap<String, Object> param = new HashMap<>();
        param.put("fromDate", fromDate);
        param.put("toDate", toDate);
        int result = taskDao.calcDataRowCount(param);

        retMap.put("title", "统计数据量");
        retMap.put("succeed", result > 0);

        return gson.toJson(retMap);
    }

    @ResponseBody
    @RequestMapping(value = "deleteData", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
    public String deleteData(@RequestParam(value = "fromDate") String fromDate,
                             @RequestParam(value = "toDate") String toDate) {
        HashMap<String, Object> param = new HashMap<>();
        param.put("fromDate", fromDate);
        param.put("toDate", toDate);
        int deleteRowCount = 0;
        try {
            deleteRowCount = taskDao.deleteData(param);
            if (deleteRowCount > 0) retMap.put("message", "删除数据成功,删除记录数：" + deleteRowCount+"，请重新统计数据量。");
            else retMap.put("message", "没有删除到任何数据");
        } catch (Exception e) {
            retMap.put("message", "删除数据失败，错误信息：" + e.getMessage());
        }

        retMap.put("title", "删除数据");
        retMap.put("succeed", deleteRowCount > 0);

        return gson.toJson(retMap);
    }
}
