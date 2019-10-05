package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.remark.util.ParamUtils;
import com.zcreate.review.dao.ImportDAO;
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

import java.lang.reflect.Method;
import java.sql.Timestamp;
import java.util.*;

@Controller
@RequestMapping("/monitor")
public class MonitorController {
    private static Logger logger = LoggerFactory.getLogger(MonitorController.class);
    @Autowired
    private TaskDAO taskDao;
    @Autowired
    private ImportDAO importDao;
    @Autowired
    private TimerThread timerThread;
    private String[] taskTypeName =new String[]{"导入数据", "重建处方数据", "每日统计汇总", "搜索疑有配伍禁忌处方", "刷新日期", "月统计", "科室收入药比计算"};
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
        String string = "";
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
        retMap = new HashMap<>();
        retMap.put("title", "统计数据量");
        retMap.put("succeed", result > 0);

        return gson.toJson(retMap);
    }

    @ResponseBody
    @RequestMapping(value = "deleteData", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
    public String deleteData(@RequestParam(value = "fromDate") String fromDate,
                             @RequestParam(value = "toDate") String toDate) {
        retMap = new HashMap<>();
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
    @ResponseBody
    @RequestMapping(value = "deleteTask", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
    public String deleteTask(@RequestParam(value = "taskID") int taskID ) {
        retMap = new HashMap<>();
        boolean succeed=taskDao.deleteTask(taskID);
        retMap.put("succeed",  succeed);
        if(succeed)
            retMap.put("message","删除任务成功！");
        else
            retMap.put("message","删除任务失败！");
        return gson.toJson(retMap);
    }


    @ResponseBody
    @RequestMapping(value = "submitTask", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
    public String submitTask(@RequestParam(value = "runType") int runType,
                             @RequestParam(value = "timerMode") int timerMode,
                             @RequestParam(value = "timeFrom") String timeFrom,
                             @RequestParam(value = "timeTo") String timeTo,
                             @RequestParam(value = "exeDateField") String exeDateField,
                             @RequestParam(value = "exeTimeField") String exeTimeField) {

        logger.debug("runType=" + runType);
        logger.debug("timeFrom=" + timeFrom);
        if (timerMode == 2) { //立即执行
            return exeTask(runType, timeFrom, timeTo);
        } else {//定时
            logger.debug("exeDateField=" + exeDateField);
            logger.debug("exeTimeField=" + exeTimeField);
            retMap = new HashMap<>();
            Timestamp timerTime = new Timestamp(DateUtils.parseDateFormat(exeDateField + " " + exeTimeField, "yyyy-MM-dd HH:mm").getTime());
            if (timerMode == 1 && timerTime.getTime() - System.currentTimeMillis() < timerThread.getSleepTime() * 1000) {
                retMap.put("message", "指定时间已过，不能设定！");
                retMap.put("succeed", false);
            } else {
                Task task = new Task();
                task.setTaskType(runType);
                task.setTimerMode(timerMode);
                task.setParam1(timeFrom);
                task.setParam2(timeTo);
                task.setTimerTime(timerTime);
                task.setTaskName(taskTypeName[runType - 1]);
                retMap.put("succeed", taskDao.insertTask(task));
                logger.debug("task.getTaskID() = " + task.getTaskID());

                if ((Boolean) retMap.get("succeed"))
                    retMap.put("message", "增加定时任务成功");
                else
                    retMap.put("message", "增加定时任务失败");
            }
            return gson.toJson(retMap);
        }
    }

    //立即执行
    private String exeTask(int runType, String timeFrom, String timeTo) {
        retMap = new HashMap<>();
        // System.out.println("timerThread = " + timerThread);
        LinkedList<CallProcedure> list = timerThread.getRunningProcedure();
        for (CallProcedure procedure : list)
            if (procedure.isAlive()) {
                //failed("执行任务", );
                retMap.put("message", taskTypeName[procedure.getTaskType() - 1] + " 线程还在执行中，请等候！");
                retMap.put("succeed", false);
                return gson.toJson(retMap);
            }

        Method method = timerThread.getProcedure(runType);

        CallProcedure procedure = new CallProcedure(importDao, method, runType);
        if (runType <= 4) {//1,2,3,4
            Object[] param= new Object[2];
            param[0] = timeFrom;
            param[1] = timeTo;
            procedure.setParam(param);
        }

        procedure.start();
        timerThread.addProcedure(procedure);

        retMap.put("message", "启动了" + taskTypeName[procedure.getTaskType() - 1] + "线程成功。");
        retMap.put("succeed", true);
        return gson.toJson(retMap);
    }

}
