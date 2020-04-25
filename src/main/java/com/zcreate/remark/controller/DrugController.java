package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.pinyin.PinyinUtil;
import com.zcreate.remark.util.ParamUtils;
import com.zcreate.review.dao.DrugDAO;
import com.zcreate.review.model.Drug;
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
@RequestMapping("/drug")
public class DrugController {
    private static Logger log = LoggerFactory.getLogger(DrugController.class);
    @Autowired
    private DrugDAO drugDao;

  /*  @Autowiredz
    private InstructionDAO instructionDao;*/

    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

    @ResponseBody
    @RequestMapping(value = "liveDrug", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String liveDrug(@RequestParam(value = "search[value]", required = false) String search,
                           @RequestParam(value = "drugID", required = false, defaultValue = "0") int drugID,
                           @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                           @RequestParam(value = "length", required = false, defaultValue = "100") int limit) {
        Map<String, Object> param = new HashMap<>();
        param.put("drugID", drugID);
        param.put("start", start);
        param.put("limit", limit);
        if (search != null) {
            //queryString = queryString.replaceAll("'", "");
            if (PinyinUtil.isFullEnglish(search))
                param.put("livePinyin", search.trim());
            else
                param.put("liveChnName", search.trim());
        }
        List<Drug> medicineList = drugDao.liveDrug(param);

        return ParamUtils.returnJson(medicineList, drugDao.queryCount(param));
    }

    @ResponseBody
    @RequestMapping(value = "getDrug", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getDrug(@RequestParam(value = "drugID") int drugID) {
        return gson.toJson(drugDao.getDrug(drugID));
    }

    @ResponseBody
    @Transactional
    @RequestMapping(value = "/saveDrug", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String saveDrug(@ModelAttribute("drug") Drug drug) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Map<String, Object> map = new HashMap<>();
        if (principal instanceof UserDetails) {
            UserDetails ud = (UserDetails) principal;
            log.debug("drug = " + drug);
            int result;
            map.put("title", "保存通用名");
            drug.setUpdateUser(ud.getUsername());
            if (drug.getDrugID() != null)
                result = drugDao.save(drug);
            else
                result = drugDao.insert(drug);
            
            map.put("succeed", result > 0);
        } else {
            map.put("title", "保存通用名");
            map.put("succeed", false);
            map.put("message", "没登录用户信息，请重新登录！");
        }

        return gson.toJson(map);
    }

}
