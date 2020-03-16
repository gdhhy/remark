package com.zcreate.review.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.review.dao.UntowardDAO;
import com.zcreate.review.logic.ReviewService;
import com.zcreate.review.model.Clinic;
import com.zcreate.review.model.Recipe;
import com.zcreate.review.model.Untoward;
import com.zcreate.security.dao.UserMapper;
import com.zcreate.util.Verify;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by hhy on 2014/10/12.
 */
@Controller
@RequestMapping("/spring")
public class UntowardController {
    static Logger logger = Logger.getLogger(UntowardController.class);
    private UntowardDAO untowardDao;
    private ReviewService reviewService;
    @Autowired
    private UserMapper userMapper;

    @Autowired
    public void setReviewService(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @Autowired
    public void setUntowardDao(UntowardDAO untowardDao) {
        this.untowardDao = untowardDao;
    }


    private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm").create();
    private Gson gson2 = new GsonBuilder().create();

    @ResponseBody
    @RequestMapping(value = "getUntowardList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getUntowardList(@RequestParam(value = "doubtMedicineNo", required = false) String doubtMedicineNo,
                                  @RequestParam(value = "fromDate", required = false) String fromDate,
                                  @RequestParam(value = "toDate", required = false) String toDate) {
        Map<String, Object> modelMap = new HashMap< >();
        Map<String, Object> param = new HashMap< >();
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            UserDetails ud = (UserDetails) principal;

            if (!ud.getAuthorities().contains(new SimpleGrantedAuthority("REVIEW")))
                param.put("doctorUserID", ud.getUsername()); 
          /*  if (!role.getRoleNo().equals("drugHead"))//处方点评管理员
                param.put("declarerUserID", authToken.getUserID());*/
            else
                param.put("notWorkflow", 0);//新建编辑的，管理员不看

            if (Verify.validPositiveInt(doubtMedicineNo))
                param.put("doubtMedicineNo", doubtMedicineNo);
          /*  else
                param.put("doubtMedicineName", doubtMedicineNo);
            logger.debug("doubtMedicineNo = " + doubtMedicineNo);*/
            param.put("fromDate", fromDate);
            param.put("toDate", toDate);

            List<Map<String, Object>> untowards = untowardDao.getUntowardList(param);
            for (Map<String, Object> untoward : untowards)
                untoward.put("declarer", userMapper.getUserByID((Integer) untoward.get("declarerUserID")).getName());

            modelMap.put("success", true);
            modelMap.put("totalCount", untowards.size());
            modelMap.put("untowards", untowards);
        }

        return gson.toJson(modelMap);
    }

    @ResponseBody
    @RequestMapping(value = "setWorkflow", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String setWorkflow(@RequestParam Integer objectID, @RequestParam Integer workflow, @RequestParam String flowNote) {
        Map<String, Object> modelMap = new HashMap<>();
        int affectedRow;
        String[] arr = untowardDao.getWorkflowChn();

        Untoward untoward = new Untoward();
        untoward.setUntowardID(objectID);
        untoward.setWorkflow(workflow);
        untoward.setWorkflowNote(flowNote);
        affectedRow = untowardDao.doSave(untoward);

        modelMap.put("success", affectedRow > 0);
        if (affectedRow > 0)
            modelMap.put("message", "不良反应报告已 " + arr[workflow % 10] + " 。");
        else
            modelMap.put("message", "不良反应报告 " + arr[workflow % 10] + " 失败。");

        return gson.toJson(modelMap);
    }

    @ResponseBody
    @RequestMapping(value = "getUntoward", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getUntoward(@RequestParam Integer untowardID, @RequestParam Integer objectType, @RequestParam(required = false) Integer objectID) {
        Map<String, Object> modelMap = new HashMap< >();
        //Map<String, Object> param = new HashMap<String, Object>();
        //param.put("untowardID", untowardID);
        if (untowardID != null && untowardID > 0) {
            Untoward untoward = untowardDao.getUntoward(untowardID);
            //untoward.setDeclareUser(orgService.getUser(untoward.getDeclarerUserID()));
            untoward.setDeclareUser(userMapper.getUserByID(untoward.getDeclarerUserID()));
            modelMap.put("untoward", untoward);
        }
        if (objectType != null && objectID != null) {
            if (objectType == 1 && objectID > 0) {
                Clinic clinic = reviewService.getClinic(objectID);
                modelMap.put("clinic", clinic);
            } else {
                Recipe recipe = reviewService.getRecipe(objectID);
                //recipe.setDepartCode(reviewService.getDepartCode(recipe.getDepartment()));
                modelMap.put("recipe", recipe);
            }
        }
        modelMap.put("success", true);

        return gson2.toJson(modelMap);
    }

    @ResponseBody
    @RequestMapping(value = "deleteUntoward", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String deleteUntoward(@RequestParam Integer untowardID) {
        Map<String, Object> modelMap = new HashMap< >();

        try {
            int succeed = untowardDao.doDelete(untowardID);
            modelMap.put("success", succeed > 0);
        } catch (Exception e) {
            e.printStackTrace();
            modelMap.put("success", false);
            modelMap.put("message", e.toString());
        }

        return gson2.toJson(modelMap);
    }

    @ResponseBody
    @RequestMapping(value = "saveUntoward", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String saveUntoward(@RequestBody Untoward untoward) {
        Map<String, Object> modelMap = new HashMap< >();

        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) { 
            untoward.setDeclarerUserID(Integer.parseInt(((UserDetails) principal).getUsername()));
            if (untoward.getWorkflow() % 10 == 2) untoward.setWorkflow(untoward.getWorkflow() + 8);
            try {
                boolean saveResult;
                if (untoward.getUntowardID() != null && untoward.getUntowardID() > 0)
                    saveResult = untowardDao.doSave(untoward) > 0;
                else
                    saveResult = untowardDao.doInsert(untoward) > 0;

                if (saveResult) {
                    //保存怀疑、并用药品

                    //transactionManager.commit(status);
                    modelMap.put("message", "药品不良反应/事件报告表已保存。");
                    modelMap.put("success", true);
                } else
                    modelMap.put("message", "药品不良反应/事件报告表保存失败。");
            } catch (Exception e) {
                e.printStackTrace();
                // logger.debug("回滚数据库事务！");
                //transactionManager.rollback(status);
                modelMap.put("success", false);
                modelMap.put("message", e.toString());
            }

            modelMap.put("untoward", untoward);
        }

        return gson2.toJson(modelMap);
    }
}
