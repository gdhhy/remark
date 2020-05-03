package com.zcreate.review.model;

import java.io.Serializable;

/**
 * Created with IntelliJ IDEA.
 * User: hhy
 * Date: 13-11-28
 * Time: 下午4:09
 */
public class DrugDose implements Serializable {
    private Integer drugDoseID;
    private int drugID;
    private String route;
    private String dose;
    private int instructionID;
    private String instructionName;
    private int    instructCount;

    public Integer getDrugDoseID() {
        return drugDoseID;
    }

    public void setDrugDoseID(Integer drugDoseID) {
        this.drugDoseID = drugDoseID;
    }

    public int getDrugID() {
        return drugID;
    }

    public void setDrugID(int drugID) {
        this.drugID = drugID;
    }

    public String getRoute() {
        return route;
    }

    public void setRoute(String route) {
        this.route = route;
    }

    public String getDose() {
        return dose;
    }

    public void setDose(String dose) {
        this.dose = dose;
    }

    public int getInstructionID() {
        return instructionID;
    }

    public void setInstructionID(int instructionID) {
        this.instructionID = instructionID;
    }

    public String getInstructionName() {
        return instructionName;
    }

    public void setInstructionName(String instructionName) {
        this.instructionName = instructionName;
    }

    public int getInstructCount() {
        return instructCount;
    }

    public void setInstructCount(int instructCount) {
        this.instructCount = instructCount;
    }
}
