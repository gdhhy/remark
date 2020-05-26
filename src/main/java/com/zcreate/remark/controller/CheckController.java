package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.remark.dao.HisMapper;
import com.zcreate.remark.model.Pacs;
import com.zcreate.remark.util.ParamUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/check")
public class CheckController {
    private static Logger log = LoggerFactory.getLogger(CheckController.class);
    @Autowired
    private HisMapper hisMapper;

    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

    @ResponseBody
    @RequestMapping(value = "lisCount", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String lisCount(@RequestParam(value = "hospID") Integer hospID) {
        HashMap<String, Object> count = hisMapper.selectLisCount(hospID);
        return gson.toJson(count);
    }

    @ResponseBody
    @RequestMapping(value = "lisDir", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String lisDir(@RequestParam(value = "hospID") Integer hospID) {
        List<HashMap<String, Object>> dirs = hisMapper.selectLisDir(hospID);
        return gson.toJson(dirs);
    }

    @ResponseBody
    @RequestMapping(value = "lisResult", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String lisResult(@RequestParam(value = "labID") Integer labID) {
        List<HashMap<String, Object>> results = hisMapper.selectLisResult(labID);
        return gson.toJson(results);
    }

    @ResponseBody
    @RequestMapping(value = "pacsCount", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String pacsCount(@RequestParam(value = "hospID") Integer hospID) {
        HashMap<String, Object> count = hisMapper.selectPacsCount(hospID);
        return gson.toJson(count);
    }

    @ResponseBody
    @RequestMapping(value = "pacsResult", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String pacsResult(@RequestParam(value = "hospID") Integer hospID) {
        List<Pacs> results = hisMapper.selectPacsResult(hospID);
        //申请类别：1-CT；2-DR；3-MR；4-CR；5-RF；6-US；7-脑电图；8-心电图；9-镜检查；10-MG；11-DSA；12-普放；13-病理；14-其它'
        String[] type = {"CT", "DR", "MR", "CR", "RF", "US", "脑电图", "心电图", "镜检查", "MG", "DSA", "普放", "病理", "其它", "DM", "DX", "ECG", "EI", "ES"};
        Map<Integer, List<Pacs>> detailsMap01 = results.stream().collect(Collectors.groupingBy(Pacs::getxType));

        Integer[] key = new Integer[detailsMap01.size()];
        detailsMap01.keySet().toArray(key);
        ArrayList<HashMap<String, Object>> ret = new ArrayList<>(key.length);
        for (Integer k : key) {
            HashMap<String, Object> kMap = new HashMap<>();
            if (k <= type.length && k > 0)
                kMap.put("xType", type[k - 1]);
            else
                kMap.put("xType", k);
            kMap.put("pacs", detailsMap01.get(k));
            ret.add(kMap);
        }
        return ParamUtils.returnJson(ret, ret.size());
    }
}
