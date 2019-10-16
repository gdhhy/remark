package com.zcreate.remark.controller;

import com.google.gson.*;
import com.zcreate.ReviewConfig;
import com.zcreate.common.DictService;
import com.zcreate.pinyin.PinyinUtil;
import com.zcreate.rbac.web.DeployRunning;
import com.zcreate.review.dao.AppealDAO;
import com.zcreate.review.dao.SampleDAO;
import com.zcreate.review.logic.ReviewService;
import com.zcreate.review.model.Clinic;
import com.zcreate.review.model.Recipe;
import com.zcreate.review.model.RecipeReview;
import com.zcreate.review.model.SampleBatch;
import com.zcreate.util.DataFormat;
import com.zcreate.util.DateUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.MessageFormat;
import java.text.NumberFormat;
import java.util.*;

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
    @Autowired
    private DictService dictService;
    @Autowired
    private AppealDAO appealDao;

    static int CLINIC_COLUMN_COUNT = 15;
    static int HOSPITAL_COLUMN_COUNT = 20;

    JsonParser parser = new JsonParser();
    String templateDir = "excel";

    @ResponseBody
    @RequestMapping(value = "saveRecipe", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
    public String saveRecipe(@RequestBody String string) {
        //log.debug("SecurityContextHolder.getContext().getAuthentication().getPrincipal()=" + SecurityContextHolder.getContext().getAuthentication().getPrincipal());
        Map<String, Object> result = new HashMap<>();
        //out.println("string = " + string);
        //  reviewService.saveRecipe(recipe);
        JsonObject json = (JsonObject) parser.parse(string);
        //JsonObject baseInfo = json.getAsJsonObject("基本情况");
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
            log.debug("review.getRecipeReviewID():" + review.getRecipeReviewID());
            result.put("succeed", succeed);
            result.put("message", "已保存！");
            result.put("recipeReviewID", review.getRecipeReviewID());
        } catch (Exception e) {
            e.printStackTrace();
            result.put("succeed", false);
            result.put("message", e.getMessage());
        }

        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "saveClinic", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
    public String saveClinic(@RequestBody String string) {
        JsonObject json = (JsonObject) parser.parse(string);
        //Clinic clinic=reviewService.getClinic(json.getAsJsonPrimitive("clinicID").getAsInt());
        Clinic clinic = new Clinic();
        clinic.setClinicID(json.get("clinicID").getAsInt());
        clinic.setReviewDate(new Timestamp(System.currentTimeMillis()));
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            clinic.setReviewUser(((UserDetails) principal).getUsername());
        }
        clinic.setResult(json.get("result").getAsString());
        clinic.setDisItem(json.get("disItem").getAsString());
        clinic.setRational(json.get("rational").getAsInt());

        Map<String, Object> result = new HashMap<>();
        reviewService.saveClinic(clinic);
        boolean succeed;
        try {
            succeed = reviewService.saveClinic(clinic);
            //log.debug("review.getRecipeReviewID():" + review.getRecipeReviewID());
            result.put("succeed", succeed);
            result.put("message", "已保存！");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("succeed", false);
            result.put("message", e.getMessage());
        }
        return gson.toJson(result);

    }

    @RequestMapping("getRecipeExcel0")
    public void getRecipeExcel0(HttpServletResponse response, @RequestParam(value = "recipeID") int recipeID, @RequestParam(value = "batchID") int batchID) throws IOException {
        Recipe recipe = reviewService.getRecipe(recipeID);
        RecipeReview review = recipe.getReview();
        //SampleBatch batch = sampleDao.getSampleBatch(batchID);
        JsonObject json = (JsonObject) parser.parse(review.getReviewJson());
        HashSet problemCodeSet = new HashSet(5);

        HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(DeployRunning.getDir() + templateDir + File.separator + "reviewHospital.xls"));//getSurgery 0 or 1
        // String downFileName = "非手术病人抗菌药物使用情况调查表" + recipeID + ".xls";
        HSSFSheet sheet = wb.getSheet("Sheet1");
        JsonObject baseInfo = json.getAsJsonObject("基本情况");
        sheet.getRow(1).getCell(0).setCellValue("科室：" + recipe.getDepartment());
        sheet.getRow(1).getCell(5).setCellValue("病历号：" + recipe.getPatientNo());
        sheet.getRow(1).getCell(7).setCellValue("病人姓名：" + recipe.getPatientName());
        sheet.getRow(2).getCell(2).setCellValue("性别：" + baseInfo.get("sex").getAsString() + baseInfo.get("age").getAsString() + "岁");//(recipe.getSex() ? "男" : "女") + "   年龄：" + String.valueOf(recipe.getAge()) + "岁"
        sheet.getRow(2).getCell(5).setCellValue("入院时间：" + baseInfo.get("inHospital").getAsString());//DateUtils.formatDate(recipe.getInDate(), "yy-M-d")
        sheet.getRow(2).getCell(7).setCellValue("出院时间：" + baseInfo.get("outHospital").getAsString());// DateUtils.formatDate(recipe.getOutDate(), "yy-M-d")

        /*诊断*/
        String inDiagnosis = "入院诊断：", outDiagnosis = "出院诊断：";
        int inIndex = 1, outIndex = 1;
        JsonArray diagnosisArray = json.getAsJsonArray("诊断");
        StringBuilder line = new StringBuilder();
        for (int i = 0; i < diagnosisArray.size(); i++) {
            if (diagnosisArray.get(i).getAsJsonObject().get("type").getAsString().equals("入院诊断"))
                inDiagnosis += inIndex++ + "、" + diagnosisArray.get(i).getAsJsonObject().get("disease").getAsString() + "；  ";
            else
                outDiagnosis += outIndex++ + "、" + diagnosisArray.get(i).getAsJsonObject().get("disease").getAsString() + "；  ";

            if (i == 2) line.append("\n");
        }
        sheet.getRow(3).getCell(2).setCellValue(inDiagnosis);
        sheet.getRow(4).getCell(2).setCellValue(outDiagnosis);
        //细菌培养和药敏
        JsonObject lab = json.getAsJsonObject("细菌培养和药敏");
        sheet.getRow(5).getCell(2).setCellValue("是否送检：" + (lab.get("micro").getAsString().equals("true") ? "是" : "否"));
        sheet.getRow(5).getCell(4).setCellValue("标本：" + lab.get("sample").getAsString());
        sheet.getRow(5).getCell(7).setCellValue("送检日期：" + lab.get("micro_time").getAsString());
        sheet.getRow(6).getCell(2).setCellValue("细菌名称：" + lab.get("germName").getAsString());
        sheet.getRow(7).getCell(2).setCellValue("敏感药物：" + lab.get("sensitiveDrug").getAsString());
        //围手术期用药
        JsonObject surgery = json.getAsJsonObject("围手术期用药");
        //log.debug("surgery=" + surgery);
        if (surgery != null) {//外科
            sheet.getRow(8).getCell(2).setCellValue("手术名称：" + surgery.get("surgeryName").getAsString());
            sheet.getRow(8).getCell(5).setCellValue("手术日期：" + surgery.get("startTime").getAsString());
            String incision = "";
            if ((surgery.get("incision").getAsInt() & 1) == 1) incision = "Ⅰ";
            if ((surgery.get("incision").getAsInt() & 2) == 2) incision += " Ⅱ";
            if ((surgery.get("incision").getAsInt() & 4) == 4) incision += " Ⅲ";
            sheet.getRow(8).getCell(7).setCellValue("切口类别：" + incision);
            String[] before = {"≤2h", ">2h", "未用"};
            sheet.getRow(9).getCell(2).setCellValue("术前用药时间：" + before[surgery.get("beforeDrug").getAsInt()]);
            sheet.getRow(9).getCell(5).setCellValue("术中追加：" + (surgery.get("surgeryAppend").getAsBoolean() ? "有" : "无"));
            sheet.getRow(9).getCell(7).setCellValue("手术持续时间：" + surgery.get("lastTime").getAsString());
            String[] after = {"≤24h", ">24h≤48h", ">48h≤72h", ">3~7天", ">7天"};
            sheet.getRow(10).getCell(2).setCellValue("术后停药时间：" + after[surgery.get("afterDrug").getAsInt()]);
        }
        //用药情况
        JsonObject drugInfo = json.getAsJsonObject("用药情况");
        sheet.getRow(12).getCell(6).setCellValue(drugInfo.get("symptom").getAsString());
        sheet.getRow(14).getCell(6).setCellValue(drugInfo.get("symptom2").getAsString());
        //署名、日期
        sheet.getRow(16).getCell(0).setCellValue("点评人：" + json.get("reviewUser").getAsString());
        sheet.getRow(16).getCell(3).setCellValue("时间：" + DateUtils.formatDate(recipe.getReview().getReviewTime(), "yyyy年M月d日"));
        sheet.getRow(16).getCell(8).setCellValue(recipe.getMasterDoctorName());


        HSSFCellStyle centerAndWrap = wb.createCellStyle();
        centerAndWrap.setAlignment(HorizontalAlignment.CENTER);
        centerAndWrap.setVerticalAlignment(VerticalAlignment.CENTER);
        centerAndWrap.setWrapText(true);
        /*长嘱*/
        JsonArray drugs = json.getAsJsonArray("长嘱");
        int longRow = drugs.size();
        if (longRow > 0) {
            sheet.shiftRows(13, sheet.getLastRowNum(), longRow, false, false);
            for (int i = 0; i < longRow; i++) {
                JsonObject item = drugs.get(i).getAsJsonObject();
                HSSFRow aRow = sheet.createRow(13 + i);
                for (int m = 0; m < 9; m++) {
                    HSSFCell cell = aRow.createCell(m);//getCell 、cr    eateCell
                    HSSFCell sampleCell = sheet.getRow(12).getCell(m);
                    HSSFCellStyle style = sampleCell.getCellStyle();
                    cell.setCellStyle(style);
                    cell.setCellType(sampleCell.getCellType());
                }
                aRow = sheet.getRow(12 + i);
                aRow.setHeight((short) 380);
                //log.debug("item.getRoute()=" + item.get("adviceType").getAsString());
                aRow.getCell(2).setCellValue(item.get("advice").getAsString());
                aRow.getCell(4).setCellValue(item.get("adviceType").getAsString());
                aRow.getCell(5).setCellValue(item.get("recipeDate").getAsString());
                aRow.getCell(8).setCellValue("设置".equals(item.get("question").getAsString()) ? "" : item.get("question").getAsString());

                if (item.get("question").getAsString().indexOf(",") > 0) {
                    String[] codes = item.get("question").getAsString().split(",");
                    for (int p = 0; p < codes.length; p++)
                        problemCodeSet.add(codes[p]);
                }
            }
            sheet.shiftRows(13 + longRow, sheet.getLastRowNum(), -1, true, false);//删除一行，这行是占位设置单元格样式的
            longRow--;
        }
        // 参数1：起始行号 参数2：终止行号 参数3： 起始列号参数4：终止列号
        sheet.addMergedRegion(new CellRangeAddress(11, 12 + longRow, 1, 1)); //用药情况（长期)
        sheet.addMergedRegion(new CellRangeAddress(12, 12 + longRow, 6, 7)); //症状体征及检查
        HSSFCell cell = sheet.getRow(11).getCell(1);
        cell.setCellStyle(centerAndWrap);
        cell = sheet.getRow(12).getCell(6);
        cell.setCellStyle(centerAndWrap);

        //临嘱
        drugs = json.getAsJsonArray("临嘱");
        sheet.getRow(13 + longRow).setHeight((short) 600);
        int shortRow = drugs.size();
        if (shortRow > 0) {
            sheet.shiftRows(15 + longRow, sheet.getLastRowNum(), shortRow, false, false);
            for (int i = 0; i < shortRow; i++) {
                JsonObject item = drugs.get(i).getAsJsonObject();
                HSSFRow aRow = sheet.createRow(15 + longRow + i);
                for (int m = 0; m < 9; m++) {
                    cell = aRow.createCell(m);//getCell 、createCell
                    HSSFCell sampleCell = sheet.getRow(14 + longRow).getCell(m);
                    HSSFCellStyle style = sampleCell.getCellStyle();
                    cell.setCellStyle(style);
                    cell.setCellType(sampleCell.getCellType());
                }
                aRow = sheet.getRow(14 + longRow + i);
                aRow.setHeight((short) 380);

                aRow.getCell(2).setCellValue(item.get("advice").getAsString());
                aRow.getCell(4).setCellValue(item.get("adviceType").getAsString());
                aRow.getCell(5).setCellValue(item.get("recipeDate").getAsString());
                aRow.getCell(8).setCellValue("设置".equals(item.get("question").getAsString()) ? "" : item.get("question").getAsString());

                if (item.get("question").getAsString().indexOf(",") > 0) {
                    String[] codes = item.get("question").getAsString().split(",");
                    for (int p = 0; p < codes.length; p++)
                        problemCodeSet.add(codes[p]);
                }
            }
            sheet.shiftRows(15 + longRow + shortRow, sheet.getLastRowNum(), -1, true, false);//删除一行，这行是占位设置单元格样式的
            shortRow--;
        }
        //参数1：起始行号 参数2：终止行号 参数3： 起始列号参数4：终止列号 ;
        sheet.addMergedRegion(new CellRangeAddress(13 + longRow, 14 + longRow + shortRow, 1, 1));
        sheet.addMergedRegion(new CellRangeAddress(14 + longRow, 14 + longRow + shortRow, 6, 7));
        cell = sheet.getRow(13 + longRow).getCell(1);
        cell.setCellStyle(centerAndWrap);
        cell = sheet.getRow(14 + longRow).getCell(6);
        cell.setCellStyle(centerAndWrap);
        sheet.addMergedRegion(new CellRangeAddress(11, 14 + longRow + shortRow, 0, 0));

        JsonObject remark = json.getAsJsonObject("点评");
        String problemDesc = "";
        for (Iterator iter = problemCodeSet.iterator(); iter.hasNext(); ) {
            String code = (String) iter.next();
            if (code != null && !"".equals(code))
                problemDesc += code.trim() + ":" + dictService.getDictByParentChildNo("00010", code.trim()).getValue() + "\n";
        }
        sheet.getRow(15 + longRow + shortRow).getCell(2).setCellValue(remark.get("review").getAsString() + "\n" + problemDesc);
        if (surgery == null) {//内科，没手术
            sheet.shiftRows(11, sheet.getLastRowNum(), -3, true, false);//删除3行
            sheet.getRow(8).getCell(0).setCellValue(4);
            sheet.getRow(12 + longRow + shortRow).getCell(0).setCellValue(5);

            sheet.getRow(12 + longRow + shortRow).setHeight((short) 2000);
        } else {
            sheet.getRow(15 + longRow + shortRow).setHeight((short) 2000);
            CellRangeAddress region = new CellRangeAddress(8, 10, 1, 1);
            sheet.addMergedRegion(region);

            sheet.getRow(0).getCell(0).setCellValue("医嘱点评工作表（外科）");
        }


        OutputStream out = null;
        try {
            // response.setContentType("image/jpeg;charset=UTF-8");
            response.setContentType("application/vnd.ms-excel;charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename*=utf-8'zh_cn'" +
                    java.net.URLEncoder.encode("医嘱点评工作表", "UTF-8") + recipeID + ".xls");//chrome 、 firefox都正常
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

    @RequestMapping("getRecipeExcel")
    public void getRecipeAntiExcel(HttpServletResponse response, @RequestParam(value = "recipeID") int recipeID, @RequestParam(value = "batchID") int batchID) throws IOException {
        Recipe recipe = reviewService.getRecipe(recipeID);
        RecipeReview review = recipe.getReview();
        SampleBatch batch = sampleDao.getSampleBatch(batchID);
        JsonObject json = (JsonObject) parser.parse(review.getReviewJson());
        HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(DeployRunning.getDir() + templateDir + File.separator + "hospital_" + batch.getSurgery() + ".xls"));//getSurgery 0 or 1
        // String downFileName = "非手术病人抗菌药物使用情况调查表" + recipeID + ".xls";
        HSSFSheet sheet = wb.getSheet("Sheet1");
        int startRow = 1, cellIndex = 3;
//抽样
        String string = Optional.ofNullable(sheet.getRow(startRow).getCell(0).getStringCellValue()).orElse(" {0}医院　抽样时间：{1}至{2}　非手术病人出院人数：{3}");

        sheet.getRow(startRow++).getCell(0).setCellValue(MessageFormat.format(string, reviewConfig.getHospitalName(),
                batch.getFromDate(), batch.getToDate(), batch.getOutPatientNum()));
//病人资料
        string = Optional.ofNullable(sheet.getRow(startRow).getCell(0).getStringCellValue())
                .orElse("病人所属科室：%s   病历号：%s       序号：%s");

        sheet.getRow(startRow++).getCell(0).setCellValue(String.format(string, recipe.getDepartment(), recipe.getPatientNo(), "1"));
//基本情况
        string = Optional.ofNullable(sheet.getRow(startRow).getCell(cellIndex).getStringCellValue())
                .orElse("性别 %s  年龄 %s  体重 %s kg   入院时间： %s 出院时间： %s");
        JsonObject baseInfo = json.getAsJsonObject("基本情况");
        sheet.getRow(startRow++).getCell(cellIndex).setCellValue(String.format(string, baseInfo.get("sex").getAsString(), baseInfo.get("age").getAsString(),
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
        if (batch.getSurgery() == 0) {
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
        }
//手术情况
        if (batch.getSurgery() == 1) {
            JsonObject surgery = json.getAsJsonObject("手术情况");
            string = Optional.ofNullable(sheet.getRow(startRow).getCell(cellIndex).getStringCellValue()).orElse(" 手术名称：{0}　　　切口类别：{1}\n" +
                    "手术开始时间：{2} 手术结束时间：{3}\n" +
                    "术前初次预防用药时间：{4}1.＞1h；{5}2.切皮前0.5-1h ；{6}3.＜0.5hr；{7}4.术前未用术后用；{8}5.未夹脐带后用药；{9}6.夹住脐带后用药；{10}7.眼科滴眼＜24hr；{11}8. 眼科滴眼＞24hr；\n" +
                    "术中给药情况：{12}1.已追加；{13}2.未追加");
            //log.debug("string:" + string);
            int incision = surgery.get("incision").getAsInt();
            int drugItem = surgery.get("drugItem").getAsInt();
            sheet.getRow(startRow++).getCell(cellIndex).setCellValue(MessageFormat.format(string,
                    surgery.get("name").getAsString(), ((incision & 1) == 1 ? "Ⅰ " : "") + ((incision & 2) == 2 ? "Ⅱ " : "") + ((incision & 4) == 4 ? "Ⅲ" : ""),
                    surgery.get("startTime").getAsString(), surgery.get("endTime").getAsString(),
                    getBox(drugItem, 1), getBox(drugItem, 2), getBox(drugItem, 4), getBox(drugItem, 8),
                    getBox(drugItem, 16), getBox(drugItem, 32), getBox(drugItem, 64), getBox(drugItem, 128),
                    getBox(surgery.get("surgeryDrug"), "已追加"), getBox(surgery.get("surgeryDrug"), "未追加")));
        }
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

            sheet.getRow(startRow + i + 1).getCell(cellIndex).setCellValue(Optional.ofNullable(drug.get("menstruum")).map(JsonElement::getAsString).orElse(""));
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
        String[] boxResult = new String[batch.getSurgery() == 0 ? 9 : 12];
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


    @RequestMapping("clinic")
    public void clinic(HttpServletResponse response, @RequestParam(value = "sampleBatchID") int sampleBatchID) throws IOException {
        List<HashMap<String, Object>> list = sampleDao.getSampleList(sampleBatchID, 1, 0, 10000);

        Map<String, Object> param = new HashMap<String, Object>();
        param.put("limit", 1);
        param.put("sampleBatchID", sampleBatchID);
        SampleBatch sampleBatch = sampleDao.getSampleBatchList(param).get(0);
        HashMap<String, Object> statBatch = sampleDao.statSampleBatch(sampleBatchID);
        HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(DeployRunning.getDir() + templateDir + File.separator + "dp.xls"));
        //String  downFileName = "门诊处方评价表.xls";
        HSSFSheet sheet = wb.getSheet("Sheet1");
        HSSFCell hospitalName = sheet.getRow(1).getCell(2);
        HSSFCell usernameCell = sheet.getRow(2).getCell(2);
        HSSFCell dateCell = sheet.getRow(2).getCell(13 - sampleBatch.getType());
        hospitalName.setCellValue(dictService.getDictByNo("00011001").getValue());
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            usernameCell.setCellValue(((UserDetails) principal).getUsername());
        }

        // int lm = sampleBatch.getType() == 1 ? 15 : 13;
        //logger.debug("DateUtils.getDateDayFormat()=" + DateUtils.getDateDayFormat());
        dateCell.setCellValue(DateUtils.getDateDayFormat());
        NumberFormat currencyDisplay = DataFormat.getInstance().getCurrencyEdit();

        sheet.shiftRows(5, sheet.getLastRowNum(), list.size(), false, false);
        for (int i = 0; i < list.size(); i++) {
            HashMap<String, Object> row = list.get(i);
            HSSFRow aRow = sheet.createRow(5 + i);
            aRow.setHeight((short) 380);
            for (int m = 0; m < CLINIC_COLUMN_COUNT; m++) {
                HSSFCell cell = aRow.createCell(m);//getCell 、createCell
                HSSFCell sampleCell = sheet.getRow(4).getCell(m);
                cell.setCellStyle(sampleCell.getCellStyle());
                cell.setCellType(sampleCell.getCellType());
            }
            aRow.getCell(0).setCellValue(i + 1);
            aRow.getCell(1).setCellValue(DateUtils.formatDate((Timestamp) row.get("clinicDate"), "yyyyMMdd"));
            aRow.getCell(2).setCellValue((String) row.get("age"));
            aRow.getCell(3).setCellValue((String) row.get("diagnosis"));
            aRow.getCell(4).setCellValue((Integer) row.get("drugNum"));
            aRow.getCell(5).setCellValue((Integer) row.get("antiNum") == 0 || row.get("antiNum") == null ? 0 : 1);
            aRow.getCell(6).setCellValue((Integer) row.get("injectionNum") > 0 ? 1 : 0);
            aRow.getCell(7).setCellValue((Integer) row.get("baseDrugNum"));
            //columnRow.getCell(8).setCellValue((Integer) row.get("generalNameNum"));废，电脑处方，没有通用名说法
            aRow.getCell(8).setCellValue((Integer) row.get("drugNum"));
            aRow.getCell(9).setCellValue(currencyDisplay.format(((BigDecimal) row.get("money")).floatValue()));
            aRow.getCell(10).setCellValue((String) row.get("doctorName"));
            // if (sampleBatch.getType() == 1) {
            aRow.getCell(11).setCellValue((String) row.get("apothecaryName"));
            aRow.getCell(12).setCellValue((String) row.get("confirmName"));
            aRow.getCell(13).setCellValue(row.get("rational") == null || (Short) row.get("rational") == 0 ? 1 : 0);
            aRow.getCell(14).setCellValue((String) row.get("disItem"));
            /* } else {
                aRow.getCell(11).setCellValue((Short) row.get("rational"));
                aRow.getCell(12).setCellValue((String) row.get("disItem"));
            }*/
        }

        sheet.shiftRows(5, sheet.getLastRowNum(), -1, true, false);//删除一行，这行是占位设置单元格样式的
        //统计、平均
        // 输出列头
        HSSFCellStyle st = wb.createCellStyle();
        st.setBorderBottom(BorderStyle.THIN);
        st.setBorderLeft(BorderStyle.THIN);
        st.setBorderRight(BorderStyle.THIN);
        st.setBorderTop(BorderStyle.THIN);
        HSSFFont font = wb.createFont();
        font.setFontHeightInPoints((short) 8);
        font.setFontName("宋体");
        st.setFont(font);

        HSSFRow totalRow = sheet.createRow(4 + list.size());
        HSSFRow aveRow = sheet.createRow(5 + list.size());
        HSSFRow percentRow = sheet.createRow(6 + list.size());

        for (int m = 0; m < CLINIC_COLUMN_COUNT; m++) {
            HSSFCell cell = totalRow.createCell(m);
            cell.setCellStyle(st);
            cell = aveRow.createCell(m);
            cell.setCellStyle(st);
            cell = percentRow.createCell(m);
            cell.setCellStyle(st);
        }

        NumberFormat numberFormat = NumberFormat.getNumberInstance();
        totalRow.getCell(0).setCellValue("统计");
        totalRow.getCell(4).setCellValue("A=" + statBatch.get("totalDrugNum"));
        totalRow.getCell(5).setCellValue("C=" + statBatch.get("antiNum"));
        totalRow.getCell(6).setCellValue("E=" + statBatch.get("injectionNum"));
        totalRow.getCell(7).setCellValue("G=" + statBatch.get("baseDrugNum"));
        totalRow.getCell(8).setCellValue("I=" + statBatch.get("totalDrugNum"));
        totalRow.getCell(9).setCellValue("K=" + statBatch.get("totalMoney"));
        totalRow.getCell(13).setCellValue("O=" + statBatch.get("rationalNum"));

        // NumberFormat percentDisplay = DataFormat.getPercentDisplay();

        numberFormat.setMaximumFractionDigits(1);
        numberFormat.setMinimumFractionDigits(1);
        /*  logger.debug("statBatch.get(\"totalDrugNum\") =" + statBatch.get("totalDrugNum"));
      logger.debug("statBatch.get(\"rxNum\")=" + statBatch.get("rxNum"));
      logger.debug("aveRow.getCell(4)=" + aveRow.getCell(4));*/
        aveRow.getCell(0).setCellValue("平均");
        aveRow.getCell(4).setCellValue("B=" + numberFormat.format((Integer) statBatch.get("totalDrugNum") * 1.0 / (Integer) statBatch.get("rxNum")));
        aveRow.getCell(9).setCellValue("L=" + numberFormat.format(((BigDecimal) statBatch.get("totalMoney")).doubleValue() / (Integer) statBatch.get("rxNum")));
        percentRow.getCell(0).setCellValue("%");
        percentRow.getCell(5).setCellValue("D=" + numberFormat.format((Integer) statBatch.get("antiNum") * 100.0 / list.size()));
        percentRow.getCell(6).setCellValue("F=" + numberFormat.format((Integer) statBatch.get("injectionNum") * 100.0 / list.size()));
        percentRow.getCell(7).setCellValue("H=" + numberFormat.format((Integer) statBatch.get("baseDrugNum") * 100.0 / (Integer) statBatch.get("totalDrugNum")));
        percentRow.getCell(8).setCellValue("J=" + numberFormat.format((Integer) statBatch.get("totalDrugNum") * 100.0 / (Integer) statBatch.get("totalDrugNum")));
        //numberFormat.setMaximumFractionDigits(0);
        //todo 出现空指针错误， update Clinic set rational=1 where rational is null
        //已完成二院的修改
        aveRow.getCell(13).setCellValue("P=" + numberFormat.format((Integer) statBatch.get("rationalNum") * 100.0 / (Integer) statBatch.get("rxNum")));

        /*tempFilename = "dp" + (int) (Math.random() * 1000000) + ".xls";
        FileOutputStream file = new FileOutputStream(DeployRunning.getDir() + downloadDir + File.separator + tempFilename);
        wb.write(file);
        file.close(); */
        OutputStream out = null;
        try {
            // response.setContentType("image/jpeg;charset=UTF-8");
            response.setContentType("application/vnd.ms-excel;charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename*=utf-8'zh_cn'" +
                    java.net.URLEncoder.encode("门诊处方评价表_", "UTF-8") + sampleBatchID + ".xls");//chrome 、 firefox都正常
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

    @RequestMapping("hospital")
    public void hospital(HttpServletResponse response, @RequestParam(value = "sampleBatchID") int sampleBatchID) throws IOException {

        List<HashMap<String, Object>> list = sampleDao.getSampleList(sampleBatchID, 2, 0, 10000);

      /*  Map<String, Object> param = new HashMap< >();
        param.put("limit", 1);
        param.put("sampleBatchID", sampleBatchID);*/
      //  SampleBatch sampleBatch = sampleDao.getSampleBatchList(param).get(0);
        SampleBatch batch = sampleDao.getSampleBatch(sampleBatchID);
        HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(DeployRunning.getDir() + templateDir + File.separator + "hospital.xls"));
        HSSFSheet sheet = wb.getSheet("Sheet1");
        if (batch.getDoctor() != null) {//填写医生
            HSSFCell doctorCell = sheet.getRow(1).getCell(1);
            doctorCell.setCellValue(batch.getDoctor());
        }
        HSSFCell dateCell = sheet.getRow(1).getCell(15);//填写日期为输出当天
        dateCell.setCellValue(DateUtils.getDateDayFormat());

        // insertRow(sheet, 4, list.size());//插入行

        sheet.shiftRows(5, sheet.getLastRowNum(), list.size(), true, true);      //插入行
        for (int i = 0; i < list.size(); i++) {
            HashMap<String, Object> row = list.get(i);
            HSSFRow aRow = sheet.createRow(5 + i);
            for (int m = 0; m < HOSPITAL_COLUMN_COUNT; m++) {
                HSSFCell cell = aRow.createCell(m);
                HSSFCell sampleCell = sheet.getRow(4).getCell(m);
                cell.setCellStyle(sampleCell.getCellStyle());
                cell.setCellType(sampleCell.getCellType());
            }
            Short antiNum = (Short) row.get("field1_1");
            if (antiNum == null && row.get("concurAntiNum") != null)
                antiNum = ((Number) row.get("concurAntiNum")).shortValue();
            else if (antiNum == null)
                antiNum = 0;
            aRow.getCell(0).setCellValue((String) row.get("patientNo"));
            aRow.getCell(1).setCellValue(getRoman((Short) row.get("field1_2")) + "(" + antiNum + ")");
            aRow.getCell(2).setCellValue(string(row.get("field2_2")) + "/" + getTrueFalse(row.get("field2_1")));
            aRow.getCell(3).setCellValue(getTrueFalse(row.get("field3")));
            aRow.getCell(4).setCellValue(getTrueFalse(row.get("field4")));
            aRow.getCell(5).setCellValue(getTrueFalse(row.get("field5")));
            aRow.getCell(6).setCellValue(getTrueFalse(row.get("field6")));
            aRow.getCell(7).setCellValue(getTrueFalse(row.get("field7")));
            aRow.getCell(8).setCellValue(getTrueFalse(row.get("field8")));
            aRow.getCell(9).setCellValue(getTrueFalse(row.get("field9")));
            aRow.getCell(10).setCellValue(getTrueFalse(row.get("field10")));
            aRow.getCell(11).setCellValue(getTrueFalse(row.get("field11")));
            aRow.getCell(12).setCellValue(getTrueFalse(row.get("field12")));
            aRow.getCell(13).setCellValue(getTrueFalse(row.get("field13")));
            aRow.getCell(14).setCellValue(getTrueFalse(row.get("field14")));
            aRow.getCell(15).setCellValue(getTrueFalse(row.get("field15")));
            aRow.getCell(16).setCellValue(getTrueFalse(row.get("field16")));
            aRow.getCell(17).setCellValue((String) row.get("diagnosis"));
            aRow.getCell(18).setCellValue((String) row.get("result"));
            aRow.getCell(19).setCellValue(getTrueFalse(row.get("rational")));
        }
        sheet.shiftRows(5, sheet.getLastRowNum(), -1, true, false);//删除一行 ，这行是占位设置单元格样式的

        OutputStream out = null;
        try {
            // response.setContentType("image/jpeg;charset=UTF-8");
            response.setContentType("application/vnd.ms-excel;charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename*=utf-8'zh_cn'" +
                    java.net.URLEncoder.encode("住院医嘱调查统计表_", "UTF-8") + sampleBatchID + ".xls");//chrome 、 firefox都正常
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

    private String getTrueFalse(Object obj) {
        if (obj == null) return "";
        else if (obj instanceof Number)
            return 1 == ((Number) obj).intValue() ? "√" : "×";

        return obj.toString();
    }

    private String getRoman(Short value) {
        if (value == null) return "";
        String roman[] = {"", "Ⅰ", "Ⅱ", "Ⅲ"};
        if (value < 4)
            return roman[value];
        else return "";
    }

    private String string(Object obj) {
        if (obj == null) return "";
        else return obj.toString();
    }

    //抗菌药调查
    @RequestMapping(value = "viewClinic", method = RequestMethod.GET)
    public String viewClinic(@RequestParam(value = "clinicID") Integer clinicID, @RequestParam(value = "batchID") Integer batchID, ModelMap model) {
        Clinic clinic = reviewService.getClinic(clinicID);
        clinic.setDoctorName(PinyinUtil.replaceName(clinic.getDoctorName()));
        clinic.setApothecaryName(PinyinUtil.replaceName(clinic.getApothecaryName()));
        clinic.setConfirmName(PinyinUtil.replaceName(clinic.getConfirmName()));

        if (clinic.getAppealState() != null && clinic.getAppealState() > 0) {
            model.addAttribute("appeal", appealDao.getAppeal(clinicID, 1));
        }
        log.debug("clinic:" + clinic.getAntiMoney());
        SampleBatch batch = sampleDao.getSampleBatch(batchID);
        model.addAttribute("clinic", clinic);
        model.addAttribute("deployLocation", reviewConfig.getDeployLocation());
        model.addAttribute("batchID", batchID);
        model.addAttribute("batch", batch);
        model.addAttribute("currentUser", SecurityContextHolder.getContext().getAuthentication().getPrincipal());//todo
        return "/remark/clinic";
    }

    //抗菌药调查
    @RequestMapping(value = "viewRecipe1", method = RequestMethod.GET)
    public String viewRecipe1(@RequestParam(value = "recipeID") Integer recipeID, @RequestParam(value = "batchID") Integer batchID, ModelMap model) {
        Recipe recipe = reviewService.getRecipe(recipeID);
        if (recipe != null) {
            log.debug("viewRecipe:" + recipe.getDepartment());
            log.debug("reviewService:" + reviewService);
            recipe.setDepartCode(reviewService.getDepartCode(recipe.getDepartment()));
            SampleBatch batch = sampleDao.getSampleBatch(batchID);
            recipe.setMasterDoctorName(PinyinUtil.replaceName(recipe.getMasterDoctorName()));
            if (recipe.getReview().getRecipeReviewID() == null) recipe.getReview().setGermCheck(recipe.getMicrobeCheck() > 0 ? 1 : 0);

            model.addAttribute("recipe", recipe);
            model.addAttribute("deployLocation", reviewConfig.getDeployLocation());
        /*model.addAttribute("inDate", DateUtils.formatSqlDateTime(recipe.getInDate()));
        model.addAttribute("outDate", DateUtils.formatSqlDateTime(recipe.getOutDate()));*/
            model.addAttribute("inDate", new Date(recipe.getInDate().getTime()));
            model.addAttribute("outDate", new java.util.Date(recipe.getOutDate().getTime()));
            model.addAttribute("batchID", batchID);
            model.addAttribute("batch", batch);
            model.addAttribute("currentUser", SecurityContextHolder.getContext().getAuthentication().getPrincipal());//todo change spring security
        }
        return "/remark/recipe1";
    }

    //医嘱点评
    @RequestMapping(value = "viewRecipe0", method = RequestMethod.GET)
    public String viewRecipe0(@RequestParam(value = "recipeID") Integer recipeID, @RequestParam(value = "batchID") Integer batchID, ModelMap model) {
        Recipe recipe = reviewService.getRecipe(recipeID);
        if (recipe != null) {
            log.debug("viewRecipe:" + recipe.getDepartment());
            log.debug("reviewService:" + reviewService);
            recipe.setDepartCode(reviewService.getDepartCode(recipe.getDepartment()));
            SampleBatch batch = sampleDao.getSampleBatch(batchID);
            recipe.setMasterDoctorName(PinyinUtil.replaceName(recipe.getMasterDoctorName()));
            if (recipe.getReview().getRecipeReviewID() == null) recipe.getReview().setGermCheck(recipe.getMicrobeCheck() > 0 ? 1 : 0);

            model.addAttribute("recipe", recipe);
            model.addAttribute("deployLocation", reviewConfig.getDeployLocation());
            model.addAttribute("inDate", new Date(recipe.getInDate().getTime()));
            model.addAttribute("outDate", new java.util.Date(recipe.getOutDate().getTime()));
            model.addAttribute("batchID", batchID);
            model.addAttribute("batch", batch);
            model.addAttribute("currentUser", SecurityContextHolder.getContext().getAuthentication().getPrincipal());
        }
        return "/remark/recipe0";
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

    public static String getBox(JsonElement element, String compare) {
        return element != null && element.getAsString().equals(compare) ? "☑" : "□";
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
