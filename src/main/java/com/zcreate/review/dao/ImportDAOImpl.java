package com.zcreate.review.dao;

import com.zcreate.review.model.ImportLog;
import org.apache.log4j.Logger;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-4-2
 * Time: 下午11:23
 */
public class ImportDAOImpl extends SqlSessionDaoSupport implements ImportDAO, Serializable {
    static Logger logger = Logger.getLogger(HealthDAOImpl.class);

    @SuppressWarnings("unchecked")
    public List<ImportLog> query(Map param) {
        return getSqlSession().selectList("Import.queryImportLog", param);
    }

    public int queryCount(Map param) {
        return (Integer) getSqlSession().selectOne("Import.queryImportLogCount", param);
    }

    public boolean daily(String fromDate, String toDate) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fromDate", fromDate);
        paramMap.put("toDate", toDate);
        getSqlSession().update("Import.daily", paramMap);
        //logger.debug("result = " + result);
        return true;
    }

    //测试环境，把处方日期提到最近
    /*public boolean updateDate() {
        int result = getSqlSession().update("Import.updateDate");
        logger.info("刷新日期数据记录数=" + result);
        return result > 0;
    }*/

    public boolean monthlyStat() {
        int result = getSqlSession().update("Import.monthlyStat");
        logger.info("月统计=" + result);
        return result > 0;
    }

    public boolean buildClinicInPatient(String fromDate, String toDate) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fromDate", fromDate);
        paramMap.put("toDate", toDate);
        paramMap.put("logID", 0);
        getSqlSession().update("Import.buildClinicInPatient", paramMap);

        return true;
    }

   /* public boolean dailyStat(String fromDate, String toDate) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fromDate", fromDate);
        paramMap.put("toDate", toDate);
        getSqlSession().update("Import.dailyStat", paramMap);

        return true;
    }*/

    public boolean searchIncompatibilityRx(String lastTime, String endTime) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fromDate", lastTime);
        paramMap.put("toDate", endTime);
        paramMap.put("logID", 0);
        getSqlSession().update("Incompatibility.searchIncompatibilityRx", paramMap);

        return true;
    }

    public boolean departIncome( ) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("logID", 0);
        getSqlSession().update("RationalDepartConfig.etoneMonthDepartIncomeRatio", paramMap);

        return true;
    }

    public void backup(String path) {
        getSqlSession().update("Import.backup", path);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getLogForPortal(int recordCount) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("recordCount", recordCount);
        return getSqlSession().selectList("Import.selectForPortal", paramMap);
    }
}
