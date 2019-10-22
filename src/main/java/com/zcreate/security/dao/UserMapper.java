package com.zcreate.security.dao;

import com.zcreate.security.pojo.User;
//import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * Created by hhy on 17-5-5.
 */
//@Mapper
public interface UserMapper {
    User getUser(@Param("param") Map<String, Object> param);

    User getUserByID(@Param("userID") int userID);

    User getUserByLoginname(@Param("loginname") String loginname);

    List<User> selectUser(@Param("param") Map<String, Object> param);

    int insertUser(@Param("pojo") User user);

    int updateUser(@Param("pojo") User user);

    int loginUpdateUser(@Param("pojo") User user);

    int deleteUser(@Param("userID") int userID);

  /*  int setUserRole(@Param("param") List<Map<String, Object>> param);

    int deleteUserRole(@Param("userID") int userID);*/
}
