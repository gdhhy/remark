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
<script src="../components/typeahead.js/dist/typeahead.bundle.min.js"></script>
<script src="../components/typeahead.js/handlebars.js"></script>  <%--todo ?--%>

<script type="text/javascript">
    jQuery(function ($) {
        var sampleBatchID = $.getUrlParam("sampleBatchID");
        var remarkType = $.getUrlParam("remarkType");

        $("#batchName").text(decodeURI($.getUrlParam("batchName")));

        var url = "/remark/listDetails.jspa?sampleBatchID=" + sampleBatchID;
        //var editor = new $.fn.dataTable.Editor({});
        //initiate dataTables plugin
        var dynamicTable = $('#dynamic-table');
        var myTable = dynamicTable
            //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                //paging: false,
                "columns": [
                    {"data": "detailID"},
                    {"data": "hospNo", "sClass": "center", defaultContent: ''},
                    {"data": "patientName", "sClass": "center"},
                    {"data": "age", "sClass": "center"},
                    /*  {"data": "inDate", "sClass": "center"},//4*/
                    {"data": "outDate", "sClass": "center"},
                    {"data": "inHospitalDay", "sClass": "center"},
                    {"data": "drugNum", "sClass": "center"},
                    {"data": "money", "sClass": "center"},
                    {"data": "medicineMoney", "sClass": "center"},//9
                    {"data": "diagnosis2", "sClass": "center"},
                    {"data": "masterDoctorName", "sClass": "center"},
                    /*  {"data": "rational", "sClass": "center"},*/
                    {"data": "disItem", "sClass": "center"},
                    {"data": "inPatientID", "sClass": "center"}//14
                ],

                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {"orderable": false, "targets": 1, title: '住院号', width: 60},
                    {"orderable": false, "targets": 2, title: '病人', width: 60},
                    {"orderable": false, "targets": 3, title: '年龄'},
                    /*{"orderable": false, "targets": 4, title: '入院日期', width: 130},*/
                    {"orderable": false, "targets": 4, title: '出院日期', width: 130},
                    {"orderable": false, "targets": 5, title: '住院天数', width: 45},
                    {"orderable": false, "targets": 6, title: '药品组数', width: 45},
                    {"orderable": false, "targets": 7, title: '总金额', defaultContent: '', align: 'right'},
                    {"orderable": false, "targets": 8, title: '药品金额', defaultContent: ''},
                    {"orderable": false, "targets": 9, title: '出院诊断', defaultContent: ''},
                    {"orderable": false, "targets": 10, title: '主管<br/>医生', defaultContent: '', width: 60},
                    /*   {
                           "orderable": false, "targets": 11, title: '合理', defaultContent: '', render: function (data, type, row, meta) {
                               if (data === 1) return '是';
                               return '否';
                           }
                       },*/
                    {"orderable": false, searchable: false, "targets": 11, title: '问题代码', width: 45},
                    {
                        "orderable": false, "targets": 12, title: '点评', render: function (data, type, row, meta) {
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                /*'<a class="hasDetail" href="#" data-Url="/index.jspa?content=/remark/viewInPatient.jspa&inPatientID={0}">'.format(data) +*/
                                '<a class="hasDetail" href="#" data-Url="/remark/viewInPatient{0}.jspa?inPatientID={1}&batchID={2}">'.format(remarkType, data, sampleBatchID) +
                                (row['reviewTime'] === undefined ? '<i class="ace-icon glyphicon glyphicon-pencil  bigger-130"></i>' : row['reviewTime'].substring(0, 10)) +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasDetail" href="#" data-Url="javascript:deleteSample({0},\'{1}\',\'{2}\');">'.format(sampleBatchID, data, row['patientName']) +
                                '<i class="ace-icon fa fa-trash-o red bigger-110"></i>' +
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
        });
        $("#dt").resize(function () {
            myTable.columns.adjust();
        });

        //$.fn.dataTable.Buttons.swfPath = "components/datatables.net-buttons-swf/index.swf"; //in Ace demo ../components will be replaced by correct assets path
        $.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';

        new $.fn.dataTable.Buttons(myTable, {
            buttons: [
                {
                    "text": "<i class='fa fa-file-excel-o  bigger-110 red'></i>导出调查表",
                    "className": "btn btn-xs btn-white btn-primary"
                }
            ]
        });
        myTable.buttons().container().appendTo($('.tableTools-container'));
        myTable.button(0).action(function (e, dt, button, config) {
            e.preventDefault();
            window.location.href = "remark/hospital.jspa?sampleBatchID=" + sampleBatchID;
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

        function deleteSample(batchID, objectID, patientName) {
            console.log("deleteSample");
            if (batchID === undefined) return;
            $('#patientName').text(patientName);
            $("#dialog-delete").removeClass('hide').dialog({
                resizable: false,
                modal: true,
                title: "确认删除抽样",
                //title_html: true,
                buttons: [
                    {
                        html: "<i class='ace-icon fa fa-trash bigger-110'></i>&nbsp;确定",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            $.ajax({
                                type: "POST",
                                url: "/remark/deleteSample.jspa?batchID=" + batchID + '&objectID=' + objectID,
                                //contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                                cache: false,
                                success: function (response, textStatus) {
                                    var result = JSON.parse(response);
                                    if (result.succeed)
                                        myTable.ajax.reload();
                                    else
                                        showDialog("请求结果：" + result.succeed, '删除失败，请稍后重试或与管理员联系！');
                                },
                                error: function (response, textStatus) {/*能够接收404,500等错误*/
                                    showDialog("请求状态码：" + response.status, response.responseText);
                                }
                            });
                            $(this).dialog("close");
                        }
                    },
                    {
                        html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 取消",
                        "class": "btn btn-minier",
                        click: function () {
                            $(this).dialog("close");
                        }
                    }
                ]
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
        <h1>住院抽样列表 </h1>
    </div><!-- /.page-header -->

    <div class="row">
        <div class="col-xs-12">

            <div class="row">

                <div class="col-xs-12">
                    <div class="table-header">
                        抽样处方 <span id="batchName"></span>的"全部列表"
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
<div id="dialog-delete" class="hide">
    <div class="alert alert-info bigger-110">
        删除 <span id="patientName" class="red"></span> 的抽样。
    </div>

    <div class="space-6"></div>

    <p class="bigger-110 bolder center grey">
        <i class="icon-hand-right blue bigger-120"></i>
        确认吗？
    </p>
</div>