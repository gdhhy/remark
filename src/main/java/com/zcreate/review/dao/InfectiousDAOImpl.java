package com.zcreate.review.dao;

import com.zcreate.ReviewConfig;
import com.zcreate.review.model.Contagion;
import com.zcreate.review.model.Infectious;
import com.zcreate.review.model.RecipeItemReview;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by hhy on 2014/10/5.
 */
public class InfectiousDAOImpl extends SqlSessionDaoSupport implements InfectiousDAO, Serializable {
    private static String[] workflowChn = new String[]{"编辑", "提交", "退回", "接受", "作废"};


    @Override
    public int saveInfectious(Infectious infectious) {
        int affectedRowCount;
        if (infectious.getInfectiousID() != null && infectious.getInfectiousID() > 0) {
            affectedRowCount = getSqlSession().update("Infectious.updateInfectious", infectious);

        } else
            affectedRowCount = getSqlSession().insert("Infectious.insertInfectious", infectious);

        return affectedRowCount;
    }

    @Override
    public int deleteInfectious(int InfectiousID) {
        return getSqlSession().delete("Infectious.deleteInfectious", InfectiousID);
    }

    @Override
    public HashMap<String, Object> getInfectious(int InfectiousID) {
        return getSqlSession().selectOne("Infectious.selectInfectious", InfectiousID);
    }

    @Override
    public int saveContagion(Contagion contagion) {
        int affectedRowCount;
        if (contagion.getContagionID() != null && contagion.getContagionID() > 0) {
            affectedRowCount = getSqlSession().update("Infectious.updateContagion", contagion);

        } else
            affectedRowCount = getSqlSession().insert("Infectious.insertContagion", contagion);

        return affectedRowCount;
    }

    @Override
    public int deleteContagion(int contagionID) {
        return getSqlSession().delete("Infectious.deleteContagion", contagionID);
    }

    @Override
    public HashMap<String, Object> getContagion(int contagionID) {
        return getSqlSession().selectOne("Infectious.selectContagion", contagionID);
    }

    @Override
    public List<Infectious> getInfectiousList(Map param) {
        List<Infectious> list = getSqlSession().selectList("Infectious.selectInfectiousList", param);
        for (Infectious infect : list) {
            infect.setWorkflowChn(workflowChn[infect.getWorkflow() % 10]);
        }
        return list;
    }

    @Override
    public List<Contagion> getContagionList(Map param) {
        List<Contagion> list = getSqlSession().selectList("Infectious.selectContagionList", param);
        for (Contagion infect : list) {
            infect.setWorkflowChn(workflowChn[infect.getWorkflow() % 10]);
        }
        return list;
    }

    public String[] getWorkflowChn() {
        return workflowChn;
    }
}
