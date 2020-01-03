package com.zcreate.remark.controller;

import com.zcreate.common.DictService;
import com.zcreate.rbac.web.DeployRunning;
import com.zcreate.remark.dao.DrugRecordsMapper;
import com.zcreate.remark.util.ParamUtils;
import com.zcreate.review.dao.DailyDAO;
import com.zcreate.review.dao.StatDAO;
import com.zcreate.review.logic.AntibiosisService;
import com.zcreate.review.logic.StatService;
import com.zcreate.util.DataFormat;
import com.zcreate.util.StatMath;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Controller
@RequestMapping("/excel")
public class ExcelController {
    private static Logger logger = LoggerFactory.getLogger(SunningController.class);
    /* @Autowired
     private StatDAO statDao;
     @Autowired
     private DailyDAO dailyDao;*/
    @Autowired
    private StatService statService;
    @Autowired
    private AntibiosisService antibiosisService;
    @Autowired
    private DrugRecordsMapper drugRecordsMapper;
    @Autowired
    private DictService dictService;
    String templateDir = "template";

    //药品分析（天）
    //@ResponseBody
    @RequestMapping(value = "statMedicine", method = RequestMethod.GET/*, produces = "text/html;charset=UTF-8"*/)
    public void statMedicine(
            HttpServletResponse response,
            @RequestParam(value = "medicineNo", required = false, defaultValue = "") String medicineNo,
            @RequestParam(value = "department", required = false, defaultValue = "") String department,
            @RequestParam(value = "healthNo", required = false, defaultValue = "") String healthNo,
            @RequestParam(value = "special", required = false, defaultValue = "") String special,
            @RequestParam(value = "top3", required = false, defaultValue = "false") Boolean top3,
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate,
            @RequestParam(value = "type", required = false, defaultValue = "-1") Integer type) throws Exception {
        List<HashMap<String, Object>> result = statService.statByHealthNo(0, 3000, fromDate, toDate, healthNo, medicineNo, department, type, top3, special);
        for (HashMap<String, Object> row : result) {
            row.put("patientRatio", DataFormat.getInstance().getPercentDisplayFormat().format(row.get("patientRatio")));
        }

        String[] prop = {"no", "chnName", "spec", "dose", "base", "minUnit", "minOfpack", "producer", "dealer", "quantity", "amount", "patient", "amountRatio", "patientRatio", "topDepartment", "topDoctor"};

        HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(DeployRunning.getDir() + templateDir + File.separator + "medicine.xls"));

        exportExcel(response, wb, 3, "药品使用统计" + fromDate + "～" + toDate, result, prop);
    }

    @RequestMapping(value = "byDepart", method = RequestMethod.GET/*, produces = "text/html;charset=UTF-8"*/)
    public void byDepart(
            HttpServletResponse response,
            @RequestParam(value = "medicineNo", required = false, defaultValue = "") String medicineNo,
            @RequestParam(value = "healthNo", required = false, defaultValue = "") String healthNo,
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate,
            @RequestParam(value = "type", required = false, defaultValue = "-1") Integer type) throws Exception {
        List<HashMap<String, Object>> result = statService.byDepart(fromDate, toDate, type, healthNo, medicineNo);

        String[] prop = {"department", "amount", "clinicAmount", "hospitalAmount", "amountRatio", "insuranceAmount", "insuranceRatio"};

        HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(DeployRunning.getDir() + templateDir + File.separator + "byDepart.xls"));

        exportExcel(response, wb, 3, "科室用药统计", result, prop);
    }

    @RequestMapping(value = "antiDrug", method = RequestMethod.GET)
    public void antiDrug(HttpServletResponse response,
                         @RequestParam(value = "quarter", required = false, defaultValue = "") String quarter,
                         @RequestParam(value = "month", required = false, defaultValue = "") String month) throws Exception {
        HashMap<String, Object> param = new HashMap<>();
        String chnPeriod = "";
        String[] prop;
        HSSFWorkbook wb;
        if (!"".equals(quarter)) {
            String date[] = quarter.split("-");
            param.put("year", Integer.parseInt(date[0]));
            param.put("quarter", Integer.parseInt(date[1]));
            chnPeriod = Integer.parseInt(date[0]) + "年" + Integer.parseInt(date[1]) + "季度";
            prop = new String[]{"chnName", "antiClass", "dose", "spec", "minUnit", "", "clinicQuantity", "hospitalQuantity", "bringQuantity", "total", "DDDs"};
            wb = new HSSFWorkbook(new FileInputStream(DeployRunning.getDir() + templateDir + File.separator + "antiDrug.xls"));
        } else {//if (!"".equals(month))
            String date[] = month.split("-");
            param.put("year", Integer.parseInt(date[0]));
            param.put("month", Integer.parseInt(date[1]));
            chnPeriod = Integer.parseInt(date[0]) + "年" + Integer.parseInt(date[1]) + "月";
            prop = new String[]{"goodsNo", "chnName", "antiClass", "spec", "minUnit", "price", "amount", "clinicQuantity", "hospitalQuantity", "bringQuantity", "total", "DDDs"};
            wb = new HSSFWorkbook(new FileInputStream(DeployRunning.getDir() + templateDir + File.separator + "antiDrug_month.xls"));
        }
        List<HashMap<String, Object>> result = antibiosisService.antiDrug(param);
        String[] antiClass = {"非限制", "限制", "特殊"};
        for (HashMap<String, Object> aMap : result)
            if ((Short) aMap.get("antiClass") > 0 && (Short) aMap.get("antiClass") <= 3)
                aMap.put("antiClass", antiClass[(Short) aMap.get("antiClass") - 1]);

        wb.getSheet("Sheet1").getRow(1).getCell(0).setCellValue("机构名称：" + dictService.getDictByNo("00011001").getValue());
        wb.getSheet("Sheet1").getRow(1).getCell(11).setCellValue(chnPeriod);

        exportExcel(response, wb, 5, !"".equals(quarter), "抗菌药物品种统计" + chnPeriod, result, prop);
    }

    @RequestMapping(value = "byDoctor", method = RequestMethod.GET)
    public void byDoctor(
            HttpServletResponse response,
            @RequestParam(value = "department", required = false, defaultValue = "") String department,
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate) throws Exception {
        List<HashMap<String, Object>> result = statService.byDoctor(fromDate, toDate, department);

        StatMath.ratio(result, "antiAmount", "amount", "amountRatio");
        StatMath.sumAndCalcRatio(result, "antiAmount", "antiAmountRatio");
        StatMath.ratio(result, "hospitalAntiPatient2", "hospitalPatient2", "antiPatientRatio");
        StatMath.sumAndCalcRatio(result, "clinicAntiPatient", "clinicAntiCompose");
        StatMath.ratio(result, "clinicAntiPatient", "clinicPatient2", "clinicAntiPatientRatio");

        for (HashMap<String, Object> aMap : result) {
            if (aMap.get("hospitalDay") != null && aMap.get("DDDs") != null && ((Number) aMap.get("hospitalDay")).doubleValue() > 0)
                aMap.put("AUD", ((Number) aMap.get("DDDs")).doubleValue() * 100 / ((Number) aMap.get("hospitalDay")).doubleValue());
        }

        String prop[] = {"doctorName", "antiAmount", "amount", "amountRatio", "antiAmountRatio", "hospitalAntiPatient2", "antiPatientRatio",
                "DDDs", "hospitalDay", "AUD", "clinicAntiPatient", "clinicAntiPatientRatio", "clinicAntiCompose"};

        HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(DeployRunning.getDir() + templateDir + File.separator + "antiByDoctor.xls"));

        exportExcel(response, wb, 3, "科室用药统计", result, prop);
    }

    public void exportExcel(HttpServletResponse response, HSSFWorkbook wb, int startRow, String downloadFilename, Collection dataset, String prop[]) throws Exception {
        exportExcel(response, wb, startRow, false, downloadFilename, dataset, prop);
    }

    public void exportExcel(HttpServletResponse response, HSSFWorkbook wb, int startRow, boolean needOrderColumn, String downloadFilename, Collection dataset, String prop[]) throws Exception {
        exportExcel(response, wb, startRow, needOrderColumn, downloadFilename, dataset, prop, 0);
    }

    //通用数据集格式
    public void exportExcel(HttpServletResponse response, HSSFWorkbook wb, int startRow, boolean needOrderColumn, String downloadFilename, Collection dataset, String prop[], int mergeStartRow) throws Exception {
        HSSFSheet sheet = wb.getSheet("Sheet1");
        HSSFCellStyle cellStyle2 = wb.createCellStyle();
        //创建一个DataFormat对象
        HSSFDataFormat format = wb.createDataFormat();
        //这样才能真正的控制单元格格式，@就是指文本型，具体格式的定义还是参考上面的原文吧
        cellStyle2.setDataFormat(format.getFormat("@"));
        sheet.shiftRows(startRow, sheet.getLastRowNum(), dataset.size(), true, true);      //插入行

        //遍历集合数据，产生数据行
        Object[] dataColl = new Object[dataset.size()];
        dataset.toArray(dataColl);
        int startCol = needOrderColumn ? 1 : 0;
        for (int k = 0; k < dataColl.length; k++) {
            // logger.debug("k=" + k);
            HSSFRow aRow = sheet.createRow(startRow + k);
            for (int m = 0; m < prop.length + startCol; m++) {
                HSSFCell cell = aRow.createCell(m);
                HSSFCell sampleCell = sheet.getRow(startRow - 1).getCell(m);
                try {
                    cell.setCellStyle(sampleCell.getCellStyle());
                } catch (Exception e) {
                    logger.debug("m=" + m);
                    logger.debug("m=" + m);
                    e.printStackTrace();
                }
                cell.setCellType(sampleCell.getCellType());
            }
            //if(true) continue;
            Object object = dataColl[k];
            // logger.debug("type6=" + object);
            //利用反射，根据javabean属性的先后顺序，动态调用getXxx()方法得到属性值
            if (needOrderColumn)//需要序号
                aRow.getCell(0).setCellValue(k + 1);
            Calendar cal = Calendar.getInstance();
            for (int i = startCol; i < prop.length + startCol; i++) {
                Object value = BeanUtils.getProperty(object, prop[i - startCol]);
                //logger.debug("type5=" + value);
                //判断值的类型后进行强制类型转换
                String textValue = null;
                if (value instanceof Boolean) {
                    boolean bValue = (Boolean) value;
                    textValue = "是";
                    if (!bValue) {
                        textValue = "否";
                    }
                    aRow.getCell(i).setCellValue(textValue);
                } else if (value instanceof Date) {
                    cal.setTime((Date) value);
                    aRow.getCell(i).setCellValue(cal);
                } else if (value instanceof Double || value instanceof Float) {
                    // logger.debug("type1=" + value);

                    aRow.getCell(i).setCellValue((Double) value);

                } else {
                    //其它数据类型都当作字符串简单处理
                    if (value != null) {
                        //logger.debug("type4=" + value);
                        textValue = value.toString();

                        Pattern p = Pattern.compile("^\\d+(\\.\\d+)?$");
                        Pattern pa = Pattern.compile("^[+-]?(?!0\\d)\\d+(\\.\\d+)?(E-?\\d+)?$");
                        Matcher matcher = p.matcher(textValue);
                        Matcher match = pa.matcher(textValue);
                        if (matcher.matches() || match.matches()) {
                            //是数字当作double处理

                            //logger.debug("type2=" + textValue);

                            aRow.getCell(i).setCellValue(Double.parseDouble(textValue));

                        } else {
                            aRow.getCell(i).setCellValue(textValue);
                            //logger.debug("type3=" + value);
                        }
                    }
                }
            }
        }
        //
        HSSFCellStyle cellStyle = wb.createCellStyle();
        cellStyle.setAlignment(HorizontalAlignment.CENTER); // 水平布局：居中
        cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        if (mergeStartRow > 0)
            for (int j = mergeStartRow + 1; j < sheet.getLastRowNum() - 1; j++) {
                boolean b = sheet.getRow(mergeStartRow + 1).getCell(0).getStringCellValue().trim().equals(sheet.getRow(j + 1).getCell(0).getStringCellValue().trim());
                if (!b) {
                    sheet.addMergedRegion(new CellRangeAddress(mergeStartRow + 1, j, 0, 0));
                    sheet.getRow(mergeStartRow + 1).getCell(0).setCellStyle(cellStyle);
                    mergeStartRow = j + 1;
                }
            }


        sheet.shiftRows(startRow, sheet.getLastRowNum(), -1, true, false);//删除一行，这行是占位设置单元格样式的

        OutputStream out = null;
        try {
            // response.setContentType("image/jpeg;charset=UTF-8");
            response.setContentType("application/vnd.ms-excel;charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename*=utf-8'zh_cn'" +
                    java.net.URLEncoder.encode(downloadFilename, "UTF-8") + ".xls");//chrome 、 firefox都正常
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

    @RequestMapping(value = "departBase", method = RequestMethod.GET)
    public void departBase(HttpServletResponse response, @RequestParam(value = "fromDate") String fromDate, @RequestParam(value = "toDate") String toDate) throws Exception {
        HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate, null);
        List<HashMap<String, Object>> result = drugRecordsMapper.departBase(param);

        StatMath.ratio(result, "base2Amount", "amount", "base2Ratio");
        StatMath.ratio(result, "base3Amount", "amount", "base3Ratio");

        String[] prop = {"department", "amount", "base2Amount", "base3Amount", "base2Ratio", "base3Ratio"};

        HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(DeployRunning.getDir() + templateDir + File.separator + "departBase.xls"));

        exportExcel(response, wb, 3, "科室基药统计" + fromDate + "～" + toDate, result, prop);
    }

    @RequestMapping(value = "doctorBase", method = RequestMethod.GET)
    public void doctorBase(HttpServletResponse response, @RequestParam(value = "fromDate") String fromDate, @RequestParam(value = "toDate") String toDate) throws Exception {
        HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate, null);
        List<HashMap<String, Object>> result = drugRecordsMapper.departBase(param);

        StatMath.ratio(result, "base2Amount", "amount", "base2Ratio");
        StatMath.ratio(result, "base3Amount", "amount", "base3Ratio");

        String[] prop = {"department", "amount", "base2Amount", "base3Amount", "base2Ratio", "base3Ratio"};

        HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(DeployRunning.getDir() + templateDir + File.separator + "departBase.xls"));

        exportExcel(response, wb, 3, "医生基药统计" + fromDate + "～" + toDate, result, prop);
    }
}
