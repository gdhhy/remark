package com.zcreate.review.logic;

import com.zcreate.review.dao.ImportDAO;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

/**
 * Created with IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-4-18
 * Time: 下午10:32
 */
public class CallProcedure extends Thread {
    private ImportDAO importDao;
    private long startTime;
    private long consumingTime;
    private Method method;
    private Object param[];
    private int taskType;

    public CallProcedure(ImportDAO importDao, Method method, int taskType) {
        this.importDao = importDao;
        this.method = method;
        this.taskType = taskType;
        consumingTime = 0;
    }

    public void setParam(Object[] param) {
        this.param = param;
    }

    public void run() {
        consumingTime = 0;
        startTime = System.currentTimeMillis();
        try {
            /* System.out.println("importDao = " + importDao);
        System.out.println("param = " + param);
        System.out.println("method = " + method);*/
            method.invoke(importDao, param);
            consumingTime = System.currentTimeMillis() - startTime;
            System.out.println("线程完成，consumingTime = " + consumingTime);
        } catch (IllegalAccessException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    public boolean isRunning() {
        return consumingTime == 0;
    }

    public long getConsumingTime() {
        if (consumingTime > 0)
            return consumingTime;
        else
            return System.currentTimeMillis() - startTime;
    }

    public long getStartTime() {
        return startTime;
    }

    public Object[] getParam() {
        return param;
    }

    public int getTaskType() {
        return taskType;
    }

    public Method getMethod() {
        return method;
    }

    public static void main(String[] args) {
        try {
            /*Date d= DateUtils.parseDateFormat("2012年04月27日 04:00", "yyyy年MM月dd日 HH:mm");
            System.out.println("d = " + d);*/
            CallProcedure pro = new CallProcedure(null, null, 0);
            System.out.println("pro.isAlive() = " + pro.isAlive());
            System.out.println("pro.isRunning() = " + pro.isRunning());
            System.out.println("pro.isDaemon() = " + pro.isDaemon());
            System.out.println("pro.isInterrupted() = " + pro.isInterrupted());
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            System.out.println(" finally ");
        }
        System.out.println("args = " + args);
    }

}
