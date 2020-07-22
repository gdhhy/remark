package com.zcreate.review.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * 本院药品
 * User: 黄海晏
 * Date: 11-11-19
 * Time: 上午10:01
 */
public class Medicine implements Serializable {
    private Integer medicineID;
    //private String medicineNo;//对应药品ID，医保统一编码
    private String no;//医院内部编码
    private String ypID;
    private int goodsID;
    private String pinyin;
    //todo 药理分类不要了,关联到通用名，看它的药理分类
    //todo 暂时要 2012-1-25
    private String healthNo;
    private String chnName;
    private String engName;
    //剂型
    private String dose;
    //规格
    private String spec;
    private Double price;
    private Double contents;
    //  包装单位，瓶、盒、支
    private String producer;//生产厂家
    private Integer insurance;//医保分类
    private String packUnit;
    //使用单位(可拆分最小单位)
    private String minUnit;
    private String clinicUnit;

    private Integer minOfpack;// 包装转换比
    private Integer matchDrugID;
    private Integer matchInstrID;//匹配的说明书ID

    private Timestamp updateTime;
    private String updateUser;
    private String memo;
    //西药标识
    private int isWestern;
    //-------------------------新增
   /* 1	口服
    2	注射
    3	大输液
    4	外用
    5	材料
    6	其他*/
    private Integer route;
    //是否注射剂
    private Integer injectRoute;
    //口服\
    //抗菌药级别，是否限制使用
    private Integer antiClass;
    private float ddd;
    private String measureUnit;
    private Integer usageCounter;
    //base 根据南雄的定义，基药为1（分不清国家或省），国家基药为2，省基药为3，非基药为0
    private Integer base;

    //下面三个字段在粤北二院实施时增加，2013-08-29
    private String dealer;//经销商
    private Timestamp lastPurchaseTime;//最后采购时间
    //修改为特殊类别
    private Integer mental;//精神药物：1、Glucocorticoid 糖皮质激素：2
    //增加字段，做剂量、天数、溶媒监控
    //private  double maxContent;//可能就是抗菌药的日限定剂量，todo 删除
    private int maxDay;
    private int menstruum;//0无定义，1：盐水；2：糖水
    private String json;//0无定义，1：盐水；2：糖水


    //--------------------
    //查询关联属性
    private String generalName;
    private String instructionName;
    private String healthName;
    private Integer isDelete;
    private Integer isStat;//抗菌药是否统计该值

    public Integer getMedicineID() {
        return medicineID;
    }

    public void setMedicineID(Integer medicineID) {
        this.medicineID = medicineID;
    }

   /* public String getMedicineNo() {
        return medicineNo;
    }

    public void setMedicineNo(String medicineNo) {
        this.medicineNo = medicineNo;
    }*/

    public String getYpID() {
        return ypID;
    }

    public void setYpID(String ypID) {
        this.ypID = ypID;
    }

    public int getGoodsID() {
        return goodsID;
    }

    public void setGoodsID(int goodsID) {
        this.goodsID = goodsID;
    }

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getPinyin() {
        return pinyin;
    }

    public void setPinyin(String pinyin) {
        this.pinyin = pinyin;
    }

    public String getHealthNo() {
        return healthNo;
    }

    public void setHealthNo(String healthNo) {
        this.healthNo = healthNo;
    }

    public String getChnName() {
        return chnName;
    }

    public void setChnName(String chnName) {
        this.chnName = chnName;
    }

    public String getEngName() {
        return engName;
    }

    public void setEngName(String engName) {
        this.engName = engName;
    }

    public String getDose() {
        return dose;
    }

    public void setDose(String dose) {
        this.dose = dose;
    }

    public String getSpec() {
        return spec;
    }

    public void setSpec(String spec) {
        this.spec = spec;
    }

    public String getProducer() {
        return producer;
    }

    public void setProducer(String producer) {
        this.producer = producer;
    }

    public Integer getInsurance() {
        return insurance;
    }

    public void setInsurance(Integer insurance) {
        this.insurance = insurance;
    }

    public String getPackUnit() {
        return packUnit;
    }

    public void setPackUnit(String packUnit) {
        this.packUnit = packUnit;
    }

    public String getMinUnit() {
        return minUnit;
    }

    public void setMinUnit(String minUnit) {
        this.minUnit = minUnit;
    }

    public String getClinicUnit() {
        return clinicUnit;
    }

    public void setClinicUnit(String clinicUnit) {
        this.clinicUnit = clinicUnit;
    }

    public Integer getMinOfpack() {
        return minOfpack;
    }

    public void setMinOfpack(Integer minOfpack) {
        this.minOfpack = minOfpack;
    }

    public Integer getMatchDrugID() {
        return matchDrugID;
    }

    public void setMatchDrugID(Integer matchDrugID) {
        this.matchDrugID = matchDrugID;
    }

    public Integer getMatchInstrID() {
        return matchInstrID;
    }

    public void setMatchInstrID(Integer matchInstrID) {
        this.matchInstrID = matchInstrID;
    }

    public Timestamp getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Timestamp updateTime) {
        this.updateTime = updateTime;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }


    public String getGeneralName() {
        return generalName;
    }

    public void setGeneralName(String generalName) {
        this.generalName = generalName;
    }

    public String getInstructionName() {
        return instructionName;
    }

    public void setInstructionName(String instructionName) {
        this.instructionName = instructionName;
    }

    public Integer getRoute() {
        return route;
    }

    public void setRoute(Integer route) {
        this.route = route;
    }

    public Integer getInjectRoute() {
        return injectRoute;
    }

    public void setInjectRoute(Integer injectRoute) {
        this.injectRoute = injectRoute;
    }

    public Integer getIsStat() {
        return isStat;
    }

    public void setIsStat(Integer isStat) {
        this.isStat = isStat;
    }

    public Integer getAntiClass() {
        return antiClass;
    }

    public void setAntiClass(Integer antiClass) {
        this.antiClass = antiClass;
    }

    public int getWestern() {
        return isWestern;
    }

    public void setWestern(int western) {
        isWestern = western;
    }

    public Integer getUsageCounter() {
        return usageCounter;
    }

    public void setUsageCounter(Integer usageCounter) {
        this.usageCounter = usageCounter;
    }

    public Integer getBase() {
        return base;
    }

    public void setBase(Integer base) {
        this.base = base;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Double getContents() {
        return contents;
    }

    public void setContents(Double contents) {
        this.contents = contents;
    }

    public String getMeasureUnit() {
        return measureUnit;
    }

    public void setMeasureUnit(String measureUnit) {
        this.measureUnit = measureUnit;
    }

    public String getHealthName() {
        return healthName;
    }

    public void setHealthName(String healthName) {
        this.healthName = healthName;
    }

    public float getDdd() {
        return ddd;
    }

    public void setDdd(float ddd) {
        this.ddd = ddd;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser;
    }

    public String getDealer() {
        return dealer;
    }

    public void setDealer(String dealer) {
        this.dealer = dealer;
    }

    public Timestamp getLastPurchaseTime() {
        return lastPurchaseTime;
    }

    public void setLastPurchaseTime(Timestamp lastPurchaseTime) {
        this.lastPurchaseTime = lastPurchaseTime;
    }

    public Integer getMental() {
        return mental;
    }

    public void setMental(Integer mental) {
        this.mental = mental;
    }

    public int getMaxDay() {
        return maxDay;
    }

    public void setMaxDay(int maxDay) {
        this.maxDay = maxDay;
    }

    public int getMenstruum() {
        return menstruum;
    }

    public void setMenstruum(int menstruum) {
        this.menstruum = menstruum;
    }

    public Integer getIsDelete() {
        return isDelete;
    }

    public void setIsDelete(Integer isDelete) {
        this.isDelete = isDelete;
    }

    public String getJson() {
        return json;
    }

    public void setJson(String json) {
        this.json = json;
    }
}
