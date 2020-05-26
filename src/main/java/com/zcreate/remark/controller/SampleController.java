package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.review.dao.ClinicDAO;
import com.zcreate.review.dao.InPatientDAO;
import com.zcreate.review.dao.SampleDAO;
import com.zcreate.review.logic.ReviewService;
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

import static com.zcreate.remark.util.ControllerHelp.wrap;

@Controller
@RequestMapping("/sample") //todo change /sample
public class SampleController {
    private static Logger log = LoggerFactory.getLogger(SampleController.class);
    @Autowired
    private SampleDAO sampleDao;
    @Autowired
    private ClinicDAO clinicDao;
    @Autowired
    private InPatientDAO inPatientDao;
    @Autowired
    private ReviewService reviewService;

    private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm").serializeNulls().create();

    @ResponseBody
    @RequestMapping(value = "listSamples", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String listSamples(@RequestParam(value = "year", required = false, defaultValue = "0") int year,
                              @RequestParam(value = "month", required = false, defaultValue = "-1") int month,
                              @RequestParam(value = "remarkType", required = false, defaultValue = "0") int remarkType,
                              @RequestParam(value = "type", required = false, defaultValue = "0") int type,
                              @RequestParam(value = "search[value]", required = false) String search,
                              @RequestParam(value = "search[regex]", required = false) String regex,
                              @RequestParam(value = "draw", required = false) Integer draw,
                              @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                              @RequestParam(value = "length", required = false, defaultValue = "100") int limit) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("year", year);
        param.put("month", month);
        param.put("type", type);
        param.put("search", search);
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
                                 @RequestParam(value = "doctorID", required = false) Integer doctorID,
                                 @RequestParam(value = "goodsID", required = false) Integer goodsID,
                                 @RequestParam(value = "draw", required = false) Float draw) {
        Map<String, Object> param = new HashMap<String, Object>();
        //param.put("antiClass", -1);//额外增加   remove 2020-03-15
        param.put("type", type);
        param.put("doctorID", doctorID);
        /*if (western >= 0) *///取值：西药1， 中药，0，-1不限
        param.put("western", western);
        param.put("clinicType", clinicType);
        param.put("medicine1", goodsID);
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
            param.put("RxDetailTable", "RxDetail_" + date[0].substring(0, 4));
            param.put("clinicDateTo", toCal.getTime());
            result.put("count", clinicDao.getClinicCount(param));
        } else {
            Map<String, Object> dateParam = new HashMap<String, Object>();
            dateParam.put("outDateFrom", DateUtils.parseSqlDate(date[0]));
            dateParam.put("AdviceItemTable", "AdviceItem_" + date[0].substring(0, 4));
            dateParam.put("outDateTo", toCal.getTime());
            param.put("notStat", true);
            result.put("outPatientNum", inPatientDao.getInPatientCount(dateParam));

            param.putAll(dateParam);
            result.put("count", inPatientDao.getInPatientCount(param));
        }

        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "newSampling", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
    public String newSampling(@RequestBody SampleBatch record) {
       /* log.debug("sampleBatch:" + record);
        log.debug("doctorID:" + record.getDoctorID());
        log.debug("goodsID:" + record.getGoodsID());
        log.debug("surgery:" + record.getSurgery());
        log.debug("incision:" + record.getIncision());*/

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
            data = inPatientDao.getInPatientByIDList(ids);
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

    @ResponseBody
    @RequestMapping(value = "/deleteSample", method = RequestMethod.POST)
    public String deleteSample(@RequestParam("batchID") int batchID, @RequestParam("objectID") int objectID) {
        Map<String, Object> map = new HashMap<>();
        int deleteCount = 0;
        try {
            deleteCount = reviewService.deleteSample(batchID, objectID);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("message", "错误信息：<br/>" + e.getMessage());
        }
        map.put("succeed", deleteCount > 0);
        map.put("affectedRowCount", deleteCount);

        return gson.toJson(map);
    }

}