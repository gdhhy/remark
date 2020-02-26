package com.zcreate.qrcode;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.util.StringUtils;
import org.apache.commons.dbcp.BasicDataSource;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created with IntelliJ IDEA.
 * User: hhy
 * Date: 13-5-17
 * Time: 下午2:36
 */
public class InstructionAuthCode {
    public static FileSystemXmlApplicationContext context;
    static int m1 = 0, m2 = 0, auth = 0;
    private Gson gson = new GsonBuilder().create();

    protected static void setLogDir() throws IOException {
        File log_dir = new File("logs");
        System.out.println("log dir = " + log_dir.getCanonicalPath());
        if (!log_dir.isDirectory()) {
            if (!log_dir.mkdirs()) return;
        }
        System.setProperty("LOG_DIR", "logs");
    }


    /*while (m.find()) {
        System.out.println("m.groupCount() = " + m.groupCount());
        for (int i = 0; i <= m.groupCount(); i++) System.out.println("m.group(" + i + ") = " + m.group(i));
        System.out.println();
    }
    m = regex1.matcher(s);*/
    public static String parseCorpname(String s) {
        String producer = "";
        //生产企业2471、生产厂商24、生产厂家：550、生产单位 23、生产厂66
        Pattern regex1 = Pattern.compile("(?<=公司名称|名称及地址|企业名称|厂家|生产厂商|生产厂|生产企业|生产单位)[:：\\]】\\s]\\s*" +
                "(?:公司名称：|名称：|企业名称：)?([\\u4E00-\\u9FA5()（）/^　]{2,30}|[a-zA-Z（）()\\-\\. &,／]{4,50})(?=$|\n|\t|\r|，|。|【|、|\\-\\-|——| 药| \\s)"); //2992、553 (?:\([\u4E00-\u9FA5]{2,10}\))?

        Matcher m = regex1.matcher(s);
       /* while (m.find()) {
            System.out.println("m.groupCount() = " + m.groupCount());
            for (int i = 0; i <= m.groupCount(); i++) System.out.println("m.group(" + i + ") = " + m.group(i));
            System.out.println();
        }
        m = regex1.matcher(s);*/
        while (m.find() && m.groupCount() > 0)
            if (m.group(1) != null && producer.length() < m.group(1).trim().length())
                producer = m.group(1).trim();

        if (!"".equals(producer)) {
            System.out.print("m1:" + (++m1));
            return producer;
        }
        // 1130、1115、524、949
      /*  Pattern regex2 = Pattern.compile("((?<=[ \\]　\n\r：:】])([\\u4E00-\\u9FA5]{4,25}(?:公司|厂)))|" +
                "((?<=[ \\]　\n\r：:】])([a-zA-Z（）()\\. ]{4,50}(?: Ltd[\\. ]| Inc[\\. ]| co[\\. ])))", Pattern.CASE_INSENSITIVE); //不用\\(\\) */
        Pattern regex2 = Pattern.compile("((?<=[\\s\\]　：:】])([\\u4E00-\\u9FA5()（）/]{4,30}?(?:公司|厂)))|" +//{4,30}?非贪婪
                "((?<=[\\s\\]　：:】])([a-zA-Z（）()\\. &,／]{4,50}(?: Ltd[\\.\\s]| Inc[\\.\\s]| Co[\\.\\s])))", Pattern.CASE_INSENSITIVE); //不用\\(\\)
        m = regex2.matcher(s);
        if (m.find() && m.groupCount() > 0) {
            if (m.group(0) != null)
                producer = m.group(0).trim();
        }

        if (!"".equals(producer))
            System.out.print("m2:" + (++m2));
        return producer;
    }

    public static String parseAuthCode(String s) {
        String authCode = "";
        Pattern regex1 = Pattern.compile("([a-zA-Z]\\d{8})");
        Matcher m = regex1.matcher(s);
        while (m.find() && m.groupCount() == 1)
            if (m.group(1) != null)
                authCode = m.group(1).trim();

     /*   if (!"".equals(authCode))
            System.out.print("A:" + (++auth));*/
        return authCode;
    }

    public static void parseInstruction() throws Exception {
        BasicDataSource source = (BasicDataSource) context.getBean("reviewDataSource");
        Connection conn = source.getConnection();
        Statement stmt = conn.createStatement();
        String updateSql = "update instruction set producer=?,authCode=? where instructionID=?";
        PreparedStatement pstmt = conn.prepareStatement(updateSql);
        String sql = "SELECT instructionID,instruction,authCode,producer FROM instruction";
        ResultSet rs = stmt.executeQuery(sql);
        int count = 0;
        while (rs.next()) {
            String instruction = rs.getString("instruction");
            if (instruction == null) continue;
            String ss = StringUtils.replaceHtml2(instruction.replaceAll("<br>|<br/>|<br />|<p>|</p>", "\n"));
            String producer = parseCorpname(ss);
            String authCode = parseAuthCode(ss);

            if (producer.length() > 0 || authCode.length() > 0) {
                count++;
                System.out.println(", producer:" + producer + ",authCode:" + authCode);
                pstmt.setString(1, producer);
                pstmt.setString(2, authCode);
                pstmt.setInt(3, rs.getInt("instructionID"));
                pstmt.execute();
            }

        }
        System.out.println("识别总数：" + count);
        rs.close();
        stmt.close();
        pstmt.close();
        conn.close();
    }

    //main数，开启服务器
    public static void main(String a[]) throws Exception {
        setLogDir();
        String ss[] = {
                "【制 造 商】asdf公司<br/>",
                "【零售价格】198元/支<br/>【生产单位】日本三菱制药株式会社 <br/>",
                "<br/><br/>公司名称及地址：<br/>Solvay Pharmaceuticals B.V.<br/>C.J.Van Houtenlaan 36,138 CP Weesp,The Netherlands荷兰<br/><br/>生产厂名称及地址：<br/>Solvay Pharmaceuticals B.V.<br/>Veerweg 12,8121 AA Olst,The Netherlands荷兰<br/><br/>"
        };
        int i = 1;
        for (String s : ss) {
            System.out.println("------------------");
            String aa = StringUtils.replaceHtml2(s);
            //System.out.println(aa);
            //System.out.println("s = " + parseAuthCode(s));
            System.out.println("corpname " + i++ + "=====" + parseCorpname(aa));
        }

        context = new FileSystemXmlApplicationContext("application-review-qrcode.xml");
        parseInstruction();
    }
}