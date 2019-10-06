package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.review.dao.ClinicDAO;
import com.zcreate.review.dao.RecipeDAO;
import com.zcreate.review.dao.SampleDAO;
import com.zcreate.review.his.Course;
import com.zcreate.review.his.HisDAO;
import com.zcreate.review.his.History;
import com.zcreate.review.logic.ReviewService;
import com.zcreate.review.model.RecipeItem;
import com.zcreate.review.model.SampleBatch;
import com.zcreate.util.DateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/remark")
public class SampleController {
    private static Logger log = LoggerFactory.getLogger(SampleController.class);
    @Autowired
    private SampleDAO sampleDao;
    @Autowired
    private ClinicDAO clinicDao;
    @Autowired
    private RecipeDAO recipeDao;
    @Autowired
    private HisDAO hisDao;
    @Autowired
    private ReviewService reviewService;

    private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm").serializeNulls().create();

    @ResponseBody
    @RequestMapping(value = "listSamples", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String listSamples(@RequestParam(value = "year", required = false, defaultValue = "0") int year,
                              @RequestParam(value = "month", required = false, defaultValue = "-1") int month,
                              @RequestParam(value = "remarkType", required = false, defaultValue = "0") int remarkType,
                              @RequestParam(value = "type", required = false, defaultValue = "0") int type,
                              @RequestParam(value = "draw", required = false) Integer draw,
                              @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                              @RequestParam(value = "length", required = false, defaultValue = "100") int limit) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("year", year);
        param.put("month", month);
        param.put("type", type);
        param.put("start", start);
        param.put("limit", limit);
        int count = sampleDao.getSampleBatchCount(param);
        log.debug("count=" + count);
        List<SampleBatch> goods = sampleDao.getSampleBatchList(param);

        Map<String, Object> result = new HashMap<>();
        result.put("draw", draw);
        result.put("data", goods);
        result.put("remarkType", remarkType);
        result.put("iTotalRecords", count);//todo 表的行数，未加任何调剂
        result.put("iTotalDisplayRecords", count);

        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "listDetails", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String listDetails(@RequestParam(value = "sampleBatchID", required = false, defaultValue = "0") int querySampleBatchID,
                              @RequestParam(value = "draw", required = false, defaultValue = "1") int draw,
                              @RequestParam(value = "type", required = false, defaultValue = "0") int type,
                              @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                              @RequestParam(value = "length", required = false, defaultValue = "100") int limit) {

        List<HashMap<String, Object>> list = sampleDao.getSampleList(querySampleBatchID, type, 0, 100000);
       /* log.debug("list:" + list);
        log.debug("start:" + start);
        log.debug("limit:" + limit);
        log.debug("draw:" + draw);*/
        return wrap(list, start, limit, draw);
    }

    @ResponseBody
    @RequestMapping(value = "getObjectCount", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getObjectCount(@RequestParam(value = "type", required = false, defaultValue = "1") int type,
                                 @RequestParam(value = "clinicType", required = false, defaultValue = "1") int clinicType,
                                 @RequestParam(value = "western", required = false, defaultValue = "1") int western,
                                 @RequestParam(value = "special", required = false, defaultValue = "1") int special,
                                 @RequestParam(value = "surgery", required = false, defaultValue = "0") int surgery,
                                 @RequestParam(value = "incision", required = false, defaultValue = "0") int incision,
                                 @RequestParam(value = "dateRange", required = false) String dateRange,
                                 @RequestParam(value = "department", required = false) String department,
                                 @RequestParam(value = "doctorNo", required = false) String doctorNo,
                                 @RequestParam(value = "medicineNo", required = false) String medicineNo,
                                 @RequestParam(value = "draw", required = false) Float draw) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("antiClass", -1);//额外增加
        param.put("type", type);
        param.put("doctor", doctorNo);
        /*if (western >= 0) *///取值：西药1， 中药，0，-1不限
        param.put("western", western);
        param.put("clinicType", clinicType);
        param.put("medicine1", medicineNo);
        param.put("surgery", surgery);
        if (surgery == 1)
            param.put("incision", incision);
        param.put("special", special);

        if (!"全部".equals(department))
            param.put("department", department);

        String date[] = dateRange.split("～");

        Calendar toCal = DateUtils.parseCalendarDayFormat(date[1]);
        toCal.add(Calendar.DATE, 1);
        Map<String, Object> result = new HashMap<>();
        result.put("draw", draw);
        if (type == 1) {
            param.put("clinicDateFrom", DateUtils.parseSqlDate(date[0]));
            param.put("clinicDateTo", toCal.getTime());
            result.put("count", clinicDao.getClinicCount(param));
        } else {
            param.put("outDateFrom", DateUtils.parseSqlDate(date[0]));
            param.put("outDateTo", toCal.getTime());
            result.put("count", recipeDao.getRecipeCount(param));
        }

        return gson.toJson(result);
    }/*
 @ResponseBody
    @RequestMapping(value = "getObjectCount2", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getObjectCount2(@RequestBody SampleBatch record) {

        Map<String, Object> result = new HashMap<>();
        result.put("draw", draw);
        if (type == 1) {
            param.put("clinicDateFrom", DateUtils.parseSqlDate(date[0]));
            param.put("clinicDateTo", toCal.getTime());
            result.put("count", clinicDao.getClinicCount(param));
        } else {
            param.put("outDateFrom", DateUtils.parseSqlDate(date[0]));
            param.put("outDateTo", toCal.getTime());
            result.put("count", recipeDao.getRecipeCount(param));
        }

        return gson.toJson(result);
    }*/

    @ResponseBody
    @RequestMapping(value = "newSampling", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
    public String newSampling(@RequestBody SampleBatch record) {
        log.debug("sampleBatch:" + record);

        Map<String, Object> result = new HashMap<>();
        //result.put("type", record.getType());
        try {
            List<Integer> ids = reviewService.createSampling(record);
            record.setIds(ids);
            //result.put("samplingRxID", ids);
            result.put("sampleBatch", record);
            result.put("succeed", true);

            result.put("resultData", "抽样成功，点击 “确定” 显示抽样结果。");
        } catch (Exception e) {
            e.printStackTrace();

            result.put("succeed", false);
            result.put("resultTitle", "抽样失败");
            result.put("resultData", "错误信息：<br/>" + e.getMessage());
        }

        return gson.toJson(result);
        /*sampleBatch.setType(type);
        sampleBatch.setClinicType(clinicType);
        sampleBatch.setWestern(western);
        sampleBatch.setSpecial(special);
        sampleBatch.setIncision(incision);
        String date[] = dateRange.split("～");
        Calendar toCal = DateUtils.parseCalendarDayFormat(date[1]);
        toCal.add(Calendar.DATE, 1);
        sampleBatch.setFromDate(date[0]);
        sampleBatch.setToDate(toCal.get);*/
    }

    @ResponseBody
    @RequestMapping(value = "getSamplingList", method = RequestMethod.GET, produces = "application/json; charset=UTF-8")
    public String getSamplingList(@RequestParam(value = "ids", required = false, defaultValue = "1") List<Integer> ids,
                                  @RequestParam(value = "type", required = false, defaultValue = "1") int type) {
        //log.debug("ids:"+ids.toString());
        List data;
        if (type == 1) {
            data = clinicDao.getClinicByIDList(ids);
        } else {
            data = recipeDao.getRecipeByIDList(ids);
        }

        return wrap(data);
    }

    @ResponseBody
    @RequestMapping(value = "saveSampling", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
    public String saveSampling(@RequestBody SampleBatch sampleBatch) {
        Map<String, Object> result = new HashMap<>();
        try {
            if (sampleBatch.getIds() != null) {
                reviewService.doSaveSampling(sampleBatch, sampleBatch.getIds());

                result.put("succeed", true);
                result.put("resultData", "保存抽样成功");
            } else {
                result.put("succeed", false);
                result.put("resultTitle", "保存抽样失败");

                result.put("resultData", "错误信息：<br/>服务器无暂存的抽样数据！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("succeed", false);
            result.put("resultTitle", "保存抽样失败");
            result.put("resultData", "错误信息：<br/>" + e.getMessage());
        }
        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/deleteSampleBatch", method = RequestMethod.POST)
    public String deleteSampleBatch(@RequestParam("batchID") int batchID) {
        Map<String, Object> map = new HashMap<>();
        int deleteCount = 0;
        try {
            deleteCount = reviewService.doDeleteSampleBatch(batchID);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("message", "错误信息：<br/>" + e.getMessage());
        }
        map.put("succeed", deleteCount > 0);
        map.put("affectedRowCount", deleteCount);

        return gson.toJson(map);
    }


    @ResponseBody //带这个返回json，不带返回jsp视图
    @RequestMapping(value = "getRecipeItemList", method = RequestMethod.GET, produces = "application/json; charset=UTF-8")
    public String getRecipeItemList(@RequestParam(value = "serialNo") String serialNo,
                                    @RequestParam(value = "longAdvice", defaultValue = "1") int longAdvice) {
        //      log.debug("getRecipeItemList");
        List<RecipeItem> adviceList = reviewService.getRecipeItemList(serialNo, longAdvice);
//   log.debug("getRecipeItemList2");
        return wrap(adviceList);
    }

    @ResponseBody //带这个返回json，不带返回jsp视图
    @RequestMapping(value = "getSurgerys", method = RequestMethod.GET, produces = "application/json; charset=UTF-8")
    public String getSurgerys(@RequestParam(value = "serialNo") String serialNo) {
        List<HashMap<String, Object>> surgerys = recipeDao.selectSurgery(serialNo);
        return wrap(surgerys);
    }

    @ResponseBody //带这个返回json，不带返回jsp视图
    @RequestMapping(value = "getDiagnosis", method = RequestMethod.GET, produces = "application/json; charset=UTF-8")
    public String getDiagnosis(@RequestParam(value = "serialNo") String serialNo, @RequestParam(value = "archive", defaultValue = "0") int archive) {
        List<HashMap> diagnosis = hisDao.getDiagnosis(serialNo, archive);
        return wrap(diagnosis);
    }

    @ResponseBody //带这个返回json，不带返回jsp视图
    @RequestMapping(value = "getCourse", method = RequestMethod.GET, produces = "application/json; charset=UTF-8")
    public String getCourse(@RequestParam(value = "serialNo") String serialNo,
                            @RequestParam(value = "departCode") String departCode, @RequestParam(value = "archive") int archive) {
        List<Course> course = hisDao.getCourse(serialNo, departCode, archive);
        return wrap(course);
    }

    @ResponseBody //带这个返回json，不带返回jsp视图
    @RequestMapping(value = "showHistory", method = RequestMethod.GET, produces = "application/json; charset=UTF-8")
    public String showHistory(@RequestParam(value = "serialNo") String serialNo,
                              @RequestParam(value = "departCode") String departCode, @RequestParam(value = "archive") int archive) {
        History history = hisDao.getHistory(serialNo, departCode, archive);
        return gson.toJson(history);
    }

    private String wrap(List list) {
        Map<String, Object> result = new HashMap<>();
        result.put("data", list);

        result.put("iTotalRecords", list.size());
        result.put("iTotalDisplayRecords", list.size());
        return gson.toJson(result);
    }

    private String wrap(List list, int start, int limit, int draw) {
        Map<String, Object> result = new HashMap<>();
        result.put("data", list.subList(start, Math.min(list.size(), start + limit)));
        result.put("sEcho", draw);

        result.put("iTotalRecords", list.size());
        result.put("iTotalDisplayRecords", list.size());
        return gson.toJson(result);
    }
}