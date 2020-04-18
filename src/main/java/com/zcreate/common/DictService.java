package com.zcreate.common;

import com.zcreate.common.pojo.Dict;

import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 11-12-14
 * Time: 上午11:15
 */
public interface DictService {
    Dict getDict(Integer dictID);

    boolean save(Dict dict);

    boolean doDeleteByPrimaryKey(Integer dictID);

    Dict doInsert(Dict dict);

    List<Dict> selectByParentID(Integer parentID);

    //List<Dict> query(Map param);

    String getPathIDToRoot(int dictID);

    Dict getDictByParentNoAndValue(String parentNo, String value);

    Dict getDictByParentChildNo(String parentNo, String dictNo);

    Dict getDictByNo(String dictNo);

    List live(Map<String, Object> param);

    int liveCount(Map<String, Object> param);
}
