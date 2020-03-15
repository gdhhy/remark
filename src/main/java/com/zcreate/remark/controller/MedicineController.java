package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.pinyin.PinyinUtil;
import com.zcreate.review.dao.DrugDAO;
import com.zcreate.review.dao.InstructionDAO;
import com.zcreate.review.dao.MedicineDAO;
import com.zcreate.review.model.Drug;
import com.zcreate.review.model.Medicine;
import com.zcreate.util.StringUtils;
import com.zcreate.util.Verify;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/medicine")
public class MedicineController {
    private static Logger log = LoggerFactory.getLogger(MedicineController.class);
    @Autowired
    private MedicineDAO medicineDao;
    @Autowired
    private DrugDAO drugDao;

    @Autowired
    private InstructionDAO instructionDao;

    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

    @ResponseBody
    @RequestMapping(value = "liveMedicine", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String liveMedicine(@RequestParam(value = "queryChnName", required = false) String queryChnName,
                               @RequestParam(value = "antiClass", required = false, defaultValue = "0") int antiClass,
                               @RequestParam(value = "draw", required = false) Integer draw,
                               @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                               @RequestParam(value = "length", required = false, defaultValue = "100") int limit) {
        Map<String, Object> param = new HashMap<>();
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
    @RequestMapping(value = "liveDrug", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String liveDrug(@RequestParam(value = "queryString", required = false) String queryString,
                           @RequestParam(value = "drugID", required = false, defaultValue = "0") int drugID,
                           @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                           @RequestParam(value = "length", required = false, defaultValue = "100") int limit) {
        Map<String, Object> param = new HashMap<>();
        param.put("drugID", drugID);
        param.put("start", start);
        param.put("limit", limit);
        if (queryString != null) {
            //queryString = queryString.replaceAll("'", "");
            if (PinyinUtil.isFullEnglish(queryString))
                param.put("livePinyin", queryString.trim());
            else
                param.put("liveChnName", queryString.trim());
        }
        List<Drug> medicineList = drugDao.liveDrug(param);

        Map<String, Object> result = new HashMap<>();
        result.put("data", medicineList);
        result.put("iTotalRecords", medicineList.size());//todo 表的行数，未加任何调剂
        result.put("iTotalDisplayRecords", medicineList.size());

        return gson.toJson(result);
    }

   /* @ResponseBody
    @RequestMapping(value = "getDrug", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getDrug(@RequestParam(value = "drugID") int drugID) {
        Map<String, Object> param = new HashMap<>();
        param.put("drugID",drugID);
        return gson.toJson(drugDao.getDrug(drugID));
    }*/

    @ResponseBody
    @RequestMapping(value = "getMedicine", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getMedicine(@RequestParam(value = "goodsID", required = false) Integer goodsID,
                              @RequestParam(value = "medicineID", defaultValue = "0") Integer medicineID) {
        if (medicineID > 0)
            return gson.toJson(medicineDao.getMedicine(medicineID));
        return gson.toJson(medicineDao.selectMedicineByGoodsID(goodsID));
    }

    @ResponseBody
    @RequestMapping(value = "matchInstruct", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String matchInstruct(@RequestParam(value = "instrIDs") String instrIDs,
                                @RequestParam(value = "length", required = false, defaultValue = "1000") int limit) {
        Map<String, Object> param = new HashMap<>();
        param.put("instrIDs", StringUtils.splitToInts(instrIDs, ","));
        param.put("hasInstruction", 1);
        param.put("limit", limit);
        List<HashMap> instructionList = instructionDao.query(param);

        Map<String, Object> result = new HashMap<>();
        result.put("data", instructionList);
        result.put("iTotalRecords", instructionList.size());//todo 表的行数，未加任何调剂
        result.put("iTotalDisplayRecords", instructionList.size());

        return gson.toJson(result);

    }

    @ResponseBody
    @RequestMapping(value = "getMedicineList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getMedicineList(
            @RequestParam(value = "queryChnName", required = false) String queryChnName,
            @RequestParam(value = "medicineID", required = false, defaultValue = "0") int medicineID,
            @RequestParam(value = "search[value]", required = false) String search,
            @RequestParam(value = "search[regex]", required = false) String regex,
            @RequestParam(value = "no", required = false) String no,
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
                param.put("liveNo", search);
            else if (Verify.validLetter(search))
                param.put("livePinyin", search);
            else
                param.put("liveChnName", search);
        }
        param.put("chnName", queryChnName);

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
                //case 12://西药外用
                param.put("western", type);
                break;
            default:
        }

        param.put("no", no);
        //param.put("medicineNo", medicineNo);
        param.put("medicineID", medicineID);

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

    @ResponseBody
    @Transactional
    @RequestMapping(value = "/saveMedicine", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String saveMedicine(@ModelAttribute("medicine") Medicine medicine) {
        log.debug("medicine = " + medicine);
        Map<String, Object> map = new HashMap<>();
        int result;
        map.put("title", "保存药品资料");

        result = medicineDao.save(medicine);
        map.put("succeed", result > 0);

        return gson.toJson(map);
    }

    @ResponseBody
    @Transactional
    @RequestMapping(value = "/saveMatch", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String saveMatch(@ModelAttribute("medicine") Medicine medicine) {
        log.debug("medicine = " + medicine);
        Map<String, Object> map = new HashMap<>();
        int result;
        map.put("title", "保存药品资料");
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            medicine.setUpdateUser(((UserDetails) principal).getUsername());
            result = medicineDao.saveMatch(medicine);
            map.put("succeed", result > 0);
        } else {
            map.put("title", "保存配对失败");
            map.put("message", "没登录用户信息，请重新登录！");
            map.put("succeed", false);
        }


        return gson.toJson(map);
    }
}
