package com.zcreate.review.dao;

import com.zcreate.review.model.Task;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-4-25
 * Time: 下午5:31
 */
public class TaskDAOImpl extends SqlSessionDaoSupport implements TaskDAO, Serializable {
    @SuppressWarnings("unchecked")
    public List<Task> getTask(long interval) {
        org.apache.ibatis.cache.decorators.TransactionalCache a;
        return getSqlSession().selectList("Task.selectTask", (int) interval);
    }

    @SuppressWarnings("unchecked")
    public List<Task> getTodoTask(long interval) {
        return getSqlSession().selectList("Task.selectTodoTask", interval);
    }

    public boolean updateTask(Task task) {
        return getSqlSession().update("Task.updateTask", task) == 1;
    }

    public boolean insertTask(Task task) {
        return getSqlSession().insert("Task.insertTask", task) == 1;
    }

    public boolean deleteTask(int taskID) {
        return getSqlSession().delete("Task.deleteTask", taskID) == 1;
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getDataList(HashMap<String, Object> param) {
        return getSqlSession().selectList("Task.selectMonitorDataRowCount", param);
    }

    public int getDataListCount(HashMap<String, Object> param) {
        return (Integer) getSqlSession().selectOne("Task.selectMonitorDataRowCountCount", param);
    }

    public int calcDataRowCount(HashMap<String, Object> param) {
        return getSqlSession().update("Task.calcDataRowCount", param);//有影响记录，返回1，否则返回-1
    }

    public int deleteData(HashMap<String, Object> param) {
        getSqlSession().update("Task.deleteData", param);

        return param.get("deleteRowCount") != null ? (Integer) param.get("deleteRowCount") : 0;
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getTaskLogList(HashMap<String, Object> param) {
        return getSqlSession().selectList("Task.selectTaskLog", param);
    }

    public int getTaskLogCount() {
        return (Integer) getSqlSession().selectOne("Task.selectTaskLogCount");
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getTaskDetailList(int logID) {
        return getSqlSession().selectList("Task.selectTaskDetail", logID);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> selectTaskByTable( Map<String, Object> param) {
        return getSqlSession().selectList("Task.selectTaskByTable", param);
    }
}
