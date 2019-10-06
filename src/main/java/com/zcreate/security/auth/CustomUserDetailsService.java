package com.zcreate.security.auth;


import com.zcreate.security.dao.UserMapper;
import com.zcreate.security.pojo.User;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service("customUserDetailsService")
public class CustomUserDetailsService implements UserDetailsService {
    Logger logger = Logger.getLogger(CustomUserDetailsService.class);
    //@Autowired
    //private UserDao userDao;

    @Autowired
    private UserMapper userMapper;


    //@Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String loginname)
            throws UsernameNotFoundException {
        //System.out.println("userDao = " + userDao);
        Map<String, Object> param = new HashMap<>();
        param.put("loginname", loginname);
        User user = userMapper.getUser(param);

        if (user == null) {
            throw new UsernameNotFoundException("用户名不存在！");
        }
        logger.debug("user:" + user.getUsername());

        /*logger.debug("User : " + user.get(0));
        logger.debug("User.isAccountNonExpired(): " + user.get(0).isAccountNonExpired());
        logger.debug("User.isAccountNonLocked(): " + user.get(0).isAccountNonLocked());
        logger.debug("User.isCredentialsNonExpired(): " + user.get(0).isCredentialsNonExpired());*/
        //return user;
        return new org.springframework.security.core.userdetails.User(user.getUsername(), user.getPassword(),
                user.isEnabled(), user.isAccountNonExpired(), user.isCredentialsNonExpired(), user.isAccountNonLocked(),
                getGrantedAuthorities(user));
    }


    private List<GrantedAuthority> getGrantedAuthorities(User user) {
        List<GrantedAuthority> authorities = new ArrayList<>();
        String[] roles = user.getRoles().split(",");
        for (String role : roles)
            authorities.add(new SimpleGrantedAuthority(role));
     /*   for (UserProfile userProfile : user.getUserProfiles()) {
            System.out.println("UserProfile : " + userProfile);
            authorities.add(new SimpleGrantedAuthority("ROLE_" + userProfile.getType()));
        }*/
      /*  authorities.add(new SimpleGrantedAuthority("ADMIN"));
        authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));*/
        logger.debug("authorities :" + authorities);
        return authorities;
    }

}
