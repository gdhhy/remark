package com.zcreate.review.dao;

import com.zcreate.review.model.Instruction;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * User: 黄海晏
 * Date: 11-11-16
 * Time: 下午4:03
 */
public interface InstructionDAO {
    int save(Instruction instruction);

    int deleteByPrimaryKey(Integer instructionID);

    void insert(Instruction instruction);

    List<HashMap<String,Object>> query(Map param);

    int queryCount(Map param);

    Instruction getInstruction(Integer instructionID);

    Instruction viewInstruction(Integer instructionID);

    public Instruction viewInstrByGeneralInstrID(Integer instructionID);

    int doSetNewGeneral(Integer newGeneralID, Integer oldGeneralID);

    List<String> getSourceList();

    List<String> getProducerList();
}
