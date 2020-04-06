package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.review.dao.InstructionDAO;
import com.zcreate.review.model.Drug;
import com.zcreate.review.model.Instruction;
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
@RequestMapping("/instruction")
public class InstructionController {
    @Autowired
    private InstructionDAO instructionDao;
    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

    @ResponseBody
    @RequestMapping(value = "getInstruction", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getInstruction(@RequestParam(value = "instructionID") Integer instructionID) {
        System.out.println("instructionDao = " + instructionDao);
        return gson.toJson(instructionDao.viewInstruction(instructionID));
    }

    @ResponseBody
    @RequestMapping(value = "instructionList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String instructionList(@RequestParam(value = "chnName", required = false) String chnName,
                                  @RequestParam(value = "generalName", required = false) String generalName,
                                  @RequestParam(value = "hasInstruction", required = false) Integer hasInstruction,
                                  @RequestParam(value = "source", required = false) String source,
                                  @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                                  @RequestParam(value = "length", required = false, defaultValue = "100") int limit) {
        Map<String, Object> param = new HashMap<>();
        param.put("chnName", chnName);
        param.put("generalName", generalName);
        param.put("hasInstruction", hasInstruction);
        param.put("source", source);
        param.put("start", start);
        param.put("limit", limit);
        List<HashMap<String,Object>> medicineList = instructionDao.query(param);
        int count= instructionDao.queryCount(param);
        Map<String, Object> result = new HashMap<>();
        result.put("data", medicineList);
        result.put("iTotalRecords", count);//todo 表的行数，未加任何调剂
        result.put("iTotalDisplayRecords",count);

        return gson.toJson(result);
    }
}
