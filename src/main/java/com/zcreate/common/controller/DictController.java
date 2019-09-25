package com.zcreate.common.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.ReviewConfig;
import com.zcreate.common.dao.DictMapper;
import com.zcreate.common.pojo.Dict;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/common/dict")
public class DictController {
    @Autowired
    private DictMapper dictMapper;

    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();
    @Autowired
    private   ReviewConfig reviewConfig;
    @ResponseBody
    @RequestMapping(value = "listDict", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String listDict(@RequestParam(value = "dictID", required = false, defaultValue = "0") int dictID,
                           @RequestParam(value = "parentDictNo", required = false ) String parentDictNo,
                           @RequestParam(value = "parentID", required = false, defaultValue = "0") int parentID) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("prefix", reviewConfig.getPrefixRBAC());
        param.put("dictID", dictID);
        System.out.println("parentDictNo = " + parentDictNo);
        param.put("parentDictNo", parentDictNo);
        param.put("parentID", parentID);
        List<Dict> dicts = dictMapper.selectDict(param);

        Map<String, Object> result = new HashMap<>();
        result.put("data", dicts);
        result.put("recordsTotal", dicts.size());

        return gson.toJson(result);
    }
}
