package com.zcreate.pinyin;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

import static com.zcreate.pinyin.PinyinUtil.getPinyinInitial;

@Controller
@RequestMapping("/pinyin")
public class PinyinController {

    private Gson gson = new GsonBuilder().serializeNulls().create();

    @ResponseBody
    @RequestMapping(value = "getPinyin", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getPinyin(@RequestParam(value = "chinese" ) String chinese) {
        String[] pinyin = getPinyinInitial(chinese);
        Map<String, Object> result = new HashMap<>();
        result.put("data", pinyin);
        result.put("iTotalRecords", pinyin.length);
        result.put("iTotalDisplayRecords", pinyin.length);

        return gson.toJson(result);
    }
}
