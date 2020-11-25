package com.zcreate.remark.controller;

import ChartDirector.Chart;
import ChartDirector.XYChart;
import com.zcreate.remark.dao.DrugRecordsMapper;
import com.zcreate.remark.util.ChartHelp;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import static com.zcreate.remark.util.ParamUtils.produceMap;

@Controller
@RequestMapping("/chart")
public class ChartController {
    private static Logger log = LoggerFactory.getLogger(ChartController.class);

    @Autowired
    private DrugRecordsMapper drugRecordsMapper;

    public ChartController() {
        Chart.setLicenseCode("SXZVFNRN9MZ9L8LGA0E2B1BB");
    }

    @ResponseBody
    @RequestMapping(value = "/medicine", method = RequestMethod.GET,  produces = MediaType.IMAGE_PNG_VALUE)
    public BufferedImage medicine(
            @RequestParam(value = "goodsID", required = false ) Integer goodsID,
            @RequestParam(value = "department", required = false, defaultValue = "") String department,
            @RequestParam(value = "doctorName", required = false, defaultValue = "") String doctorName,
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate,
            @RequestParam(value = "type", required = false, defaultValue = "-1") Integer type,
            @RequestParam(value = "chartWidth", required = false, defaultValue = "400") int chartWidth,
            @RequestParam(value = "chartHeight", required = false, defaultValue = "300") int chartHeight) throws IOException {
        //log.debug("statMedicine");
        HashMap<String, Object> param = produceMap(fromDate, toDate, department, type);//本查询type没用到，for循环时用到
        param.put("goodsID", goodsID);
        param.put("doctorName", doctorName);
        List<HashMap<String, Object>> result = drugRecordsMapper.medicineDay(param);
        XYChart c = ChartHelp.createXYChart(chartWidth, chartHeight, result, "amount", "date", "元", Color.red.getRed());

        return ImageIO.read(new ByteArrayInputStream(c.makeChart2(Chart.PNG)));
    }
}
