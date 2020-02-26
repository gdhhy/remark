package com.zcreate.review.his;

import com.zcreate.ReviewConfig;
import com.zcreate.util.StringUtils;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * User: 黄海晏@广州志创网络科技有限公司
 * Date: 13-1-9
 * Time: 下午2:18
 */
public class HisDAOImpl extends SqlSessionDaoSupport implements HisDAO, Serializable {
    private static ReviewConfig reviewConfig;

    public void setReviewConfig(ReviewConfig reviewConfig) {
        HisDAOImpl.reviewConfig = reviewConfig;

    }

    @SuppressWarnings("unchecked")
    public List<Course> getCourse(Integer serialNo, String departCode, int archive) {
        HashMap<String, Object> map = new HashMap<String, Object>(2);
        map.put("serialNo", serialNo);
        map.put("prefix", reviewConfig.getPrefixClinic(archive == 1, departCode));
        List<Course> courses = getSqlSession().selectList("His.selectCourse", map);
        for (Course course : courses)
            course.setContent(StringUtils.toHTMLString(course.getContent()));
        return courses;
    }

    public History getHistory(Integer serialNo, String departCode, int archive) {
        HashMap<String, Object> map = new HashMap<String, Object>(2);
        map.put("serialNo", serialNo);
        map.put("prefix", reviewConfig.getPrefixClinic(archive == 1, departCode));
        History history = (History) getSqlSession().selectOne("His.selectHistory", map);
        if (history != null)
            history.setContent(StringUtils.toHTMLString(history.getContent()));
        return history;
    }


    public static void main(String[] args) {


    }

    public List<HashMap> getDiagnosis(Integer serialNo) {
        HashMap<String, Object> param = new HashMap<String, Object>(2);
        param.put("serialNo", serialNo);

        return getSqlSession().selectList("His.selectDiagnosis", param);
    }

}