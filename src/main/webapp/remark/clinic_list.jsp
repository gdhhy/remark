<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script src="../components/datatables/jquery.dataTables.min.js"></script>
<script src="../components/datatables/jquery.dataTables.bootstrap.min.js"></script>
<script src="../components/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="../components/datatables/dataTables.select.min.js"></script>
<!--不能用1.11.4-->
<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>
<%--<script src="../assets/js/ace.js"></script>--%>
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

<!-- bootstrap & fontawesome -->

<script type="text/javascript">
    jQuery(function ($) {
        var sampleBatchID = $.getUrlParam("sampleBatchID");
      //  var remarkType = $.getUrlParam("remarkType");
        $("#batchName").text(decodeURI($.getUrlParam("batchName")));
        var url = "/sample/listDetails.jspa?sampleBatchID=" + sampleBatchID + '&type=1';
        //var editor = new $.fn.dataTable.Editor({});
        //initiate dataTables plugin
        var dynamicTable = $('#dynamic-table');
        var myTable = dynamicTable
        //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                // paging: false,
                "columns": [
                    {"data": "detailID"},
                    {"data": "mzNo", "sClass": "center"},
                    {"data": "clinicTime", "sClass": "center"},
                    {"data": "patientName", "sClass": "center"},
                    {"data": "age", "sClass": "center",defaultContent:''},//4
                    {"data": "diagnosis", "sClass": "center",defaultContent:''},
                    {"data": "clinicType", "sClass": "center"},
                    {"data": "drugNum", "sClass": "center"},
                    {"data": "antiNum", "sClass": "center"},
                    {"data": "injectionNum", "sClass": "center"},//9
                    {"data": "baseDrugNum", "sClass": "center"},
                    {"data": "money", "sClass": "center"},
                    {"data": "memo", "sClass": "center"},
                    {"data": "department", "sClass": "center"},
                    {"data": "doctorName", "sClass": "center"},/*
                    {"data": "confirmName", "sClass": "center"},//14
                    {"data": "apothecaryName", "sClass": "center"},*/
                    {"data": "rational", "sClass": "center"},
                    {"data": "disItem", "sClass": "center"},
                    {"data": "reviewDate", "sClass": "center"}
                ],

                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 10, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {"orderable": false, "targets": 1, title: '门诊号', width: 120},
                    {"orderable": false, "targets": 2, title: '时间', width: 45},//, width: 85
                    {"orderable": false, "targets": 3, title: '姓名', width: 60},
                    {"orderable": false, "targets": 4, title: '年龄', width: 80},
                    {"orderable": false, "targets": 5, title: '诊断'},
                    {"orderable": false, "targets": 6, title: '类型', width: 45},
                    {"orderable": false, "targets": 7, title: '品种数', defaultContent: '', width: 60},
                    {"orderable": false, "targets": 8, title: '抗菌素', defaultContent: '', width: 60, render: renderBoolean},
                    {"orderable": false, "targets": 9, title: '注射液', defaultContent: '', width: 60, render: renderBoolean},
                    {"orderable": false, "targets": 10, title: '基本', defaultContent: '', width: 45},
                    {"orderable": false, "targets": 11, title: '金额', defaultContent: '', width: 60},
                    {"orderable": false, "targets": 12, title: '备注', defaultContent: '', width: 60},
                    {"orderable": false, "targets": 13, title: '科室', defaultContent: ''},//, width: 70
                    {"orderable": false, "targets": 14, title: '医生', defaultContent: '', width: 60},
                    /*{"orderable": false, "targets": 14, title: '审核', defaultContent: '', width: 60},
                    {"orderable": false, "targets": 15, title: '配药', defaultContent: '', width: 60},*/
                    {"orderable": false, "targets": 15, title: '合理', defaultContent: '', width: 45, render: renderYES},
                    {"orderable": false, searchable: false, "targets": 16, title: '问题代码', width: 50, defaultContent: ''},
                    {
                        "orderable": false, "targets": 17, title: '点评', width: 45, render: function (data, type, row, meta) {
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="hasDetail" href="#" data-Url="/remark/viewClinic.jspa?clinicID={0}">'.format(row['clinicID']) +
                                (data === undefined ? '<i class="ace-icon glyphicon glyphicon-pencil  bigger-130"></i>' : data.substring(0, 10)) +
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
                // scrollY: '60vh',
                //'sScrollY': 'calc(60vh - 280px)',
                //"serverSide": true,
                select: {
                    style: 'single'
                }
            });

        $("#dt").bind('resize', function () {
            myTable.columns.adjust();
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


        function renderBoolean(data, type, row, meta) {
            return data >= 1 ? "有" : "无";
        }

        function renderYES(data, type, row, meta) {
            return data >= 1 ? "是" : "<font color='red'>否</font>";
        }

        function renderWestern(data, type, row, meta) {
            return data === 1 ? "西" : "中";
        }

        function renderReview(data, type, row, meta) {
            return data !== "" && value != null ? "是" : "";
        }

        //$.fn.dataTable.Buttons.swfPath = "components/datatables.net-buttons-swf/index.swf"; //in Ace demo ../components will be replaced by correct assets path
        $.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';

        new $.fn.dataTable.Buttons(myTable, {
            buttons: [
                {
                    "text": "<i class='fa fa-file-excel-o  bigger-110 red'></i>导出评价表",
                    "className": "btn btn-xs btn-white btn-primary"
                }
            ]
        });
        myTable.buttons().container().appendTo($('.tableTools-container'));
        myTable.button(0).action(function (e, dt, button, config) {
            e.preventDefault();
            window.location.href = "remark/clinic.jspa?sampleBatchID=" + sampleBatchID;
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
        <h1>门诊抽样列表 </h1>
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