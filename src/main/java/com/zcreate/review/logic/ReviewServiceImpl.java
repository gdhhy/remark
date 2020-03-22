package com.zcreate.review.logic;

import com.zcreate.common.DictService;
import com.zcreate.review.dao.*;
import com.zcreate.review.model.*;
import com.zcreate.util.DateUtils;
import com.zcreate.util.StringUtils;
import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;

import java.util.*;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-1-17
 * Time: 上午11:18
 */
public class ReviewServiceImpl implements ReviewService {
    static Logger logger = Logger.getLogger(ReviewServiceImpl.class);
    private static ClinicDAO clinicDao;
    private static InPatientDAO inPatientDao;
    private static SampleDAO sampleDao;
    private static IncompatibilityDAO incompatibilityDAO;
    private DictService dictService;

    public ReviewServiceImpl() {
    }

    public ReviewServiceImpl(SqlSessionTemplate sqlMapClient) {
        ClinicDAOImpl clinicDao = new ClinicDAOImpl();
        clinicDao.setSqlSessionTemplate(sqlMapClient);
        ReviewServiceImpl.clinicDao = clinicDao;

        InPatientDAOImpl inPatientDAO = new InPatientDAOImpl();
        inPatientDAO.setSqlSessionTemplate(sqlMapClient);
        ReviewServiceImpl.inPatientDao = inPatientDAO;

        SampleDAOImpl sampleDao = new SampleDAOImpl();
        sampleDao.setSqlSessionTemplate(sqlMapClient);
        ReviewServiceImpl.sampleDao = sampleDao;

        IncompatibilityDAOImpl incompatibilityDAO = new IncompatibilityDAOImpl();
        incompatibilityDAO.setSqlSessionTemplate(sqlMapClient);
        ReviewServiceImpl.incompatibilityDAO = incompatibilityDAO;

    }

    public InPatient getInPatient(int inPatientID,int reviewType) {
        InPatient inPatient = inPatientDao.getInPatient(inPatientID,reviewType);

        InPatientReview review = inPatient.getReview();
        if (review == null) {
            // System.out.println("----------review is null  ");
            review = new InPatientReview();
            review.setReviewJson("{}");
            review.setHospID(inPatient.getHospID());
            //设置手术信息
           /* if (inPatient.getSurgerys().size() > 0) {
                review.setSurgeryName((String) inPatient.getSurgerys().get(0).get("surgeryName"));
                review.setSurgeryDate(DateUtils.formatSqlDateTime((Timestamp) inPatient.getSurgerys().get(0).get("surgeryDate")));
                review.setIncision((String) inPatient.getSurgerys().get(0).get("incision"));
            }*/
            //微生物送检 todo 药师提出名字优化 能写在sql吗？ 少一次读数据库
           /* List<AdviceItem> germItem = inPatientDao.getAdviceItemWithGerm(inPatient.gethospID());
            if (germItem.size() > 0) {
                review.setGermCheck(1);
                review.setCheckDate(DateUtils.formatSqlDateTime(germItem.get(0).getInPatientDate()));
                review.setSample(germItem.get(0).getAdvice());
            }*/
            HashMap<String, Object> param = new HashMap<>();
            param.put("hospID", inPatient.getHospID());
            param.put("AdviceItemTable", "AdviceItem_" + inPatient.getYear());
            //寻找配伍禁忌药品
            List<HashMap<String, Object>> incompatiMap = incompatibilityDAO.queryByhospID(param);
            HashMap<Integer, String> resultMap = new HashMap<Integer, String>();
            for (HashMap aMap : incompatiMap) {
                String result = aMap.get("medicineName1") + " + " + aMap.get("medicineName2") + " : " + aMap.get("result");
                resultMap.put((Integer) aMap.get("incompatibilityID"), result);//过滤重复ID的
            }
            String result = "";
            Iterator<String> iter = resultMap.values().iterator();
            while (iter.hasNext()) {
                result += iter.next();
                if (iter.hasNext())
                    result += "；";
            }
            review.setReview(result);

            //完毕，填充回来
            inPatient.setReview(review);
        } else {
            if (review.getReviewJson() == null || "".equals(review.getReviewJson()))
                review.setReviewJson("{}");
        }

        return inPatient;
    }

    /**
     * 取门诊处方去点评
     *
     * @param clinicID
     * @return
     */
    public Clinic getClinic(int clinicID) {

        Clinic clinic = clinicDao.getClinic(clinicID);

        List<RxDetail> details = clinic.getDetails();
        //拼凑1、(1)
        //       (2)
        int num1 = 1;
        int num2 = 1;
        if (details.size() > 0) {
            details.get(0).setNum1("1、");
            details.get(0).setNum2("(1)");
            for (int i = 1; i < details.size(); i++) {
                if (details.get(i).getGroupID().equals(details.get(i - 1).getGroupID())) {
                    if (!"+".equals(details.get(i).getGoodsID()))
                        details.get(i).setNum2("(" + ++num2 + ")");
                } else {
                    details.get(i).setNum1(++num1 + "、");
                    details.get(i).setNum2("(1)");
                    num2 = 1;
                }
            }
        }

        //寻找配伍禁忌药品
        String result = "";
        //标记配伍禁忌药品，显示为红色
        for (HashMap aMap : clinic.getIncompatibilitys()) {
            if (!"".equals(result)) result += "\n";
            result += aMap.get("medicineName1") + " + " + aMap.get("medicineName2") + " : " + aMap.get("result");

            for (RxDetail detail : clinic.getDetails()) {
                if (detail.getRxDetailID().equals(aMap.get("itemID1")) || detail.getRxDetailID().equals(aMap.get("itemID2"))) {
                    //logger.debug("incompatibility:" + detail.getMedicineNo());
                    detail.setIncompatibility(Boolean.TRUE);
                    detail.setTaboo(aMap.get("medicineName1") + " + " + aMap.get("medicineName2") + " : " + aMap.get("result"));
                }
            }
        }
        if ("".equals(clinic.getResult()) || clinic.getResult() == null)
            clinic.setResult(result);

        return clinic;
    }

    /*public int getObjectCount(int type, int year, int month, String department, String doctorNo, int western) {
        logger.debug("getRxCount(),department=" + department);
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("type", type);
        param.put("doctor", doctorNo);
        *//*if (western >= 0) *//*//取值：西药1， 中药，0，-1不限
        param.put("western", western);
        if (!"全部".equals(department))
            param.put("department", department);

        if (year > 0 && month <= 0)  //只选择年份，月份为空
            param.put("year", year);

        if (type == 1) {
            if (year > 0 && month > 0) {
                Calendar cal = DateUtils.parseCalendarDayFormat(year + "-" + month + "-01");
                param.put("clinicDateFrom", ((Calendar) cal.clone()).getTime());

                cal.add(Calendar.MONTH, 1);
                param.put("clinicDateTo", cal.getTime());
            }

            return clinicDao.getClinicCount(param);
        } else {
            if (year > 0 && month > 0) {
                Calendar cal = DateUtils.parseCalendarDayFormat(year + "-" + month + "-01");
                param.put("inPatientDateFrom", ((Calendar) cal.clone()).getTime());

                cal.add(Calendar.MONTH, 1);
                param.put("inPatientDateTo", cal.getTime());
            }
            return inPatientDao.getInPatientCount(param);
        }
    }*/

    public int getObjectCount(int type, String fromDate, String toDate, int clinicType, String department, String doctorNo, int western, String medicineNo, int special, int incision) {
        logger.debug("getRxCount(),special=" + special + "medicineNo=" + medicineNo);
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("type", type);
        param.put("doctor", doctorNo);
        /*if (western >= 0) *///取值：西药1， 中药，0，-1不限
        param.put("western", western);
        param.put("clinicType", clinicType);
        param.put("medicine1", medicineNo);
        //if (incision)
        param.put("incision", incision);
        param.put("special", special);

        if (!"全部".equals(department))
            param.put("department", department);
        Calendar toCal = DateUtils.parseCalendarDayFormat(toDate);
        toCal.add(Calendar.DATE, 1);
        if (type == 1) {
            param.put("clinicDateFrom", DateUtils.parseSqlDate(fromDate));
            param.put("clinicDateTo", toCal.getTime());
            return clinicDao.getClinicCount(param);
        } else {
            param.put("outDateFrom", DateUtils.parseSqlDate(fromDate));
            param.put("AdviceItemTable", "AdviceItem_" + fromDate.substring(0, 4));
            param.put("outDateTo", toCal.getTime());
            //param.put("outHospital", true);
            return inPatientDao.getInPatientCount(param);
        }
    }

    public boolean saveClinic(Clinic clinic) {
        return clinicDao.save(clinic) == 1;
    }

    public boolean saveInPatient(InPatient inPatient) {
        return inPatientDao.save(inPatient) == 1;
    }

    /*   public void setRxDao(RxDAO clinicDao) {
        //  logger.debug("setRxDao");
        ReviewServiceImpl.clinicDao = clinicDao;
    }

    public void setInPatientDao(InPatientDAO inPatientDao) {
        //  logger.debug("setRxDao");
        ReviewServiceImpl.inPatientDao = inPatientDao;
    }*/


    public List<Integer> createSampling(SampleBatch sampleBatch) {
        Map<String, Object> param = new HashMap<>();
        param.put("type", sampleBatch.getType());
        param.put("department", sampleBatch.getDepartment());
        param.put("doctorID", sampleBatch.getDoctorID());
        if (sampleBatch.getWestern() != null && sampleBatch.getWestern() >= 0)
            param.put("western", sampleBatch.getWestern());
        param.put("limit", sampleBatch.getNum());
        param.put("year", sampleBatch.getYear());
        param.put("month", sampleBatch.getMonth());
        param.put("clinicType", sampleBatch.getClinicType());
        param.put("medicine1", sampleBatch.getGoodsID());
        param.put("special", sampleBatch.getSpecial());
        param.put("surgery", sampleBatch.getSurgery());
        param.put("incision", sampleBatch.getIncision());
        param.put("atLeastMoney", 0);

        Calendar toCal = (Calendar) DateUtils.parseCalendarFormat(sampleBatch.getToDate(), "yyyy年MM月dd日").clone();
        toCal.add(Calendar.DATE, 1);

        param.put("clinicDateFrom", DateUtils.formatSqlDate(DateUtils.parseDateFormat(sampleBatch.getFromDate(), "yyyy年MM月dd日")));//varchar
        param.put("clinicDateTo", toCal.getTime());//timestamp

        if (sampleBatch.getType() == 1)//门诊抽样
            if (sampleBatch.getSampleType() == 1)//随机
                return clinicDao.getRandomClinicID(param);
            else {
                //不调用存储过程，效率低
                //先产生等差随机数列
                param.put("RxDetailTable", "RxDetail_" + param.get("clinicDateFrom").toString().substring(0, 4));
                int array[] = linearArray(clinicDao.getClinicCount(param), sampleBatch.getNum());
                List<Integer> clinicIDs = clinicDao.selectClinicIDForLinear(param);
                List<Integer> result = new ArrayList<Integer>(array.length);
                for (int index : array)
                    if (index < clinicIDs.size())
                        result.add(clinicIDs.get(index));
                return result;
            }
        else {   //住院
            param.put("outDateFrom", param.get("clinicDateFrom"));
            param.put("AdviceItemTable", "AdviceItem_" + param.get("clinicDateFrom").toString().substring(0, 4));
            param.put("outDateTo", param.get("clinicDateTo"));
            //param.put("outHospital", true);
            if (sampleBatch.getSampleType() == 1)//随机
                return inPatientDao.getRandomInPatientID(param);
            else {//等差
                //不调用存储过程，效率低
                // 先产生等差随机数列
                int array[] = linearArray(inPatientDao.getInPatientCount(param), sampleBatch.getNum());
                List<Integer> inPatientIDs = inPatientDao.selectInPatientIDForLinear(param);
                List<Integer> result = new ArrayList<Integer>(array.length);
                for (int index : array)
                    if (index < inPatientIDs.size())
                        result.add(inPatientIDs.get(index));
                return result;
                //return inPatientDao.getLinearInPatientID(param);
            }
        }
    }

    private int[] linearArray(int total, int result) {
        if (result > total) result = total;
        int array[] = new int[result];
        double step = total * 1.0 / result;  //step 最小为1
        for (int i = 0; i < result; i++) {
            int target = (int) Math.floor(i * step + step * Math.random());

            if (target > (i + 1) * step) target = (int) Math.floor(i * step); //修正
            else if (target < i * step) target = (int) Math.ceil(i * step);

            array[i] = target;
        }
        return array;
    }

    public static void main(String[] args) {
        int[] a = new ReviewServiceImpl().linearArray(100, 100);
        for (int i : a)
            System.out.print("," + i);
    }

    public List getObjectByIDs(List<Integer> ids, int type) {
        if (type == 1)
            return clinicDao.getClinicByIDList(ids);
        else
            return inPatientDao.getInPatientByIDList(ids);
    }


    public List getClinicList(Map<String, Object> param) {
        if (param.get("atLeastMoney") == null || (Integer) param.get("start") > 0)
            param.put("orderField", "clinicID");
        else
            param.put("orderField", "money");
        return clinicDao.getClinicList(param);
    }

    public List getInPatientList(Map<String, Object> param) {
        if (param.get("atLeastMoney") == null || (Integer) param.get("start") > 0)
            param.put("orderField", "inPatientID");
        else
            param.put("orderField", "money");
        //param.put("outHospital", true); 应新丰要求，未出院的可以选择填写传染病报告，备注掉
        return inPatientDao.getInPatientList(param);
    }

    public List<HashMap<String, Object>> getInPatientListForExcel(Map<String, Object> param) {
        return inPatientDao.getInPatientListForExcel(param);
    }

    public List<HashMap<String, Object>> getAdviceItemForExcel(Integer hospID, int medicineType) {
        Map<String, Object> param = new HashMap<String, Object>(2);
        param.put("hospID", hospID);
        if (medicineType == 1)
            param.put("chineseInjection", 1);
        else
            param.put("antiClass", 1);
        return inPatientDao.getAdviceItemForExcel(param);
    }

    /*public int getClinicCount(Map<String, Object> param) {
        return clinicDao.getClinicCount(param);
    }*/

   /* public int getInPatientCount(Map<String, Object> param) {
        return inPatientDao.getInPatientCount(param);
    }*/

    /*  public static void setSampleDao(SampleDAO sampleDao) {
        ReviewServiceImpl.sampleDao = sampleDao;
    }*/
    @SuppressWarnings("unchecked")
    public int doSaveSampling(SampleBatch sampleBatch, List<Integer> ids) {
//        sampleBatch.setSampleNo(sampleBatch.getYear() + "-" + (sampleBatch.getMonth() != null ? sampleBatch.getMonth() : "") + (sampleBatch.getType() == 1 ? "-MZ-" : "-ZY-") + sampleBatch.getName());
        sampleDao.insert(sampleBatch);
        //logger.debug("sampleBatchID="+sampleBatch.getSampleBatchID());
        List objects = getObjectByIDs(ids, sampleBatch.getType());
        if (sampleBatch.getType() == 1)
            for (Object clinic : objects) {
                dealClinicIntoSample((Clinic) clinic, sampleBatch);
            }
        else for (Object inPatient : objects) {
            dealInPatientIntoSample((InPatient) inPatient, sampleBatch);
        }
        return objects.size();
    }

    //在已保存抽样临时增加处方
    @SuppressWarnings("unchecked")
    public int addSampleToBatch(SampleBatch sampleBatch, String clinicIDs) {
        int[] ints = StringUtils.splitToInts(clinicIDs, ",");
        List<Integer> lists = new ArrayList<Integer>(ints.length);
        for (int i : ints) lists.add(i);
        int succeedCount = 0;
        List objectIds = getObjectByIDs(lists, sampleBatch.getType());
        List<HashMap<String, Object>> detailList = sampleDao.getSampleList(sampleBatch.getSampleBatchID(), sampleBatch.getType(), 0, sampleBatch.getNum());
        if (sampleBatch.getType() == 1)
            for (Object rx : objectIds) {
                boolean exist = false;
                for (HashMap<String, Object> detail : detailList) {
                    if (detail.get("clinicID").equals(((Clinic) rx).getClinicID())) {
                        //if (detail.gethospID().equals(clinic.gethospID()) && detail.getPrescribeDate().equals(clinic.getPrescribeDate())) {
                        exist = true;
                        break;
                    }
                }

                if (!exist) {
                    dealClinicIntoSample((Clinic) rx, sampleBatch);
                    succeedCount++;
                }
            }
        else
            for (Object rx : objectIds) {
                boolean exist = false;
                for (HashMap<String, Object> detail : detailList) {
                    if (detail.get("inPatientID").equals(((InPatient) rx).getInPatientID())) {
                        //if (detail.gethospID().equals(clinic.gethospID()) && detail.getPrescribeDate().equals(clinic.getPrescribeDate())) {
                        exist = true;
                        break;
                    }
                }

                if (!exist) {
                    dealInPatientIntoSample((InPatient) rx, sampleBatch);
                    succeedCount++;
                }
            }
        return succeedCount;
    }

    private void dealInPatientIntoSample(InPatient inPatient, SampleBatch sampleBatch) {
        SampleList sample = new SampleList();
        sample.setObjectID(inPatient.getInPatientID());
        sample.setSampleBatchID(sampleBatch.getSampleBatchID());
        sampleDao.insertSampleDetail(sample);
    }

    /**
     * 抽样入库，同时自动判断几个不合理项目
     */
    private void dealClinicIntoSample(Clinic clinic, SampleBatch sampleBatch) {
        SampleList sample = new SampleList();
        sample.setObjectID(clinic.getClinicID());
        sample.setSampleBatchID(sampleBatch.getSampleBatchID());
        sampleDao.insertSampleDetail(sample);
    }

    public HashMap<String, Object> analyseClinic(int clinicID) {
        Clinic clinic = clinicDao.getClinic(clinicID);
        return analyseClinic(clinic);
    }

    public HashMap<String, Object> analyseClinic(Clinic clinic) {
        HashMap<String, Object> analyseResult = new HashMap<String, Object>(3);
        List<String> disItem = new ArrayList<String>(5);
        if (!"".equals(clinic.getDoctorName()) && !"".equals(clinic.getConfirmName()) && !"".equals(clinic.getApothecaryName()))
            clinic.setRational(1);
        else {
            clinic.setRational(0);
            disItem.add("1-3");//药师未对处方进行适宜性审核的（处方后记的审核、调配、核对、发药栏目无审核调配药师及核对发药药师签名，或者单人值班调剂未执行双签名规定）；
        }

        if (clinic.getDrugNum() > 5 && clinic.getWestern() == 1) {
            disItem.add("1-11");//单张门急诊处方超过五种药品的；
            clinic.setRational(0);
        }
        analyseResult.put("disItem", disItem);

        return analyseResult;
    }

    public int doDeleteSampleBatch(int sampleBatchID) {
        int deleteDetailCount = sampleDao.deleteDetailBySampleBatchID(sampleBatchID);
        deleteDetailCount += sampleDao.deleteByPrimaryKey(sampleBatchID);
        return deleteDetailCount;
    }

    public boolean publishClinic(int clinicID, int publishType) {
        Clinic clinic = new Clinic();
        clinic.setClinicID(clinicID);
        clinic.setPublish(publishType);

        Map<String, Object> param = new HashMap<String, Object>();
        param.put("type", 1);
        param.put("objectID", clinicID);

        return clinicDao.save(clinic) == 1 && (publishType != 2 || clinicDao.publish(param));
    }

    public boolean publishInPatient(int inPatientID, int publishType) {
        InPatient inPatient = new InPatient();
        inPatient.setInPatientID(inPatientID);
        inPatient.setPublish(publishType);

        Map<String, Object> param = new HashMap<String, Object>();
        param.put("type", 2);
        param.put("objectID", inPatientID);

        return inPatientDao.save(inPatient) == 1 && (publishType != 2 || clinicDao.publish(param));
    }

    public boolean saveInPatientReview(InPatientReview review) {
        return inPatientDao.saveInPatientReview(review) > 0;
    }

    /* public InPatientReview getInPatientReview(int inPatientID) {
        return inPatientDao.getInPatientReview(inPatientID);
    }*/
/*
    public List<Course> getCourse(Integer hospID) {
        return hisDao.getCourse(hospID);
    }

    public History getHistory(Integer hospID) {
        return hisDao.getHistory(hospID);
    }*/

    public List<AdviceItem> getAdviceItemList(Integer hospID, int longAdvice, String year) {
        Map<String, Object> param = new HashMap<>();
        param.put("hospID", hospID);
        param.put("longAdvice", longAdvice);
        param.put("AdviceItemTable", "AdviceItem_" + year);
        List<AdviceItem> inPatientItemList = inPatientDao.getAdviceItemList(param);
        for (int i = 1; i < inPatientItemList.size(); i++) {
            if (inPatientItemList.get(i).getGroupID().equals(inPatientItemList.get(i - 1).getGroupID())) {
                inPatientItemList.get(i).setAdviceDate(null);
            }
        }
        List<HashMap<String, Object>> map = incompatibilityDAO.queryByhospID(param);
        //标记配伍禁忌药品，显示为红色
        for (HashMap aMap : map)
            for (AdviceItem item : inPatientItemList) {
                if (aMap.get("itemID1").equals(item.getAdviceItemID()) || aMap.get("itemID2").equals(item.getAdviceItemID())) {
                    item.setIncompatibility(Boolean.TRUE);
                    item.setTaboo(aMap.get("medicineName1") + " + " + aMap.get("medicineName2") + " : " + aMap.get("result"));
                }
            }
        return inPatientItemList;
    }

    public int saveDiagnosis(Integer hospID, String diagnosisNos, String diseases) {
        String[] diagnosisNoArr = diagnosisNos.split(";");
        String[] diseaseArr = diseases.split(";");
        if (diagnosisNoArr.length == diseaseArr.length && diseaseArr.length > 0) {
            List<Map> diagnosisList = new ArrayList<Map>(diseaseArr.length);
            for (int i = 0; i < diseaseArr.length; i++) {
                HashMap<String, Object> map = new HashMap<String, Object>();
                map.put("hospID", hospID);
                map.put("type", diagnosisNoArr[i].indexOf("_0") > 0 ? 0 : 1);
                map.put("diagnosisNo", diagnosisNoArr[i]);
                map.put("disease", diseaseArr[i]);
                map.put("choose", 1);

                diagnosisList.add(map);
            }
            inPatientDao.deleteDiagnosis(hospID, 1);
            return inPatientDao.saveDiagnosis(diagnosisList);
        }
        return 0;
    }

    public List<HashMap<String, Object>> getLastReview(int topRecount) {
        return sampleDao.getLastReview(topRecount);
    }

    public List<HashMap<String, Object>> getLastReviewByDoctor(int topRecount) {
        return sampleDao.getLastReviewByDoctor(topRecount);
    }

    public int getSurgeryCount(Integer hospID) {
        return inPatientDao.getSurgeryCount(hospID);
    }

    public List<HashMap<String, Object>> getAdviceItemCount(Integer hospID) {
        return inPatientDao.getAdviceItemCount(hospID);
    }

    /* public int saveChooseDiagnosis(Integer hospID, int[] ids) {
        List<Integer> list = new ArrayList<Integer>(ids.length);
        for (int i : ids) list.add(i);
        return inPatientDao.saveChooseDiagnosis(hospID, list);
    }*/

    public DictService getDictService() {
        return dictService;
    }

    public void setDictService(DictService dictService) {
        this.dictService = dictService;
    }
    /* public List<HashMap<String, Object>> getSurgeryList(Integer hospID) {
        return inPatientDao.getSurgeryList(hospID);
    }*/
}
