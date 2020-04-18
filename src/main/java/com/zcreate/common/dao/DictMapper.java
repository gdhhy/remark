package com.zcreate.common.dao;

import com.zcreate.common.pojo.Dict;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface DictMapper {
    int liveCount(@Param("param") Map<String, Object> param);

    List<Dict> selectDict(@Param("param") Map<String, Object> param);

    Dict getDictByParentChildNo(@Param("param") Map<String, Object> param);

    Dict getDictByParentNo_Value(@Param("param") Map<String, Object> param);

    int insertDict(Dict dict);

    int updateHasChild(@Param("param") Dict dict);

    int updateHasChildByHasParent(int dictID);

    int updateDictByPrimaryKeySelective(Dict dict);

    int deleteDict(int dictID);

    List<Map> live(@Param("param") Map<String, Object> param);

}
