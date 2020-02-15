package com.zcreate.review.logic;

import ChartDirector.XYChart;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 12-2-4
 * Time: 上午12:19
 */
public interface StatService {
    HashMap<String, Object> summary(String fromDate, String toDate, String department, int type, int table);

    List<HashMap<String, Object>> global(String fromDate, String toDate, String department);

    List<HashMap<String, Object>> healthAnalysis(String fromDate, String toDate, String healthNo, String department, int type);

    List<HashMap<String, Object>> getMedicineByHealthNo(String fromDate, String toDate, String healthNo, String department, int type);

    List<HashMap<String, Object>> byMedicine( String fromDate, String toDate, String healthNo, Integer goodsID, String department, int type, boolean top3, String special,int start, int limit);

    List<HashMap<String, Object>> statMedicineGroupByDepart(String fromDate, String toDate, String medicineNo, String department, int type);

    List<HashMap<String, Object>> getDoctorListByMedicine(String fromDate, String toDate, String medicineNo, String department, boolean viewDoctorNum);

    XYChart statMedicineGroupByDate(int chartWidth, int chartHeight, String fromDate, String toDate, String medicineNo, String department, String doctorName, int type);

    XYChart statMedicineGroupByMonth(int chartWidth, int chartHeight, String medicineNo, String department, String doctorName);

    XYChart statMultiMedicineGroupByDate(int chartWidth, int chartHeight, String fromDate, String toDate, String medicineNos, String department, int type);

    List<HashMap<String, Object>> statByDose(int start, int limit, String fromDate, String toDate, String healthNo, String department, int type);

    XYChart doseTrend(int chartWidth, int chartHeight, String fromDate, String toDate, String dose, String healthNo, String department, int type);

    //List<HashMap<String, Object>> byDepart(String fromDate, String toDate, int type, String healthNo, String medicineNo);

    List<HashMap<String, Object>> antiByDepart(String fromDate, String toDate, int antiClass, String medicineNo);

    List<HashMap<String, Object>> getDepartDetail(String fromDate, String toDate, String depart, int type, String healthNo, int antiClass);

    List<HashMap<String, Object>> getMedicineListByDoctor(String fromDate, String toDate, String department, String doctorName, int type, int antiClass, boolean hasViewProp);

    List<HashMap<String, Object>> getBaseListByDoctor(String fromDate, String toDate, String department, String doctorName, int type, int baseType, boolean hasViewProp);

    List<HashMap<String, Object>> getBaseListByDepart(String fromDate, String toDate, String department, int type, int baseType, boolean hasViewProp);

    XYChart multiDoctorTrend(int chartWidth, int chartHeight, String fromDate, String toDate, String department, String doctorNos, int antiClass, int type);

    //药品趋势
    XYChart medicineTrend(int chartWidth, int chartHeight, String fromDate, String toDate, String department, String healthNo, String medicineNo, String resultFieldName, String unit);

    XYChart doctorTrend(int chartWidth, int chartHeight, String fromDate, String toDate, String department, String doctorName, int antiClass, int type);

    XYChart baseDoctorTrend(int chartWidth, int chartHeight, String fromDate, String toDate, String department, String doctorName, int baseType, int type);

    XYChart baseDepartTrend(int chartWidth, int chartHeight, String fromDate, String toDate, String department, String doctorName, int baseType, int type);

    List<HashMap<String, Object>> byDoctor(String fromDate, String toDate, String department);

    List<HashMap<String, Object>> baseState(String fromDate, String toDate, String department);

    List<HashMap<String, Object>> departBase(String fromDate, String toDate, String department);


    //List<HashMap<String, Object>> byDepartDoctor(String fromDate, String toDate);

    List<HashMap<String, Object>> queryPatientDrug(int start, int limit, String fromDate, String toDate, int type, String patient, String healthNo, String medicineNo);

    int queryPatientDrugCount(String fromDate, String toDate, int type, String patient, String healthNo, String medicineNo);

    List<HashMap<String, Object>> getPatientInOut(String dailyDate);

    List<HashMap<String, Object>> getDailyInOut(int recordCount);

    List<HashMap<String, Object>> monthKPI(int recordCount);

    List<HashMap<String, Object>> dailyKPI(int recordCount);

    List<HashMap<String, Object>> medicineAmp(String month, double leastAmount);

    List<HashMap<String, Object>> doctorMonthKPI(int recordCount, String doctorName);

    List<HashMap<String, Object>> doctorDailyKPI(int recordCount, String doctorName);

    Map<String, Object> departMedicineSummary(Map<String, Object> param);

}
