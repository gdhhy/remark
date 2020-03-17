package com.zcreate.rbac.web;

import java.io.File;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 11-11-23
 * Time: 下午9:55
 */
public class DeployRunning {
    private static String dir;

    public static String getDir() {
        return dir;
    }

    public static void setDir(String dir) {
        DeployRunning.dir = dir;
    }

    public static String getCanonicalPath(String path) {
        if (path.startsWith(dir)) return path.substring(dir.length()).replace(File.separator,"/");
        else return path.replace(File.separator,"/");
    }
}
