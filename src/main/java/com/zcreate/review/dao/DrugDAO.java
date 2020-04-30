package com.zcreate.review.dao;

import com.zcreate.review.model.Drug;
import com.zcreate.review.model.DrugDose;

import java.util.List;
import java.util.Map;

/**
 * User: 黄海晏
 * Date: 11-11-16
 * Time: 下午4:03
 */
public interface DrugDAO {
    int save(Drug drug);

    int deleteByPrimaryKey(Integer drugID);

    boolean restore(Integer drugID);

    boolean invalid(Integer drugID);

    int insert(Drug drug);

    //List<Drug> selectByParentID(Integer parentID);

    List<Drug> query(Map param);

    List<Drug> liveDrug(Map param);

    int queryCount(Map param);

    Drug getDrug(Integer drugID);

    //DrugDose
    void insertDrugDose(DrugDose drugDose);

    List<DrugDose> selectDrugDose(int drugID);

    int deleteDrugDose(int drugDoseID);

    int saveDrugDose(DrugDose drugDose);

}