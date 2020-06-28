<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<!-- basic styles -->
<link href="../components/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet"/>

<!-- text fonts -->
<link rel="stylesheet" href="../assets/css/ace-fonts.css"/>
<!-- page specific plugin styles -->
<!-- ace styles -->
<link rel="stylesheet" href="../assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/>
<!--重要-->
<link rel="stylesheet" href="../assets/css/ace-skins.min.css"/>


<link rel="stylesheet" href="../components/jquery-ui/jquery-ui.min.css"/>
<link rel="stylesheet" href="../components/jquery-ui.custom/jquery-ui.custom.css"/>
<link rel="stylesheet" href="../components/datatables/select.dataTables.min.css"/>
<link rel="stylesheet" href="../components/bootstrap-datepicker/css/bootstrap-datepicker3.css"/>
<link rel="stylesheet" href="../components/bootstrap-timepicker/css/bootstrap-timepicker.css"/>
<link rel="stylesheet" href="../components/bootstrap-daterangepicker/daterangepicker.css"/>
<link rel="stylesheet" href="../components/bootstrap-datetimepicker/bootstrap-datetimepicker.css"/>
<link rel="stylesheet" href="../assets/css/bootstrap-editable.css"/>
<link rel="stylesheet" href="../components/datatables/select.dataTables.css"/>

<!-- basic scripts -->
<script src="../js/jquery-1.12.4.min.js"></script>
<script src="../js/bootstrap.min.js"></script>

<!-- ace scripts -->
<%--<script src="../assets/js/src/elements.scroller.js"></script>--%>
<script src="../assets/js/ace.js"></script>
<script src="../assets/js/ace-elements.js"></script>
<script src="../assets/js/src/ace.widget-box.js"></script>
<!-- ace settings handler -->
<script src="../assets/js/ace-extra.js"></script>

<!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->
<!--[if lte IE 8]>
<script src="../components/html5shiv/dist/html5shiv.js"></script>
<script src="../components/respond/dest/respond.min.js"></script>
<![endif]-->

<!-- page specific plugin scripts -->
<!-- static.html end-->
<%--<script src="../components/jquery-ui.custom/jquery-ui.custom.js"></script>--%>
<script src="../components/datatables/jquery.dataTables.min.js"></script>
<%--<link rel="stylesheet" href="../components/chosen/chosen.css" />--%>

<script src="../components/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script src="../components/moment/moment.min.js"></script>
<script src="../components/bootstrap-datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script src="../components/datatables/jquery.dataTables.bootstrap.min.js"></script>
<script src="../components/datatables/dataTables.select.min.js"></script>
<script src="../components/jquery-ui/jquery-ui.min.js"></script>
<script src="../components/typeahead.js/handlebars.js"></script>
<script src="../assets/js/x-editable/bootstrap-editable.min.js"></script>

<script src="../js/string_func.js"></script>
<style type="text/css">
    .modal-dialog {
        position: absolute;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
    }

    .modal-content {
        /*overflow-y: scroll; */
        position: absolute;
        top: 0;
        bottom: 0;
        width: 100%;
    }

    .modal-body {
        overflow-y: scroll;
        position: absolute;
        top: 38px;
        bottom: 65px;
        width: 100%;
    }

    .modal-body2 {
        overflow-y: scroll;
        position: absolute;
        top: 38px;
        bottom: 0;
        width: 100%;
    }

    .modal-header .close {
        margin-right: 15px;
    }

    .modal-footer {
        position: absolute;
        width: 100%;
        bottom: 0;
    }

    .dropdown-preview {
        margin: 0 5px;
        display: inline-block;
    }

    .dropdown-preview > .dropdown-menu {
        display: block;
        position: static;
        margin-bottom: 5px;
    }
</style>

<script type="text/javascript">
    jQuery(function ($) {
        var inPatientID = '${inPatient.inPatientID}';
        /* if (inPatientID === '') {
             showDialog("加载失败", "请检查数据或联系系统开发！");
             return;
         }*/
        var saveJson = JSON.parse('${inPatient.review.reviewJson}'.replace('\n', '\\n'));
        //var saveJson = JSON.parse('{"inPatientID":"1251","hospID":"2623","inPatientReviewID":"8904","reviewUser":"陈会玲","masterDoctor":"陈国优","基本情况":{"sex":"女","age":"69","weight":"","inHospital":"2020年03月12日","outHospital":"2020年03月19日"},"诊断":[{"diagnosisNo":"19808","type":"住院诊断","disease":"急性上消化道出血"},{"diagnosisNo":"22259","type":"住院诊断","disease":"十二指肠溃疡"},{"diagnosisNo":"22260","type":"住院诊断","disease":"重度贫血"},{"diagnosisNo":"22261","type":"住院诊断","disease":"幽门螺旋杆菌感染"},{"diagnosisNo":"22262","type":"住院诊断","disease":"肾结石"},{"diagnosisNo":"22263","type":"住院诊断","disease":"肝囊肿"},{"diagnosisNo":"22264","type":"住院诊断","disease":"脂肪肝"}],"细菌培养和药敏":{"micro":false,"micro_time":"","sample":"","germName":"","sensitiveDrug":""},"围手术期用药":{"incision":0,"surgery":false,"surgeryName":"","startTime":"","lastTime":"","beforeDrug":"0","afterDrug":"0","surgeryAppend":false},"长嘱":[],"临嘱":[],"用药情况":{"symptom":"","symptom2":""},"点评":{"review":"刘昌海：肾功能不全选用药物不适宜。患者年龄68岁，肌酐247umol/L，体重45kg，肌酐清除率为13.64ml/min，使用二甲双胍、阿卡波糖、双氯芬酸钠不适宜。肌酐清除率＜45ml/min禁用，肌酐清除率＜25ml/min禁用，晚期肾脏病避免使用双氯芬酸钠。\\n2、肾功能减退未按照肌酐清除率调整剂量不适宜。患者肌酐清除率为13.64ml/min，使用阿莫西林克拉维酸钾1.2g q8h不适宜，根据《国家抗微生物指南》肌酐清除率10~30ml/min时阿莫西林克拉维酸钾首剂1.2g 维持0.6g q12h","rational":"2"},"reviewType":0}');
        //左侧用药情况
        var longDrugTb = $('#longDrugTb').DataTable({
            bAutoWidth: false,
            language: {info: '', infoEmpty: '', sZeroRecords: '', emptyTable: ''},
            paging: false, searching: false, ordering: false, "destroy": true,
            'columnDefs': [
                {
                    "orderable": false, "data": "advice", "targets": 0, width: 100, title: '医嘱内容', render: function (data, type, row, meta) {
                        return data + (typeof (row["menstruum"]) === 'undefined' ? "" : "<br/><span class=\"light-grey\">溶剂</span>" + row["menstruum"]);
                    }
                },
                {
                    "orderable": false, "data": "adviceType", "targets": 1, width: 80, title: '用法', className: 'center', render: function (data, type, row, meta) {
                        return '<a href="#" data-value="{0}" data-type="text" >{1}</a>'.format(data, data);
                    }
                },
                {
                    "orderable": false, "data": "quantity", "targets": 2, width: 40, title: '数量', className: 'center', render: function (data, type, row, meta) {
                        return '<a href="#" data-value="{0}" data-type="text" >{1}</a>'.format(data, data);
                    }
                },
                {
                    "orderable": false, "data": "adviceDate", "targets": 3, width: 80, title: '起止时间', render: function (data, type, row, meta) {
                        return '<a href="#" data-value="{0}" data-type="text" >{1}</a>'.format(data, data);
                    }
                },
                {
                    "orderable": false, "data": "question", "targets": 4, width: 40, title: '问题', className: 'center', render: function (data, type, row, meta) {
                        return '<a href="#" id="question" data-value="{0}" data-type="text">{1}</a>'.format(data, data === '' ? '设置' : data);
                    }
                }
            ]

        });

        longDrugTb.on('draw', function (e, setting) {
            $("#longDrugTb tr").find("td a[id!='question']").editable();
            $("#longDrugTb tr").find("td a[id='question']").on('click', function () {
                showQuestionDialog(this, '#longDrugTb', $(this).parent().parent().prevAll().length);
                //$(this).text('4a');
            });
        });
        var shortDrugTb = $('#shortDrugTb').DataTable({
            bAutoWidth: false,
            language: {info: '', infoEmpty: '', sZeroRecords: '', emptyTable: ''},
            paging: false, searching: false, ordering: false, "destroy": true,
            'columnDefs': [
                {
                    "orderable": false, "data": "advice", "targets": 0, width: 100, title: '医嘱内容', render: function (data, type, row, meta) {
                        return data + (typeof (row["menstruum"]) === 'undefined' ? "" : "<br/><span class=\"light-grey\">溶剂</span>" + row["menstruum"]);
                    }
                },
                {
                    "orderable": false, "data": "adviceType", "targets": 1, width: 80, title: '用法', className: 'center', render: function (data, type, row, meta) {
                        return '<a href="#" data-value="{0}" >{1}</a>'.format(data, data);
                    }
                },
                {
                    "orderable": false, "data": "quantity", "targets": 2, width: 40, title: '数量', className: 'center', render: function (data, type, row, meta) {
                        return '<a href="#" data-value="{0}" data-type="text" >{1}</a>'.format(data, data);
                    }
                },
                {
                    "orderable": false, "data": "adviceDate", "targets": 3, width: 80, title: '起止时间', render: function (data, type, row, meta) {
                        return '<a href="#" data-value="{0}" data-type="text" >{1}</a>'.format(data, data);
                    }
                },
                {
                    "orderable": false, "data": "question", "targets": 4, width: 40, title: '问题', className: 'center', render: function (data, type, row, meta) {
                        return '<a href="#" id="question" data-value="{0}" data-type="text">{1}</a>'.format(data, data === '' ? '设置' : data);
                    }
                }
            ]

        });
        shortDrugTb.on('draw', function (e, setting) {
            $("#shortDrugTb tr").find("td a[id!='question']").editable();

            $("#shortDrugTb tr").find("td a[id='question']").on('click', function () {
                //$(this).parent().prevAll().length + 1;//行号
                showQuestionDialog(this, '#shortDrugTb', $(this).parent().parent().prevAll().length);
                //$(this).text('asdfasf');
            });
        });

        function chooseTab(tabId) {
            //$('#myTab3 a[href="' + tabId + '"]').parent().tab('show');
            /* $('#myTab3 li').removeClass("active");
            $('#myTab3 a[href="' + tabId + '"]').parent().addClass("active");
            $("#divTab1 div").removeClass("active");
            $(tabId).addClass("active");*/
        }


        /*  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
              //当切换tab时，强制重新计算列宽
              $.fn.dataTable.tables({visible: true, api: true}).columns.adjust().draw();
          });*/


        // scrollables
        $('.scrollable').each(function () {
            var $this = $(this);
            $(this).ace_scroll({
                size: $this.attr('data-size') || 100,
                //styleClass: 'scroll-left scroll-margin scroll-thin scroll-dark scroll-light no-track scroll-visible'
            });
        });
        $('.scrollable-horizontal').each(function () {
            var $this = $(this);
            $(this).ace_scroll(
                {
                    horizontal: true,
                    styleClass: 'scroll-top',//show the scrollbars on top(default is bottom)
                    size: $this.attr('data-size') || 500,
                    mouseWheelLock: true
                }
            ).css({'padding-top': 12});
        });

        $(window).on('resize.scroll_reset', function () {
            $('.scrollable-horizontal').ace_scroll('reset');
        });
        //datepicker plugin
        //link
        $('.date-picker').datepicker({
            autoclose: true,
            format: "yyyy-mm-dd", //选择日期后，文本框显示的日期格式
            language: 'zh-CN', //汉化
            todayHighlight: true
        })
        //show datepicker when clicking on the icon
            .next().on(ace.click_event, function () {
            $(this).prev().focus();
        });


        if (!ace.vars['old_ie']) $('#form-field-surgeryTime').datetimepicker({
            //format: 'MM/DD/YYYY h:mm:ss A',//use this option to display seconds
            //language: 'zh-CN',
            icons: {
                time: 'fa fa-clock-o',
                date: 'fa fa-calendar',
                up: 'fa fa-chevron-up',
                down: 'fa fa-chevron-down',
                previous: 'fa fa-chevron-left',
                next: 'fa fa-chevron-right',
                today: 'fa fa-arrows ',
                clear: 'fa fa-trash',
                close: 'fa fa-times'
            }
        }).next().on(ace.click_event, function () {
            $(this).prev().focus();
        });

        //导出
        $('.btn-info').on('click', function (e) {
            window.location.href = "getInPatientExcel0.jspa?inPatientID=${inPatient.inPatientID}";
        });

        var json = {
            inPatientID: '${inPatient.inPatientID}', hospID: '${inPatient.hospID}', inPatientReviewID: '${inPatient.review.inPatientReviewID}',
            reviewUser: '${currentUser.name}', masterDoctor: '${inPatient.masterDoctorName}'
        };
        //保存
        $('.btn-success').on('click', function (e) {
            var baseInfo = {};

            baseInfo.sex = $('input:radio[name="form-field-radio-sex"]:checked').val();
            baseInfo.age = $('#form-field-age').val();
            baseInfo.weight = $('#form-field-weight').val();
            baseInfo.inHospital = $('#id-date-picker-inHospital').val();
            baseInfo.outHospital = $('#id-date-picker-outHospital').val();
            json.基本情况 = baseInfo;

            var diagnosis = [];
            $("#chooseDiagnosis tr:gt(0)").each(function (i, item) {
                //if ($(item).attr("data-id") !== null) {
                diagnosis.push({"diagnosisNo": $(item).attr("data-id"), "type": $(item).find("td:eq(0)").text(), "disease": $(item).find("td:eq(1)").text()});
                //}
            });
            json.诊断 = diagnosis;


            var lab = {micro: false};

            lab.micro = $('input:radio[name="form-field-micro"]:checked').val() == null ? false : $('input:radio[name="form-field-micro"]:checked').val();
            lab.micro_time = $('#micro_time').val();
            lab.sample = $('#form-field-sample').val();
            lab.germName = $('#form-field-germName').val();
            lab.sensitiveDrug = $('#form-field-sensitiveDrug').val();
            json.细菌培养和药敏 = lab;


            <c:if test="${inPatient.surgery==1}">
            var surgery = {incision: 0};

            surgery.surgery = $("input[name='form-field-surgery']").is(':checked');
            surgery.surgeryName = $('#form-field-surgeryName').val();
            surgery.startTime = $('#form-field-surgeryTime').val();
            surgery.lastTime = $('#form-field-lastTime').val();
            surgery.beforeDrug = $("input:radio[name='form-field-beforeDrug']:checked").val() == null ? 0 : $('input:radio[name="form-field-beforeDrug"]:checked').val();
            surgery.afterDrug = $("input:radio[name='form-field-afterDrug']:checked").val() == null ? 0 : $('input:radio[name="form-field-afterDrug"]:checked').val();
            surgery.surgeryAppend = $("input[name='form-field-surgeryAppend']").is(':checked');                //术中追加
            $("input:checkbox[name='form-field-incision']:checked").each(function () {
                surgery.incision += parseInt($(this).val());
            });

            json.围手术期用药 = surgery;
            </c:if>

            var drug = [];
            longDrugTb.rows().every(function (rowIdx, tableLoop, rowLoop) {
                if (typeof (this.data()) !== 'undefined') {
                    var trRow = $("#longDrugTb tbody tr").eq(rowIdx);
                    drug.push({
                        "adviceItemID": this.data()["adviceItemID"],
                        "advice": this.data()["advice"],
                        "adviceType": trRow.find("td:eq(1)").text(),
                        "quantity": trRow.find("td:eq(2)").text(),
                        "adviceDate": trRow.find("td:eq(3)").text(),
                        "question": trRow.find("td:eq(4)").text(),
                        "medicineNo": this.data()["medicineNo"]
                    });
                }
            });
            json.长嘱 = drug;
            var drug2 = [];
            shortDrugTb.rows().every(function (rowIdx, tableLoop, rowLoop) {
                if (typeof (this.data()) !== 'undefined') {
                    var trRow = $("#shortDrugTb tbody tr").eq(rowIdx);
                    //console.log("eq3:" + trRow.find["td:eq(3)"]);
                    drug2.push({
                        "adviceItemID": this.data()["adviceItemID"],
                        "advice": this.data()["advice"],
                        "adviceType": trRow.find("td:eq(1)").text(),
                        "quantity": trRow.find("td:eq(2)").text(),
                        "question": trRow.find("td:eq(4)").text(),
                        "adviceDate": trRow.find("td:eq(3)").text(),
                        "medicineNo": this.data()["medicineNo"]
                    });
                }
            });
            json.临嘱 = drug2;

            var drugInfo = {};
            drugInfo.symptom = $('#form-field-symptom').val();
            drugInfo.symptom2 = $('#form-field-symptom2').val();
            json.用药情况 = drugInfo;

            var review = {};
            review.review = $('#form-field-review').val();
            review.rational = $("input[name='form-field-rational']:checked").val();
            json.点评 = review;
            json.reviewType = 0;
            $.ajax({
                type: "POST",
                url: 'saveInPatient.jspa',
                data: JSON.stringify(json),
                contentType: "application/json; charset=utf-8",
                cache: false,
                success: function (response, textStatus) {
                    showDialog(response.succeed ? "保存成功" : "保存失败", response.message);
                    if (response.succeed) {
                        $('.btn-info').removeClass("hidden");
                        json.inPatientReviewID = response.inPatientReviewID;
                    }
                },
                error: function (response, textStatus) {/*能够接收404,500等错误*/
                    showDialog("请求状态码：" + response.status, response.responseText);
                },
            });
        });


        function fillout() {
            if (typeof (saveJson.基本情况) === 'undefined')
                return;
            $('.btn-info').removeClass("hidden");

            //基本情况
            $('input:radio[name="form-field-radio-sex"][value="' + saveJson.基本情况.sex + '"]').prop("checked", "checked");
            $('#form-field-age').val(saveJson.基本情况.age);
            $('#form-field-weight').val(saveJson.基本情况.weight);
            $('#id-date-picker-inHospital').val(saveJson.基本情况.inHospital);
            $('#id-date-picker-outHospital').val(saveJson.基本情况.outHospital);

            for (var i = 0; i < saveJson.诊断.length; i++)
                $("#chooseDiagnosis tr:last").after(Handlebars.compile("<tr data-id='{{diagnosisNo}}'><td>{{type}}</td><td>{{disease}}</td></tr>")(saveJson.诊断[i]));

            $('input:radio[name="form-field-micro"][value="' + saveJson.细菌培养和药敏.micro + '"]').prop("checked", "checked");
            $('#micro_time').val(saveJson.细菌培养和药敏.micro_time);
            $('#form-field-sample').val(saveJson.细菌培养和药敏.sample);
            $('#form-field-germName').val(saveJson.细菌培养和药敏.germName);
            $('#form-field-sensitiveDrug').val(saveJson.细菌培养和药敏.sensitiveDrug);

            <c:if test="${inPatient.surgery==1}">
            $('input:checkbox[name="form-field-surgery"]').prop("checked", saveJson.围手术期用药.surgery);
            $('#form-field-surgeryName').val(saveJson.围手术期用药.surgeryName);
            $('#form-field-surgeryTime').val(saveJson.围手术期用药.startTime);
            $('#form-field-lastTime').val(saveJson.围手术期用药.lastTime);
            $("input:checkbox[name='form-field-incision']").each(function () {
                $(this).attr("checked", (saveJson.围手术期用药.incision & $(this).val()) === parseInt($(this).val()));
            });
            $("input:radio[name='form-field-beforeDrug']").each(function () {
                $(this).attr("checked", (saveJson.围手术期用药.beforeDrug & $(this).val()) === parseInt($(this).val()));
            });
            $("input:radio[name='form-field-afterDrug']").each(function () {
                $(this).attr("checked", (saveJson.围手术期用药.afterDrug & $(this).val()) === parseInt($(this).val()));
            });
            $("input:radio[name='form-field-surgeryAppend']").attr("checked", saveJson.围手术期用药.surgeryAppend);
            </c:if>


            for (i = 0; i < saveJson.长嘱.length; i++)
                longDrugTb.row.add(saveJson.长嘱[i]).draw(false);
            for (i = 0; i < saveJson.临嘱.length; i++)
                shortDrugTb.row.add(saveJson.临嘱[i]).draw(false);
            $('#form-field-symptom').val(saveJson.用药情况.symptom);
            $('#form-field-symptom2').val(saveJson.用药情况.symptom2);

            $('#form-field-review').val(saveJson.点评.review);
            $("input:radio[name='form-field-rational']").each(function () {
                $(this).attr("checked", (saveJson.点评.rational & $(this).val()) === parseInt($(this).val()));
            });
        }

        fillout();

        //todo 统一到一个对话框
        function showDialog(title, content) {
            $("#errorText").html(content);
            $("#dialog-error").removeClass('hide').dialog({
                modal: true,
                width: 600,
                title: title,
                buttons: [{
                    text: "确定", "class": "btn btn-primary btn-xs", click: function () {
                        $(this).dialog("close");
                    }
                }]
            });
        }


    })
</script>
<!-- #section:basics/content.breadcrumbs -->
<div class="breadcrumbs ace-save-state" id="breadcrumbs">
    <ul class="breadcrumb">
        <li>
            <i class="ace-icon fa fa-home home-icon"></i>
            <a href="/index.jspa">首页</a>
        </li>
        <li class="active">传染病报告卡</li>
    </ul><!-- /.breadcrumb -->


    <!-- /section:basics/content.searchbox -->
</div>

<!-- /section:basics/content.breadcrumbs -->
<div class="page-content" style="width: 980px">
    <div class="row">
        <div class="col-sm-12">
            <%--<h3 class="header smaller lighter red">点评</h3>--%>
            <h4 class="header smaller lighter blue">不良反应事件报告
                <span class="light-grey smaller-50">填写人：${currentUser.name}</span>
                <div class="pull-right">
                    <button type="button" class="btn btn-sm btn-info hidden">
                        导出
                        <i class="ace-icon fa fa-file-excel-o icon-on-right bigger-110"></i>
                    </button>&nbsp;
                    <button type="button" class="btn btn-sm btn-success">
                        保存
                        <i class="ace-icon fa fa-save icon-on-right bigger-110"></i>
                    </button>
                </div>
            </h4>

            <form id="inPatientForm">
                <!-- #section:elements.tab.position -->
                <div class="tabbable tabs-left">
                    <ul class="nav nav-tabs" id="myTab3">
                        <li><a data-toggle="tab" href="#dropdown3">报告信息</a></li>
                        <li><a data-toggle="tab" href="#dropdown23">患者资料</a></li>
                        <li><a data-toggle="tab" href="#dropdown24">事件描述</a></li>

                        <li class="active"><a data-toggle="tab" href="#dropdown17">用药情况</a></li>
                        <li><a data-toggle="tab" href="#dropdown21">结果评价</a></li>
                    </ul>

                    <div class="tab-content" id="divTab1">
                        <div id="dropdown3" class="tab-pane">
                            <div class="well well-sm" style="height: 200px">
                                <div class="control-group row">
                                    <div class="col-xs-6">
                                        <input name="form-field-radio-first" type="radio" class="ace" value="首次报告"/>
                                        <span class="lbl">首次报告</span>
                                        <input name="form-field-radio-first" type="radio" class="ace" value="跟踪报告"/>
                                        <span class="lbl">跟踪报告</span>
                                    </div>
                                    <div class="col-xs-6">
                                        <label class="control-label" for="form-field-reportNo" style="text-overflow:ellipsis; white-space:nowrap;">编码：</label>
                                        <input type="text" id="form-field-reportNo" placeholder="编码" class="no-padding" style="width: 180px "/>
                                    </div>
                                </div>
                                <div class="control-group col-xs-12" style="margin-top: 10px;">
                                    <span class="lbl">报告类型：</span>
                                    <input name="form-field-radio-reportType" type="radio" class="ace" value="新的"/>
                                    <span class="lbl">新的</span>
                                    <input name="form-field-radio-reportType" type="radio" class="ace" value="严重"/>
                                    <span class="lbl">严重</span>
                                    <input name="form-field-radio-reportType" type="radio" class="ace" value="一般"/>
                                    <span class="lbl">一般</span>
                                </div>
                                <div class="control-group col-xs-12" style="margin-top: 10px;">
                                    <span class="lbl">报告单位类别：</span>
                                    <input name="form-field-radio-unitType" type="radio" class="ace" checked value="医疗机构"/>
                                    <span class="lbl">医疗机构</span><span class="space-4"></span>
                                    <input name="form-field-radio-unitType" type="radio" class="ace" value="经营企业"/>
                                    <span class="lbl">经营企业</span><span class="space-4"></span>
                                    <input name="form-field-radio-unitType" type="radio" class="ace" value="生产企业"/>
                                    <span class="lbl">生产企业</span><span class="space-4"></span>
                                    <input name="form-field-radio-unitType" type="radio" class="ace" value="个人"/>
                                    <span class="lbl">个人</span>
                                </div>
                                <div class=" col-xs-12" style="margin-top: 10px;">
                                    <div class="form-inline col-xs-4 no-padding no-margin">
                                        <label class="control-label" for="form-field-reportDepart" style="text-overflow:ellipsis; white-space:nowrap;">报告科室：</label>
                                        <input type="text" id="form-field-reportDepart" placeholder="报告科室" class="no-padding" style="width: 180px"/>
                                    </div>
                                    <div class="form-inline col-xs-4 no-padding no-margin control-group ">
                                        <label class="control-label" for="form-field-reportNo" style="text-overflow:ellipsis; white-space:nowrap;">报告日期：</label>
                                        <div class="input-group">
                                            <input class="date-picker no-padding" style="width: 110px" id="id-date-picker-reportDate" type="text"
                                                   data-date-format="YYYY年MM月DD日" pattern='yyyy年MM月dd日'/>
                                            <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                        </div>
                                    </div>
                                    <div class="form-inline col-xs-4 no-padding no-margin">
                                        <label class="control-label" for="form-field-reportTel" style="text-overflow:ellipsis; white-space:nowrap;">科室电话：</label>
                                        <input type="text" id="form-field-reportTel" placeholder="科室电话" class="no-padding" style="width: 180px"/>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <div id="dropdown23" class="tab-pane">
                            <div class="well well-sm" style="height: 270px">
                                <div class="col-xs-12" style="margin-top: 10px;">
                                    <div class="form-inline col-xs-6 no-padding no-margin">
                                        <label class="control-label" for="form-field-patientName" style="text-overflow:ellipsis; white-space:nowrap;">患者姓名：</label>
                                        <input type="text" id="form-field-patientName" placeholder="患者姓名" class="no-padding" style="width: 100px"/>
                                    </div>

                                    <div class="form-inline col-xs-6 no-padding no-margin">
                                        <label class="control-label" for="form-field-patientNo" style="text-overflow:ellipsis; white-space:nowrap;">门诊/病历号：</label>
                                        <input type="text" id="form-field-patientNo" placeholder="门诊/病历号" class="no-padding" style="width: 180px"/>
                                    </div>
                                </div>

                                <div class="col-xs-12" style="margin-top: 10px;">
                                    <div class="form-inline col-xs-6 no-padding no-margin">
                                        <span class="lbl">性别：</span>
                                        <input name="form-field-radio-unitType" type="radio" class="ace" checked value="男"/>
                                        <span class="lbl">男</span><span class="space-4"></span>
                                        <input name="form-field-radio-unitType" type="radio" class="ace" value="女"/>
                                        <span class="lbl">女</span>
                                    </div>
                                    <div class="form-inline col-xs-6 no-padding no-margin">
                                        <label class="control-label" for="id-date-picker-birthdate" style="text-overflow:ellipsis; white-space:nowrap;">出生日期 </label>
                                        <div class="input-group">
                                            <input class="date-picker no-padding" style="width: 110px" id="id-date-picker-birthdate" type="text"
                                                   data-date-format="YYYY年MM月DD日" pattern='yyyy年MM月dd日'/>
                                            <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-xs-12" style="margin-top: 10px;">
                                    <div class="form-inline col-xs-4 no-padding no-margin">
                                        <label class="control-label" for="form-field-national" style="text-overflow:ellipsis; white-space:nowrap;">民族</label>
                                        <input type="text" id="form-field-national" placeholder="民族" class="no-padding" style="width: 100px"/>
                                    </div>
                                    <div class="form-inline col-xs-4 no-padding no-margin">
                                        <label class="control-label" for="form-field-weight" style="text-overflow:ellipsis; white-space:nowrap;">体重</label>
                                        <input type="text" id="form-field-weight" placeholder="kg" class="no-padding" style="width: 60px;text-align: center"/>
                                        <label class="control-label" for="form-field-weight" style="text-overflow:ellipsis; white-space:nowrap;">kg</label>
                                    </div>
                                    <div class="form-inline col-xs-4 no-padding no-margin">
                                        <label class="control-label" for="form-field-patientTel" style="text-overflow:ellipsis; white-space:nowrap;">电话</label>
                                        <input type="text" id="form-field-patientTel" placeholder="电话" class="no-padding" style="width: 100px"/>
                                    </div>
                                </div>
                                <div class="col-xs-12" style="margin-top: 10px;">
                                    <span class="control-label col-xs-3">家族药品不良反应：</span>
                                    <input name="form-field-radio-famaily" type="radio" class="ace" checked value="有"/>
                                    <span class="lbl">有</span>
                                    <input type="text" id="form-field-famaily2" placeholder="家族药品不良反应" class="no-padding" style="width: 180px"/>
                                    <input name="form-field-radio-famaily" type="radio" class="ace" value="无"/>
                                    <span class="lbl">无</span><span class="space-4"></span>
                                    <input name="form-field-radio-famaily" type="radio" class="ace" value="不详"/>
                                    <span class="lbl">不详</span>
                                </div>
                                <div class="col-xs-12" style="margin-top: 10px;">
                                    <span class="control-label  col-xs-3">患者既往药品不良反应：</span>
                                    <input name="form-field-radio-patientHis" type="radio" class="ace" checked value="有"/>
                                    <span class="lbl">有</span>
                                    <input type="text" id="form-field-patientHis2" placeholder="患者既往药品不良反应" class="no-padding" style="width: 180px"/>
                                    <input name="form-field-radio-patientHis" type="radio" class="ace" value="无"/>
                                    <span class="lbl">无</span><span class="space-4"></span>
                                    <input name="form-field-radio-patientHis" type="radio" class="ace" value="不详"/>
                                    <span class="lbl">不详</span>
                                </div>
                                <div class="control-group col-xs-12" style="margin-top: 10px;">
                                    <span class="lbl">相关重要信息：</span>
                                    <input name="form-field-radio-important" type="checkbox" class="ace" checked value="吸烟史"/>
                                    <span class="lbl">吸烟史</span><span class="space-4"></span>
                                    <input name="form-field-radio-important" type="checkbox" class="ace" value="饮酒史"/>
                                    <span class="lbl">饮酒史</span><span class="space-4"></span>
                                    <input name="form-field-radio-important" type="checkbox" class="ace" value="妊娠期"/>
                                    <span class="lbl">妊娠期</span><span class="space-4"></span>
                                    <input name="form-field-radio-important" type="checkbox" class="ace" value="肝病史"/>
                                    <span class="lbl">肝病史</span><span class="space-4"></span>
                                    <input name="form-field-radio-important" type="checkbox" class="ace" value="肾病史"/>
                                    <span class="lbl">肾病史</span><span class="space-4"></span>
                                    <input name="form-field-radio-important" type="checkbox" class="ace" value="过敏史"/>
                                    <span class="lbl">过敏史</span><span class="space-4"></span>
                                    <input type="text" id="form-field-important" placeholder="过敏史" class="no-padding" style="width: 120px"/>

                                    <input name="form-field-radio-important" type="checkbox" class="ace" value="其他"/>
                                    <span class="lbl">其他</span><span class="space-4"></span>
                                    <input type="text" id="form-field-important2" placeholder="其他" class="no-padding" style="width: 120px"/>
                                </div>
                            </div>
                        </div>
                        <div id="dropdown24" class="tab-pane">
                            <div class="well well-sm" style="height: 480px">
                                <div class=" col-xs-12" style="margin-top: 10px;">
                                    <div class="form-inline col-xs-6 no-padding no-margin">
                                        <label class="control-label" for="form-field-eventName" style="text-overflow:ellipsis; white-space:nowrap;">不良反应/事件名称：</label>
                                        <input type="text" id="form-field-eventName" placeholder="不良反应/事件名称" class="no-padding"/>
                                    </div>
                                    <div class="form-inline col-xs-6 no-padding no-margin control-group ">
                                        <label class="control-label" for="id-date-picker-eventTime" style="text-overflow:ellipsis; white-space:nowrap;">不良反应发生时间：</label>
                                        <div class="input-group">
                                            <input class="date-picker no-padding" style="width: 110px" id="id-date-picker-eventTime" type="text"
                                                   data-date-format="YYYY年MM月DD日" pattern='yyyy年MM月dd日'/>
                                            <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xs-12" style="margin-top: 5px;">
                                    <label class="control-label" for="form-field-cause" style="text-overflow:ellipsis; white-space:nowrap;">不良反应描述：患者因（用药原因）</label>
                                    <input type="text" id="form-field-cause" placeholder="症状" class="no-padding" style="width: 380px"/>
                                </div>
                                <div class=" col-xs-12" style="margin-top: 5px;">
                                    <label class="control-label" for="form-field-useTime" style="text-overflow:ellipsis; white-space:nowrap;">使用怀疑药品（使用时间）</label>
                                    <input type="text" id="form-field-useTime" placeholder="使用时间" class="no-padding" style="width: 380px"/>
                                </div>
                                <div class="col-xs-12" style="margin-top: 5px;">
                                    <label class="control-label" for="form-field-symptom" style="text-overflow:ellipsis; white-space:nowrap;">出现 (症状)：</label>
                                    <input type="text" id="form-field-symptom" placeholder="症状" class="no-padding" style="width: 380px"/>
                                </div>
                                <div class="col-xs-12" style="margin-top: 5px;">
                                    <label class="control-label" for="form-field-physicalSign" style="text-overflow:ellipsis; white-space:nowrap;"> (或体征)：</label>
                                    <input type="text" id="form-field-physicalSign" placeholder="体征" class="no-padding" style="width: 380px"/>
                                </div>
                                <div class="col-xs-12" style="margin-top: 5px;">
                                    <label class="control-label" for="form-field-checkResult" style="text-overflow:ellipsis; white-space:nowrap;"> (相关检查结果)：</label>
                                    <input type="text" id="form-field-checkResult" placeholder="相关检查结果" class="no-padding" style="width: 380px"/>
                                </div>
                                <div class="col-xs-12" style="margin-top: 5px;">
                                    <label class="control-label" for="form-field-measure" style="text-overflow:ellipsis; white-space:nowrap;"> 采取</label>
                                    <input type="text" id="form-field-measure" placeholder="处理措施" class="no-padding" style="width: 380px"/>
                                    <label class="control-label" for="form-field-checkResult" style="text-overflow:ellipsis; white-space:nowrap;">处理后（填写处理措施），</label>
                                </div>
                                <div class="col-xs-12" style="margin-top: 5px;">
                                    <label class="control-label" for="form-field-symptomContinue" style="text-overflow:ellipsis; white-space:nowrap;">（症状持续时间）</label>
                                    <input type="text" id="form-field-symptomContinue" placeholder="处理措施" class="no-padding" style="width: 380px"/>
                                </div>
                                <div class="col-xs-12" style="margin-top: 5px;">
                                    <label class="control-label" for="form-field-symptomChange" style="text-overflow:ellipsis; white-space:nowrap;">（症状变化）</label>
                                    <input type="text" id="form-field-symptomChange" placeholder="症状变化" class="no-padding" style="width: 380px"/>
                                </div>
                                <div class="col-xs-12" style="margin-top: 5px;">
                                    <label class="control-label" for="form-field-checkChange" style="text-overflow:ellipsis; white-space:nowrap;">（体征或相关检查结果变化）</label>
                                    <input type="text" id="form-field-checkChange" placeholder="体征或相关检查结果变化" class="no-padding" style="width: 380px"/>
                                </div>
                                <div class="col-xs-12" style="margin-top: 5px;">
                                    <label class="control-label" for="form-field-lapseTo" style="text-overflow:ellipsis; white-space:nowrap;">最终转归：</label>
                                    <input type="text" id="form-field-lapseTo" placeholder="最终转归" class="no-padding" style="width: 380px"/>
                                </div>

                                <div class="col-xs-12" style="margin-top: 5px;">
                                    <%--<label class="control-label" for="form-field-dynamic" style="text-overflow:ellipsis; white-space:nowrap;"></label> --%>
                                    <label for="form-field-dynamic">如有详细动态变化，见后：</label>
                                    <textarea id="form-field-dynamic" class="autosize-transition form-control"></textarea>
                                </div>
                            </div>
                        </div>

                        <div id="dropdown17" class="tab-pane in active">
                            <div class="well well-sm col-xs-12">
                                <h6 class="green lighter">怀疑药品</h6>
                                <div class="clearfix">
                                    <div class="pull-right tableTools-container"></div>
                                </div>
                                <table id="longDrugTb" class="table table-striped table-bordered table-hover">
                                    <thead class="thin-border-bottom">
                                    <tr>
                                        <th>商品名称</th>
                                        <th>通用名称</th>
                                        <th>生产厂家</th>
                                        <th>批号</th>
                                        <th>用法用量</th>
                                        <th>起止时间</th>
                                        <th>用药原因</th>
                                    </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                            <div class="well well-sm col-xs-12">
                                <h6 class="green lighter">并用药品</h6>
                                <table id="shortDrugTb" class="table table-striped table-bordered table-hover">
                                    <thead class="thin-border-bottom">
                                    <tr>
                                        <th>商品名称</th>
                                        <th>通用名称</th>
                                        <th>生产厂家</th>
                                        <th>批号</th>
                                        <th>用法用量</th>
                                        <th>起止时间</th>
                                        <th>用药原因</th>
                                    </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                        <div id="dropdown21" class="tab-pane">
                            <%--<div class="well well-sm" style="height: 170px">--%>
                            <div class="well well-sm col-xs-12">
                                <div class="control-group col-xs-12" style="margin-top: 10px;">

                                    <div class="form-inline col-xs-5 no-padding no-margin control-group">
                                        <label class="control-label" for="id-date-picker-eventTime" style="text-overflow:ellipsis; white-space:nowrap;">不良反应结果：</label>
                                        <input name="form-field-radio-result" type="radio" class="ace" checked value="治愈"/>
                                        <span class="lbl">治愈</span>
                                        <input name="form-field-radio-result" type="radio" class="ace" value="好转"/>
                                        <span class="lbl">好转</span>
                                        <input name="form-field-radio-result" type="radio" class="ace" value="有后遗症"/>
                                        <span class="lbl">有后遗症</span>
                                        <input name="form-field-radio-result" type="radio" class="ace" value="死亡"/>
                                        <span class="lbl">死亡</span>
                                    </div>
                                    <div class="form-inline col-xs-3  no-padding no-margin control-group">
                                        <span class="lbl">直接死因</span>
                                        <input type="text" id="form-field-deadCause" placeholder="直接死因" class="no-padding" style="width: 100px"/>
                                    </div>

                                    <%-- <span class="lbl"></span>--%>
                                    <div class="form-inline col-xs-4  no-padding no-margin control-group">
                                        <label class="control-label" for="id-date-picker-eventTime" style="text-overflow:ellipsis; white-space:nowrap;">死亡时间：</label>
                                        <div class="input-group">
                                            <input class="date-picker no-padding" style="width: 110px" id="id-date-picker-deadTime" type="text"
                                                   data-date-format="YYYY年MM月DD日" pattern='yyyy年MM月dd日'/>
                                            <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="control-group col-xs-12" style="margin-top: 10px;">
                                    <div class="form-inline col-xs-4">
                                        <label class="control-label" for="form-field-checkChange" style="text-overflow:ellipsis; white-space:nowrap;">原患疾病：</label>
                                        <input type="text" id="form-field-disease" placeholder="原患疾病" class="no-padding" style="width: 100px"/>
                                    </div>

                                    <div class="form-inline col-xs-8  no-padding no-margin control-group">
                                        <label class="control-label" for="id-date-picker-eventTime" style="text-overflow:ellipsis; white-space:nowrap;">对原患疾病的影响：</label>
                                        <input name="form-field-radio-result" type="radio" class="ace" value="不明显"/>
                                        <span class="lbl">不明显</span>
                                        <input name="form-field-radio-result" type="radio" class="ace" value="病程延长"/>
                                        <span class="lbl">病程延长</span>
                                        <input name="form-field-radio-result" type="radio" class="ace" value="病情加重"/>
                                        <span class="lbl">病情加重</span>
                                        <input name="form-field-radio-result" type="radio" class="ace" value="导致后遗症"/>
                                        <span class="lbl">导致后遗症</span>

                                        <input name="form-field-radio-result" type="radio" class="ace" value="导致死亡"/>
                                        <span class="lbl">导致死亡</span>
                                    </div>
                                </div>
                                <div class="control-group col-xs-12" style="margin-top: 10px;">

                                    <div class="form-inline col-xs-8 no-padding no-margin control-group">
                                        <label class="control-label" for="id-date-picker-eventTime" style="text-overflow:ellipsis; white-space:nowrap;">国内有无类似不良反应（包括文献报道）：</label>
                                        <input name="form-field-radio-similar" type="radio" class="ace" value="有"/>
                                        <span class="lbl">有</span>
                                        <input name="form-field-radio-similar" type="radio" class="ace" value="无"/>
                                        <span class="lbl">无</span>
                                        <input name="form-field-radio-similar" type="radio" class="ace" value="不详"/>
                                        <span class="lbl">不详</span>
                                    </div>
                                    <div class="form-inline col-xs-4  no-padding no-margin control-group">
                                        <span class="lbl">简述：</span>
                                        <input type="text" id="form-field-sketch" placeholder="简述" class="no-padding" style="width: 200px"/>
                                    </div>
                                </div>
                                <div class="control-group col-xs-12" style="margin-top: 10px;">

                                    <div class="form-inline col-xs-8 no-padding no-margin control-group">
                                        <label class="control-label" for="id-date-picker-eventTime" style="text-overflow:ellipsis; white-space:nowrap;">国外有无类似不良反应：</label>
                                        <input name="form-field-radio-similar2" type="radio" class="ace" value="有"/>
                                        <span class="lbl">有</span>
                                        <input name="form-field-radio-similar2" type="radio" class="ace" value="无"/>
                                        <span class="lbl">无</span>
                                        <input name="form-field-radio-similar2" type="radio" class="ace" value="不详"/>
                                        <span class="lbl">不详</span>
                                    </div>
                                    <div class="form-inline col-xs-4  no-padding no-margin control-group">
                                        <span class="lbl">简述：</span>
                                        <input type="text" id="form-field-sketch2" placeholder="简述" class="no-padding" style="width: 200px"/>
                                    </div>
                                </div>
                            </div>

                            <div class="well well-sm col-xs-12">
                                <h6 class="green lighter">关联性评价</h6>
                                <div class="control-group col-xs-12">
                                    <div class="form-inline col-xs-8 no-padding no-margin control-group">
                                        <input name="form-field-radio-evaluate" type="radio" class="ace" value="肯定"/>
                                        <span class="lbl">肯定</span>
                                        <input name="form-field-radio-evaluate" type="radio" class="ace" value="很可能"/>
                                        <span class="lbl">很可能</span>
                                        <input name="form-field-radio-evaluate" type="radio" class="ace" value="可能"/>
                                        <span class="lbl">可能</span>
                                        <input name="form-field-radio-evaluate" type="radio" class="ace" value="可能无关"/>
                                        <span class="lbl">可能无关</span>
                                        <input name="form-field-radio-evaluate" type="radio" class="ace" value="待评价"/>
                                        <span class="lbl">待评价</span>
                                        <input name="form-field-radio-evaluate" type="radio" class="ace" value="无法评价"/>
                                        <span class="lbl">无法评价</span>

                                    </div>
                                    <div class="form-inline col-xs-4  no-padding no-margin control-group">
                                        <span class="lbl">报告人签名：</span>
                                        <input type="text" id="form-field-reporterSign" placeholder="报告人签名" class="no-padding" style="width: 100px"/>
                                    </div>
                                </div>
                                <div class="control-group col-xs-12" style="margin-top: 10px;">
                                    <div class="form-inline col-xs-8 no-padding no-margin control-group">
                                        <input name="form-field-radio-evaluate2" type="radio" class="ace" value="肯定"/>
                                        <span class="lbl">肯定</span>
                                        <input name="form-field-radio-evaluate2" type="radio" class="ace" value="很可能"/>
                                        <span class="lbl">很可能</span>
                                        <input name="form-field-radio-evaluate2" type="radio" class="ace" value="可能"/>
                                        <span class="lbl">可能</span>
                                        <input name="form-field-radio-evaluate2" type="radio" class="ace" value="可能无关"/>
                                        <span class="lbl">可能无关</span>
                                        <input name="form-field-radio-evaluate2" type="radio" class="ace" value="待评价"/>
                                        <span class="lbl">待评价</span>
                                        <input name="form-field-radio-evaluate2" type="radio" class="ace" value="无法评价"/>
                                        <span class="lbl">无法评价</span>
                                    </div>
                                    <div class="form-inline col-xs-4  no-padding no-margin control-group">
                                        <span class="lbl">报告人单位：</span>
                                        <input type="text" id="form-field-reportUnitSign" placeholder="报告人单位" class="no-padding" style="width: 100px"/>
                                    </div>
                                </div>
                            </div>
                            <div class="well well-sm col-xs-12">
                                <h6 class="green lighter">不良反应分析</h6>
                                <div class="control-group col-xs-12">
                                    <div class="form-inline col-xs-8  no-padding no-margin control-group">
                                        <label class="control-label" for="id-date-picker-eventTime" style="text-overflow:ellipsis; white-space:nowrap;">1、用药与不良反应的出现有无合理的时间关系？</label>
                                    </div>
                                    <div class="form-inline col-xs-4 no-padding no-margin control-group">
                                        <input name="form-field-radio-analyze1" type="radio" class="ace" value="有"/>
                                        <span class="lbl">有</span>
                                        <input name="form-field-radio-analyze1" type="radio" class="ace" value="无"/>
                                        <span class="lbl">无</span>
                                        <input name="form-field-radio-analyze1" type="radio" class="ace" value="不明"/>
                                        <span class="lbl">不明</span>
                                    </div>
                                    <div class="form-inline col-xs-8  no-padding no-margin control-group">
                                        <label class="control-label" for="id-date-picker-eventTime" style="text-overflow:ellipsis; white-space:nowrap;">2、反应是否符合该药已知的不良反应类型（说明书有无注明）？</label>
                                    </div>
                                    <div class="form-inline col-xs-4 no-padding no-margin control-group">
                                        <input name="form-field-radio-analyze2" type="radio" class="ace" value="是"/>
                                        <span class="lbl">是</span>
                                        <input name="form-field-radio-analyze2" type="radio" class="ace" value="否"/>
                                        <span class="lbl">否</span>
                                        <input name="form-field-radio-analyze2" type="radio" class="ace" value="不明"/>
                                        <span class="lbl">不明</span>
                                    </div>
                                    <div class="form-inline col-xs-8  no-padding no-margin control-group">
                                        <label class="control-label" for="id-date-picker-eventTime" style="text-overflow:ellipsis; white-space:nowrap;">3、停药或减量后，反应是否消失或减轻？</label>
                                    </div>
                                    <div class="form-inline col-xs-4 no-padding no-margin control-group">
                                        <input name="form-field-radio-analyze3" type="radio" class="ace" value="是"/>
                                        <span class="lbl">是</span>
                                        <input name="form-field-radio-analyze3" type="radio" class="ace" value="否"/>
                                        <span class="lbl">否</span>
                                        <input name="form-field-radio-analyze3" type="radio" class="ace" value="未停药或减量"/>
                                        <span class="lbl">未停药或减量</span>
                                        <input name="form-field-radio-analyze3" type="radio" class="ace" value="不明"/>
                                        <span class="lbl">不明</span>
                                    </div>
                                    <div class="form-inline col-xs-8  no-padding no-margin control-group">
                                        <label class="control-label" for="id-date-picker-eventTime" style="text-overflow:ellipsis; white-space:nowrap;">4、再次使用可疑药品后是否再次出现同样反应？</label>
                                    </div>
                                    <div class="form-inline col-xs-4 no-padding no-margin control-group">
                                        <input name="form-field-radio-analyze4" type="radio" class="ace" value="是"/>
                                        <span class="lbl">是</span>
                                        <input name="form-field-radio-analyze4" type="radio" class="ace" value="否"/>
                                        <span class="lbl">否</span>
                                        <input name="form-field-radio-analyze4" type="radio" class="ace" value="未再使用"/>
                                        <span class="lbl">未再使用</span>
                                        <input name="form-field-radio-analyze4" type="radio" class="ace" value="不明"/>
                                        <span class="lbl">不明</span>
                                    </div>
                                    <div class="form-inline col-xs-8  no-padding no-margin control-group">
                                        <label class="control-label" for="id-date-picker-eventTime" style="text-overflow:ellipsis; white-space:nowrap;">5、反应是否可用并用药的作用、患者病情的进展、其他治疗的影响来解析？</label>
                                    </div>
                                    <div class="form-inline col-xs-4 no-padding no-margin control-group">
                                        <input name="form-field-radio-analyze5" type="radio" class="ace" value="是"/>
                                        <span class="lbl">是</span>
                                        <input name="form-field-radio-analyze5" type="radio" class="ace" value="否"/>
                                        <span class="lbl">否</span>
                                        <input name="form-field-radio-analyze5" type="radio" class="ace" value="不明"/>
                                        <span class="lbl">不明</span>
                                    </div>

                                </div>
                            </div>
                            <div class="well well-sm col-xs-12">
                                <h6>严重药品不良反应是指有下列情形之一者：</h6>
                                <div class="col-xs-12">
                                    <div class="form-inline col-xs-6  no-padding no-margin ">
                                        <label class="control-label" style="text-overflow:ellipsis; white-space:nowrap;">1、引起死亡？</label>
                                    </div>
                                    <div class="form-inline col-xs-6 no-padding no-margin control-group">
                                        <input name="form-field-radio-severe1" type="radio" class="ace" value="是"/>
                                        <span class="lbl">是</span>
                                        <input name="form-field-radio-severe1" type="radio" class="ace" value="否"/>
                                        <span class="lbl">否</span>
                                    </div>
                                </div>

                                <div class="col-xs-12">
                                    <div class="form-inline col-xs-6  no-padding no-margin control-group">
                                        <label class="control-label" style="text-overflow:ellipsis; white-space:nowrap;">2、致畸、致癌或出生缺陷？</label>
                                    </div>
                                    <div class="form-inline col-xs-5 no-padding no-margin control-group">
                                        <input name="form-field-radio-severe2" type="radio" class="ace" value="是"/>
                                        <span class="lbl">是</span>
                                        <input name="form-field-radio-severe2" type="radio" class="ace" value="否"/>
                                        <span class="lbl">否</span>
                                    </div>

                                </div>

                                <div class="col-xs-12">
                                    <div class="form-inline col-xs-6  no-padding no-margin control-group">
                                        <label class="control-label" style="text-overflow:ellipsis; white-space:nowrap;">3、对生命有危险、或能够导致永久的或显著的伤残？</label>
                                    </div>
                                    <div class="form-inline col-xs-5 no-padding no-margin control-group">
                                        <input name="form-field-radio-severe3" type="radio" class="ace" value="是"/>
                                        <span class="lbl">是</span>
                                        <input name="form-field-radio-severe3" type="radio" class="ace" value="否"/>
                                        <span class="lbl">否</span>
                                    </div>
                                </div>

                                <div class="col-xs-12">
                                    <div class="form-inline col-xs-6  no-padding no-margin control-group">
                                        <label class="control-label" style="text-overflow:ellipsis; white-space:nowrap;">4、对身体功能产生永久损伤？</label>
                                    </div>
                                    <div class="form-inline col-xs-5 no-padding no-margin control-group">
                                        <input name="form-field-radio-severe4" type="radio" class="ace" value="是"/>
                                        <span class="lbl">是</span>
                                        <input name="form-field-radio-severe4" type="radio" class="ace" value="否"/>
                                        <span class="lbl">否</span>
                                    </div>
                                </div>

                                <div class="col-xs-12">
                                    <div class="form-inline col-xs-6  no-padding no-margin control-group">
                                        <label class="control-label" style="text-overflow:ellipsis; white-space:nowrap;">5、需要住院？</label>
                                    </div>
                                    <div class="form-inline col-xs-5 no-padding no-margin control-group">
                                        <input name="form-field-radio-severe5" type="radio" class="ace" value="是"/>
                                        <span class="lbl">是</span>
                                        <input name="form-field-radio-severe5" type="radio" class="ace" value="否"/>
                                        <span class="lbl">否</span>
                                    </div>
                                </div>

                                <div class="col-xs-12" style="margin-top: 10px;">
                                    <div class="form-inline col-xs-12 no-padding no-margin">
                                        <label class="control-label " for="form-field-memo" style="text-overflow:ellipsis; white-space:nowrap;">备注：</label>
                                        <input type="text" id="form-field-memo" placeholder="备注" class="no-padding" style="width: 90%;"/>
                                    </div>
                                </div>

                                <div class="col-xs-12" style="margin-top: 10px;">
                                    <div class="form-inline col-xs-4 no-padding no-margin">
                                        <label class="control-label" for="form-field-reporterOccupation" style="text-overflow:ellipsis; white-space:nowrap;">报告人职业：</label>
                                        <input type="text" id="form-field-reporterOccupation" placeholder="报告人职业" class="no-padding"/>
                                    </div>
                                    <div class="form-inline col-xs-4 no-padding no-margin">
                                        <label class="control-label col-xs-6" for="form-field-reporterTitle" style="text-overflow:ellipsis; white-space:nowrap;">报告人职务/职称：</label>
                                        <input type="text" id="form-field-reporterTitle" placeholder="报告人职务/职称" class="no-padding col-xs-6"/>
                                    </div>
                                    <div class="form-inline col-xs-4 no-padding no-margin">
                                        <label class="control-label" for="form-field-reporter" style="text-overflow:ellipsis; white-space:nowrap;">&nbsp;&nbsp;&nbsp;报告人：</label>
                                        <input type="text" id="form-field-reporter" placeholder="报告人" class="no-padding"/>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

            </form>
            <!-- /section:elements.tab.position -->
        </div><!-- /.col -->

    </div>
    <!-- /.row -->

</div>
<!-- /.page-content -->
<div class="detail-row hidden" id="rowDetail">
    <div class="table-detail no-padding">
        溶剂：{{menstruum}}
    </div>
</div>
<div id="dialog-error" class="hide alert" title="提示">
    <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
</div>