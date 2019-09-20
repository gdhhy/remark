package com.zcreate.remark.controller;

import ChartDirector.BarLayer;
import ChartDirector.Chart;
import ChartDirector.LineLayer;
import ChartDirector.XYChart;
import com.zcreate.util.DateUtils;

import java.util.*;

public class ChartHelp {
    //通用的XYChart
    public static XYChart createXYChart(int chartWidth, int chartHeight, List<HashMap<String, Object>> result, String valueField, final String dateField, String yUnit, int dataColor) {
        Collections.sort(result, new Comparator<HashMap<String, Object>>() {
            public int compare(HashMap<String, Object> o1, HashMap<String, Object> o2) {
                return -1 * ((Date) o1.get(dateField)).compareTo(((Date) o2.get(dateField)));
            }
        });
        Date[] date = new Date[result.size()];
        double[] values = new double[result.size()];

        double maxValue = Double.MIN_VALUE, minValue = Double.MAX_VALUE;
        for (int i = 0; i < result.size(); i++) {
            date[i] = (Date) result.get(i).get(dateField);
            if (result.get(i).get(valueField) != null)
                values[i] = ((Number) result.get(i).get(valueField)).doubleValue();

            if (values[i] > maxValue) maxValue = values[i];
            if (values[i] < minValue) minValue = values[i];
        }

        XYChart c = new XYChart(chartWidth, chartHeight, 0xfcfaff);

        c.setPlotArea(65, 20, chartWidth - 100, chartHeight - 60, 0xffffff, -1, -1, 0xc0c0c0, -1);

        c.yAxis().setTitle("<*font=宋体,size=10 *>" + yUnit + "<*/*>").setFontAngle(0);
        if (result.size() > 0)
            c.xAxis().setTitle("<*font=宋体,size=10 *>" + DateUtils.formatDate((Date) result.get(result.size() - 1).get(dateField), "yyyy-MM-dd") + " - " +
                    DateUtils.formatDate((Date) result.get(0).get(dateField), "yyyy-MM-dd") + "<*/*>");
        LineLayer layer = c.addLineLayer2();
        layer.setLineWidth(2);

        if (date.length > 0)
            layer.setXData(date[0], date[date.length - 1]);
        c.xAxis().setLabelFormat("{value|m-d}");
        // c.xAxis().setLabels(date);
        layer.addDataSet(values, dataColor);
        c.yAxis().setLinearScale(minValue, maxValue);//Y坐标的最小值和最大值

        return c;
    }

    //通用的XYChart
    public static XYChart createSymbolLineChart(int chartWidth, int chartHeight, List<HashMap<String, Object>> result, String valueField, final String dateField, String yUnit, int dataColor) {
        Collections.sort(result, new Comparator<HashMap<String, Object>>() {
            public int compare(HashMap<String, Object> o1, HashMap<String, Object> o2) {
                return -1 * ((Date) o1.get(dateField)).compareTo(((Date) o2.get(dateField)));
            }
        });
        Date[] date = new Date[result.size()];
        double[] values = new double[result.size()];

        double maxValue = Double.MIN_VALUE, minValue = Double.MAX_VALUE;
        for (int i = 0; i < result.size(); i++) {
            date[i] = (Date) result.get(i).get(dateField);
            if (result.get(i).get(valueField) != null)
                values[i] = ((Number) result.get(i).get(valueField)).doubleValue();

            if (values[i] > maxValue) maxValue = values[i];
            if (values[i] < minValue) minValue = values[i];
        }

        XYChart c = new XYChart(chartWidth, chartHeight, Chart.brushedSilverColor(), Chart.Transparent, 0);//0xE3E3E3

        c.setPlotArea(65, 15, chartWidth - 90, chartHeight - 40, 0xffffff, -1, Chart.Transparent, 0xc0c0c0, -1);

        c.yAxis().setTitle("<*font=黑体,size=12 *>" + yUnit + "<*/*>");
        /* if (result.size() > 0)
c.xAxis().setTitle("<*font=宋体,size=10 *>" + DateUtils.formatDate((Date) result.get(result.size() - 1).get(dateField), "yyyy-MM-dd") + " - " +
     result.get(0).get(dateField), "yyyy-MM-dd") + "<**///*>");*/
        LineLayer layer = c.addLineLayer2();
        layer.setLineWidth(2);
        if (date.length > 0)
            layer.setXData(date[0], date[date.length - 1]);
        c.xAxis().setLabelFormat("{value|m-d}");
        layer.addDataSet(values, dataColor).setDataSymbol(Chart.DiamondSymbol, 5);

        c.yAxis().setLinearScale(minValue, maxValue);//Y坐标的最小值和最大值

        return c;
    }

    //通用的XYChart,多条线
    public static XYChart createMultiXYChart(int chartWidth, int chartHeight, List<List<HashMap<String, Object>>> result, String valueField, final String dateField, String yUnit) {
        XYChart c = new XYChart(chartWidth, chartHeight, 0xfcfaff);
        c.setPlotArea(65, 20, chartWidth - 100, chartHeight - 60, 0xffffff, -1, -1, 0xc0c0c0, -1);
        c.yAxis().setTitle("<*font=宋体,size=10 *>" + yUnit + "<*/*>").setFontAngle(0);
        c.addLegend(60, 25, false, "宋体", 10).setBackground(Chart.Transparent);

        Date maxDate = null, minDate = null;
        double maxValue = Double.MIN_VALUE, minValue = Double.MAX_VALUE;

        for (List<HashMap<String, Object>> aList : result) {
            if (aList.size() == 0) continue;

            Collections.sort(aList, new Comparator<HashMap<String, Object>>() {
                public int compare(HashMap<String, Object> o1, HashMap<String, Object> o2) {
                    return ((Date) o1.get(dateField)).compareTo(((Date) o2.get(dateField)));
                }
            });
            Date[] date = new Date[aList.size()];
            double[] values = new double[aList.size()];
            for (int i = 0; i < aList.size(); i++) {
                date[i] = (Date) aList.get(i).get(dateField);
                if (aList.get(i).get(valueField) != null)
                    values[i] = ((Number) aList.get(i).get(valueField)).doubleValue();

                if (values[i] > maxValue) maxValue = values[i];
                if (values[i] < minValue) minValue = values[i];
            }

            if (maxDate == null || maxDate.before(date[aList.size() - 1]))
                maxDate = date[aList.size() - 1];
            if (minDate == null || minDate.after(date[0]))
                minDate = date[0];

            LineLayer layer = c.addLineLayer2();
            layer.setLineWidth(2);
            layer.setXData(date[0], date[date.length - 1]);
            layer.addDataSet(values, -1, "<*font=宋体,size=10 *>" + aList.get(0).get("chnName").toString() + "<*/*>");
        }
        c.xAxis().setLabelFormat("{value|m-d}");
        if (maxDate != null && minDate != null)
            c.xAxis().setTitle("<*font=宋体,size=10 *>" + DateUtils.formatDate(minDate, "yyyy-MM-dd") + " - " + DateUtils.formatDate(maxDate, "yyyy-MM-dd") + "<*/*>");
        c.yAxis().setLinearScale(minValue, maxValue);//Y坐标的最小值和最大值
        return c;
    }

    //通用的BarChart,Portal样式
    public static XYChart createBarChart(int chartWidth, int chartHeight, List<HashMap<String, Object>> result, String valueField, final String dateField, String yUnit, int dataColor) {
        Collections.sort(result, new Comparator<HashMap<String, Object>>() {
            public int compare(HashMap<String, Object> o1, HashMap<String, Object> o2) {
                return ((String) o1.get(dateField)).compareTo(((String) o2.get(dateField)));
            }
        });
        String[] items = new String[result.size()];
        double[] values = new double[result.size()];

        double maxValue = Double.MIN_VALUE, minValue = Double.MAX_VALUE;
        for (int i = 0; i < result.size(); i++) {
            items[i] = (String) result.get(i).get(dateField);
            if (result.get(i).get(valueField) != null)
                values[i] = ((Number) result.get(i).get(valueField)).doubleValue();
            if (values[i] > maxValue) maxValue = values[i];
            if (values[i] < minValue) minValue = values[i];
        }

        XYChart c = new XYChart(chartWidth, chartHeight, Chart.brushedSilverColor(), Chart.Transparent, 0);//0xE3E3E3

        c.setPlotArea(50, 20, chartWidth - 85, chartHeight - 45, -1, -1, Chart.Transparent, c.dashLineColor(0x888888, Chart.DashLine));

        c.yAxis().setTitle("<*font=黑体,size=12 *>" + yUnit + "<*/*>");
        //c.addBarLayer(values, dataColor).setBarShape();
        BarLayer bar = c.addBarLayer(values, dataColor);
        bar.setBarShape(Chart.CircleShape);
        bar.setAggregateLabelStyle();

        // Set the labels on the x axis.
        c.xAxis().setLabels(items);

        // Show the same scale on the left and right y-axes
        c.syncYAxis();
        // Set y-axes to transparent
        // c.yAxis().setColors(Chart.Transparent);
        c.yAxis2().setColors(Chart.Transparent);
        // Disable ticks on the x-axis by setting the tick color to transparent
        c.xAxis().setTickColor(Chart.Transparent);
        c.yAxis().setLinearScale(minValue, maxValue);//Y坐标的最小值和最大值

        return c;
    }

    //通用的BarChart，内页样式
    public static XYChart createBarChart2(int chartWidth, int chartHeight, List<HashMap<String, Object>> result, String valueField, final String dateField, String yUnit, int dataColor) {
        Collections.sort(result, new Comparator<HashMap<String, Object>>() {
            public int compare(HashMap<String, Object> o1, HashMap<String, Object> o2) {
                return ((String) o1.get(dateField)).compareTo(((String) o2.get(dateField)));
            }
        });
        String[] items = new String[result.size()];
        double[] values = new double[result.size()];

        double maxValue = Double.MIN_VALUE, minValue = Double.MAX_VALUE;
        for (int i = 0; i < result.size(); i++) {
            items[i] = (String) result.get(i).get(dateField);
            if (result.get(i).get(valueField) != null)
                values[i] = ((Number) result.get(i).get(valueField)).doubleValue();
            if (values[i] > maxValue) maxValue = values[i];
            if (values[i] < minValue) minValue = values[i];
        }

        XYChart c = new XYChart(chartWidth, chartHeight, 0xfcfaff);//0xE3E3E3

        c.setPlotArea(60, 20, chartWidth - 85, chartHeight - 45, -1, -1, Chart.Transparent);

        c.yAxis().setTitle("<*font=黑体,size=12 *>" + yUnit + "<*/*>");
        //c.addBarLayer(values, dataColor).setBarShape();
        BarLayer bar = c.addBarLayer(values, dataColor);
        bar.setBarShape(Chart.CircleShape);
        //在bar上显示具体数值
        //bar.setAggregateLabelStyle();

        // Set the labels on the x axis.
        c.xAxis().setLabels(items);

        // Set y-axes to transparent
        // c.yAxis().setColors(Chart.Transparent);
        c.yAxis2().setColors(Chart.Transparent);
        // Disable ticks on the x-axis by setting the tick color to transparent
        c.xAxis().setTickColor(Chart.Transparent);
        c.yAxis().setLinearScale(minValue, maxValue);//Y坐标的最小值和最大值

        return c;
    }

}
