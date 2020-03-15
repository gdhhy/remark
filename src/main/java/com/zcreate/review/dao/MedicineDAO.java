package com.zcreate.review.dao;

import com.zcreate.review.model.Medicine;

import java.util.List;
import java.util.Map;

/**
 * User: 黄海晏
 * Date: 11-11-16
 * Time: 下午4:03
 */
public interface MedicineDAO {
    int save(Medicine medicine);

    int saveMatch(Medicine medicine);

    int deleteByPrimaryKey(Integer medicineID);

    void insert(Medicine medicine);

    List<Medicine> query(Map param);

    List<Map> live(Map param);

    int queryCount(Map param);

    int liveCount(Map param);

    Medicine getMedicine(Integer medicineID);

    Medicine getMedicine(String medicineNo);

    Medicine selectMedicineByGoodsID(Integer goodsID);
}
