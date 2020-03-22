package com.zcreate.review.timer;

import com.zcreate.review.dao.ImportDAO;
import com.zcreate.review.dao.ImportDAOImpl;
import com.zcreate.review.dao.TaskDAO;
import com.zcreate.review.logic.CallProcedure;
import com.zcreate.review.model.Task;
import com.zcreate.util.DateUtils;

import java.lang.reflect.Method;
import java.sql.Timestamp;
import java.util.*;

/**
 * Created with IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-4-25
 * Time: 下午5:30
 */
public class TimerThread extends Thread {
    private TaskDAO taskDao;
    private ImportDAO importDao;
    private long sleepTime;
    private int runTime = 0;
    private LinkedList<CallProcedure> threads;
    private Method[] methods;
    private long lastRuntime;

    public TimerThread(TaskDAO taskDao, ImportDAO importDao, long sleepTime) throws NoSuchMethodException {
        System.out.println("TimerThread.TimerThread");
        this.taskDao = taskDao;
        this.importDao = importDao;
        this.sleepTime = sleepTime;
        threads = new LinkedList<>();

        methods = new Method[7];//记得同时修改 MonitorThreadAction
        methods[0] = ImportDAOImpl.class.getMethod("daily", String.class, String.class);
        methods[1] = ImportDAOImpl.class.getMethod("buildClinicInPatient", String.class, String.class);
        //methods[2] = ImportDAOImpl.class.getMethod("dailyStat", String.class, String.class);
        methods[2] = ImportDAOImpl.class.getMethod("searchIncompatibilityRx", String.class, String.class);
        //methods[4] = ImportDAOImpl.class.getMethod("updateDate");
        methods[3] = ImportDAOImpl.class.getMethod("monthlyStat");
        methods[4] = ImportDAOImpl.class.getMethod("departIncome");

        this.setDaemon(true);// 所以setDeamon(true)的唯一意义就是告诉JVM不需要等待它退出，让JVM喜欢什么退出就退出吧，不用管它

        // startTimerBackup(importDao);
    }

    public void run() {
        lastRuntime = System.currentTimeMillis();
        while (true) {
            try {
                long exeInterval = System.currentTimeMillis() - lastRuntime;
                lastRuntime = System.currentTimeMillis();
                runTime++;
                System.out.println("定时任务运行次数 = " + runTime + ",间隔=" + exeInterval);
                List<Task> tasks = taskDao.getTask(sleepTime);
                for (final Task task : tasks) {
                    System.out.println("task.getExeTime() = " + DateUtils.formatDate(task.getExeTime(), "yyyy-MM-dd HH:mm:ss.S"));
                    Method method = getProcedure(task.getTaskType());

                    final CallProcedure procedure = new CallProcedure(importDao, method, task.getTaskType());

                    if (task.getTaskType() <= 4) {
                        Object param[] = new Object[2];
                        param[0] = task.getParam1();
                        param[1] = task.getParam2();
                        procedure.setParam(param);
                    }

                    //定时它
                    Timer timer = new Timer();
                    TimerTask timerTask = new TimerTask() {
                        @Override
                        public void run() {
                            task.setExeTime(new Timestamp(System.currentTimeMillis()));
                            taskDao.updateTask(task);//马上写下这次执行时间，防止下次重复执行
                            procedure.start();
                        }
                    };
                    timer.schedule(timerTask, task.getExeTime());

                    addProcedure(procedure);
                    // removeFinishThread();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            try {
                sleep(sleepTime * 1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public Method getProcedure(int type) {
        return methods[type - 1];
    }

    public void addProcedure(CallProcedure procedure) {
        removeFinishThread();
        threads.add(procedure);

    }

    public LinkedList<CallProcedure> getRunningProcedure() {
        removeFinishThread();
        return threads;
    }

    public int removeFinishThread() {
        int count = 0;
        for (int i = threads.size() - 1; i >= 0; i--)
            if (!threads.get(i).isRunning()) {
                threads.remove(i);
                count++;
            }
        if (threads.size() > 0) {
            System.out.println("待运行线程数 = " + threads.size());

        }
        return count;
    }

    public void setSleepTime(long sleepTime) {
        this.sleepTime = sleepTime;
    }

    public long getSleepTime() {
        return sleepTime;
    }

    public long getLastRuntime() {//毫秒
        return lastRuntime;
    }
}
