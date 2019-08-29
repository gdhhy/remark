package com.zcreate.review.mapper;

import com.zcreate.review.model.Remark;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface RemarkMapper {

    List<Remark> selectRemark(@Param("param") Map<String, Object> param);

    List<Remark> getRemark(int remarkID);

    int insertRemark(Remark remark);

    int updateRemark(@Param("param") Remark remark); 

}
