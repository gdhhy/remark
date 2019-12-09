package com.zcreate.review.dao;

import com.zcreate.review.model.Contagion;
import com.zcreate.review.model.Infectious;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by hhy on 2014/10/5.
 */
public interface InfectiousDAO {

    int saveInfectious(Infectious infectious);

    int deleteInfectious(int infectiousID);

    HashMap<String, Object> getInfectious(int infectiousID);

    List<Infectious> getInfectiousList(Map param);

    int saveContagion(Contagion contagion);

    int deleteContagion(int contagionID);

    HashMap<String, Object> getContagion(int contagionID);

    List<Contagion> getContagionList(Map param);

    String[] getWorkflowChn();
}
