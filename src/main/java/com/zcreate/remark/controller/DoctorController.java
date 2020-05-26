package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.review.logic.DoctorService;
import com.zcreate.review.model.Doctor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/doctor")
public class DoctorController {
    @Autowired
    private DoctorService doctorService;

    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

    @ResponseBody
    @RequestMapping(value = "liveDoctor", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String liveDoctor(@RequestParam(value = "pinyin", required = false) String pinyin) {
        List<Doctor> doctors = doctorService.getDoctorByPinyin(pinyin);

        /*Map<String, Object> result = new HashMap<>();
        result.put("data", doctors);
        result.put("iTotalRecords", doctors.size());//todo 表的行数，未加任何调剂
        result.put("iTotalDisplayRecords", doctors.size());*/

        return gson.toJson(doctors);
    }
}
