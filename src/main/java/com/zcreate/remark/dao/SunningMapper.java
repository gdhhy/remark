package com.zcreate.remark.dao;


import org.apache.ibatis.annotations.Mapper;

import java.util.HashMap;
import java.util.Map;
import java.util.List;

@Mapper
public interface SunningMapper {
    HashMap<String, Object> getSunning(Map<String, Object> param);

    HashMap<String, Object> getSunningInPatient(Map<String, Object> param);

}
