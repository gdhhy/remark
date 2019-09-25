package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.pinyin.PinyinUtil;
import com.zcreate.review.dao.MedicineDAO;
import com.zcreate.review.logic.DoctorService;
import com.zcreate.review.model.Doctor;
import com.zcreate.review.model.Medicine;
import com.zcreate.util.Verify;
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
@RequestMapping("/medicine")
public class MedicineController {
    @Autowired
    private MedicineDAO medicineDao;

    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

    @ResponseBody
    @RequestMapping(value = "liveMedicine", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String liveMedicine(@RequestParam(value = "queryChnName", required = false) String queryChnName,
                               @RequestParam(value = "antiClass", required = false, defaultValue = "0") int antiClass,
                               @RequestParam(value = "draw", required = false) Integer draw,
                               @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                               @RequestParam(value = "length", required = false, defaultValue = "100") int limit) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("start", start);
        param.put("limit", limit);
        param.put("antiClass", antiClass);
        if (queryChnName != null) {
            queryChnName = queryChnName.replaceAll("'", "");
            if (Verify.validNumber(queryChnName.trim()))
                param.put("liveNo", queryChnName.trim());
            else if (PinyinUtil.isFullEnglish(queryChnName))
                param.put("livePinyin", queryChnName.trim());
            else
                param.put("liveChnName", queryChnName.trim());
        }
        List<Map> medicineList = medicineDao.live(param);

        Map<String, Object> result = new HashMap<>();
        result.put("data", medicineList);
        result.put("iTotalRecords", medicineList.size());//todo 表的行数，未加任何调剂
        result.put("iTotalDisplayRecords", medicineList.size());

        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "getMedicine", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getMedicine(@RequestParam(value = "medicineNo") String medicineNo) {
        return gson.toJson(medicineDao.getMedicine(medicineNo));

    }

    @ResponseBody
    @RequestMapping(value = "getMedicineList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getMedicineList(
            //@RequestParam(value = "queryChnName", required = false) String queryChnName,
            @RequestParam(value = "search[value]", required = false) String search,
            @RequestParam(value = "search[regex]", required = false) String regex,
            @RequestParam(value = "goodsNo", required = false) String goodsNo,
            @RequestParam(value = "matchType", required = false, defaultValue = "0") int matchType,
            @RequestParam(value = "type", required = false, defaultValue = "0") int type,
            @RequestParam(value = "draw", required = false) Integer draw,
            @RequestParam(value = "start", required = false, defaultValue = "0") int start,
            @RequestParam(value = "length", required = false, defaultValue = "1000") int limit) {
        Map<String, Object> param = new HashMap<>();
        param.put("start", start);
        param.put("limit", limit);
        if (search != null) {
            search = search.replaceAll("\\s+", "");
            if (Verify.validNumber(search))
                param.put("liveGoodsNo", search);
            else if (Verify.validLetter(search))
                param.put("livePinyin", search);
            else
                param.put("liveChnName", search);
        }
        //  param.put("chnName", queryChnName);

        //String antiClass = ParamUtils.getParameter(ServletActionContext.getRequest(), "antiClass");
        if (matchType == 1)
            param.put("noMatch", true);
        else if (matchType == 2)
            param.put("match", true);
        else if (matchType == 3)
            param.put("matchGeneralOnly", true);
        else if (matchType == 4)
            param.put("matchInstructionOnly", true);
        switch (type) {
            case 1:
            case 3:
            case 4:
                param.put("western", type);
                break;
            case 5:
                param.put("antiClass", 1);
                break;
            case 6:
                param.put("base", 1);
                break;
            case 7:
                param.put("insurance", 1);
                break;
            case 8:
                param.put("insurance", 2);
                break;
            case 9://西药口服
            case 10://西药注射
            case 11://西药大输液
                param.put("western", type);
                break;
            default:
        }

        param.put("no", goodsNo);

        List<Medicine> medicineList = medicineDao.query(param);

        int totalCount = medicineList.size();
        if (start > 0 || totalCount == limit)
            totalCount = medicineDao.queryCount(param);

        Map<String, Object> retMap = new HashMap<>();
        retMap.put("sEcho", draw);
        retMap.put("aaData", medicineList);
        retMap.put("iTotalRecords", totalCount);//todo 表的行数，未加任何调剂
        retMap.put("iTotalDisplayRecords", totalCount);

        return gson.toJson(retMap);

    }
}
