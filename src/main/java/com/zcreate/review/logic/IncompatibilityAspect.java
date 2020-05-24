package com.zcreate.review.logic;

import com.zcreate.review.dao.DrugDAOImpl;
import com.zcreate.review.dao.IncompatibilityDAOImpl;
import org.aspectj.lang.JoinPoint;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-1-3
 * Time: 下午9:44
 */
public class IncompatibilityAspect {
    public void afterAdvice(JoinPoint point) {
       /* System.out.print("前置通知被触发：" +
                point.getTarget().getClass().getName() +
                "将要" + point.getSignature().getName());*/
        if ("com.zcreate.review.dao.IncompatibilityDAOImpl".equals(point.getTarget().getClass().getName())
                || "com.zcreate.review.dao.DrugDAOImpl".equals(point.getTarget().getClass().getName()))
            if ("insert".equals(point.getSignature().getName()) || "deleteByPrimaryKey".equals(point.getSignature().getName())) {
                System.out.println("执行清除配伍禁忌缓存！");
                IncompatibilityDAOImpl.setTmpDataInvalid();
                DrugDAOImpl.setTmpDataInvalid();
            }
        //System.out.println();
    }

}
