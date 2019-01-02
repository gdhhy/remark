package com.zcreate.remark.controller;

import com.google.gson.*;
import com.zcreate.ReviewConfig;
import com.zcreate.pinyin.PinyinUtil;
import com.zcreate.rbac.web.DeployRunning;
import com.zcreate.review.dao.SampleDAO;
import com.zcreate.review.logic.ReviewService;
import com.zcreate.review.model.Recipe;
import com.zcreate.review.model.RecipeReview;
import com.zcreate.review.model.SampleBatch;
import com.zcreate.util.DateUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.ss.util.CellRangeAddress;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.sql.Timestamp;
import java.text.MessageFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static java.lang.System.out;

@Controller
@RequestMapping("/remark")
public class RemarkController {
    private static Logger log = LoggerFactory.getLogger(SampleController.class);
    @Autowired
    private ReviewService reviewService;
    @Autowired
    private SampleDAO sampleDao;
    private Gson gson = new GsonBuilder().serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

    @Autowired
    private ReviewConfig reviewConfig;

    @Autowired
    private static String deployDir = DeployRunning.getDir();

    JsonParser parser = new JsonParser();
    String templateDir = "excel";

    @ResponseBody
    @RequestMapping(value = "saveRecipe", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
    public String saveRecipe(@RequestBody String string) {
        log.debug("SecurityContextHolder.getContext().getAuthentication().getPrincipal()=" + SecurityContextHolder.getContext().getAuthentication().getPrincipal());
        Map<String, Object> result = new HashMap<>();
        out.println("string = " + string);
        //  reviewService.saveRecipe(recipe);
        JsonObject json = (JsonObject) parser.parse(string);
        //JsonObject baseInfo = json.getAsJsonObject("基本信息");
        RecipeReview review = new RecipeReview();
        review.setRecipeReviewID(json.getAsJsonPrimitive("recipeReviewID").getAsInt());
        //Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        //System.out.println("principal = " + principal);
       /* if (principal instanceof UserDetails) {
            review.setReviewUser(SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString());
        }*/
        review.setReviewUser(json.get("reviewUser").getAsString());
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

    @RequestMapping("getRecipeExcel")
    public void getRecipeExcel(HttpServletResponse response, @RequestParam(value = "recipeID") int recipeID, @RequestParam(value = "batchID") int batchID) throws IOException {
        Recipe recipe = reviewService.getRecipe(recipeID);
        RecipeReview review = recipe.getReview();
        JsonObject json = (JsonObject) parser.parse(review.getReviewJson());
        HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(DeployRunning.getDir() + templateDir + File.separator + "hospital_1.xls"));
        // String downFileName = "非手术病人抗菌药物使用情况调查表" + recipeID + ".xls";
        HSSFSheet sheet = wb.getSheet("Sheet1");
        int startRow = 1, cellIndex = 3;
//抽样
        String string = Optional.ofNullable(sheet.getRow(startRow).getCell(0).getStringCellValue()).orElse(" {0}医院　抽样时间：{1}至{2}　非手术病人出院人数：{3}");
        SampleBatch batch = sampleDao.getSampleBatch(batchID);
        sheet.getRow(startRow++).getCell(0).setCellValue(MessageFormat.format(string, reviewConfig.getHospitalName(),
                batch.getFromDate(), batch.getToDate(), batch.getOutPatientNum()));
//病人资料
        string = Optional.ofNullable(sheet.getRow(startRow).getCell(0).getStringCellValue())
                .orElse("病人所属科室：%s   病历号：%s       序号：%s");

        sheet.getRow(startRow++).getCell(0).setCellValue(String.format(string , recipe.getDepartment(), recipe.getPatientNo(), "1"));
//基本情况
        string = Optional.ofNullable(sheet.getRow(startRow).getCell(cellIndex).getStringCellValue())
                .orElse("性别 %s  年龄 %s  体重 %s kg   入院时间： %s 出院时间： %s");
        JsonObject baseInfo = json.getAsJsonObject("基本信息");
        sheet.getRow(startRow++).getCell(cellIndex).setCellValue(String.format(string , baseInfo.get("sex").getAsString(), baseInfo.get("age").getAsString(),
                baseInfo.get("weight").getAsString(), baseInfo.get("inHospital").getAsString(), baseInfo.get("outHospital").getAsString()));
//诊断
        JsonArray diagnosisArray = json.getAsJsonArray("诊断");
        StringBuilder line = new StringBuilder();
        for (int i = 0; i < diagnosisArray.size(); i++) {
            line.append(i + 1).append("、").append(diagnosisArray.get(i).getAsJsonObject().get("disease").getAsString()).append("；");
            if (i == 2) line.append("\n");
        }
        sheet.getRow(startRow++).getCell(cellIndex).setCellValue(line.toString());
//过敏史
        string = Optional.ofNullable(sheet.getRow(startRow).getCell(cellIndex).getStringCellValue()).orElse("无{0}　有{1}（抗菌药品通用名：{2}）");
        JsonObject allergy = json.getAsJsonObject("过敏史");
        //log.debug("allergy:" + allergy.toString());
        String tempElement = allergy.get("is") == null ? "" : allergy.get("is").getAsString();
        sheet.getRow(startRow++).getCell(cellIndex).setCellValue(MessageFormat.format(string,
                "无".equals(tempElement) ? "√" : "",
                "有".equals(tempElement) ? "√" : "", allergy.get("generalName").getAsString()));
//实验室检查
        JsonObject lab = json.getAsJsonObject("实验室检查");
        string = Optional.ofNullable(sheet.getRow(startRow).getCell(cellIndex).getStringCellValue())
                .orElse("体温（t）：{0}℃（{1}） 白细胞计数（WBC）：{2}（{3}） 中性粒细胞（NEUT%）：{4}（{5}）\n" +
                        "  谷丙转氨酶（ALT）:{6}（{7}） 肌酐（Cr）:{8}（{9}）");
        sheet.getRow(startRow++).getCell(cellIndex).setCellValue(MessageFormat.format(string,
                replace2Space(lab.get("temperature1").getAsString()), formatDate(lab.get("temperature1_time").getAsString()),
                replace2Space(lab.get("wbc1").getAsString()), formatDate(lab.get("wbc1_time").getAsString()),
                replace2Space(lab.get("neut1").getAsString()), formatDate(lab.get("neut1_time").getAsString()),
                replace2Space(lab.get("alt1").getAsString()), formatDate(lab.get("alt1_time").getAsString()),
                replace2Space(lab.get("cr1").getAsString()), formatDate(lab.get("cr1_time").getAsString())
        ));
        sheet.getRow(startRow++).getCell(cellIndex).setCellValue(MessageFormat.format(string,
                replace2Space(lab.get("temperature2").getAsString()), formatDate(lab.get("temperature2_time").getAsString()),
                replace2Space(lab.get("wbc2").getAsString()), formatDate(lab.get("wbc2_time").getAsString()),
                replace2Space(lab.get("neut2").getAsString()), formatDate(lab.get("neut2_time").getAsString()),
                replace2Space(lab.get("alt2").getAsString()), formatDate(lab.get("alt2_time").getAsString()),
                replace2Space(lab.get("cr2").getAsString()), formatDate(lab.get("cr2_time").getAsString())
        ));
        string = Optional.ofNullable(sheet.getRow(startRow).getCell(cellIndex).getStringCellValue())
                .orElse("病原学检测：1.未做{0} 2.做{1}（{2}）；标本：{3}(未检出{4}/检出{5} -{6}菌)\n" +
                        "药敏试验：1.未做{7} 2.做{8}（{9}）：（相符{10}/不相符{11}）");
        sheet.getRow(startRow++).getCell(cellIndex).setCellValue(MessageFormat.format(string,
                getCorrect(lab.get("micro"), "未做"), getCorrect(lab.get("micro"), "做"), formatDate(lab.get("micro_time").getAsString()),
                replace2Space(lab.get("sample").getAsString()), getCorrect(lab.get("micro"), "未检出"), getCorrect(lab.get("micro"), "检出"),
                replace2Space(lab.get("germName").getAsString()),
                getCorrect(lab.get("sensitive"), "未做"), getCorrect(lab.get("sensitive"), "做"), formatDate(lab.get("sensitive_time").getAsString()),
                getCorrect(lab.get("match"), "相符"), getCorrect(lab.get("match"), "不相符")
        ));
//影像学诊断
        JsonObject imaging = json.getAsJsonObject("影像学检查");
        string = Optional.ofNullable(sheet.getRow(startRow).getCell(cellIndex).getStringCellValue())
                .orElse("1.X线{0}　　CT{1}　　磁共振{2} 　2.部位：{3} 3.结论：{4}");
        sheet.getRow(startRow++).getCell(cellIndex).setCellValue(MessageFormat.format(string,
                getBox(imaging.getAsJsonPrimitive("imaging").getAsInt(), 1),
                getBox(imaging.getAsJsonPrimitive("imaging").getAsInt(), 2),
                getBox(imaging.getAsJsonPrimitive("imaging").getAsInt(), 4),
                replace2Space(imaging.get("part").getAsString()),
                replace2Space(imaging.get("conclusion").getAsString())
        ));
//临床症状
        string = Optional.ofNullable(sheet.getRow(startRow).getCell(cellIndex).getStringCellValue()).orElse("与感染有关的主要症状：%s");
        sheet.getRow(startRow++).getCell(cellIndex).setCellValue(String.format(string, json.get("临床症状").getAsString()));
        //用药目的
        JsonObject purpose = json.getAsJsonObject("用药目的");
        string = Optional.ofNullable(sheet.getRow(startRow).getCell(cellIndex).getStringCellValue())
                .orElse("1．未用药{0}　2.预防（{1}）　3.治疗（{2}）（感染诊断{3} ）");
        sheet.getRow(startRow++).getCell(cellIndex).setCellValue(MessageFormat.format(string,
                getCorrect(purpose.get("purpose"), "未用药"),
                "预防".equals(purpose.get("purpose").getAsString()) ? "▲" : "△",
                getBox("治疗".equals(purpose.get("purpose").getAsString())),
                replace2Space(purpose.get("infection").getAsString())
        ));
//用药情况
        startRow++;//跳过标题行
        JsonArray drugs = json.getAsJsonArray("用药情况");
        //增加一行
        sheet.shiftRows(startRow, sheet.getLastRowNum(), drugs.size() * 2, true, true);      //插入行

        HSSFRow sampleRow = sheet.getRow(startRow + drugs.size() * 2);

        for (int i = 0; i < drugs.size() * 2; i += 2) {

            HSSFRow aRow = sheet.createRow(startRow + i);
            HSSFRow aRow2 = sheet.createRow(startRow + i + 1);

            for (int m = 3; m < sampleRow.getLastCellNum(); m++) {
                HSSFCell sampleCell = sampleRow.getCell(m);

                HSSFCell cell = aRow.createCell(m);
                cell.setCellStyle(sampleCell.getCellStyle());
                cell.setCellType(sampleCell.getCellType());

                HSSFCell cell2 = aRow2.createCell(m);
                cell2.setCellStyle(sampleCell.getCellStyle());
                cell2.setCellType(sampleCell.getCellType());
            }
            sheet.addMergedRegion(new CellRangeAddress(startRow + i, startRow + i, 3, 4));
            sheet.addMergedRegion(new CellRangeAddress(startRow + i + 1, startRow + i + 1, 3, 9));

            JsonObject drug = drugs.get(i / 2).getAsJsonObject();
            sheet.getRow(startRow + i).getCell(cellIndex).setCellValue(("治疗".equals(drug.get("purpose").getAsString()) ? "☑" : "□") +
                    ("预防".equals(drug.get("purpose").getAsString()) ? "▲" : "△") + drug.get("advice").getAsString());
            sheet.getRow(startRow + i).getCell(cellIndex + 2).setCellValue(drug.get("singleQty").getAsString());
            sheet.getRow(startRow + i).getCell(cellIndex + 3).setCellValue(drug.get("frequency").getAsString());
            sheet.getRow(startRow + i).getCell(cellIndex + 4).setCellValue(drug.get("adviceType").getAsString());
            sheet.getRow(startRow + i).getCell(cellIndex + 5).setCellValue(drug.get("quantity").getAsString());
            sheet.getRow(startRow + i).getCell(cellIndex + 6).setCellValue(drug.get("recipeDate").getAsString());

            sheet.getRow(startRow + i + 1).getCell(cellIndex).setCellValue(drug.get("menstruum").getAsString());
        }
        if (drugs.size() > 0)
            sheet.shiftRows(startRow + drugs.size() * 2 + 2, sheet.getLastRowNum(), -2, true, false);//删除两行，这行是占位设置单元格样式的
        sheet.addMergedRegion(new CellRangeAddress(startRow - 1, startRow + (drugs.size() > 0 ? drugs.size() : 1) * 2, 0, 0));//存在标题行,需要 -1
        sheet.addMergedRegion(new CellRangeAddress(startRow - 1, startRow + (drugs.size() > 0 ? drugs.size() : 1) * 2, 1, 2));

        startRow += (drugs.size() > 0 ? drugs.size() : 1) * 2;//记录数x2
        //log.debug("startRow=" + startRow);
//用药情况统计
        JsonObject drugStat = json.getAsJsonObject("用药情况统计");
        string = Optional.ofNullable(sheet.getRow(startRow).getCell(cellIndex).getStringCellValue()).orElse("累计使用抗菌药 %s 种 %s 天");
        sheet.getRow(startRow++).getCell(cellIndex).setCellValue(String.format(string,
                Optional.ofNullable(drugStat.get("antiNum")).map(JsonElement::getAsString).orElse(" "),
                Optional.ofNullable(drugStat.get("antiDays")).map(JsonElement::getAsString).orElse(" ")));
//费用
        JsonObject money = json.getAsJsonObject("费用");
        string = Optional.ofNullable(sheet.getRow(startRow).getCell(cellIndex).getStringCellValue())
                .orElse("住院总费用：%s元；住院药品总费用：%s元；住院抗菌药物总费用： %s元  ");
        sheet.getRow(startRow++).getCell(cellIndex).setCellValue(String.format(string,
                money.get("money").getAsString(), money.get("medicineMoney").getAsString(), money.get("antiMoney").getAsString()
        ));
        //治疗结果
        JsonObject result = json.getAsJsonObject("治疗结果");
        string = Optional.ofNullable(sheet.getRow(startRow).getCell(cellIndex).getStringCellValue())
                .orElse("治愈%s好转%s无效%s");
        sheet.getRow(startRow).getCell(cellIndex).setCellValue(String.format(string,
                getCorrect(result.get("result"), "治愈"), getCorrect(result.get("result"), "好转"), getCorrect(result.get("result"), "无效")
        ));
        string = Optional.ofNullable(sheet.getRow(startRow).getCell(cellIndex + 2).getStringCellValue())
                .orElse("%s　继发（医院）感染");
        sheet.getRow(startRow).getCell(cellIndex + 2).setCellValue(String.format(string, Optional.ofNullable(result.get("secondary")).map(JsonElement::getAsString).orElse(" ")));
        string = Optional.ofNullable(sheet.getRow(startRow).getCell(cellIndex + 6).getStringCellValue())
                .orElse("%s 使用抗真菌药");
        sheet.getRow(startRow++).getCell(cellIndex + 6).setCellValue(String.format(string, Optional.ofNullable(result.get("antimycotic")).map(JsonElement::getAsString).orElse(" ")));


//用药合理性评价
        //startRow = 17;
        String checkbox = sheet.getRow(startRow).getCell(cellIndex).getStringCellValue();
        JsonObject rational = json.getAsJsonObject("用药合理性评价");
        String[] boxResult = new String[9];
        for (int i = 0; i < boxResult.length; i++)
            boxResult[i] = getBox(rational.getAsJsonPrimitive("me").getAsInt(), (int) Math.pow(2, i));
        sheet.getRow(startRow++).getCell(cellIndex).setCellValue(MessageFormat.format(checkbox, (Object[]) boxResult));

        for (int i = 0; i < boxResult.length; i++)
            boxResult[i] = getBox(rational.getAsJsonPrimitive("central").getAsInt(), (int) Math.pow(2, i));
        sheet.getRow(startRow++).getCell(cellIndex).setCellValue(MessageFormat.format(checkbox, (Object[]) boxResult));
        //备注
        //string = Optional.ofNullable(sheet.getRow(startRow).getCell(cellIndex).getStringCellValue()).orElse("%s");
        sheet.getRow(startRow).getCell(cellIndex).setCellValue(json.get("备注").getAsString());

        OutputStream out = null;
        try {
            // response.setContentType("image/jpeg;charset=UTF-8");
            response.setContentType("application/vnd.ms-excel;charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename*=utf-8'zh_cn'" +
                    java.net.URLEncoder.encode("非手术病人抗菌药物使用情况调查表_", "UTF-8") + recipeID + ".xls");//chrome 、 firefox都正常
            out = response.getOutputStream(); // 输出到文件流
            wb.write(out);
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }

    @RequestMapping(value = "viewRecipe", method = RequestMethod.GET)
    public String viewRecipe(@RequestParam(value = "recipeID") Integer recipeID, @RequestParam(value = "batchID") Integer batchID, ModelMap model) {
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
        model.addAttribute("batchID", batchID);
        model.addAttribute("currentUser", SecurityContextHolder.getContext().getAuthentication().getPrincipal());
        return "/remark/recipe";
    }

    public static String getBox(Boolean box) {
        return box != null && box ? "☑" : "□";
    }

    public static String formatDate(String sqlDate) {
        if ("".equals(sqlDate)) return "__/__";
        if (sqlDate.indexOf("-") > 0) return sqlDate.substring(sqlDate.indexOf("-") + 1).replace("-", "/");
        return sqlDate;
    }

    public static String replace2Space(String string) {
        return ("".equals(string)) || string == null ? "  " : string;
    }

    public static String getBox(Integer num, int k) {
        return num != null && ((num & k) == k) ? "☑" : "□";
    }

    public static String getBox(Long num, int k) {
        return num != null && ((num & k) == k) ? "☑" : "□";
    }

    public static String getTriangle(Integer triangle, int k) {
        return triangle != null && ((triangle & k) == k) ? "▲" : "△";
    }

    private String getCorrect(Object obj) {
        if (obj == null) return "";
        else if (obj instanceof Number)
            return 1 == ((Number) obj).intValue() ? "√" : "×";

        return obj.toString();
    }

    private String getCorrect(JsonElement element, String compare) {
        return element != null && element.getAsString().equals(compare) ? "√" : " ";
    }

}
