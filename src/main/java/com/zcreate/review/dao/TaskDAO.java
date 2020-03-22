package com.zcreate.review.dao;

import com.zcreate.review.model.Task;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-4-25
 * Time: 下午5:31
 */
public interface TaskDAO {
    List<Task> getTask(long interval);

    List<Task> getTodoTask(long interval);

    boolean updateTask(Task task);

    boolean insertTask(Task task);

    boolean deleteTask(int taskID);

    List<HashMap<String, Object>> getDataList(HashMap<String, Object> param);

    int getDataListCount(HashMap<String, Object> param);

    int calcDataRowCount(HashMap<String, Object> param);

    int deleteData(HashMap<String, Object> param);

    List<HashMap<String, Object>> getTaskLogList(HashMap<String, Object> param);

    int getTaskLogCount();

    List<HashMap<String, Object>> getTaskDetailList(int logID);

    List<HashMap<String, Object>> selectTaskByTable( Map<String, Object> param);
}
