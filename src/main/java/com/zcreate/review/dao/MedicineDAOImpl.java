package com.zcreate.review.dao;

import com.zcreate.ReviewConfig;
import com.zcreate.review.model.Medicine;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 11-11-16
 * Time: 下午4:06
 */
public class MedicineDAOImpl extends SqlSessionDaoSupport implements MedicineDAO, Serializable {
    private static ReviewConfig reviewConfig;

    public void setReviewConfig(ReviewConfig reviewConfig) {
        MedicineDAOImpl.reviewConfig = reviewConfig;
    }

    public int save(Medicine medicine) {
        // setInnerField(medicine);
        return getSqlSession().update("Medicine.updateMedicineByPrimaryKeySelective", medicine);
    }

    public int saveMatch(Medicine medicine) {
        //setInnerField(medicine);
        return getSqlSession().update("Medicine.updateMatchMedicine", medicine);
    }

    public int deleteByPrimaryKey(Integer medicineID) {
        //  Medicine medicine = getMedicine(medicineID);
        return getSqlSession().delete("Medicine.deleteMedicine", medicineID);
    }

    public void insert(Medicine medicine) {
        //setInnerField(medicine);
        getSqlSession().insert("Medicine.insertMedicine", medicine);
    }

    private void setInnerField(Medicine medicine) {
        if (medicine.getAntiClass() == null)
            if (medicine.getHealthNo() != null && (medicine.getHealthNo().startsWith("4001") || medicine.getHealthNo().startsWith("400204")))/*||
                    medicine.getHealthNo().startsWith("400201") || medicine.getHealthNo().startsWith("400202") ||
                    medicine.getHealthNo().startsWith("400206") || medicine.getHealthNo().startsWith("400208") || medicine.getHealthNo().startsWith("400210")))     */
                medicine.setAntiClass(0);
            else
                medicine.setAntiClass(-1);
        else if (!medicine.getHealthNo().startsWith("4001") && !medicine.getHealthNo().startsWith("400204"))
            medicine.setAntiClass(0);

    }

    public Medicine getMedicine(Integer medicineID) {
        return (Medicine) getSqlSession().selectOne("Medicine.selectMedicine", medicineID);
    }

    public Medicine getMedicine(String medicineNo) {
        return (Medicine) getSqlSession().selectOne("Medicine.selectMedicineByNo", medicineNo);
    }

    public Medicine selectMedicineByGoodsID(Integer goodsID) {
        return (Medicine) getSqlSession().selectOne("Medicine.selectMedicineByGoodsID", goodsID);
    }

    @SuppressWarnings("unchecked")
    public List<Medicine> query(Map param) {
        int start = (Integer) param.get("start");
        int toIndex = (Integer) param.get("limit") + start;
        param.remove("start");
        param.put("limit", 100000);

        param.put("orderField", "lastPurchaseTime");
        List result;
        if (reviewConfig.getDeployLocation().contains("xf")) {
            param.put("orderField", "no");
            result = getSqlSession().selectList("Medicine.queryMedicine", param);
        } else
            result = getSqlSession().selectList("Medicine.queryMedicineDesc", param);
       /* System.out.println("start = " + start);
        System.out.println("toIndex = " + toIndex);
        System.out.println("result.size() = " + result.size());*/
        if (result.size() < toIndex) toIndex = result.size();
        return result.subList(start, toIndex);
    }

    public int queryCount(Map param) {
        return (Integer) getSqlSession().selectOne("Medicine.queryMedicineCount", param);
    }

    @SuppressWarnings("unchecked")
    public List<Map> live(Map param) {
        param.put("orderField", "medicineNo");
        return getSqlSession().selectList("Medicine.liveMedicine", param);
    }

    public int liveCount(Map param) {
        return (Integer) getSqlSession().selectOne("Medicine.liveMedicineCount", param);
    }
}
