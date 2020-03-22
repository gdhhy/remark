package com.zcreate.review.dao;

import com.zcreate.review.model.ImportLog;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: zcreate
 * Date: 12-4-2
 * Time: 下午11:22
 */
public interface ImportDAO {
    List<ImportLog> query(Map param);

    int queryCount(Map param);

    boolean daily(String fromDate, String toDate);

    boolean buildClinicInPatient(String fromDate, String toDate);

   // boolean dailyStat(String fromDate, String toDate);

    boolean searchIncompatibilityRx(String lastTime, String endTime);

    void backup(String path);

    List<HashMap<String, Object>> getLogForPortal(int recordCount);

    //boolean updateDate();

    boolean monthlyStat();

    boolean departIncome();
}
