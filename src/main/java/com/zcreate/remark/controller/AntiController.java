package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.remark.dao.DrugRecordsMapper;
import com.zcreate.review.dao.StatDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
@RequestMapping("/anti")
public class AntiController {
    private static Logger log = LoggerFactory.getLogger(AntiController.class);
    @Autowired
    private StatDAO statDao;
    @Autowired
    private DrugRecordsMapper drugRecordsMapper;
   /*@Autowired
    private DailyDAO dailyDao;
    @Autowired
    private AntibiosisService antibiosisService;*/

    Map<String, Object> retMap;
    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

    //药品分析（天） 按科室
    @ResponseBody
    @RequestMapping(value = "antiDrug", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String antiDrug(
            @RequestParam(value = "quarter") String quarter,
            @RequestParam(value = "month") String month,
            @RequestParam(value = "table", defaultValue = "0") Integer table,
            @RequestParam(value = "draw", required = false) Integer draw) {
        HashMap<String, Object> param = new HashMap<>();
        if (!"".equals(quarter)) {
            String[] date = quarter.split("-");
            param.put("DrugRecordTable", "DrugRecords_" + date[0]);
            //param.put("year", Integer.parseInt(date[0]));
            param.put("quarter", Integer.parseInt(date[1]));
        } else if (!"".equals(month)) {
            String[] date = month.split("-");
            param.put("DrugRecordTable", "DrugRecords_" + date[0]);
           // param.put("year", Integer.parseInt(date[0]));
            param.put("month", Integer.parseInt(date[1]));
        }
        List<HashMap<String, Object>> result;
        if (table == 1)
            result = statDao.antiDrug(param);
        else
            result = drugRecordsMapper.antiDrug(param);

        retMap = new HashMap<>();
        retMap.put("draw", draw);
        retMap.put("data", result);
        retMap.put("iTotalRecords", result.size());//todo 表的行数，未加任何调剂
        retMap.put("iTotalDisplayRecords", result.size());

        return gson.toJson(retMap);
    }


}
