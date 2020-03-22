package com.zcreate.remark.dao;


import org.apache.ibatis.annotations.Mapper;

import java.util.HashMap;
import java.util.Map;

@Mapper
public interface SunningMapper {
    public HashMap<String, Object> getSunning(Map param);
    public HashMap<String, Object> getSunningInPatient(Map param);
    public HashMap<String, Object> getSunningAdviceItem(Map param);
}
