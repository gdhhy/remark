package com.zcreate.review.dao;

import com.zcreate.review.model.Incompatibility;
import com.zcreate.util.DateUtils;
import org.apache.log4j.Logger;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import java.io.Serializable;
import java.util.*;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 11-12-26
 * Time: 下午8:28
 */
public class IncompatibilityDAOImpl extends SqlSessionDaoSupport implements IncompatibilityDAO, Serializable {
    static Logger logger = Logger.getLogger(IncompatibilityDAOImpl.class);
    static int tmpHasData;

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> queryForList(int start, int limit, String drugName) {
        decideRefreshTmpIncomp();

        Map<String, Object> param = new HashMap<String, Object>();
        param.put("start", start);
        param.put("limit", limit);
        param.put("chnName", drugName);
        return getSqlSession().selectList("Drug.queryIncompatibilityList", param);
    }

    public int getQueryResultCount(String drugName) {

        Map<String, Object> param = new HashMap<String, Object>();
        param.put("chnName", drugName);
        return (Integer) getSqlSession().selectOne("Drug.queryIncompatibilityCount", param);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> getIncompatibilityDetail(Integer drugID) {
        return getSqlSession().selectList("Drug.selectIncompatibilityByDrugID", drugID);
    }

    private void decideRefreshTmpIncomp() {
        if (tmpHasData == 0) {
            logger.debug("IncompatibilityDAOImpl.createTmpIncompatibility");

            getSqlSession().update("Drug.truncateTmpIncompatibility");//清空
            int insertTmpCount = getSqlSession().insert("Drug.createTmpIncompatibility");//再创建

            logger.debug("insertTmpCount=" + insertTmpCount);
            tmpHasData = 1;
        }
    }

    public static void setTmpDataInvalid() {
        logger.debug("IncompatibilityDAOImpl.setTmpDataInvalid");
        tmpHasData = 0;
    }

    public int save(Incompatibility incompatibility) {
        return getSqlSession().update("Drug.updateIncompatibility", incompatibility);
    }

    public int insert(Incompatibility incompatibility) {
       return getSqlSession().insert("Drug.insertIncompatibility", incompatibility);
    }

    public int deleteByPrimaryKey(Integer incompatibilityID) {
        return getSqlSession().delete("Drug.deleteIncompatibility", incompatibilityID);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> queryByhospID(Map param) {
        return getSqlSession().selectList("Drug.queryByhospID", param);
    }


    @SuppressWarnings("unchecked")
    public List<HashMap<String, Object>> queryHasInterRx(int start, int limit, String drugID, String inOutType, String dateFrom, String dateTo) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("start", start);
        param.put("limit", limit);
        param.put("drugID", drugID);

        if (!"".equals(dateTo)) {
            Calendar cal = DateUtils.parseCalendarDayFormat(dateTo);
            cal.add(Calendar.DATE, 1);
            param.put("clinicDateTo", cal.getTime());
        }
        if (inOutType.equals("1")) {
            param.put("clinicDateFrom", dateFrom);
            return getSqlSession().selectList("Drug.queryHasInterClinic", param);
        } else {
            param.put("adviceDateFrom", dateFrom);

            param.put("adviceDateTo", param.get("clinicDateTo"));
            param.remove("clinicDateTo");

            return getSqlSession().selectList("Drug.queryHasInterInPatient", param);
        }
    }

    @SuppressWarnings("unchecked")
    public HashMap<String, Object> getIncompatibilityObjectMap(int incompatibilityID) {
        return (HashMap<String, Object>) getSqlSession().selectOne("Drug.getIncompatibility", incompatibilityID);
    }
}
