package com.zcreate.security.auth;

import com.zcreate.security.dao.UserMapper;
import com.zcreate.security.pojo.User;
import com.zcreate.util.Hmac;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationCredentialsNotFoundException;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * Created by hhy on 17-5-20.
 */
public class SecurityProvider implements AuthenticationProvider {
    Logger logger = Logger.getLogger(SecurityProvider.class);

    @Autowired
    private UserMapper userMapper;
    @Resource
    private Properties configs;

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        //UsernamePasswordAuthenticationToken token = (UsernamePasswordAuthenticationToken) authentication;
        /*logger.debug("auth.getName()=" + authentication.getName());//登录的用户名
        logger.debug("auth.getCredentials()=" + authentication.getCredentials().toString());//密码*/

        Map<String, Object> param = new HashMap<>();
        param.put("loginname", authentication.getName());
        User user = userMapper.getUser(param);
        if (user == null) {
            throw new UsernameNotFoundException("用户名不存在");
        }
        if (!user.getPassword().equals(Hmac.sha1(authentication.getCredentials().toString().getBytes(),
                configs.getProperty("application_name").getBytes()))) {
            user.setFailureLogin(user.getFailureLogin() + 1);
            userMapper.loginUpdateUser(user);
            throw new BadCredentialsException("密码错误");
        }
        if (user.getAuthorities().size() == 0) {
            throw new AuthenticationCredentialsNotFoundException("未设置授权");
        }
       /* logger.debug("user:" + user);
        logger.debug("user:" + user.getAuthorities());
        logger.debug("authentication:" + authentication);
        logger.debug("authentication:" + authentication.getCredentials());*/

        return new UsernamePasswordAuthenticationToken(user, authentication.getCredentials(), user.getAuthorities());
    }

    @Override
    public boolean supports(Class<?> authentication) {
        // TODO Auto-generated method stub
        return UsernamePasswordAuthenticationToken.class.equals(authentication);
    }

}