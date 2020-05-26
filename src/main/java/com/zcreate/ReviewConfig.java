package com.zcreate;

/**
 * Created by hhy on 2014/6/30.
 */
public class ReviewConfig {
    //wy\nx\yber\test

    private static String deployLocation;
    private static String hospitalName;

    public String getDeployLocation() {
        return deployLocation;
    }

    public void setDeployLocation(String deployLocation) {
        ReviewConfig.deployLocation = deployLocation;
    }


    /**
     * @return etonehis.POLICLINIC.WILLIAM.
     * etonehis.HMZYSDB.etone.
     * etonehis.CLINIC01.WILLIAM.
     * etonehis.nmedicine.dbo. 仅YP_YPXX
     */
    public String getPrefixNmedicine() {
        switch (deployLocation) {
            case "nx_test":
                return "nx_etonedb.dbo";
            case "nx_test_icu":
                return "etonedb_icu.dbo";
            case "wy_test":
                return "wy_etonedb.dbo";
            case "yber":
                return "eyserver.nmedicine.dbo";
            case "yber_test":
                return "etonedb.dbo";
            case "xf_test":
            default:
                return "etonehis.nmedicine.dbo";
        }
    }

    public String getPrefixHmzysdb(String dbo) {
        switch (deployLocation) {
            case "nx_test":
                return "nx_etonedb.dbo";
            case "nx_test_icu":
                return "etonedb_icu.dbo";
            case "wy_test":
                return "wy_etonedb.dbo";
            case "yber":
                return "eyserver.HMZYSDB." + dbo;
            case "yber_test":
                return "yber_etonedb_print3.dbo";
            case "xf_test":
            default:
                return "etonehis.HMZYSDB.etone";
        }
    }

    public String getPrefixPoliclinic(boolean backup) {
        switch (deployLocation) {
            case "nx_test":
                return "nx_etonedb.dbo";
            case "nx_test_icu":
                return "etonedb_icu.dbo";
            case "wy_test":
                return "wy_etonedb.dbo";
            case "yber":
                return !backup ? "eyserver.Policlinic.William" : "eyserver.finance.William";
            case "yber_test":
                return "yber_etonedb_print3.dbo";
            case "xf_test":
            default:
                return !backup ? "etonehis.Policlinic.William" : "etonehis.finance.William";
        }
    }

    public String getPrefixHospital(boolean backup) {
        switch (deployLocation) {
            case "nx_test":
                return "nx_etonedb.dbo";
            case "nx_test_icu":
                return "etonedb_icu.dbo";
            case "wy_test":
                return "wy_etonedb.dbo";
            case "yber":
                return !backup ? "eyserver.HOSPITAL.William" : "eyserver.hhospital.William";
            case "yber_test":
                return "yber_etonedb_print3.dbo";
            case "xf":
                return "review.dbo";
            case "xf_test":
                return "xf_review_20171204.dbo";
            default:
                return !backup ? "etonehis.HOSPITAL.William" : "etonehis.hhospital.William";
        }
    }

    public String getPrefixClinic(boolean backup, String departCode) {
        switch (deployLocation) {
            case "nx_test":
                return "nx_etonedb.dbo";
            case "nx_test_icu":
                return "etonedb_icu.dbo";
            case "wy_test":
                return "wy_etonedb.dbo";
            case "yber":
                return !backup ? "eyserver." + departCode + ".WILLIAM" : "eyserver.h" + departCode + ".WILLIAM";
            case "yber_test":
                return "yber_etonedb_print3.dbo";
            case "xf_test":
            default:
                return !backup ? "etonehis." + departCode + ".WILLIAM" : "etonehis.h" + departCode + ".WILLIAM";
        }
    }

    public String getPrefixRBAC() {
        if (deployLocation.contains("nx_test")) return "nx_rbac";
        else if (deployLocation.contains("yber_test")) return "yber_rbac";
        else if (deployLocation.contains("wy_test")) return "wy_rbac";
        else if (deployLocation.contains("xf_test")) return "xf_rbac";
        else return "rbac";
    }

    public String getPrefixEtone() {
        if (deployLocation.contains("nx_test")) return "nx_etonedb.";
        else if (deployLocation.contains("yber_test")) return "yber_etonedb_print3.dbo";
        else if (deployLocation.contains("wy_test")) return "wy_etonedb_0202.dbo";
        else if (deployLocation.contains("xf_test")) return "xf_etonedb.";
        else return "etonehis.EMEDICINE.dbo";
    }

    public String getPrefixStorage() {
        if (deployLocation.contains("nx_test")) return "nx_etonedb.";
        else if (deployLocation.contains("yber_test")) return "yber_etonedb_20161008.dbo";

        else if (deployLocation.contains("wy_test")) return "wy_etonedb_0202.dbo";
        else if (deployLocation.contains("wy")) return "wy_etonedb.dbo";
        else if (deployLocation.contains("xf_test")) return "xf_etonedb.";
        else return "etonehis.EMEDICINE.dbo";
    }

    public String getPrefixBD1000() {
        if (deployLocation.contains("nx_test")) return "nx_eteonedb.dbo";
        else if (deployLocation.contains("xf_test")) return "xf_review_20171204.dbo";
        else if (deployLocation.contains("xf")) return "review.dbo";
        else return "etonehis.basedata.william";
    }

    public String getSBInterface() {
        if (deployLocation.contains("yber_test")) return "yber_etonedb_print3.dbo";
        else return "eyserver.sbinterface.dbo";
    }

    public String getReviewDB() {
        if (deployLocation.contains("nx_test")) return "";
        else return "reviewdb.review.dbo.";
    }
    public String getHuaeaseHis(){
        if (deployLocation.contains("xf_test"))
            return "huaease.dbo";
        else
            return "huaease.hisdb.dbo";
    }
    public String getHuaeaseEmr(){
        if (deployLocation.contains("xf_test"))
            return "huaease_emr.dbo";
        else
            return "huaease.emr.dbo";
    }

    public   String getHospitalName() {
        return hospitalName;
    }

    public   void setHospitalName(String hospitalName) {
        ReviewConfig.hospitalName = hospitalName;
    }
}
