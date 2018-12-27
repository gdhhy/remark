package com.zcreate.remark.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.zcreate.ReviewConfig;
import com.zcreate.pinyin.PinyinUtil;
import com.zcreate.review.logic.ReviewService;
import com.zcreate.review.model.Recipe;
import com.zcreate.review.model.RecipeReview;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/remark")
public class RemarkController {
    private static Logger log = LoggerFactory.getLogger(SampleController.class);
    @Autowired
    private ReviewService reviewService;
    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

    @Autowired
    private ReviewConfig reviewConfig;

    @ResponseBody
    @RequestMapping(value = "saveRecipe", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
    public String saveRecipe(@RequestBody String string) {

        Map<String, Object> result = new HashMap<>();
        JsonParser parser = new JsonParser();
        System.out.println("string = " + string);
        //  reviewService.saveRecipe(recipe);
        JsonObject json = (JsonObject) parser.parse(string);
        //JsonObject baseInfo = json.getAsJsonObject("基本信息");
        RecipeReview review = new RecipeReview();
        review.setRecipeReviewID(json.getAsJsonPrimitive("recipeReviewID").getAsInt());
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            review.setReviewUser(((UserDetails) principal).getUsername());
        }
        review.setReviewTime(new Timestamp(System.currentTimeMillis()));
        //System.out.println("baseInfo.get(\"serialNo\").getAsString() = " + baseInfo.get("serialNo").getAsString());
        review.setSerialNo(json.get("serialNo").getAsString());
        review.setReviewJson(string);
        boolean succeed;
        try {
            succeed = reviewService.saveRecipeReview(review);
            result.put("succeed", succeed);
            result.put("message", "已保存！");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("succeed", false);
            result.put("message", e.getMessage());
        }

        return gson.toJson(result);
    }

    @RequestMapping(value = "viewRecipe", method = RequestMethod.GET)
    public String viewRecipe(@RequestParam(value = "recipeID") Integer recipeID, ModelMap model) {
        log.debug("viewRecipe");
        Recipe recipe = reviewService.getRecipe(recipeID);
        recipe.setDepartCode(reviewService.getDepartCode(recipe.getDepartment()));

        recipe.setMasterDoctorName(PinyinUtil.replaceName(recipe.getMasterDoctorName()));
        if (recipe.getReview().getRecipeReviewID() == null) recipe.getReview().setGermCheck(recipe.getMicrobeCheck() > 0 ? 1 : 0);

        model.addAttribute("recipe", recipe);
        model.addAttribute("deployLocation", reviewConfig.getDeployLocation());
        /*model.addAttribute("inDate", DateUtils.formatSqlDateTime(recipe.getInDate()));
        model.addAttribute("outDate", DateUtils.formatSqlDateTime(recipe.getOutDate()));*/
        model.addAttribute("inDate", new Date(recipe.getInDate().getTime()));
        model.addAttribute("outDate", new java.util.Date(recipe.getOutDate().getTime()));
        return "/remark/recipe";
    }
}
