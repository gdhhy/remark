package com.zcreate;

import com.zcreate.rbac.web.DeployRunning;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.File;
import java.util.Timer;

/**
 * 配置到应用服务器启动时自动加载，环境变量和配置文件初始化<p>
 *
 * @author 黄海晏
 * Date: 2009-11-19
 * Time: 22:19:41
 */
public class AppStartListener implements ServletContextListener {
    private Timer timer;


    public void contextInitialized(ServletContextEvent event) {
        /*try {
            new Config();
        } catch (Exception e) {
            e.printStackTrace();
        }*/
        String deploy_dir = event.getServletContext().getRealPath(File.separator);
        if (!deploy_dir.endsWith(File.separator)) deploy_dir += File.separator;
        DeployRunning.setDir(deploy_dir);
        //  Config.setAppPathRoot(class_root);
        String log_dir = deploy_dir + "WEB-INF" + File.separator + "logs";
        File file = new File(log_dir);// String 中文版;
        if (!file.isDirectory())
            file.mkdirs();
        else
            //System.out.println("日志目录已存在");
            System.out.println("log4j日志目录 = " + log_dir);
        System.setProperty("LOG_DIR", log_dir);


        timer = new Timer(false);
       // timer.schedule(new UserSessionTimer(), 10000, 2000);//10秒后，每隔2秒
        //  System.setSecurityManager(new RMISecurityManager());
    }

    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        timer.cancel();
    }
}
