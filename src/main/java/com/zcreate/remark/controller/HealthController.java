package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.review.dao.HealthDAO;
import com.zcreate.review.model.Health;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping("/health")
public class HealthController {
    // private static Logger log = LoggerFactory.getLogger(HealthController.class);
    @Autowired
    private HealthDAO healthDao;
    private Gson gson = new GsonBuilder().create();

    //flue
    @ResponseBody
    @RequestMapping(value = "tree", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String tree(@RequestParam(value = "healthID", required = false, defaultValue = "0") Integer healthID/*,
                       @RequestParam(value = "healthNo", required = false, defaultValue = "00000") String healthNo*/) {
        Health health = healthDao.getHealth(healthID);

        HashMap<String, Object> map = new HashMap<>();
        map.put("id", health.getHealthNo());
        map.put("title", health.getChnName());
        //map.put("healthNo", health.getHealthNo());
        if (health.getHasChild())
            map.put("subs", recurTree(healthID));

        List<HashMap<String, Object>> list = new ArrayList<>();
        list.add(map);
        return gson.toJson(list);
    }

    //easy-ui
    @ResponseBody
    @RequestMapping(value = "easyUITree", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String easyUITree(@RequestParam(value = "healthID", required = false, defaultValue = "0") Integer healthID/*,
                       @RequestParam(value = "healthNo", required = false, defaultValue = "00000") String healthNo*/) {
        Health health = healthDao.getHealth(healthID);

        HashMap<String, Object> map = new HashMap<>();
        map.put("id", health.getHealthNo());
        map.put("text", health.getChnName());
        //map.put("healthNo", health.getHealthNo());
        if (health.getHasChild())
            map.put("children", recurTree(healthID));

        List<HashMap<String, Object>> list = new ArrayList<>();
        list.add(map);
        return gson.toJson(list);
    }

    private List<HashMap<String, Object>> recurTree(int parentID) {
        HashMap<String, Object> param = new HashMap<>();
        param.put("parentID", parentID);
        List<Health> list = healthDao.query(param);

        List<HashMap<String, Object>> childs = new ArrayList<>(list.size());
        for (Health health : list) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("id", health.getHealthNo());
            map.put("text", health.getChnName());
            //map.put("healthNo", health.getHealthNo());
            if (health.getHasChild())
                map.put("children", recurTree(health.getHealthID()));
            childs.add(map);
        }
        return childs;
    }
}
