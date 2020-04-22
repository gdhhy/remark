package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.ReviewConfig;
import com.zcreate.pinyin.PinyinUtil;
import com.zcreate.remark.util.ParamUtils;
import com.zcreate.review.dao.InstructionDAO;
import com.zcreate.review.model.Instruction;
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
@RequestMapping("/instruction")
public class InstructionController {
    private static Logger log = LoggerFactory.getLogger(MedicineController.class);
    public static ReviewConfig reviewConfig;
    @Autowired
    public InstructionDAO instructionDao;
    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

    @Autowired
    public void setReviewConfig(ReviewConfig reviewConfig) {
        InstructionController.reviewConfig = reviewConfig;
    }

    @ResponseBody
    @RequestMapping(value = "getInstruction", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getInstruction(@RequestParam(value = "instructionID") Integer instructionID) {
        System.out.println("instructionDao = " + instructionDao);
        return gson.toJson(instructionDao.viewInstruction(instructionID));
    }

    @ResponseBody
    @RequestMapping(value = "viewInstrByGeneralInstrID", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String viewInstrByGeneralInstrID(@RequestParam(value = "generalInstrID") Integer generalInstrID) {
        return gson.toJson(instructionDao.viewInstrByGeneralInstrID(generalInstrID));
    }

    @ResponseBody
    @RequestMapping(value = "deleteInstruction", method = RequestMethod.POST)
    public String deleteInstruction(@RequestParam(value = "instructionID") Integer instructionID) {
        Map<String, Object> map = new HashMap<>();
        int deleteCount = 0;
        try {
            deleteCount = instructionDao.deleteByPrimaryKey(instructionID);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("message", "错误信息：<br/>" + e.getMessage());
        }
        map.put("succeed", deleteCount > 0);
        map.put("affectedRowCount", deleteCount);

        return gson.toJson(map);
    }

    @ResponseBody
    @Transactional
    @RequestMapping(value = "setOnlyGeneral", method = RequestMethod.POST)
    public String setOnlyGeneral(@RequestParam(value = "instructionID") Integer instructionID, @RequestParam(value = "generalInstrID") Integer generalInstrID) {
        Map<String, Object> map = new HashMap<>();
        int affectedRow = 0;
        try {
            affectedRow = instructionDao.doSetNewGeneral(instructionID, generalInstrID);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("message", "错误信息：<br/>" + e.getMessage());
        }
        map.put("succeed", affectedRow > 0);
        map.put("affectedRowCount", affectedRow);

        return gson.toJson(map);
    }

    @ResponseBody
    @RequestMapping(value = "instructionList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String instructionList(@RequestParam(value = "instructionID", required = false) Integer instructionID,
                                  @RequestParam(value = "generalInstrID", required = false) Integer generalInstrID,
                                  @RequestParam(value = "chnName", required = false) String chnName,
                                  @RequestParam(value = "generalName", required = false) String generalName,
                                  @RequestParam(value = "hasInstruction", required = false) Integer hasInstruction,
                                  @RequestParam(value = "source", required = false) String source,
                                  @RequestParam(value = "search[value]", required = false) String search,
                                  @RequestParam(value = "search[regex]", required = false) String regex,
                                  @RequestParam(value = "draw", required = false) Integer draw,
                                  @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                                  @RequestParam(value = "length", required = false, defaultValue = "100") int limit) {
        Map<String, Object> param = new HashMap<>();
        param.put("instructionID", instructionID);
        param.put("generalInstrID", generalInstrID);
      /*  param.put("chnName", chnName);
        param.put("generalName", generalName);*/
        if (search != null) {
            search = search.replaceAll("\\s+", "");
            if (Verify.validLetter(search))
                param.put("livePinyin", search);
            else
                param.put("liveChnName", search);
        }
        if (chnName != null)
          /*  if (PinyinUtil.isFullEnglish(chnName))
                param.put("livePinyin", chnName.trim());
            else*/
            param.put("chnName", chnName.trim());
        if (generalName != null) {
            param.put("general", 1);
            if (PinyinUtil.isFullEnglish(generalName))
                param.put("liveGeneralPinyin", generalName.trim());
            else
                param.put("liveGeneralName", generalName.trim());
        }
        param.put("hasInstruction", hasInstruction);
        param.put("source", source);

        param.put("start", start);
        param.put("limit", limit);
        List<HashMap<String, Object>> instructionList = instructionDao.query(param);
        int totalCount = instructionDao.queryCount(param);
        Map<String, Object> retMap = new HashMap<>();
        retMap.put("sEcho", draw);
        retMap.put("aaData", instructionList);
        retMap.put("iTotalRecords", totalCount);//todo 表的行数，未加任何调剂
        retMap.put("iTotalDisplayRecords", totalCount);

        return gson.toJson(retMap);
    }

    @ResponseBody
    @RequestMapping(value = "liveSource", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String liveSource() {
        List<String> sourceList = instructionDao.getSourceList();

        return ParamUtils.returnJson(sourceList, sourceList.size());
    }

    @ResponseBody
    @Transactional
    @RequestMapping(value = "/saveInstruction", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String saveInstruction(@ModelAttribute("instruction") Instruction instruction) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Map<String, Object> map = new HashMap<>();
        if (principal instanceof UserDetails) {
            UserDetails ud = (UserDetails) principal;
            log.debug("instruction = " + instruction);
            int result;
            map.put("title", "保存说明书");
            instruction.setUpdateUser(ud.getUsername());

            instruction.setDeployLocation(reviewConfig.getDeployLocation());
            if (instruction.getInstruction() != null) {
                instruction.setInstruction(instruction.getInstruction().replaceAll("\n\n", "\n"));
                instruction.setInstruction(instruction.getInstruction().replaceAll("((?i)<br>\\s*){2,}", "<br>"));
            }

            if (instruction.getInstructionID() != null)
                result = instructionDao.save(instruction);
            else {
                if (instruction.getInstruction() != null) {
                    instruction.setHasInstruction(true);
                    instruction.setFinish(1);
                }
                instruction.setCreateUser(ud.getUsername());
                result = instructionDao.insert(instruction);
            }
            map.put("succeed", result > 0);
        } else {
            map.put("title", "保存说明书");
            map.put("succeed", false);
            map.put("message", "没登录用户信息，请重新登录！");
        }

        return gson.toJson(map);
    }
  /*  @ResponseBody
    @RequestMapping(value = "liveInstruction", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String liveInstruction(@RequestParam(value = "chnName", required = false) String queryChnName,
                                  @RequestParam(value = "chnName", required = false) String queryChnName,
                                  @RequestParam(value = "generalName", required = false) String queryGeneralName,
                                  @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                                  @RequestParam(value = "length", required = false, defaultValue = "100") int limit) {
        Map<String, Object> param = new HashMap<>();
        if (queryChnName != null)
            if (PinyinUtil.isFullEnglish(queryChnName))
                param.put("livePinyin", queryChnName.trim());
            else
                param.put("liveChnName", queryChnName.trim());
        if (queryGeneralName != null)
            if (PinyinUtil.isFullEnglish(queryGeneralName))
                param.put("liveGeneralPinyin", queryGeneralName.trim());
            else
                param.put("liveGeneralName", queryGeneralName.trim());
        param.put("start", start);
        param.put("limit", limit);
        List<HashMap<String, Object>> instructionList = instructionDao.query(param);
        int count = instructionDao.queryCount(param);

        return ParamUtils.returnJson(instructionList, count);
    }*/

    //逐渐提示，自动完成，返回数据json
   /*public String liveGeneralName() {
       // logger.debug("liveGeneralName()");
       Map<String, Object> param = new HashMap<String, Object>();
       param.put("start", start);
       param.put("limit", limit);
       if (queryChnName != null)
           if (PinyinUtil.isFullEnglish(queryChnName))
               param.put("livePinyin", queryChnName.trim());
           else
               param.put("liveChnName", queryChnName.trim());
       if (queryGeneralName != null)
           if (PinyinUtil.isFullEnglish(queryGeneralName))
               param.put("liveGeneralPinyin", queryGeneralName.trim());
           else
               param.put("liveGeneralName", queryGeneralName.trim());

       String medicaDict = ParamUtils.getParameter(ServletActionContext.getRequest(), "medicaDict");
       param.put("medicaDict", medicaDict);  //AND instructioinID=generalInstrID  限制通用名就是自己 or generalInstrID is null

       List<HashMap> instructionList = instructionDao.query(param);
       //logger.debug("instructionList.size()=" + instructionList.size());
        *//*JsonConfig config = new JsonConfig();
        config.registerJsonValueProcessor(Timestamp.class, new TimestampJsonValueProcessor("yyyy-MM-dd HH:mm"));*//*
       //config.setJavaPropertyFilter(new AndPropertyFilter());
       int totalCount = instructionList.size();
       if (start > 0 || totalCount == limit)
           totalCount = instructionDao.queryCount(param);

       JSONArray array = JSONArray.fromObject(instructionList);
       this.jsonString = "{totalCount:" + totalCount + ",results:" + array.toString() + "}";
       return "json";
   }*/
}
