package com.zcreate.review.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.ReviewConfig;
import com.zcreate.rbac.web.DeployRunning;
import com.zcreate.review.dao.InfectiousDAO;
import com.zcreate.review.dao.PatientInfoDAO;
import com.zcreate.review.model.Contagion;
import com.zcreate.review.model.Infectious;
import com.zcreate.security.pojo.User;
import com.zcreate.util.DateJsonValueProcessor;
import com.zcreate.util.DateUtils;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.util.JRLoader;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Timestamp;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import static com.zcreate.remark.util.ControllerHelp.wrap;

//update Sys_Role set homepage='ext5/doctor/index.jspx' where roleNo in('infectious','contagion');
@Controller
@RequestMapping("/infectious")
public class InfectiousController {
    private static String jasperDir = "WEB-INF" + File.separator + "classes" + File.separator + "jasperreport" + File.separator;
    static Logger logger = Logger.getLogger(InfectiousController.class);
    @Autowired
    private InfectiousDAO infectiousDao;
    @Autowired
    private PatientInfoDAO patientInfoDao;
    @Autowired
    private com.zcreate.security.dao.UserMapper userMapper;
    @Autowired
    private ReviewConfig reviewConfig;

    private String check = "√", uncheck = "□";
    private JsonConfig jsonConfig;

    private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm").create();

    public InfectiousController() {
        jsonConfig = new JsonConfig();
        jsonConfig.registerJsonValueProcessor(Timestamp.class, new DateJsonValueProcessor("yyyy-MM-dd HH:mm"));
    }
    //private OrgService orgService;


    @ResponseBody
    @RequestMapping(value = "getInfectiousList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getInfectiousList(@RequestParam(value = "fromDate", required = false) String fromDate,
                                    @RequestParam(value = "toDate", required = false) String toDate,
                                    @RequestParam(value = "queryItem", required = false) String queryItem,
                                    @RequestParam(value = "queryField", required = false) String queryField,
                                    @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                                    @RequestParam(value = "limit", required = false, defaultValue = "100") int limit,
                                    @RequestParam(value = "workflowState", required = false, defaultValue = "-1") int workflowState) {
        //ModelAndView modelView = new ModelAndView();
        //Map<String, Object> modelMap = new HashMap<>();
        Map<String, Object> param = new HashMap<>();

        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            UserDetails ud = (UserDetails) principal;

            if (!ud.getAuthorities().contains(new SimpleGrantedAuthority("INFECTIOUS")) &&
                    !ud.getAuthorities().contains(new SimpleGrantedAuthority("protect")))
                param.put("doctorUsername", ud.getUsername());
            else
                param.put("notWorkflow", 0);//新建编辑的，管理员不看

            param.put("queryItem", queryItem);
            param.put("queryField", queryField);
            param.put("workflowState", workflowState);
            param.put("fromDate", fromDate);
            param.put("toDate", DateUtils.nextDaySqlStr(toDate));
            /*param.put("limit", limit);
            param.put("start", start);*/

            List<Infectious> infectiousList = infectiousDao.getInfectiousList(param);
            return wrap(infectiousList);
           /* modelMap.put("success", true);
            modelMap.put("totalCount", infectiousList.size());
            modelMap.put("infectious", infectiousList.subList(start, Math.min(start + limit, infectiousList.size())));//todo pass param into sql*/
        }
        return wrap(new ArrayList<Infectious>());
        /*modelView.addAllObjects(modelMap);*/
        //System.out.println("gson.toJson(modelMap) = " + gson.toJson(modelMap));
    }

    @RequestMapping(value = "getInfectious", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getInfectious(@RequestParam(value = "infectiousID") Integer infectiousID, ModelMap model) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        UserDetails ud = (UserDetails) principal;
        if (ud.getAuthorities().contains(new SimpleGrantedAuthority("INFECTIOUS")))
            model.addAttribute("INFECTIOUS_ROLE", true);
        else
            model.addAttribute("INFECTIOUS_ROLE", false);

        model.addAttribute("success", true);
        model.addAttribute("infectious", infectiousDao.getInfectious(infectiousID));

        return "/infectious/infectious";
    }

    @RequestMapping(value = "showInfectiousList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String showInfectiousList(ModelMap model) {
        model.addAttribute("INFECTIOUS_ROLE", false);
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            UserDetails ud = (UserDetails) principal;
            if (ud.getAuthorities().contains(new SimpleGrantedAuthority("INFECTIOUS")))
                model.addAttribute("INFECTIOUS_ROLE", true);
        }

        return "/infectious/infectious_list";
    }

    @RequestMapping(value = "showContagionList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String showContagionList(ModelMap model) {
        model.addAttribute("CONTAGION_ROLE", false);
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            UserDetails ud = (UserDetails) principal;
            if (ud.getAuthorities().contains(new SimpleGrantedAuthority("CONTAGION")))
                model.addAttribute("CONTAGION_ROLE", true);
        }

        return "/infectious/contagion_list";
    }

    @RequestMapping(value = "/newInfectious", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String newInfectious(@RequestParam(value = "patientID", required = false, defaultValue = "0") Integer patientID,
                                @RequestParam(value = "hospID", required = false, defaultValue = "") String hospID,
                                @RequestParam(value = "diagnosisDate", required = false, defaultValue = "") String diagnosisDate,
                                ModelMap model) {
        Infectious infectious = new Infectious();
        infectious.setReportType(1);
        infectious.setFillTime(DateUtils.formatSqlDateTime(new Date()));
        infectious.setReportUnit(reviewConfig.getHospitalName());
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            UserDetails ud = (UserDetails) principal;
            if (ud.getAuthorities().contains(new SimpleGrantedAuthority("INFECTIOUS")))
                model.addAttribute("INFECTIOUS_ROLE", true);
            else
                model.addAttribute("INFECTIOUS_ROLE", false);
            User user;
            if (ud instanceof User)
                user = (User) ud;
            else
                user = userMapper.getUserByLoginname(((UserDetails) principal).getUsername());//自动登录的，只有UserDetail，不是User
            infectious.setDoctorUserID(user.getUserID());
            infectious.setDoctorUsername(((UserDetails) principal).getUsername());
            infectious.setReportDoctor(user.getName());
            if (user.getLink() != null)
                infectious.setDoctorPhone(user.getLink().getAsString());
        }
        if (patientID > 0) {
            infectious.setPatientID(patientID);
            infectious.sethospID(hospID);
            Map<String, Object> patientInfo = patientInfoDao.getPatientInfo(patientID);
            infectious.setPatientName((String) patientInfo.get("Name"));
            infectious.setBirthday(DateUtils.formatSqlDate((Timestamp) patientInfo.get("BirthDate")));
            infectious.setIdCardNo((String) patientInfo.get("IDCardNo"));
            infectious.setPatientParent((String) patientInfo.get("LinkmanName"));
            infectious.setBoy("M".equals(patientInfo.get("SEX")) ? 1 : 0);
            infectious.setWorkplace((String) patientInfo.get("Company"));
            infectious.setLinkPhone((String) patientInfo.get("Mobile"));
            infectious.setAddress((String) patientInfo.get("AddressHome"));
            infectious.setOccupationElse((String) patientInfo.get("Occupation2"));
            infectious.setDiagnosisDate(diagnosisDate);

            //性病项

            switch ((Short) patientInfo.get("LsMarriage")) {//婚姻状况：1-儿童；2-未婚；3-初婚；4-再婚；5-离异；6-丧偶；7-其他
                case 1:
                case 2:
                    infectious.setMarital(1);
                    break;
                case 3:

                case 4:
                    infectious.setMarital(2);
                    break;
                case 5:
                case 6:
                    infectious.setMarital(3);
                    break;
                default:
                    infectious.setMarital(7);
            }
            infectious.setNation("汉族".equals(patientInfo.get("nation")) ? 1 : 2);
            infectious.setNationElse((String) patientInfo.get("nation"));
            infectious.setRegisterAddr((String) patientInfo.get("Residence"));
        }
        model.addAttribute("success", true);
        model.addAttribute("infectious", infectious);

        return "/infectious/infectious";
    }

    public JasperPrint getContagionJasperPrint(HashMap<String, Object> contagion) throws Exception {
        InputStream is = new FileInputStream(DeployRunning.getDir() + jasperDir + "contagion.jasper");
        JasperReport jasperReport = (JasperReport) JRLoader.loadObject(is);
        HashMap<String, Object> param = new HashMap<>();

        List<HashMap> nullList = new ArrayList<>(1);
        nullList.add(new HashMap<>());

        JSONObject sampleObject = JSONObject.fromObject(contagion.get("sample"));
        JSONArray kk;
        List listSample;
        if (sampleObject.optInt("totalCount", 0) > 0) {
            kk = (JSONArray) sampleObject.get("results");
            listSample = JSONArray.toList(kk, new HashMap(), jsonConfig);
        } else
            listSample = nullList;
        param.put("sampleDS", new JRBeanCollectionDataSource(listSample));

        sampleObject = JSONObject.fromObject(contagion.get("bAntiDrug"));
        if (sampleObject.optInt("totalCount", 0) > 0) {
            kk = (JSONArray) sampleObject.get("results");
            listSample = JSONArray.toList(kk, new HashMap(), jsonConfig);
        } else
            listSample = nullList;
        param.put("bAntiDrugDS", new JRBeanCollectionDataSource(listSample));

        sampleObject = JSONObject.fromObject(contagion.get("aAntiDrug"));
        if (sampleObject.optInt("totalCount", 0) > 0) {
            kk = (JSONArray) sampleObject.get("results");
            listSample = JSONArray.toList(kk, new HashMap(), jsonConfig);
        } else
            listSample = nullList;
        param.put("aAntiDrugDS", new JRBeanCollectionDataSource(listSample));

        sampleObject = JSONObject.fromObject(contagion.get("pAntiDrug"));
        if (sampleObject.optInt("totalCount", 0) > 0) {
            kk = (JSONArray) sampleObject.get("results");
            listSample = JSONArray.toList(kk, new HashMap(), jsonConfig);
        } else
            listSample = nullList;
        param.put("pAntiDrugDS", new JRBeanCollectionDataSource(listSample));


        contagion.put("emergency", (Integer) contagion.get("emergency") == 1 ? "√是       □否" : "□是       √否");

        String[] items = new String[]{"清洁", "清洁污染", "污染"};
        String result = "";
        for (String s : items)
            result += (s.equals(contagion.get("cut")) ? check : uncheck) + s + "     ";
        contagion.put("cut", result);
        contagion.put("spaceString", "");


        List<HashMap> list = new ArrayList<>(1);
        list.add(contagion);

        JasperPrint print = JasperFillManager.fillReport(jasperReport, param, new JRBeanCollectionDataSource(list));
        return print;
    }

    @RequestMapping(value = "getContagionPDF", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public void getContagionPDF(@RequestParam Integer contagionID, HttpServletRequest request, HttpServletResponse response) {
        HashMap<String, Object> contagion = infectiousDao.getContagion(contagionID);
        try {
            JasperPrint print = getContagionJasperPrint(contagion);

            request.setCharacterEncoding("UTF-8");
            response.setContentType("application/pdf");
            response.setHeader("Content-disposition", "attachment; filename=" + new String((StringUtils.trim((String) contagion.get("patientName")) + ".pdf").getBytes(), "ISO8859-1"));
            ServletOutputStream outputStream = response.getOutputStream();
            //輸出PDF
            JasperExportManager.exportReportToPdfStream(print, outputStream);

            outputStream.flush();
            outputStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "getContagionPDFs", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public void getContagionPDFs(@RequestParam String contagionIDs, HttpServletRequest request, HttpServletResponse response) {
        JSONArray IDs = JSONArray.fromObject(contagionIDs);
        try { //创建zip输出流
            request.setCharacterEncoding("UTF-8");
            response.setContentType("application/zip");
            response.setHeader("Content-disposition", "attachment; filename=" + DateUtils.formatDate(new Date(), "yyyyMMddHHmmss") + ".zip");

            ZipOutputStream zip = new ZipOutputStream(response.getOutputStream());

            Iterator<Integer> iter = IDs.iterator();
            while (iter.hasNext()) {
                HashMap<String, Object> contagion = infectiousDao.getContagion(iter.next());
                try {
                    JasperPrint print = getContagionJasperPrint(contagion);

                    zip.putNextEntry(new ZipEntry(StringUtils.trim((String) contagion.get("patientName")) + contagion.get("contagionID") + ".pdf"));

                    JasperExportManager.exportReportToPdfStream(print, zip);//bos
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            zip.flush();
            zip.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "getInfectiousPDFs", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public void getInfectiousPDFs(@RequestParam String infectiousIDs, HttpServletRequest request, HttpServletResponse response) {
        JSONArray IDs = JSONArray.fromObject(infectiousIDs);
        //logger.debug("IDs=" + IDs.toString());

        try { //创建zip输出流
            request.setCharacterEncoding("UTF-8");
            response.setContentType("application/zip");
            response.setHeader("Content-disposition", "attachment; filename=" + DateUtils.formatDate(new Date(), "yyyyMMddHHmmss") + ".zip");

            ZipOutputStream zip = new ZipOutputStream(response.getOutputStream());
            //创建缓冲输出流
            //BufferedOutputStream bos = new BufferedOutputStream(zip);

            Iterator<Integer> iter = IDs.iterator();
            while (iter.hasNext()) {
                HashMap<String, Object> infectious = infectiousDao.getInfectious(iter.next());
                try {
                    JasperPrint print = getInfectiousJasperPrint(infectious);

                    zip.putNextEntry(new ZipEntry(infectious.get("infectiousName") + "_" + StringUtils.trim((String) infectious.get("patientName")) + infectious.get("infectiousID") + ".pdf"));

                    JasperExportManager.exportReportToPdfStream(print, zip);//bos
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            //bos.flush();
            zip.flush();

            //bos.close();
            zip.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public JasperPrint getInfectiousJasperPrint(HashMap<String, Object> infectious) throws Exception {
        //□■△▲√×☑
        InputStream is = new FileInputStream(DeployRunning.getDir() + jasperDir + "infectious.jasper");
        JasperReport jasperReport = (JasperReport) JRLoader.loadObject(is);
        HashMap<String, Object> parameters1 = new HashMap<>();

        List<HashMap> list = new ArrayList<>(1);

        infectious.put("reportType", (Integer) infectious.get("reportType") == 1 ? "√1、初次报告   □2、订正报告" : "□1、初次报告   √2、订正报告");
        infectious.put("boy", (Integer) infectious.get("boy") == 1 ? "√男    □女" : "□男    √女");

        String[] items = new String[]{"本县区", "本市其它县区", "本省其它地市", "外省", "港澳台", "外籍"};
        String result = "";
        for (String s : items) {
            result += (s.equals(infectious.get("belongTo")) ? check : uncheck) + s + "   ";
        }
        infectious.put("belongTo", result);

        items = new String[]{"幼托儿童", "散居儿童", "学生（大中小学）", "教师", "保育员及保姆", "餐饮食品业", "商业服务", "医务人员", "工人", "民工", "农民", "牧民",
                "渔(船)民", "干部职员", "离退人员", "家务或待业", "其他", "不详"};
        result = "";
        for (String s : items) {
            result += (s.equals(infectious.get("occupation")) ? check : uncheck) + s + "  ";
            if ("其他".equals(s))
                result += "（" + infectious.get("occupationElse") + "）  ";
        }
        infectious.put("occupation", result);

        items = new String[]{"岁", "月", "天"};
        result = "";
        for (String s : items)
            result += (s.equals(infectious.get("ageUnit")) ? check : uncheck) + s + "  ";
        infectious.put("ageUnit", result);

        items = new String[]{"疑似病例", "临床诊断病例", "实验室确诊病例", "病原携带者", "急性", "慢性（乙型肝炎、血吸虫、丙型肝炎填写）"};
        result = "（1）";
        for (int i = 0; i < items.length; i++) {
            result += ((((Integer) infectious.get("caseClass")) & (int) Math.pow(2, i)) > 0 ? check : uncheck) + items[i] + "    ";
            if (i == 2)
                result += "\n（2）";
        }
        infectious.put("caseClass", result);


        items = new String[]{"鼠疫", "霍乱"};
        result = "";
        for (String s : items)
            result += (s.equals(infectious.get("infectiousName")) ? check : uncheck) + s + "  ";
        infectious.put("classA", result);

        HashMap<String, String[]> subInfect = new HashMap<>();
        items = new String[]{"HIV阳性", "艾滋病"};
        subInfect.put("艾滋病", items);
        items = new String[]{"Ⅰ期", "Ⅱ期", "Ⅲ期", "胎传", "隐性"};
        subInfect.put("梅毒", items);
        items = new String[]{"涂阳", "菌阴", "未痰检", "仅培阳"};
        subInfect.put("肺结核", items);
        items = new String[]{"伤寒", "副伤寒"};
        subInfect.put("伤寒", items);
        items = new String[]{"细菌性", "阿米巴性"};
        subInfect.put("痢疾", items);
        items = new String[]{"肺炭疽", "皮肤炭疽", "未分型"};
        subInfect.put("炭疽", items);
        items = new String[]{"间日疟", "恶性疟", "未分型"};
        subInfect.put("疟疾", items);
        items = new String[]{"甲型", "乙型", "丙型", "戊型", "未分型"};
        subInfect.put("病毒性肝炎", items);
        items = new String[]{"传染性非典型肺炎", "艾滋病", "病毒性肝炎",
                "脊髓灰质炎", "人感染高致病性禽流感", "麻疹", "流行性出血热", "狂犬病", "流行性乙型脑炎", "登革热", "炭疽", "痢疾",
                "肺结核", "伤寒", "流行性脑脊髓膜炎", "百日咳", "白喉", "新生儿破伤风", "猩红热",
                "布鲁氏菌病", "淋病", "梅毒", "钩端螺旋体病",
                "血吸虫病", "疟疾", "人感染H7N9禽流感"};
        result = "";
        String[] infectNameArray = ((String) infectious.get("infectiousName")).split("-");

        for (String firstName : items) {
            if (subInfect.get(firstName) != null) {
                String secondName = "：（";
                String[] subInfectious = subInfect.get(firstName);
                for (String s2 : subInfectious)
                    secondName += (infectNameArray.length == 2 && s2.equals(infectNameArray[1]) ? check : uncheck) + s2 + "  ";
                secondName += "）  ";
                result += firstName + secondName;
            } else
                result += (infectNameArray.length > 0 && firstName.equals(infectNameArray[0]) ? check : uncheck) + firstName + "   ";
        }
        infectious.put("classB", result + "     ");

        items = new String[]{"流行性感冒", "流行性腮腺炎", "风疹", "急性出血结膜炎", "麻风病", "流行性和地方性斑疹伤寒", "黑热病", "包虫病", "丝虫病",
                "除霍乱、细菌性和阿米巴性痢疾、伤寒和副伤寒以外的感染性腹泻病", "手足口病"};
        result = "";
        for (String s : items)
            result += (s.equals(infectious.get("infectiousName")) ? check : uncheck) + s + "  ";
        infectious.put("classC", result);

        items = new String[]{"非淋菌性尿道炎", "尖锐湿疣", "生殖器疱疹", "水痘", "肝吸虫病", "生殖道沙眼衣原体感染", "恙虫病", "森林脑炎", "结核性胸膜炎", "人感染猪链球菌病", "人粒细胞无形体病",
                "不明原因肺炎", "发热伴血小板减少综合症", "中东呼吸综合症", "埃博拉出血热", "寨卡病毒病", "AFP", "其它"};
        result = "";
        for (String s : items)
            result += (s.equals(infectious.get("infectiousName")) ? check : uncheck) + s + "  ";
        infectious.put("classD", result);


        list.add(infectious);

        JasperPrint print = JasperFillManager.fillReport(jasperReport, parameters1, new JRBeanCollectionDataSource(list));
        return print;
    }

    @RequestMapping(value = "getInfectiousPDF", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public void getInfectiousPDF(@RequestParam Integer infectiousID, HttpServletRequest request, HttpServletResponse response) {
        HashMap<String, Object> infectious = infectiousDao.getInfectious(infectiousID);
        try {
            JasperPrint print = getInfectiousJasperPrint(infectious);

            request.setCharacterEncoding("UTF-8");
            response.setContentType("application/pdf");
            response.setHeader("Content-disposition", "attachment; filename=" + new String((StringUtils.trim((String) infectious.get("patientName")) + ".pdf").getBytes(), "ISO8859-1"));
            ServletOutputStream outputStream = response.getOutputStream();
            //輸出PDF
            JasperExportManager.exportReportToPdfStream(print, outputStream);

            outputStream.flush();
            outputStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @ResponseBody
    @RequestMapping(value = "getContagion", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getContagion(@RequestParam Integer contagionID) {
        Map<String, Object> modelMap = new HashMap<>();

        HashMap contagion = infectiousDao.getContagion(contagionID);

        modelMap.put("success", true);
        modelMap.put("contagion", contagion);

        return gson.toJson(modelMap);
    }

    //todo 分页
    @ResponseBody
    @RequestMapping(value = "getContagionList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getContagionList(@RequestParam(value = "fromDate", required = false) String fromDate,
                                   @RequestParam(value = "toDate", required = false) String toDate,
                                   @RequestParam(value = "queryField", required = false) String queryField,
                                   @RequestParam(value = "start", required = false, defaultValue = "0") int start,
                                   @RequestParam(value = "limit", required = false, defaultValue = "100") int limit,
                                   @RequestParam(value = "workflowState", required = false, defaultValue = "-1") int workflowState,
                                   HttpSession session) {
        // Map<String, Object> modelMap = new HashMap<>();
        Map<String, Object> param = new HashMap<>();
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            UserDetails ud = (UserDetails) principal;

            if (!ud.getAuthorities().contains(new SimpleGrantedAuthority("INFECTIOUS")) &&
                    !ud.getAuthorities().contains(new SimpleGrantedAuthority("protect"))) {
                param.put("doctorUserID", ud.getUsername());
            }
           /* if (!role.getRoleNo().equals("infectious") && !role.getRoleNo().equals("protect"))
                param.put("doctorUserID", authToken.getUserID());*/
            else
                param.put("notWorkflow", 0);//新建编辑的，管理员不看

            param.put("queryField", queryField);
            param.put("workflowState", workflowState);
            param.put("fromDate", fromDate);
            param.put("toDate", DateUtils.nextDaySqlStr(toDate));
            /*param.put("limit", limit);
            param.put("start", start);*/

            List<Contagion> infectiousList = infectiousDao.getContagionList(param);

            return wrap(infectiousList);
           /* modelMap.put("success", true);
            modelMap.put("totalCount", infectiousList.size());
            modelMap.put("contagion", infectiousList.subList(start, Math.min(start + limit, infectiousList.size())));*/

        }

        return wrap(new ArrayList());
        //return gson.toJson(modelMap);
    }

    @ResponseBody
    @RequestMapping(value = "setWorkflow", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String setWorkflow(@RequestParam Integer objectID, @RequestParam String objectType, @RequestParam Integer workflow, @RequestParam String flowNote) {
        Map<String, Object> modelMap = new HashMap<>();
        int affectedRow;
        String[] arr = infectiousDao.getWorkflowChn();
        logger.debug("flowNote=" + flowNote);
        if ("infectious".equals(objectType)) {
            Infectious infect = new Infectious();
            infect.setInfectiousID(objectID);
            infect.setWorkflow(workflow);
            infect.setWorkflowNote(flowNote);
            affectedRow = infectiousDao.saveInfectious(infect);

            modelMap.put("success", affectedRow > 0);
            if (affectedRow > 0)
                modelMap.put("message", "传染病报告卡已 " + arr[workflow % 10] + " 。");
            else
                modelMap.put("message", "传染病报告卡 " + arr[workflow % 10] + " 失败。");
        } else {
            Contagion contagion = new Contagion();
            contagion.setContagionID(objectID);
            contagion.setWorkflow(workflow);
            contagion.setWorkflowNote(flowNote);
            affectedRow = infectiousDao.saveContagion(contagion);

            modelMap.put("success", affectedRow > 0);
            if (affectedRow > 0)
                modelMap.put("message", "感染病例报告卡已 " + arr[workflow % 10] + " 。");
            else
                modelMap.put("message", "感染病例报告卡 " + arr[workflow % 10] + " 失败。");
        }

        return gson.toJson(modelMap);
    }

    @ResponseBody
    @RequestMapping(value = "saveInfectious", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String saveInfectious(@RequestBody Infectious infectious) {
        logger.debug("saveInfectious");
        Map<String, Object> modelMap = new HashMap<>();
        try {
            if (infectious.getWorkflow() % 10 == 2) infectious.setWorkflow(infectious.getWorkflow() + 8);
            boolean saveResult = infectiousDao.saveInfectious(infectious) > 0;

            if (saveResult) {
                //保存诊断
                infectiousDao.saveInfectious(infectious);

                modelMap.put("message", "传染病报告卡已保存。");
                modelMap.put("success", true);
            } else
                modelMap.put("message", "传染病报告卡保存失败。");
        } catch (Exception e) {
            e.printStackTrace();
            modelMap.put("success", false);
            modelMap.put("message", e.toString());
        }

        modelMap.put("infectious", infectious);

        return gson.toJson(modelMap);
    }

    @ResponseBody
    @RequestMapping(value = "saveContagion", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String saveContagion(@RequestBody Contagion contagion) {
        Map<String, Object> modelMap = new HashMap<>();
        try {
            if (contagion.getWorkflow() % 10 == 2) contagion.setWorkflow(contagion.getWorkflow() + 8);
            boolean saveResult = infectiousDao.saveContagion(contagion) > 0;

            if (saveResult) {
                //保存诊断
                infectiousDao.saveContagion(contagion);

                modelMap.put("message", "感染病例报告卡已保存。");
                modelMap.put("success", true);
            } else
                modelMap.put("message", "感染病例报告卡保存失败。");
        } catch (Exception e) {
            e.printStackTrace();
            modelMap.put("success", false);
            modelMap.put("message", e.toString());
        }

        modelMap.put("contagion", contagion);
        Gson gson = new GsonBuilder().create();
        return gson.toJson(modelMap);
    }

    @ResponseBody
    @RequestMapping(value = "deleteInfectious", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String deleteInfectious(@RequestParam Integer infectiousID) {
        Map<String, Object> modelMap = new HashMap<>();

        try {
            int succeed = infectiousDao.deleteInfectious(infectiousID);
            modelMap.put("success", succeed > 0);
        } catch (Exception e) {
            e.printStackTrace();
            modelMap.put("success", false);
            modelMap.put("message", e.toString());
        }

        return gson.toJson(modelMap);
    }

    @ResponseBody
    @RequestMapping(value = "deleteContagion", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String deleteContagion(@RequestParam Integer contagionID) {
        Map<String, Object> modelMap = new HashMap<>();

        try {
            int succeed = infectiousDao.deleteContagion(contagionID);
            modelMap.put("success", succeed > 0);
        } catch (Exception e) {
            e.printStackTrace();
            modelMap.put("success", false);
            modelMap.put("message", e.toString());
        }

        return gson.toJson(modelMap);
    }

    @ResponseBody
    @RequestMapping(value = "getPatientInfo", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getPatientInfo(@RequestParam int patientID) {
        Map<String, Object> modelMap = new HashMap<>();

        Map<String, Object> info = patientInfoDao.getPatientInfo(patientID);

        modelMap.put("success", info != null);
        modelMap.put("patientInfo", info);

        return gson.toJson(modelMap);
    }

    @ResponseBody
    @RequestMapping(value = "getClinicPatient", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getClinicPatient(@RequestParam String queryItem, @RequestParam String queryField, @RequestParam String timeFrom, @RequestParam String timeTo) {
        System.out.println("getClinicPatient");
        Map<String, Object> modelMap = new HashMap<>();
        Gson gson = new GsonBuilder().create();
        List<Map<String, Object>> results = patientInfoDao.getClinicPatient(queryItem, queryField, timeFrom, timeTo);

        // modelMap.put("success", true);
        modelMap.put("data", results);
        modelMap.put("iTotalRecords", results.size());
        modelMap.put("iTotalDisplayRecords", results.size());

        return gson.toJson(modelMap);
    }

    @ResponseBody
    @RequestMapping(value = "getHospitalPatient", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getHospitalPatient(@RequestParam String queryItem, @RequestParam String queryField, @RequestParam String timeFrom, @RequestParam String timeTo) {
        logger.debug("getHospitalPatient:");

        Map<String, Object> modelMap = new HashMap<>();

        List<Map<String, Object>> results = patientInfoDao.getHospitalPatient(queryItem, queryField, timeFrom, timeTo);

        //  modelMap.put("success", true);
        modelMap.put("data", results);
        modelMap.put("iTotalRecords", results.size());
        modelMap.put("iTotalDisplayRecords", results.size());

        return gson.toJson(modelMap);
    }

}
