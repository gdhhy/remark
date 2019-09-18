package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.pinyin.PinyinUtil;
import com.zcreate.review.dao.MedicineDAO;
import com.zcreate.review.logic.DoctorService;
import com.zcreate.review.model.Doctor;
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
@RequestMapping("/remark")
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
}
