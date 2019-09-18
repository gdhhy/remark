<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script src="../components/datatables/jquery.dataTables.min.js"></script>
<script src="../components/datatables/jquery.dataTables.bootstrap.min.js"></script>
<script src="../components/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="../components/datatables/dataTables.select.min.js"></script>
<script src="../components/jquery-ui/jquery-ui.min.js"></script>
<%--<script src="../assets/js/ace.js"></script>--%>
<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>
<%--<script src="../assets/js/jquery.gritter.min.js"></script>--%>
<script src="../js/accounting.min.js"></script>
<script src="../js/jquery.cookie.min.js"></script>
<script src="../assets/js/jquery.validate.min.js"></script>
<script src="../components/moment/moment.min.js"></script>
<script src="../components/bootstrap-daterangepicker/daterangepicker.js"></script>
<script src="../components/typeahead.js/dist/typeahead.bundle.min.js"></script>
<script src="../components/typeahead.js/handlebars.js"></script>

<link rel="stylesheet" href="../components/bootstrap-daterangepicker/daterangepicker.css"/>
<!-- bootstrap & fontawesome -->

<link rel="stylesheet" href="../components/font-awesome/css/font-awesome.css"/>
<link rel="stylesheet" href="../components/jquery-ui/jquery-ui.min.css"/>
<link rel="stylesheet" href="../assets/css/ace.css"/>
<script type="text/javascript">
    jQuery(function ($) {
        var startDate = moment().month(moment().month() - 1).startOf('month');
        var endDate = moment().month(moment().month() - 1).endOf('month');
        var url = "/sunning/statMedicine.jspa?fromDate={0}&toDate={1}&assist={2}&mental={3}&medicineNo={4}";

        //initiate dataTables plugin
        var dynamicTable = $('#dynamic-table');
        var myTable = dynamicTable
        //.wrap("<div class='dataTables_borderWrap' />") //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                bProcessing: true,
                "columns": [
                    {"data": "medicineNo", "sClass": "center"},
                    {"data": "chnName", "sClass": "center"},
                    {"data": "spec", "sClass": "center"},
                    {"data": "quantity", "sClass": "center"},
                    {"data": "amount", "sClass": "center"},//4
                    {"data": "patient", "sClass": "center"},
                    {"data": "amountRatio", "sClass": "center"},
                    {"data": "patientRatio", "sClass": "center"},
                    {"data": "medicineNo", "sClass": "center"}
                ],
                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {"orderable": false, "targets": 1, title: '药品名称'},
                    {"orderable": false, "targets": 2, title: '规格'},
                    {"orderable": false, "targets": 3, title: '数量'},
                    {
                        "orderable": false, "targets": 4, title: '金额', render: function (data, type, row, meta) {
                            if (data === "-") return "未授权";
                            return data.toFixed(2);
                        }
                    },
                    {"orderable": false, "targets": 5, title: '病人数'},
                    {
                        "orderable": false, "targets": 6, title: '金额占全院', render: function (data, type, row, meta) {
                            return (data * 100).toFixed(3) + "%";
                        }
                    },
                    {
                        "orderable": false, "targets": 7, title: '病人占全院', render: function (data, type, row, meta) {
                            return (data * 100).toFixed(3) + "%";
                        }
                    },
                    {
                        'targets': 8, 'searchable': false, 'orderable': false, width: 110, title: '走势/科室/医生',
                        render: function (data, type, row, meta) {
                            var jsp = row['type'] === 1 ? "clinic_list.jsp" : "recipe_list.jsp";
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="hasDetail green" href="#" data-Url="/index.jspa?content=/remark/{2}&sampleBatchID={0}&remarkType={1}&menuID=14&batchName={3}">'.format(data, row["medicineNo"], jsp, encodeURI(encodeURI(row["chnName"]))) +
                                '<i class="ace-icon glyphicon glyphicon-stats "></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasDetail" href="#" data-Url="javascript:deleteBatch({0},\'{1}\');">'.format(data, row["name"]) +
                                '<i class="ace-icon glyphicon glyphicon-th bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasDetail" href="#" data-Url="javascript:deleteBatch({0},\'{1}\');">'.format(data, row["name"]) +
                                '<i class="ace-icon glyphicon glyphicon-user bigger-130"></i>' +
                                '</a>' +
                                '</div>';
                        }
                    }],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                "ajax": {
                    url: url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), false, false, ""),
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                },

                // "processing": true,
                "serverSide": true,
                select: {
                    style: 'single'
                }
            });
        /* myTable.on('order.dt search.dt', function () {
             myTable.column(0, {search: 'applied', order: 'applied'}).nodes().each(function (cell, i) {
                 cell.innerHTML = i + 1;
             });
         }).draw();*/
        myTable.on('draw', function () {
            $('#dynamic-table tr').find('.hasDetail').click(function () {
                if ($(this).attr("data-Url").indexOf('javascript:') >= 0) {
                    eval($(this).attr("data-Url"));
                } else
                    window.open($(this).attr("data-Url"), "_blank");
            });
        });


        var dateRange = $('#form-dateRange').daterangepicker({
            'applyClass': 'btn-sm btn-success',
            'cancelClass': 'btn-sm btn-default',
            locale: {
                format: 'YYYY-MM-DD',
                separator: ' ～ ',
                applyLabel: '确定',
                cancelLabel: '取消'
            }
        }, function (start, end, label) {
            startDate = start;
            endDate = end;
            console.log(start);
        }).next().on(ace.click_event, function () {
            $(this).prev().focus();
        });
        $('#form-dateRange').val(startDate.format("YYYY-MM-DD") + " ～ " + endDate.format("YYYY-MM-DD"));


        //todo 统一到一个对话框
        function showDialog(title, content) {
            $("#errorText").text(content);
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

        $('.btn-success').click(function () {
            var mental = $('#mental').is(':checked');
            var assist = $('#assist').is(':checked');
            var medicineNo = $('#form-medicineNo').val();
            console.log("medicine:" + medicineNo);
            console.log('url=' + url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), assist, mental, medicineNo));
            myTable.ajax.url(url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), assist, mental, medicineNo)).load();
        });

        //https://github.com/twitter/typeahead.js/blob/master/doc/jquery_typeahead.md
        $('#form-medicine').typeahead({hint: true},
            {
                limit: 1000,
                source: function (queryStr, processSync, processAsync) {
                    var params = {queryChnName: queryStr, length: 1000};
                    $.getJSON('/remark/liveMedicine.jspa', params, function (json) {
                        //medicineLiveCount = json.iTotalRecords;
                        //console.log("count:" + medicineLiveCount);
                        return processAsync(json.data);
                    });
                },
                display: function (item) {
                    return item.chnName + "-" + item.spec;
                },
                templates: {
                    header: function (query) {//header or footer
                        //console.log("query:" + JSON.stringify(query, null, 4));
                        if (query.suggestions.length > 1)
                            return '<div style="text-align:center" class="green" >发现 {0} 项</div>'.format(query.suggestions.length);
                    },
                    suggestion: Handlebars.compile('<div style="font-size: 9px">' +
                        '<div style="font-weight:bold">{{chnName}}</div>' +
                        '<span class="light-grey">编码：</span>{{goodsNo}}<span class="space-4"/> <span class="light-grey">规格：</span>{{spec}}</div>'),
                    pending: function (query) {
                        return '<div>查询中...</div>';
                    },
                    notFound: '<div class="red">没匹配</div>'
                }
            }
        );
        $('.typeahead').bind('typeahead:select', function (ev, suggestion) {
            $('#form-medicineNo').val(suggestion["medicineNo"]);
        });
        $('#form-medicine').on("input propertychange", function () {
            $('#form-medicineNo').val("");
            //console.log("clear medicineNo");
        });
        /*$('#form-medicine').bind('typeahead:asyncrequest', function (ev, suggestion, ds) {
            for (var o in ev) console.log("o:" + o);
        });*/

    })
</script>

<!-- #section:basics/content.breadcrumbs -->
<div class="breadcrumbs ace-save-state" id="breadcrumbs">
    <ul class="breadcrumb">
        <li>
            <i class="ace-icon fa fa-home home-icon"></i>
            <a href="/index.jspa">首页</a>
        </li>
        <li class="active">抽样点评</li>

    </ul><!-- /.breadcrumb -->

    <!-- #section:basics/content.searchbox -->
    <div class="nav-search" id="nav-search">

    </div><!-- /.nav-search -->

    <!-- /section:basics/content.searchbox -->
</div>

<!-- /section:basics/content.breadcrumbs -->
<div class="page-content">
    <div class="page-header">

        <form class="form-search form-inline">
            <label class=" control-label no-padding-right" for="form-medicine">药品名称： </label>
            <div class="input-group">
                <input class="typeahead scrollable nav-search-input" type="text" id="form-medicine" name="form-medicine"
                       autocomplete="off" style="width: 250px;font-size: 9px;color: black"
                       placeholder="编码或拼音匹配，鼠标选择"/><input type="hidden" id="form-medicineNo"/>
            </div>

            <label>日期：</label>
            <!-- #section:plugins/date-time.datepicker -->
            <div class="input-group">
                <input class="form-control nav-search-input" name="dateRangeString" id="form-dateRange"
                       style="color: black"
                       data-date-format="YYYY-MM-DD"/>
                <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
            </div>&nbsp;&nbsp;&nbsp;

            辅助：
            <div class="input-group">
                <input type="checkbox" id="assist">&nbsp;&nbsp;&nbsp;
            </div>
            精神：
            <div class="input-group">
                <input type="checkbox" id="mental">&nbsp;&nbsp;&nbsp;
            </div>

            <button type="button" class="btn btn-sm btn-success">
                查询
                <i class="ace-icon glyphicon glyphicon-search icon-on-right bigger-100"></i>
            </button>
            <button type="button" class="btn btn-sm btn-info">
                导出
                <i class="ace-icon glyphicon glyphicon-download icon-on-right bigger-100"></i>
            </button>
        </form>
    </div><!-- /.page-header -->

    <div class="row">
        <div class="col-xs-12">

            <div class="row">

                <div class="col-xs-12">
                    <div class="table-header">
                        药品排名
                        <div class="pull-right tableTools-container"></div>

                    </div>

                    <!-- div.table-responsive -->

                    <!-- div.dataTables_borderWrap -->
                    <div>
                        <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                        </table>
                    </div>
                </div>
            </div>


            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->

    <div id="dialog-loading" class="hide info" title="提示">
        <p id="infoText" class="ace-icon fa fa-spinner fa-spin fa-3x fa-fw">请稍后……</p>
    </div>

    <div id="dialog-error" class="hide alert" title="提示">
        <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
    </div>
</div>
<!-- /.page-content -->