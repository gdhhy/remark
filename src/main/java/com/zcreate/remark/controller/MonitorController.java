package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.remark.util.ParamUtils;
import com.zcreate.review.dao.TaskDAO;
import com.zcreate.review.logic.CallProcedure;
import com.zcreate.review.model.Task;
import com.zcreate.review.timer.TimerThread;
import com.zcreate.util.DateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

@Controller
@RequestMapping("/monitor")
public class MonitorController {
    private static Logger log = LoggerFactory.getLogger(MonitorController.class);
    @Autowired
    private TaskDAO taskDao;
    @Autowired
    private TimerThread timerThread;
    private String[] taskTypeName;
    private boolean threadAlive;

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

        return returnJson(dataList, draw);
    }

    @ResponseBody
    @RequestMapping(value = "listTask", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String listTask(@RequestParam(value = "draw", required = false) Integer draw) {
        List<Task> result = taskDao.getTodoTask(timerThread.getSleepTime());

        return returnJson(result, draw);
    }

    @ResponseBody
    @RequestMapping(value = "getRunningThread", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getRunningThread(@RequestParam(value = "draw", required = false) Integer draw) {
        String string="";
        //System.out.println("timerThread = " + timerThread);
        LinkedList<CallProcedure> list = timerThread.getRunningProcedure();
        for (CallProcedure procedure : list)
            if (procedure.isAlive()) {
                string = taskTypeName[procedure.getTaskType() - 1] + " 线程正在运行，已运行时间：" + readableTime(procedure.getConsumingTime());
                threadAlive = true;
                break; //优先显示正在运行的
            } else {
                string = taskTypeName[procedure.getTaskType() - 1] + " 线程已调度，准备运行";
                threadAlive = false;
            }

        if ("".equals(string)) string = "没有正在运行的任务，调度进程循环间隔：" + timerThread.getSleepTime() + "秒，下次调度预计时间：" + getNextRuntime();
        retMap = new HashMap<>();
        retMap.put("threadInfo", string);
        retMap.put("sEcho", draw);
        return gson.toJson(retMap);
    }

    private String getNextRuntime() {
        long nextTime = timerThread.getSleepTime() * 1000 + timerThread.getLastRuntime();
        return DateUtils.formatDate(new Date(nextTime), "yyyy-MM-dd HH:mm:ss");
    }

    public String readableTime(long ms) {
        java.text.DecimalFormat df2 = new java.text.DecimalFormat("#.00");
        java.text.DecimalFormat df = new java.text.DecimalFormat("#");

        if (ms < 1000) return ms + "毫秒";
        else if (ms < 10 * 1000) return df2.format(ms * 1.0 / 1000) + "秒";
        else if (ms < 60 * 1000) return ms / 1000 + "秒";
        else if (ms < 60 * 60 * 1000) return df.format(Math.floor(ms / (60 * 1000))) + "分" + Math.round(ms % (60 * 1000) / 1000) + "秒";
        else return df.format(Math.floor(ms / (60 * 60 * 1000))) + "小时" + Math.round(ms % (60 * 60 * 1000) / (60 * 1000)) + "分";
    }

    @ResponseBody
    @RequestMapping(value = "getTaskLogList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getTaskLogList(@RequestParam(value = "start", required = false, defaultValue = "0") int start,
                                 @RequestParam(value = "length", required = false, defaultValue = "20") int limit,
                                 @RequestParam(value = "draw", required = false) Integer draw) {
        HashMap<String, Object> param = new HashMap<>();
        param.put("start", start);
        param.put("limit", limit);

        List<HashMap<String, Object>> logList = taskDao.getTaskLogList(param);
        int total = taskDao.getTaskLogCount();
        retMap = new HashMap<>();
        retMap.put("sEcho", draw);
        retMap.put("data", logList);
        retMap.put("iTotalRecords", total);
        retMap.put("iTotalDisplayRecords", total);

        return gson.toJson(retMap);
    }

    private String returnJson(List list, Integer draw) {
        retMap = new HashMap<>();
        retMap.put("sEcho", draw);
        retMap.put("data", list);
        retMap.put("iTotalRecords", list.size());
        retMap.put("iTotalDisplayRecords", list.size());

        return gson.toJson(retMap);
    }

    @ResponseBody
    @RequestMapping(value = "getTaskDetailList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getTaskDetailList(@RequestParam(value = "logID", required = false, defaultValue = "0") int logID,
                                    @RequestParam(value = "draw", required = false) Integer draw) {
        List<HashMap<String, Object>> logList = taskDao.getTaskDetailList(logID);
        return returnJson(logList, draw);
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
            if (deleteRowCount > 0) retMap.put("message", "删除数据成功,删除记录数：" + deleteRowCount + "，请重新统计数据量。");
            else retMap.put("message", "没有删除到任何数据");
        } catch (Exception e) {
            retMap.put("message", "删除数据失败，错误信息：" + e.getMessage());
        }

        retMap.put("title", "删除数据");
        retMap.put("succeed", deleteRowCount > 0);

        return gson.toJson(retMap);
    }
}
