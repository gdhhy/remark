package com.zcreate.security.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.security.dao.UserMapper;
import com.zcreate.security.pojo.User;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.authentication.rememberme.JdbcTokenRepositoryImpl;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.security.Principal;
import java.util.*;

@Controller
@RequestMapping("/")
public class LoginController {
    @Autowired
    private JdbcTokenRepositoryImpl jdbcTokenRepository; @Autowired
    private UserMapper userMapper;

    private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();

    Logger logger = Logger.getLogger(LoginController.class);
    @Resource
    private Properties configs;

    @RequestMapping(value = "/username", method = RequestMethod.GET)
    @ResponseBody
    public String currentUserName(Principal principal) {
        return principal.getName();
    }

    @RequestMapping(value = "/loginPage", method = RequestMethod.GET)
    public String loginPage(@RequestParam(value = "error", required = false) String error, ModelMap model, HttpServletRequest request) {
        // logger.debug("url function = loginPage");
        /*logger.debug("getPathInfo" + request.getPathInfo());
        logger.debug("getParameterMap" + request.getParameterMap().toString());*/
        //logger.debug("model" + model.toString());//model{content=/admin/users.jsp}
        //logger.debug("getAuthorities" + SecurityContextHolder.getContext().getAuthentication().getAuthorities());//仅仅登录前的 ROLE_ANONYMOUS，无意义
        if (SecurityContextHolder.getContext().getAuthentication() != null) {
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

            if (principal instanceof UserDetails) {
                logger.debug("已登录");
                model.addAttribute("loginSucceed", true);
                model.addAttribute("loginName", ((UserDetails) principal).getUsername());
            }
        }
        if (error != null) {
            model.addAttribute("errMsg", getErrorMessage(request));
        }

        model.addAttribute("systemTitle", configs.getProperty("title"));
        /*model.addAttribute("systemTitle2", "系统登录");*/
        return "/loginPage";
    }
    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public String index(@RequestParam(value = "content", defaultValue = "/admin/hello.html") String contentUrl, ModelMap model) {
        model.addAttribute("content", contentUrl);
        Object loginObject = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (loginObject instanceof UserDetails)
            return "/index";
        else {
            return loginPage(null, model, null);
        }
    }

   /* @RequestMapping(value = "/menu", method = RequestMethod.GET)
    public String menu(ModelMap model) {
        //model.addAttribute("user", getPrincipal());
        return "/admin/sidebar";
    }
*/
    private List<com.zcreate.security.pojo.Function> findChildFunction(List<com.zcreate.security.pojo.Function> roleFuncs, com.zcreate.security.pojo.Function parent) throws Exception {
        List<com.zcreate.security.pojo.Function> child = new ArrayList<>();
        for (int k = roleFuncs.size() - 1; k >= 0; k--) {
            if (roleFuncs.get(k).getParentID().equals(parent.getFunctionID())) {
                child.add(roleFuncs.get(k));
                //roleFuncs.remove(k);
            }
        }

        for (com.zcreate.security.pojo.Function bean : child) {
            if (bean.getHasChild())
                bean.setChild(findChildFunction(roleFuncs, bean));
        }
        return child;
    }

    @RequestMapping(value = "/navbar", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String navbar(ModelMap model) {
        String loginname=getPrincipal();

        Map<String, Object> param = new HashMap<>();
        param.put("loginname", loginname);
        User user = userMapper.getUser(param);
        model.addAttribute("user",user);

        return "/admin/navbar";
    }
    @RequestMapping(value = "/users", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String users( ModelMap model) {
        String loginname=getPrincipal();

        Map<String, Object> param = new HashMap<>();
        param.put("loginname", loginname);
        User user = userMapper.getUser(param);
        model.addAttribute("user",user);

        return "/admin/users";
    }

   /* @RequestMapping(value = "/admin/menu", method = RequestMethod.GET)
    public ModelAndView menu() {
        return new ModelAndView("/admin/menu", null);
    }*/

    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logoutPage(HttpServletRequest request, HttpServletResponse response) {
        logger.debug("logoutPage");
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            jdbcTokenRepository.removeUserTokens(auth.getName());
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }
        return "redirect:/loginPage.jspa?logout";
    }

    private String getPrincipal() {
        String userName;
        //Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        //logger.debug("auth:" + auth);
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            logger.debug("UserDetails");
            userName = ((UserDetails) principal).getUsername();
        } else {
            logger.debug("principal:" + principal);
            userName = principal.toString();
        }
        return userName;
    }

    private String getErrorMessage(HttpServletRequest request) {
        Exception exception = (Exception) request.getSession().getAttribute("SPRING_SECURITY_LAST_EXCEPTION");
        if (exception != null)
            return exception.getMessage();
        return "";
        /*if (exception instanceof BadCredentialsException) {
            error = "Invalid username and password!";
        } else if (exception instanceof UsernameNotFoundException) {
            error = exception.getMessage();
        } else if (exception instanceof CredentialExpiredException) {
            error = exception.getMessage();
        } else if (exception instanceof DisabledException) {
            error = exception.getMessage();
        } else if (exception instanceof LockedException) {
            error = exception.getMessage();
        } else {
            error = "Invalid username and password!";
        }*/
    }

}