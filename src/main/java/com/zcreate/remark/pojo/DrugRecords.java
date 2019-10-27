package com.zcreate.remark.pojo;

/*
 drID int   ,--lydmx_id
                                 recordID int ,--lydno
                                 drugstore varchar(20),--药房
                                 dispensingDate datetime ,--发药日期
                                 patientName varchar(30),--病人姓名
                                 dispensingNo varchar(20),--发药ID
                                 invoiceNo varchar(20),--发票号
                                 department varchar(20),--科室
                                 age float,
                                 clinicType varchar(10),--门诊类型：急诊、儿科、麻、精一
                                 goodsID int ,
                                 goodsNo varchar(11) ,
                                 unit varchar(10),
                                 spec varchar(30),
                                 quantity numeric(15,4),
                                 price decimal(15,2),
                                 amount numeric(15,4),
                                 doctorName varchar(30),--
                                 adviceType varchar(30),--静滴、肌注静注
                                 valid tinyint
 */
public class DrugRecords {
    private int recordID;
    private String drugstore;
    private String dispensingDate;
    private String patientName;
    private String dispensingNo;
    private String invoiceNo;
    private String department;
    private float age;
    private String clinicType;
    private int goodsID;
    private String goodsNo;
    private String unit;
    private String spec;
    private float quantity;
    private float price;
    private double amount;
    private String doctorName;
    private String adviceType;
    private int valid;

}
