package com.zcreate.common.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.common.DictService;
import com.zcreate.common.dao.DictMapper;
import com.zcreate.common.logic.DictServiceImpl;
import com.zcreate.common.pojo.Dict;
import com.zcreate.remark.util.ParamUtils;
import com.zcreate.review.model.Instruction;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/common/dict")
public class DictController {
    private static Logger log = LoggerFactory.getLogger(DictController.class);
    @Autowired
    private DictMapper dictMapper;

    @Autowired
    private DictService dictService;

    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();


    @ResponseBody
    @RequestMapping(value = "listDict", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String listDict(@RequestParam(value = "dictID", required = false, defaultValue = "0") int dictID,
                           @RequestParam(value = "parentDictNo", required = false) String parentDictNo,
                           @RequestParam(value = "value", required = false) String value,
                           @RequestParam(value = "note", required = false) String note,
                           @RequestParam(value = "parentID", required = false, defaultValue = "0") int parentID) {
        Map<String, Object> param = new HashMap<>();
        param.put("dictID", dictID);
        //System.out.println("parentDictNo = " + parentDictNo);
      /*  if (parentDictNo != null) {
            param.put("dictNo", parentDictNo);
            Dict parent = dictMapper.selectDict(param).get(0);
            param.remove("dictNo");
            param.put("parentID", parent.getDictID());
        } else*/
        param.put("value", value);
        param.put("note", note);
        param.put("parentDictNo", parentDictNo);
        param.put("parentID", parentID);
        List<Dict> dicts = dictMapper.selectDict(param);
        return ParamUtils.returnJson(dicts, dicts.size());

        /*Map<String, Object> result = new HashMap<>();
        result.put("data", dicts);
         result.put("recordsTotal", dicts.size());

        return gson.toJson(result);*/
    }

    @ResponseBody
    @RequestMapping(value = "zTree", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String zTree(@RequestParam(value = "parentID", required = false, defaultValue = "1") int parentID) {
        List<Dict> dicts = dictService.selectByParentID(parentID);
        List<Map<String, Object>> list = new ArrayList<>();
        for (Dict dict : dicts) {
            Map<String, Object> item = new HashMap<>();
            item.put("name", dict.getName());
            item.put("isParent", dict.getHasChild());
            item.put("id", dict.getDictID());

            list.add(item);
        }

        return gson.toJson(list);
    }

    //直接返回数组,drug.jsp的jeasyui使用
    @ResponseBody
    @RequestMapping(value = "listDict2", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String listDict2(@RequestParam(value = "dictID", required = false, defaultValue = "0") int dictID,
                            @RequestParam(value = "parentDictNo", required = false) String parentDictNo,
                            @RequestParam(value = "value", required = false) String value,
                            @RequestParam(value = "note", required = false) String note,
                            @RequestParam(value = "id", required = false, defaultValue = "0") int parentID) {
        Map<String, Object> param = new HashMap<>();
        param.put("dictID", dictID);
        param.put("value", value);
        param.put("note", note);
        param.put("parentDictNo", parentDictNo);
        param.put("parentID", parentID);
        List<Dict> dicts = dictMapper.selectDict(param);
        return gson.toJson(dicts);
    }

    @ResponseBody
    @RequestMapping(value = "deleteDict", method = RequestMethod.POST)
    public String deleteDict(@RequestParam(value = "dictID") Integer dictID) {
        Map<String, Object> map = new HashMap<>();
        boolean deleteCount = false;
        try {
            deleteCount = dictService.doDeleteByPrimaryKey(dictID);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("message", "错误信息：<br/>" + e.getMessage());
        }
        map.put("succeed", deleteCount);
        map.put("affectedRowCount", deleteCount ? 1 : 0);

        return gson.toJson(map);
    }

    @ResponseBody
    @Transactional
    @RequestMapping(value = "saveDict", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String saveDict(@ModelAttribute("dict") Dict dict) {
        log.debug("dictID:"+dict.getDictID());
        Map<String, Object> map = new HashMap<>();
        boolean result;
        map.put("title", "保存数据字典");
        result = dictService.save(dict);
        map.put("succeed", result);

        return gson.toJson(map);
    }
}
