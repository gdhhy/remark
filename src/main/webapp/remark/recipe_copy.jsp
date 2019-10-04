<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>点评处方</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>

    <!-- basic styles -->
    <link href="../components/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet"/>

    <!-- text fonts -->
    <link rel="stylesheet" href="../assets/css/ace-fonts.css"/>
    <!-- page specific plugin styles -->
    <!-- ace styles -->
    <link rel="stylesheet" href="../assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/> <!--重要-->
    <link rel="stylesheet" href="../assets/css/ace-skins.min.css"/>


    <link rel="stylesheet" href="../components/jquery-ui/jquery-ui.min.css"/>
    <link rel="stylesheet" href="../components/jquery-ui.custom/jquery-ui.custom.css"/>
    <link rel="stylesheet" href="../components/datatables/select.dataTables.min.css"/>
    <%--<link rel="stylesheet" href="../components/jquery-ui.custom/dataTables.bootstrap.min.css"/>--%>

    <!-- basic scripts -->
    <script src="../js/jquery-1.12.4.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>

    <!-- ace scripts -->
    <%--<script src="../assets/js/src/elements.scroller.js"></script>--%>
    <script src="../assets/js/ace-elements.js"></script>
    <script src="../assets/js/ace.js"></script>
    <script src="../assets/js/src/ace.widget-box.js"></script>
    <!-- ace settings handler -->
    <script src="../assets/js/ace-extra.js"></script>

    <!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->
    <!--[if lte IE 8]>
    <script src="../components/html5shiv/dist/html5shiv.js"></script>
    <script src="../components/respond/dest/respond.min.js"></script>
    <![endif]-->
    <%--<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>--%>

    <!-- page specific plugin scripts -->
    <!-- static.html end-->
    <script src="../components/datatables/jquery.dataTables.min.js"></script>
    <script src="../components/datatables/jquery.dataTables.bootstrap.min.js"></script>
    <%--<script src="js/datatables.net-buttons/dataTables.buttons.min.js"></script>--%>
    <script src="../components/datatables/dataTables.select.min.js"></script>
    <script src="../components/jquery-ui/jquery-ui.min.js"></script>
    <script src="../components/typeahead.js/handlebars.js"></script>
    <%--<script src="../js/string_func.js"></script>--%>

    <script type="text/javascript">
        jQuery(function ($) {


            $('#long-table').DataTable({
                bAutoWidth: false,
                paging: false, searching: false, ordering: false, "destroy": true,

                select: {style: 'multi', selector: 'td:first-child'},
                'columnDefs': [
                    {targets: 0, data: null, defaultContent: '', orderable: false, width: 10, className: 'select-checkbox'},
                    {"orderable": false, "data": "recipeDate", "targets": 1, title: '开始时间', width: 130},
                    {"orderable": false, "data": "adviceType", "targets": 2, title: '&nbsp;'},
                    {"orderable": false, "data": "advice", "targets": 3, title: '医嘱内容', width: 160},
                    {"orderable": false, "data": "quantity", "targets": 4, title: '数量', width: 60},
                    {"orderable": false, "data": "unit", "targets": 5, title: '单位', width: 60},
                    {"orderable": false, "data": "doctorName", "targets": 6, title: '医生'},
                    {"orderable": false, "data": "nurseName", "targets": 7, title: '护士'},
                    {"orderable": false, "data": "endDate", "targets": 8, title: '停止时间', width: 130},
                    {"orderable": false, "data": "endDoctorName", "targets": 9, title: '医生'},
                    {"orderable": false, "data": "endNurseName", "targets": 10, title: '护士'}
                ],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                scrollY: '55vh',
                "ajax": {
                    url: "/remark/getRecipeItemList.jspa?longAdvice=1&serialNo=${recipe.serialNo}",
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                }
            });
            $('#short-table').DataTable({
                bAutoWidth: false,
                paging: false, searching: false, ordering: false, "destroy": true,
                select: {style: 'multi', selector: 'td:first-child'},
                'columnDefs': [
                    {targets: 0, data: null, defaultContent: '', orderable: false, width: 10, className: 'select-checkbox'},
                    {"orderable": false, "data": "recipeDate", "targets": 1, title: '开始时间', width: 130},
                    {"orderable": false, "data": "adviceType", "targets": 2, title: '&nbsp;'},
                    {"orderable": false, "data": "advice", "targets": 3, title: '医嘱内容', width: 160},
                    {"orderable": false, "data": "quantity", "targets": 4, title: '数量', width: 60},
                    {"orderable": false, "data": "unit", "targets": 5, title: '单位', width: 60},
                    {"orderable": false, "data": "doctorName", "targets": 6, title: '医生'},
                    {"orderable": false, "data": "nurseName", "targets": 7, title: '护士'},
                    {"orderable": false, "data": "endDate", "targets": 8, title: '停止时间', width: 130},
                    {"orderable": false, "data": "endDoctorName", "targets": 9, title: '医生'},
                    {"orderable": false, "data": "endNurseName", "targets": 10, title: '护士'}
                ],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                scrollY: '60vh',
                "ajax": {
                    url: "/remark/getRecipeItemList.jspa?longAdvice=2&serialNo=${recipe.serialNo}",
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                }
            });
            $('#surgery-table').DataTable({
                bAutoWidth: true,
                paging: false, searching: false, ordering: false, "destroy": true,

                "columns": [
                    {"data": "surgeryID"},
                    {"data": "surgeryDate", "sClass": "center"},
                    {"data": "incision", "sClass": "center"},
                    {"data": "surgeryName", "sClass": "center"},
                    {"data": "healOver", "sClass": "center"}
                ],

                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 15, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {"orderable": false, "targets": 1, title: '手术时间', width: 130},
                    {"orderable": false, "targets": 2, title: '切口类型'},
                    {"orderable": false, "targets": 3, title: '操作名称'},
                    {"orderable": false, "targets": 4, title: '愈合方式'}
                ],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                scrollY: '60vh',
                "ajax": {
                    url: "/remark/getSurgerys.jspa?serialNo=${recipe.serialNo}",
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                }
            });
            // fields: ['diagnosisNo', 'type', 'original', 'disease', 'icd', 'choose']
            //$.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';
            var diagnosisTable = $('#diagnosis-table').DataTable({
                bAutoWidth: false,
                paging: false, searching: false, ordering: false, "destroy": true, "info": false,
                select: {style: 'multi', selector: 'td:first-child'},
                'columnDefs': [
                    /*  {
                          "orderable": false, "data": "diagnosisNo", "targets": 0, width: 10, 'className': 'dt-body-center',
                          render: function (data, type, row, meta) {
                              return '<input type="checkbox" value="{0}">'.format(data);
                          }
                      },*/
                    {
                        targets: 0, data: "diagnosisNo", orderable: false, width: 10, className: 'select-checkbox',
                        render: function (data, type, row, meta) {
                            return '';
                        }
                    },
                    {"orderable": false, "data": "type", "targets": 1, title: '类型', defaultContent: ''},
                    {"orderable": false, "data": "disease", "targets": 2, title: '诊断', defaultContent: ''},
                    {"orderable": false, "data": "icd", "targets": 3, title: 'ICD', defaultContent: ''},
                    {"orderable": false, "data": "originalChs", "targets": 4, title: '入院病情', defaultContent: ''}
                ],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                scrollY: '60vh',
                "ajax": {
                    url: "/remark/getDiagnosis.jspa?serialNo=${recipe.serialNo}&archive=${recipe.archive}",
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                }
            });
            diagnosisTable.on('select', function (e, dt, type, indexes) {
                var rowData = diagnosisTable.row(indexes).data();
                $("#chooseDiagnosis tr:last").after(Handlebars.compile("<tr data-id='{{diagnosisNo}}'><td>{{type}}</td><td>{{disease}}</td></tr>")(rowData));

            }).on('deselect', function (e, dt, type, indexes) {
                var rowData = diagnosisTable.row(indexes).data();
                $("#chooseDiagnosis tr").each(function (i, item) {
                    if (rowData["diagnosisNo"] === $(item).attr("data-id"))
                        $(this).remove();
                });
            });

            /* $('#diagnosis-table tbody').on('click', 'input[type="checkbox"]', function (e) {
                 console.log("checkbox click");
                 var $row = $(this).closest('tr');

                 // Get row data
                 var data = table.row($row).data();

                 // Get row ID
                 var rowId = data["diagnosisNo"];
                 console.log("rowID:" + rowId);
             });*/

            // Handle click on table cells with checkboxes
            /*  $('#diagnosis-table').on('click', 'tbody td, thead th:first-child', function (e) {
                  console.log("checkbox click2");
                  $(this).parent().find('input[type="checkbox"]').trigger('click');
              });*/
            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                //当切换tab时，强制重新计算列宽
                $.fn.dataTable.tables({visible: true, api: true}).columns.adjust().draw();
            });
            var loadData = 0;
            $('#courseTabIndex').click(function () {
                if ((loadData & 1) === 0)
                    $.getJSON("/remark/getCourse.jspa?serialNo=0014196001&departCode=${recipe.departCode}&archive=${recipe.archive}", function (result) {
                        //$.getJSON("/remark/getCourse.jspa?serialNo=${recipe.serialNo}&departCode=${recipe.departCode}&archive=${recipe.archive}", function (result) {
                        var template = Handlebars.compile($('#courseContent').html());
                        var htmlArray = [];
                        $.each(result.data, function (index, value) {
                            htmlArray.push(template(value));
                        });
                        var html = htmlArray.join('');
                        $('#courseContent').html(html.replace(/&nbsp;/ig, ''));

                        loadData &= 1;
                    });

            });
            $('#historyTabIndex').click(function () {
                if ((loadData & 2) === 0)
                    $.getJSON("/remark/showHistory.jspa?serialNo=0014196001&departCode=${recipe.departCode}&archive=${recipe.archive}", function (result) {
                        //$.getJSON("/remark/getCourse.jspa?serialNo=${recipe.serialNo}&departCode=${recipe.departCode}&archive=${recipe.archive}", function (result) {
                        var template = Handlebars.compile($('#historyContent').html());

                        $('#historyContent').html(template(result));

                        loadData &= 2;
                    });

            });

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


        })
    </script>

</head>
<body class="no-skin">
<div class="main-container ace-save-state" id="main-container">
    <script type="text/javascript">
        try {
            ace.settings.loadState('main-container')
        } catch (e) {
        }
    </script>
    <div class="main-content">
        <div class="main-content-inner">


            <!-- /section:basics/content.breadcrumbs -->
            <div class="page-content">
                <div class="row">
                    <div class="col-xs-12">
                        <div class="row">
                            <div class="col-sm-5 widget-container-col" id="widget-container-col-12">
                                <div class="widget-box  transparent">
                                    <div class="widget-header widget-header-small">
                                        <h5 class="widget-title smaller">点评</h5>
                                    </div>

                                    <div class="widget-body">
                                        <div class="widget-main padding-8">
                                            <div class="background-blue alert no-padding">
                                                诊断
                                                <table id="chooseDiagnosis" class="table table-striped table-bordered table-hover">
                                                    <thead class="thin-border-bottom">
                                                    <tr>
                                                        <th>类型</th>
                                                        <th>诊断</th>
                                                    </tr>
                                                    </thead>

                                                    <tbody>

                                                    </tbody>
                                                </table>
                                            </div>
                                            <div class="widget-box widget-color-orange" id="widget-box-3">
                                                <!-- #section:custom/widget-box.options.collapsed -->
                                                <div class="widget-header widget-header-small">
                                                    <h6 class="widget-title">
                                                        过敏史
                                                    </h6>
                                                </div>

                                                <!-- /section:custom/widget-box.options.collapsed -->
                                                <div class="widget-body">
                                                    <div class="widget-main  padding-0">
                                                        <div class="alert alert-info" style="height: 50px">
                                                            <div class="control-group   col-xs-3">
                                                                <label>
                                                                    <input name="form-field-radio" type="radio" class="ace"/>
                                                                    <span class="lbl">无</span>
                                                                </label>

                                                                <label>
                                                                    <input name="form-field-radio" type="radio" class="ace"/>
                                                                    <span class="lbl">有</span>
                                                                </label>
                                                            </div>
                                                            <div class="form-group col-xs-9 no-padding">
                                                                <label class="col-xs-3 control-label no-padding-right" for="form-field-1">抗菌药品通用名</label>
                                                                <input type="text" id="form-field-1" placeholder="通用名" class="col-xs-9  no-padding"/>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="widget-box widget-color-orange" id="widget-box-4">
                                                <!-- #section:custom/widget-box.options.collapsed -->
                                                <div class="widget-header widget-header-small">
                                                    <h6 class="widget-title col-xs-12">实验室检查</h6>
                                                </div>

                                                <!-- /section:custom/widget-box.options.collapsed -->
                                                <div class="widget-body ">
                                                    <div class="widget-main padding-0">
                                                        <div class="alert alert-info" style="height: 50px">
                                                            <div class="control-group   col-xs-3">
                                                                <label>
                                                                    <input name="form-field-radio" type="radio" class="ace"/>
                                                                    <span class="lbl">无</span>
                                                                </label>

                                                                <label>
                                                                    <input name="form-field-radio" type="radio" class="ace"/>
                                                                    <span class="lbl">有</span>
                                                                </label>
                                                            </div>
                                                            <div class="form-group col-xs-9 no-padding">
                                                                <label class="col-xs-3 control-label no-padding-right" for="form-field-2">抗菌药品通用名</label>
                                                                <input type="text" id="form-field-2" placeholder="通用名" class="col-xs-9  no-padding"/>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="alert alert-success">
                                                Raw denim you probably haven't heard of them jean shorts Austin.
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-7 widget-container-col" id="widget-container-col-13">
                                <div class="widget-box transparent" id="widget-box-13">
                                    <div class="widget-header">
                                        <h4 class="widget-title lighter">住院号：${recipe.patientNo}，姓名：${recipe.patientName}</h4>

                                        <div class="widget-toolbar no-border" id="tabDiv">
                                            <ul class="nav nav-tabs" id="myTab2">
                                                <li class="active">
                                                    <a data-toggle="tab" href="#home1">病人</a>
                                                </li>
                                                <li>
                                                    <a data-toggle="tab" href="#home2">诊断</a>
                                                </li>

                                                <li>
                                                    <a data-toggle="tab" href="#longTab">长嘱</a>
                                                </li>

                                                <li>
                                                    <a data-toggle="tab" href="#shortTab">临嘱</a>
                                                </li>

                                                <li>
                                                    <a data-toggle="tab" href="#surgeryTab">手术</a>
                                                </li>

                                                <li>
                                                    <a data-toggle="tab" href="#courseTab" id="courseTabIndex">病程记录</a>
                                                </li>
                                                <li>
                                                    <a data-toggle="tab" href="#historyTab" id="historyTabIndex">住院病历</a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>

                                    <div class="widget-body">
                                        <div class="widget-main padding-12 no-padding-left no-padding-right">
                                            <div class="tab-content padding-4">
                                                <div id="home1" class="tab-pane  in active">
                                                    <table border="0" cellspacing="1" cellpadding="0" class="col-sm-5 table table-striped table-bordered table-hover">
                                                        <tbody>
                                                        <tr>
                                                            <td class="col-sm-2">住院号</td>
                                                            <td class="col-sm-4">${recipe.patientNo}</td>

                                                            <td class="col-sm-2">姓名</td>

                                                            <td class="col-sm-4">${recipe.patientName}</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col-sm-2">入院日期</td>
                                                            <td class="col-sm-4"><fmt:formatDate value='${inDate}' pattern='yyyy-MM-dd HH:mm'/></td>

                                                            <td class="col-sm-2">出院日期</td>
                                                            <td class="col-sm-4"><fmt:formatDate value='${outDate}' pattern='yyyy-MM-dd HH:mm'/></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col-sm-2">住院天数</td>
                                                            <td class="col-sm-4">${recipe.inHospitalDay}</td>

                                                            <td class="col-sm-2">年龄</td>
                                                            <td class="col-sm-4">${recipe.age}</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col-sm-2">性别</td>
                                                            <td class="col-sm-4">
                                                                <c:if test="${recipe.sex}">男</c:if>
                                                                <c:if test="${!recipe.sex}">女</c:if>
                                                            </td>

                                                            <td class="col-sm-2">就诊科室</td>
                                                            <td class="col-sm-4">${recipe.department}</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col-sm-2">主管医生</td>
                                                            <td class="col-sm-4">${recipe.masterDoctorName}</td>

                                                            <td class="col-sm-2">药品组数</td>
                                                            <td class="col-sm-4">${recipe.drugNum}</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col-sm-2">总金额</td>
                                                            <td class="col-sm-4">${recipe.money}</td>

                                                            <td class="col-sm-2">药品金额</td>
                                                            <td class="col-sm-4">${recipe.medicineMoney}</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col-sm-2">抗菌药品种数</td>
                                                            <td class="col-sm-4">${recipe.antiNum}</td>

                                                            <td class="col-sm-3">抗菌药联用数</td>
                                                            <td class="col-sm-4">${recipe.concurAntiNum}</td>
                                                        </tr>
                                                        </tbody>
                                                    </table>

                                                </div>

                                                <div id="home2" class="tab-pane">
                                                    <!-- #section:custom/scrollbar.horizontal -->
                                                    <%--<div class="scrollable" data-size="600">--%>
                                                    <div data-size="600">
                                                        <div class="row">
                                                            <div class="col-xs-12">
                                                                <table id="diagnosis-table" class="table  table-striped table-bordered table-hover">
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- /section:custom/scrollbar.horizontal -->
                                                </div>

                                                <div id="longTab" class="tab-pane">
                                                    <div class="scrollable" data-size="600" data-position="left">
                                                        <table id="long-table" class="table table-striped table-bordered table-hover ">
                                                        </table>
                                                    </div>
                                                </div>

                                                <div id="shortTab" class="tab-pane">
                                                    <table id="short-table" class="table table-striped table-bordered table-hover">
                                                    </table>
                                                </div>
                                                <div id="surgeryTab" class="tab-pane">
                                                    <table id="surgery-table" class="table table-striped table-bordered table-hover">
                                                    </table>
                                                </div>
                                                <div id="courseTab" class="tab-pane">
                                                    <div class="scrollable" data-size="600">
                                                        <div id="courseContent" class="content">
                                                            <div class="col-xs-12 bigger-130">主题：{{title}}</div>
                                                            <div class="col-xs-12">
                                                                <div class="col-xs-3 purple">{{writeTime}}</div>
                                                                <div class="col-xs-9 brown">{{doctorName}}</div>
                                                            </div>
                                                            <p class="col-xs-12 profile-info-value ">{{{content}}}</p>

                                                        </div>
                                                    </div>
                                                </div>
                                                <div id="historyTab" class="tab-pane">
                                                    <div class="scrollable" data-size="600">
                                                        <div id="historyContent">
                                                            <div class="col-xs-12">
                                                                <div class="col-xs-3 purple">{{writeTime}}</div>
                                                                <div class="col-xs-9 brown">{{doctorName1}}</div>
                                                            </div>
                                                            <div class="col-xs-12 profile-info-value">{{{content}}}</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- PAGE CONTENT ENDS -->
                    </div><!-- /.col -->
                </div><!-- /.row -->

            </div><!-- /.page-content -->
        </div><!-- /.main-container-inner -->
    </div><!-- /.main-content -->
    <div class="footer">
        <div class="footer-inner">
            <!-- #section:basics/footer -->
            <div class="footer-content">
                <span class="bigger-120"><span class="blue bolder">广州志创</span>网络科技有限公司 &copy; 2018
                </span>
            </div>
            <!-- /section:basics/footer -->
        </div>
    </div>
</div><!-- /.main-container -->

</body>
</html>