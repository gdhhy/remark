package com.zcreate.common.logic;


import com.zcreate.common.DictService;
import com.zcreate.common.dao.DictMapper;
import com.zcreate.common.pojo.Dict;
import com.zcreate.remark.controller.RemarkController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 11-12-9
 * Time: 上午11:18
 */
public class DictServiceImpl implements DictService {
    private static Logger log = LoggerFactory.getLogger(DictServiceImpl.class);
    @Autowired
    public DictMapper dictMapper; //todo 参照GroupTree，引进管理

    public DictServiceImpl() {
    }

    public String getPathIDToRoot(int dictID) {
        Dict dict = getDict(dictID);
        String path = "/" + dict.getDictID();
        while (dict.getParentID() > 0) {
            dict = getDict(dict.getParentID());
            path = "/" + dict.getDictID() + path;
        }

        return path;
    }

    public Dict getDict(Integer dictID) {
        if (dictID > 0) {
            Map<String, Object> param = new HashMap<>();
            param.put("dictID", dictID);
            List<Dict> lists = dictMapper.selectDict(param);
            if (lists.size() == 1) return lists.get(0);
        }
        return null;
    }

    public boolean save(Dict dict) {
        log.debug("dictID:" + dict.getDictID());
        if (dict.getDictID() > 0)
            return dictMapper.updateDictByPrimaryKeySelective(dict) == 1;
        else {
            doInsert(dict);
            return dict.getDictID() > 0;
        }
    }

    public boolean doDeleteByPrimaryKey(Integer dictID) {
        Dict dict = getDict(dictID);
        List<Dict> brother = selectByParentID(dict.getParentID());
        if (brother.size() == 1) {
            Dict parent = getDict(dict.getParentID());
            parent.setHasChild(false);
            dictMapper.updateDictByPrimaryKeySelective(parent);
        }
        List<Dict> son = selectByParentID(dictID);
        if (son.size() == 0)
            return dictMapper.deleteDict(dictID) == 1;
        else return false;
    }

    public Dict doInsert(Dict dict) {
        Dict parent = getDict(dict.getParentID());
        if (!parent.getHasChild()) {
            parent.setHasChild(true);
            dictMapper.updateDictByPrimaryKeySelective(parent);
        }
        dictMapper.insertDict(dict);
        System.out.println("dict.getDictID() = " + dict.getDictID());
        return dict;
    }

    public List<Dict> selectByParentID(Integer parentID) {
        Map<String, Object> param = new HashMap<>();
        param.put("parentID", parentID);
        return dictMapper.selectDict(param);
    }

    /*public List<Dict> query(Map param) {
        return dictMapper.selectDict(param);
    }*/

    public Dict getDictByParentNoAndValue(String parentNo, String value) {
        Map<String, Object> param = new HashMap<>();
        param.put("parentNo", parentNo);
        param.put("value", value);
        return dictMapper.getDictByParentNo_Value(param);
    }

    public Dict getDictByParentChildNo(String parentNo, String dictNo) {
        Map<String, Object> param = new HashMap<>();
        param.put("parentNo", parentNo);
        param.put("dictNo", dictNo);
        return dictMapper.getDictByParentChildNo(param);
    }

    public Dict getDictByNo(String dictNo) {
        Map<String, Object> param = new HashMap<>();
        param.put("dictNo", dictNo);
        List<Dict> dists = dictMapper.selectDict(param);
        if (dists.size() > 0)
            return dists.get(0);
        else
            return null;
    }

    public List live(Map<String, Object> param) {
        return dictMapper.live(param);
    }

    public int liveCount(Map<String, Object> param) {
        return dictMapper.liveCount(param);
    }
}
