package com.zcreate.remark.controller;

import com.zcreate.remark.dao.DrugRecordsMapper;
import com.zcreate.remark.util.ControllerHelp;
import com.zcreate.remark.util.ParamUtils;
import com.zcreate.review.logic.StatService;
import com.zcreate.util.StatMath;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;

import static com.zcreate.remark.util.ControllerHelp.wrap;

@Controller
@RequestMapping("/sunning")
public class SunningController {
    //private static Logger log = LoggerFactory.getLogger(SunningController.class);
    @Autowired
    private DrugRecordsMapper drugRecordsMapper;
   /* @Autowired
    private SunningMapper sunningMapper;*/
    @Autowired
    private StatService statService;

    //@ResponseBody
    @RequestMapping(value = "summary", method = RequestMethod.GET)
    public String summary(@RequestParam(value = "fromDate") String fromDate,
                          @RequestParam(value = "toDate") String toDate, ModelMap model) {
        HashMap<String, Object> stat;
        stat = statService.summary(fromDate, toDate);
        model.addAttribute("stat", stat);
        return "/sunning/summary_content";
    }

    @RequestMapping(value = "summary_anti", method = RequestMethod.GET)
    public String summary_anti(@RequestParam(value = "fromDate") String fromDate,
                               @RequestParam(value = "toDate") String toDate, ModelMap model) {
        HashMap<String, Object> stat;
        stat = statService.summary(fromDate, toDate);
        model.addAttribute("stat", stat);
        return "/sunning/summary_anti_content";
    }

    //药品分析（天） 按科室
    @ResponseBody
    @RequestMapping(value = "statMedicineGroupByDepart", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String statMedicineGroupByDepart(
            @RequestParam(value = "goodsID", required = false, defaultValue = "") String goodsID,
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate,
            @RequestParam(value = "draw", required = false, defaultValue = "0") int draw,
            @RequestParam(value = "start", required = false, defaultValue = "0") int start,
            @RequestParam(value = "length", required = false, defaultValue = "1000") int limit) {
        HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate, null);
        param.put("goodsID", goodsID);
        List<HashMap<String, Object>> result = drugRecordsMapper.statMedicineGroupByDepart(param);
        //List<HashMap<String, Object>> result = statDao.statMedicineGroupByDepart(param);
        StatMath.sumAndCalcRatio(result, "amount", "ratio");
        return ControllerHelp.wrap(result, start, limit, draw);
    }

    //科室基药
    @ResponseBody
    @RequestMapping(value = "departBase", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String departBase(@RequestParam(value = "fromDate") String fromDate, @RequestParam(value = "toDate") String toDate) {
        HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate, null);
        List<HashMap<String, Object>> result = drugRecordsMapper.departBase(param);
        return wrap(result);
    }

    //科室抗菌药--力锦
    @ResponseBody
    @RequestMapping(value = "departAnti", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String departAnti(@RequestParam(value = "fromDate") String fromDate, @RequestParam(value = "toDate") String toDate) {
        List<HashMap<String, Object>> result = statService.getAntiGroupDepartment(fromDate, toDate);
        return wrap(result);
    }
    //科室抗菌药--力锦
    @ResponseBody
    @RequestMapping(value = "doctorAnti", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String doctorAnti(@RequestParam(value = "fromDate") String fromDate, @RequestParam(value = "toDate") String toDate) {
        List<HashMap<String, Object>> result = statService.getAntiGroupDoctor(fromDate, toDate);
        return wrap(result);
    }

    //医生基药
    @ResponseBody
    @RequestMapping(value = "doctorBase", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String doctorBase(@RequestParam(value = "fromDate") String fromDate, @RequestParam(value = "toDate") String toDate) {
        HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate);
        List<HashMap<String, Object>> result = drugRecordsMapper.doctorBase(param);

        StatMath.ratio(result, "clinicBaseAmount", "clinicAmount", "clinicBaseRatio");
        StatMath.ratio(result, "hospitalBaseAmount", "hospitalAmount", "hospitalBaseRatio");

        return wrap(result);
    }

    //1、科室用药趋势；2、科室基药；3、医生基药 --力锦
    @ResponseBody
    @RequestMapping(value = "medicineList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String medicineList(@RequestParam(value = "fromDate") String fromDate, @RequestParam(value = "toDate") String toDate,
                               @RequestParam(value = "department", defaultValue = "") String department,
                               @RequestParam(value = "doctorName", required = false) Integer doctorID,
                               @RequestParam(value = "antiClass", required = false) Integer antiClass,
                               @RequestParam(value = "baseType", required = false) Integer baseType) {
        HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate, department);
        param.put("antiClass", antiClass);
        param.put("baseType", baseType);
        param.put("doctorID", doctorID);
        List<HashMap<String, Object>> result = drugRecordsMapper.medicineList(param);
        StatMath.sumAndCalcRatio(result, "amount", "amountRatio");//1、科室用药趋势
        return wrap(result);
    }

    @ResponseBody
    @RequestMapping(value = "getDoctorListByMedicine", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getDoctorListByMedicine(
            @RequestParam(value = "goodsID", required = false) Integer goodsID,
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate,
            @RequestParam(value = "draw", required = false, defaultValue = "0") int draw,
            @RequestParam(value = "start", required = false, defaultValue = "0") int start,
            @RequestParam(value = "length", required = false, defaultValue = "1000") int limit) {
        HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate, null);
        param.put("goodsID", goodsID);
        //List<HashMap<String, Object>> result = dailyDao.getDoctorListByMedicine(param);
        List<HashMap<String, Object>> result = drugRecordsMapper.byDoctor(param);
        StatMath.sumAndCalcRatio(result, "amount", "ratio");
        boolean viewDoctorNum = false;
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            viewDoctorNum = ((UserDetails) principal).getAuthorities().contains(new SimpleGrantedAuthority("DRUGDATA"));
        }

        /*log.debug("DRUGDATA=" + viewDoctorNum); */
        if (!viewDoctorNum)
            for (HashMap<String, Object> aMap : result) {
                aMap.put("amount", "-");
                aMap.put("quantity", "-");
            }

        return wrap(result, start, limit, draw);
    }

    //药品分析（天）--力锦
    @ResponseBody
    @RequestMapping(value = "byMedicine", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String byMedicine(
            @RequestParam(value = "goodsID", required = false) Integer goodsID,
            @RequestParam(value = "department", required = false, defaultValue = "") String department,
            @RequestParam(value = "healthNo", required = false, defaultValue = "") String healthNo,
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate,
            @RequestParam(value = "type", required = false, defaultValue = "-1") Integer type,
            @RequestParam(value = "special", required = false, defaultValue = "") String special,
            @RequestParam(value = "top3", required = false, defaultValue = "false") Boolean top3,
          /*  @RequestParam(value = "mental", required = false, defaultValue = "false") Boolean mental,
            @RequestParam(value = "assist", required = false, defaultValue = "false") Boolean assist,*/
            @RequestParam(value = "draw", required = false, defaultValue = "0") int draw,
            @RequestParam(value = "start", required = false, defaultValue = "0") int start,
            @RequestParam(value = "length", required = false, defaultValue = "5000") int limit) {

        /*HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate, department, type);
        param.put("start", start);
        param.put("limit", limit);
        param.put("likeHealthNo", healthNo);

        if (medicineNo.getBytes().length == medicineNo.length())
            param.put("medicineNo", medicineNo);
        else
            param.put("likeMedicineName", medicineNo);

        if ("anti".equals(special))
            param.put("antiClass", 0);
        if ("assist".equals(special))
            param.put("assist", true);
        if ("mental".equals(special))
            param.put("mental", true);
        if ("base1".equals(special))
            param.put("baseType", 1);
        if ("base2".equals(special))
            param.put("base", 2);
        if ("base3".equals(special))
            param.put("base", 3);
        param.put("top3", top3);
        //log.debug("param:" + param);
        param.put("prefix", reviewConfig.getPrefixRBAC());
        List<HashMap<String, Object>> result;
        result = drugRecordsMapper.statByMedicine(param); //取全部


        HashMap summary = drugRecordsMapper.dailySummary(ParamUtils.produceMap(fromDate, toDate, ""));
        for (HashMap<String, Object> aMap : result) {
            aMap.put("amountRatio", ((BigDecimal) aMap.get("amount")).divide(((BigDecimal) summary.get("clinicAmount")).add((BigDecimal) summary.get("hospitalAmount")), 5, BigDecimal.ROUND_HALF_UP));
            aMap.put("patientRatio", ((Integer) aMap.get("patient")) * 1.0 / ((Integer) summary.get("clinicPatient") + (Integer) summary.get("hospitalPatient")));
        }*/
        List<HashMap<String, Object>> result = statService.byMedicine(fromDate, toDate, healthNo, goodsID, department, type, top3, special, start, limit);

        return wrap(result, start, limit, draw);
    }

    //药品分析（天）
  /*  @ResponseBody
    @RequestMapping(value = "dailySummary", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String dailySummary(
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate) {
        List<HashMap<String, Object>> result = statService.byDepart(fromDate, toDate, type, healthNo, medicineNo);

        return wrap(result, start, limit, draw);
    }*/
    /*科室用药趋势 --力锦*/
    @ResponseBody
    @RequestMapping(value = "byDepart", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String byDepart(
            @RequestParam(value = "medicineNo", required = false, defaultValue = "") String medicineNo,
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate,
            @RequestParam(value = "draw", required = false, defaultValue = "0") int draw,
            @RequestParam(value = "start", required = false, defaultValue = "0") int start,
            @RequestParam(value = "length", required = false, defaultValue = "1000") int limit) {
        HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate, "");
        param.put("medicineNo", medicineNo);
        List<HashMap<String, Object>> result = drugRecordsMapper.departMedicine(param);
        StatMath.sumAndCalcRatio(result, "amount", "amountRatio");

        return wrap(result, start, limit, draw);
    }

    @ResponseBody
    @RequestMapping(value = "byDoctor", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String byDoctor(
            @RequestParam(value = "department", required = false, defaultValue = "") String department,
            @RequestParam(value = "fromDate") String fromDate,
            @RequestParam(value = "toDate") String toDate,
            @RequestParam(value = "draw", required = false, defaultValue = "0") int draw,
            @RequestParam(value = "start", required = false, defaultValue = "0") int start,
            @RequestParam(value = "length", required = false, defaultValue = "1000") int limit) {
        HashMap<String, Object> param = ParamUtils.produceMap(fromDate, toDate, department);
        List<HashMap<String, Object>> result = drugRecordsMapper.byDoctor(param);

        return wrap(result, start, limit, draw);
    }

}
