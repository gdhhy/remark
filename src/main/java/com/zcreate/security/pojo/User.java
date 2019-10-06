package com.zcreate.security.pojo;


import com.google.gson.JsonElement;
import net.sf.json.JSONObject;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

/**
 * 用户类，具体属性：<p>
 * userID:用户ID，关键字，自增长 <p>
 * username：用户名，登录ID<p>
 * name：用户姓名<p>
 * createUserID：创建本用户的用户ID<p>
 * isUse：用户是否在用，设置0为停用，用户不可登录。通过本属性可暂停用户登录<p>
 * loginIP：限制用户登录的IP，设置后，用户只可在该IP登录<p>
 * isLimitIP：设置为true,限制登录IP起作用<p>
 * groupID：用户所在的部门ID<p>
 * orderID：用户在部门内的排序ID<p>
 * lastLoginTime：上次登录时间<p>
 * lastLoginIP：上次登录IP<p>
 * requireCheckCard: 是否要求打卡，以前打卡遗留字段<p>
 * adminedGroup: 可管理的单位范围，填写groupID，在该部门范围内用户的增删改权限<p>
 * dimission：是否离职，离职后不可登录，应用里面看不到该用户，一旦设定离职，永不可恢复<p>
 * expiredDate：离职日期<p>
 * allowSynLogin：允许同步登录，即是一个用户可以打开多个浏览器登录，即使IP不同
 * failureLogin：记录失败次数
 *
 * @author 黄海晏
 */
public class User implements Serializable, Comparable, UserDetails {
    private static final long serialVersionUID = 8918676885845937568L;
    //Ibatis 不能设置缺省值，否则updateUserByPrimaryKeySelective会设置成缺省值
    private Integer userID;
    private String loginName;
    private String password;
    private Boolean accountNonLocked = true;
    private String name;
    private JsonElement link;//json,存储email，电话，移动电话，分机等等

    private Date createDate;
    private String note;
    private Integer groupID;
    private String roles;
    private Integer orderID;
    private Date expiredDate;

    private String lockedIP;
    private Boolean lockedLoginIP = false;
    private Date lastLoginTime;
    private String lastLoginIP;
    private Boolean allowSynLogin = true;

    private Integer failureLogin;
    private Integer succeedLogin;


    public Integer getUserID() {
        return userID;
    }

    public void setUserID(Integer userID) {
        this.userID = userID;
    }

    public String getUsername() {
        return loginName;
    }

    public void setUsername(String username) {
        this.loginName = username;
    }

    @Override
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isAccountNonExpired() {
        System.out.println("expiredDate = " + expiredDate);
        JSONObject s;
        return true;
        //return expiredDate != null;
    }

    public boolean isAccountNonLocked() {
        return accountNonLocked;
    }

    public boolean isCredentialsNonExpired() {
        return true;
    }

    public boolean isEnabled() {
        return true;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        List<GrantedAuthority> authorities = new ArrayList<>();
        if (roles != null) {
            String[] roleArr = roles.split(",");

            for (String role : roleArr) {
                System.out.println("role = " + role);
                authorities.add(new SimpleGrantedAuthority(role));
            }
        }
        //authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
        return authorities;
    }

    public String getLoginName() {
        return loginName;
    }

    public void setLoginName(String loginName) {
        this.loginName = loginName;
    }

    public void setAccountNonLocked(Boolean accountNonLocked) {
        this.accountNonLocked = accountNonLocked;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public JsonElement getLink() {
        return link;
    }

    public void setLink(JsonElement link) {
        this.link = link;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Integer getGroupID() {
        return groupID;
    }

    public void setGroupID(Integer groupID) {
        this.groupID = groupID;
    }

    public Integer getOrderID() {
        return orderID;
    }

    public void setOrderID(Integer orderID) {
        this.orderID = orderID;
    }

    public Date getExpiredDate() {
        return expiredDate;
    }

    public void setExpiredDate(Date expiredDate) {
        this.expiredDate = expiredDate;
    }


    public Date getLastLoginTime() {
        return lastLoginTime;
    }

    public void setLastLoginTime(Date lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
    }

    public String getLastLoginIP() {
        return lastLoginIP;
    }

    public void setLastLoginIP(String lastLoginIP) {
        this.lastLoginIP = lastLoginIP;
    }

    public Boolean getAllowSynLogin() {
        return allowSynLogin;
    }

    public void setAllowSynLogin(Boolean allowSynLogin) {
        this.allowSynLogin = allowSynLogin;
    }

    public Integer getFailureLogin() {
        return failureLogin;
    }

    public void setFailureLogin(Integer failureLogin) {
        this.failureLogin = failureLogin;
    }

    public Integer getSucceedLogin() {
        return succeedLogin;
    }

    public void setSucceedLogin(Integer succeedLogin) {
        this.succeedLogin = succeedLogin;
    }

    public String getLockedIP() {
        return lockedIP;
    }

    public void setLockedIP(String lockedIP) {
        this.lockedIP = lockedIP;
    }

    public Boolean getLockedLoginIP() {
        return lockedLoginIP;
    }

    public void setLockedLoginIP(Boolean lockedLoginIP) {
        this.lockedLoginIP = lockedLoginIP;
    }

    public String getRoles() {
        return roles;
    }

    public void setRoles(String roles) {
        this.roles = roles;
    }

    public String toString() {
        return "User [id=" + userID + ", loginName=" + loginName + ", groupID=" + groupID + ", roles=" + roles
                + ", orderID=" + orderID + "]";
    }


    /* public int hashCode() {
         return this.getGroupID();    //To change body of overridden methods use File | Settings | File Templates.
     }
 */
    @Override
    public boolean equals(Object obj) {
        return this.getUserID().equals(((User) obj).getUserID()) &&
                this.getUsername().equals(((User) obj).getUsername());
    }

    public int compareTo(Object object) {
        if (this == object) {
            return 0;
        }
        if (object != null && object instanceof User) {
            if (getUserID() > ((User) object).getUserID()) return 1;
            if (getUserID().equals(((User) object).getUserID()))
                return 0;
            else
                return -1;
        } else
            return 1;
    }

    public boolean isSpecialUser() {//意味着用户是特殊用户，例如开发者
        return userID <= 100;
    }

}