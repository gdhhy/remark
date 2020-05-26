package com.zcreate.remark.dao;

import com.zcreate.remark.model.Pacs;
import org.apache.ibatis.annotations.Mapper;

import java.util.HashMap;
import java.util.List;

@Mapper
public interface CheckMapper {
    HashMap<String, Object> selectLisCount(int hospID);

    List<HashMap<String, Object>> selectLisDir(int hospID);

    List<HashMap<String, Object>> selectLisResult(int labID);

    HashMap<String, Object> selectPacsCount(int hospID);

    List<Pacs> selectPacsResult(int labID);
}
