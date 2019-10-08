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
<link rel="stylesheet" href="../components/bootstrap-datepicker/css/bootstrap-datepicker3.css"/>
<link rel="stylesheet" href="../components/bootstrap-timepicker/css/bootstrap-timepicker.css"/>
<link rel="stylesheet" href="../components/bootstrap-daterangepicker/daterangepicker.css"/>
<script src="../components/typeahead.js/dist/typeahead.bundle.min.js"></script>
<script src="../components/typeahead.js/handlebars.js"></script>  <%--todo ?--%>

<script type="text/javascript">
    jQuery(function ($) {
        var sampleBatchID = $.getUrlParam("sampleBatchID");
        var remarkType = $.getUrlParam("remarkType");

        $("#batchName").text( decodeURI($.getUrlParam("batchName")));

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
                    {"data": "patientNo", "sClass": "center"},
                    {"data": "patientName", "sClass": "center"},
                    {"data": "age", "sClass": "center"},
                    {"data": "inDate", "sClass": "center"},//4
                    {"data": "outDate", "sClass": "center"},
                    {"data": "inHospitalDay", "sClass": "center"},
                    {"data": "drugNum", "sClass": "center"},
                    {"data": "money", "sClass": "center"},
                    {"data": "medicineMoney", "sClass": "center"},//9
                    {"data": "diagnosis", "sClass": "center"},
                    {"data": "masterDoctorName", "sClass": "center"},
                    {"data": "rational", "sClass": "center"},
                    {"data": "disItem", "sClass": "center"},
                    {"data": "detailID", "sClass": "center"}//14
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
                    {"orderable": false, "targets": 4, title: '入院日期', width: 130},
                    {"orderable": false, "targets": 5, title: '出院日期', width: 130},
                    {"orderable": false, "targets": 6, title: '住院天数'},
                    {"orderable": false, "targets": 7, title: '药品组数'},
                    {"orderable": false, "targets": 8, title: '总金额', defaultContent: ''},
                    {"orderable": false, "targets": 9, title: '药品金额', defaultContent: ''},
                    {"orderable": false, "targets": 10, title: '入院诊断', defaultContent: ''},
                    {"orderable": false, "targets": 11, title: '主管医生', defaultContent: '', width: 60},
                    {
                        "orderable": false, "targets": 12, title: '合理', defaultContent: '', render: function (data, type, row, meta) {
                            if (data === 1) return '是';
                            return '否';
                        }
                    },
                    {"orderable": false, searchable: false, "targets": 13, title: '问题代码'},
                    {
                        "orderable": false, "targets": 14, title: '点评', render: function (data, type, row, meta) {
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                /*'<a class="hasDetail" href="#" data-Url="/index.jspa?content=/remark/viewRecipe.jspa&recipeID={0}">'.format(data) +*/
                                '<a class="hasDetail" href="#" data-Url="/remark/viewRecipe{0}.jspa?recipeID={1}&batchID={2}">'.format(remarkType, data, sampleBatchID) +
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
        $("#dt").resize(function(){
            myTable.columns.adjust();
        });

        //$.fn.dataTable.Buttons.swfPath = "components/datatables.net-buttons-swf/index.swf"; //in Ace demo ../components will be replaced by correct assets path
        /*   $.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';

           new $.fn.dataTable.Buttons(myTable, {
               buttons: [
                   {
                       "text": "<i class='glyphicon glyphicon-plus  bigger-110 red'></i>新增 ",
                       "className": "btn btn-white btn-primary btn-bold"
                   }
               ]
           });
           myTable.buttons().container().appendTo($('.tableTools-container'));*/


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