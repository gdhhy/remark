<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="../components/datatables/jquery.dataTables.min.js"></script>
<script src="../components/datatables/jquery.dataTables.bootstrap.min.js"></script>
<script src="../components/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="../components/datatables/dataTables.select.min.js"></script>
<%--<script src="../assets/js/ace.js"></script>--%>
<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>
<script src="../js/resize.js"></script>
<script src="../js/jquery.cookie.min.js"></script>
<script src="../assets/js/jquery.validate.min.js"></script>
<script src="../components/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script src="../components/bootstrap-timepicker/js/bootstrap-timepicker.js"></script>
<script src="../components/moment/moment.min.js"></script>
<script src="../components/bootstrap-daterangepicker/daterangepicker.js"></script>
<script src="../components/bootstrap-daterangepicker/daterangepicker.zh-CN.js"></script>
<link rel="stylesheet" href="../components/bootstrap-datepicker/css/bootstrap-datepicker3.css"/>
<link rel="stylesheet" href="../components/bootstrap-timepicker/css/bootstrap-timepicker.css"/>
<link rel="stylesheet" href="../components/bootstrap-daterangepicker/daterangepicker.css"/>

<script type="text/javascript">
    jQuery(function ($) {
        var startDate = moment().month(moment().month() - 1).startOf('month');
        var endDate = moment().month(moment().month() - 1).endOf('month');

        var url = "/infectious/getInfectiousList.jspa";
        //var editor = new $.fn.dataTable.Editor({});
        //initiate dataTables plugin
        var dynamicTable = $('#dynamic-table');
        var myTable = dynamicTable
            //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                //paging: false,
                "columns": [
                    {"data": 'infectiousID'},
                    {"data": 'reportType', "sClass": "center"},
                    {"data": 'patientName', "sClass": "center"},
                    {"data": 'serialNo', "sClass": "center"},
                    {"data": 'age', "sClass": "center"},//4
                    {"data": 'occupation', "sClass": "center"},
                    {"data": 'infectiousName', "sClass": "center"},
                    {"data": 'fillTime', "sClass": "center"},
                    {"data": 'reportDoctor', "sClass": "center"},
                    {"data": 'workflowChn', "sClass": "center"},//9
                    {"data": 'workflowNote', "sClass": "center"},
                    {"data": 'infectiousID'}
                    /*
                     {"data": 'reportNo', "sClass": "center"},
                     {"data": 'patientParent', "sClass": "center"},
                     {"data": 'idCardNo', "sClass": "center"},
                     {"data": 'boy', "sClass": "center"},
                     {"data": 'birthday', "sClass": "center"},
                     {"data": 'ageUnit', "sClass": "center"},
                     {"data": 'workplace', "sClass": "center"},
                     {"data": 'linkPhone', "sClass": "center"},
                     {"data": 'belongTo', "sClass": "center"},
                     {"data": 'address', "sClass": "center"},
                     {"data": 'occupationElse', "sClass": "center"},
                     {"data": 'caseClass', "sClass": "center"},
                     {"data": 'accidentDate', "sClass": "center"},
                     {"data": 'diagnosisHour', "sClass": "center"},
                     {"data": 'diagnosisDate', "sClass": "center"},
                     {"data": 'deathDate', "sClass": "center"},
                     {"data": 'infectiousClass', "sClass": "center"},
                     {"data": 'correctName', "sClass": "center"},
                     {"data": 'cancelCause', "sClass": "center"},
                     {"data": 'reportUnit', "sClass": "center"},
                     {"data": 'doctorPhone', "sClass": "center"},
                     {"data": 'memo', "sClass": "center"},
                     {"data": 'marital', "sClass": "center"},
                     {"data": 'nation', "sClass": "center"},
                     {"data": 'nationElse', "sClass": "center"},
                     {"data": 'education', "sClass": "center"},
                     {"data": 'venerismHis', "sClass": "center"},
                     {"data": 'registerAddr', "sClass": "center"},
                     {"data": 'touchHis', "sClass": "center"},
                     {"data": 'touchElse', "sClass": "center"},
                     {"data": 'infectRoute', "sClass": "center"},
                     {"data": 'sampleSource', "sClass": "center"},
                     {"data": 'conclusion', "sClass": "center"},
                     {"data": 'checkConfirmDate', "sClass": "center"},
                     {"data": 'hivConfirmDate', "sClass": "center"},
                     {"data": 'checkUnit', "sClass": "center"},*/
                ],

                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {
                        "orderable": false, "targets": 1, title: '报告类型', width: 70, render: function (data, type, row, meta) {
                            if (data === 1) return "初次报告";
                            return "订正报告";
                        }
                    },
                    {"orderable": false, "targets": 2, title: '患者姓名', width: 70},
                    {"orderable": false, "targets": 3, title: '住院/门诊号', width: 90},
                    {"orderable": false, "targets": 4, title: '年龄', width: 50},
                    {"orderable": false, "targets": 5, title: '职业'},
                    {"orderable": false, "targets": 6, title: '传染病名'},
                    {"orderable": false, "targets": 7, title: '报告日期', width: 160},
                    {"orderable": false, "targets": 8, title: '报告人'},
                    {"orderable": false, "targets": 9, title: '状态'},
                    {"orderable": false, "targets": 10, title: '退回消息', defaultContent: ''},
                    {
                        "orderable": false, "targets": 11, title: '操作', render: function (data, type, row, meta) {
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="hasDetail" href="#" data-Url="/index.jspa?content=/infectious/getInfectious.jspa?infectiousID={0}">'.format( data) +
                                '<i class="ace-icon glyphicon glyphicon-pencil  bigger-130"></i>' +
                                '</a>' +
                                '</div>';
                        }
                    }
                ],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                "ajax": {
                    url: url,
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0)  //以columns开头的参数删除
                                delete d[key];
                    }
                },
                //scrollY: '60vh',
                //"serverSide": true,
                select: {
                    style: 'single'
                }
            });
        myTable.on('draw', function () {
            $('#dynamic-table tr').find('.hasDetail').click(function () {
                if ($(this).attr("data-Url").indexOf('javascript:') >= 0) {
                    eval($(this).attr("data-Url"));
                } else
                    window.open($(this).attr("data-Url"), "_blank");
            });
            /* $('a.blue').on('click', function (e) {
                 e.preventDefault();
                 $.cookie('goodsID', $(this).attr("data-goodsID"));
                 $.cookie('goodsName', $(this).attr("data-goodsName"));
                 window.location.href = "index.jspa?content=/admin/buyRecord.jsp&menuID=3";
             });*/
        });
        $("#dt").resize(function () {
            myTable.columns.adjust();
        });

        $('#form-dateRange').daterangepicker({
            'applyClass': 'btn-sm btn-success',
            'cancelClass': 'btn-sm btn-default',
            startDate: startDate,
            endDate: endDate,
            ranges: {
                '本月': [moment().startOf('month')],
                '上月': [moment().month(moment().month() - 1).startOf('month'), moment().month(moment().month() - 1).endOf('month')],
                '本季': [moment().startOf('quarter')],
                '上季': [moment().quarter(moment().quarter() - 1).startOf('month'), moment().quarter(moment().quarter() - 1).endOf('quarter')],
                '今年': [moment().startOf('year')],
                '去年': [moment().year(moment().year() - 1).startOf('year'), moment().year(moment().year() - 1).endOf('year')]
            },
            locale: locale
        }, function (start, end, label) {
            startDate = start;
            endDate = end;
        }).css("min-width", "190px").next("i").click(function () {
            // 对日期的i标签增加click事件，使其在鼠标点击时可以拉出日期选择
            $(this).parent().find('input').click();
        }).next().on(ace.click_event, function () {
            $(this).prev().focus();
        });
        $('#queryItem').on('change', function (e) {//console.log("value:" +  this.options[this.selectedIndex].innerHTML );
            $('#queryField').attr("placeholder", this.options[this.selectedIndex].innerHTML);
        });

        //$.fn.dataTable.Buttons.swfPath = "components/datatables.net-buttons-swf/index.swf"; //in Ace demo ../components will be replaced by correct assets path
        $.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';

        new $.fn.dataTable.Buttons(myTable, {
            buttons: [
                {
                    "text": "<i class='fa fa-plus-square-o bigger-110 red'></i>报告传染病",
                    "className": "btn btn-xs btn-white btn-primary"
                }, {
                    "text": "<i class='fa fa-clone  bigger-110 red'></i>空白",
                    //todo
                    "className": "btn btn-xs btn-white btn-primary"
                }, {
                    "text": "<i class='fa fa-arrow-up  bigger-110 red'></i>提交",
                    "className": "btn btn-xs btn-white btn-primary"
                }
            ]
        });
        myTable.buttons().container().appendTo($('.tableTools-container'));
        myTable.button(1).action(function (e, dt, button, config) {
            e.preventDefault();
            window.open("index.jspa?content=/infectious/newInfectious.jspa&menuID=50");
        });

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
        <li class="active">抽样结果</li>
    </ul><!-- /.breadcrumb -->

    <!-- #section:basics/content.searchbox -->
    <div class="nav-search" id="nav-search">
        <form class="form-search">
            <span class="input-icon">
                <input type="text" placeholder="Search ..." class="nav-search-input" id="nav-search-input" autocomplete="off"/>
                <i class="ace-icon fa fa-search nav-search-icon"></i>
            </span>
        </form>
    </div><!-- /.nav-search -->

    <!-- /section:basics/content.searchbox -->
</div>

<!-- /section:basics/content.breadcrumbs -->
<div class="page-content">
    <div class="page-header">

        <form class="form-search form-inline">

            <label class=" control-label no-padding-right">状态： </label>
            <div class="radio">
                <label>
                    <input type="radio" name="stat" value="3">
                    <span class="lbl">全部</span>
                </label>
            </div>
            <div class="radio">
                <label>
                    <input type="radio" name="stat" value="1">
                    <span class="lbl">接受</span>
                </label>
            </div>
            <div class="radio">
                <label>
                    <input type="radio" name="stat" value="2">
                    <span class="lbl">未接受</span>
                </label>
            </div>&nbsp;&nbsp;&nbsp;


            <div class="input-group">
                <select class="nav-search-input ace" id="queryItem" name="queryItem" style="font-size: 9px;color: black">
                    <option value="1">传染病名</option>
                    <option value="2">患者姓名</option>
                </select>&nbsp;
                <input class="nav-search-input  ace " type="text" id="queryField" name="queryField"
                       style="width: 120px;font-size: 9px;color: black"
                       placeholder="传染病名"/>
            </div>

            <label>日期：</label>
            <!-- #section:plugins/date-time.datepicker -->
            <div class="input-group">
                <input class="form-control nav-search-input" name="dateRangeString" id="form-dateRange"
                       style="color: black "
                       data-date-format="YYYY-MM-DD"/>
                <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
            </div>&nbsp;&nbsp;&nbsp;

            <button type="button" class="btn btn-sm btn-success">
                查询
                <i class="ace-icon glyphicon glyphicon-search icon-on-right bigger-100"></i>
            </button>
            <button type="button" class="btn btn-sm btn-info">
                导出
                <i class="ace-icon fa fa-file-excel-o icon-on-right bigger-100"></i>
            </button>
        </form>
    </div><!-- /.page-header -->


    <div class="row">
        <div class="col-xs-12">

            <div class="row">

                <div class="col-xs-12">
                    <div class="table-header">
                        传染病"列表"
                        <div class="pull-right tableTools-container"></div>
                    </div>

                    <!-- div.table-responsive -->

                    <!-- div.dataTables_borderWrap -->
                    <div id="dt">
                        <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                        </table>
                    </div>
                </div>
            </div>

            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->
</div>
<!-- /.page-content -->