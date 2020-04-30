package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.pinyin.PinyinUtil;
import com.zcreate.remark.util.ParamUtils;
import com.zcreate.review.dao.DrugDAO;
import com.zcreate.review.dao.IncompatibilityDAO;
import com.zcreate.review.model.Drug;
import com.zcreate.review.model.Incompatibility;
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
    @Autowired
    private IncompatibilityDAO incompatibilityDAO;

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

    @ResponseBody
    @RequestMapping(value = "deleteDrug", method = RequestMethod.POST)
    public String deleteDrug(@RequestParam(value = "drugID") Integer drugID) {
        Map<String, Object> map = new HashMap<>();
        int deleteCount = 0;
        try {
            deleteCount = drugDao.deleteByPrimaryKey(drugID);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("message", "错误信息：<br/>" + e.getMessage());
        }
        map.put("succeed", deleteCount > 0);
        map.put("affectedRowCount", deleteCount);

        return gson.toJson(map);
    }

    //配伍禁忌管理Incompatibility
    @ResponseBody
    @RequestMapping(value = "getIncompatibility", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getIncompatibility(@RequestParam(value = "drugID", defaultValue = "0") int drugID) {
        List<HashMap<String, Object>> medicineList = incompatibilityDAO.getIncompatibilityDetail(drugID);
        //return easyui datagrid
        Map<String, Object> result = new HashMap<>();
        result.put("rows", medicineList);
        result.put("total", medicineList.size());

        return gson.toJson(result);
    }

    @ResponseBody
    @Transactional
    @RequestMapping(value = "/saveIncompatibility", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String saveIncompatibility(@ModelAttribute("incompatibility") Incompatibility incompatibility) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Map<String, Object> map = new HashMap<>();
        map.put("title", "保存配伍禁忌");
        if (principal instanceof UserDetails) {
            //UserDetails ud = (UserDetails) principal;
            //log.debug("incompatibility = " + incompatibility);
            int result;
            if (incompatibility.getIncompatibilityID() != null)
                result = incompatibilityDAO.save(incompatibility);
            else
                result = incompatibilityDAO.insert(incompatibility);

            map.put("succeed", result > 0);
        } else {
            map.put("title", "保存配伍禁忌");
            map.put("succeed", false);
            map.put("message", "没登录用户信息，请重新登录！");
        }

        return gson.toJson(map);
    }

    @ResponseBody
    @RequestMapping(value = "deleteIncompatibility", method = RequestMethod.POST)
    public String deleteIncompatibility(@RequestParam(value = "incompatibilityID") Integer incompatibilityID) {
        Map<String, Object> map = new HashMap<>();
        int deleteCount = 0;
        try {
            deleteCount = incompatibilityDAO.deleteByPrimaryKey(incompatibilityID);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("message", "错误信息：<br/>" + e.getMessage());
        }
        map.put("succeed", deleteCount > 0);
        map.put("affectedRowCount", deleteCount);

        return gson.toJson(map);
    }
}
