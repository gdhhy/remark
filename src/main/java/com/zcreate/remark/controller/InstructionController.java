package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.review.dao.InstructionDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
}
