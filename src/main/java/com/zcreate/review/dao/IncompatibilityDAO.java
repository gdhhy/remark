package com.zcreate.review.dao;

import com.zcreate.review.model.Incompatibility;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 11-12-26
 * Time: 下午8:27
 */
public interface IncompatibilityDAO {
    List<HashMap<String, Object>> queryForList(int start, int limit, String drugName);

    int getQueryResultCount(String drugName);

    List<HashMap<String, Object>> getIncompatibilityDetail(Integer drugID);

    int save(Incompatibility incompatibility);

    int insert(Incompatibility incompatibility);

    int deleteByPrimaryKey(Integer incompatibilityID);

    //List<HashMap<String, Object>> queryByClinicID(int rxID);

    List<HashMap<String, Object>> queryByhospID(Map param );


    List<HashMap<String, Object>> queryHasInterRx(int start, int limit, String drugID, String inOutType, String prescribeDateFrom, String prescribeDateTo);

    // int queryHasInterRxCount(int start, int limit, String drugID, String inOutType, String prescribeDateFrom, String prescribeDateTo);

    HashMap<String, Object> getIncompatibilityObjectMap(int incompatibilityID);
}
