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
<script src="../js/render_func.js"></script>
<script src="../js/jquery.cookie.min.js"></script>
<script src="../assets/js/jquery.validate.min.js"></script>
<script src="../components/moment/moment.min.js"></script>
<script src="../components/monthpicker/MonthPicker.js"></script>
<script src="../components/typeahead.js/dist/typeahead.bundle.min.js"></script>
<script src="../components/typeahead.js/handlebars.js"></script>

<!-- bootstrap & fontawesome -->

<link rel="stylesheet" href="../components/font-awesome/css/font-awesome.css"/>
<link rel="stylesheet" href="../components/jquery-ui/jquery-ui.min.css"/>
<link rel="stylesheet" href="../components/monthpicker/MonthPicker.css"/>
<link rel="stylesheet" href="../assets/css/ace.css"/>
<style>
    .month-year-input {
        width: 100px;
        margin-right: 2px;
    }
</style>
<script type="text/javascript">
    jQuery(function ($) {
        var month = moment().month(moment().month() - 1).startOf('month');
        var url = "/anti/antiDrug.jspa?month={0}&quarter={1}";

        //initiate dataTables plugin
        var dynamicTable = $('#dynamic-table');
        var myTable = dynamicTable
        //.wrap("<div class='dataTables_borderWrap' />") //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                "columns": [
                    {"data": "chnName", "sClass": "center", "orderable": false, width: 40},
                    {"data": "chnName", "sClass": "center", "orderable": false, searchable: true},
                    {"data": "antiClass", "sClass": "center", render: renderAntiClass, "orderable": false},
                    {"data": "dose", "sClass": "center", defaultContent: '', "orderable": false},
                    {"data": "spec", "sClass": "center", "orderable": false},//4
                    {"data": "minUnit", "sClass": "center", "orderable": false},
                    {"data": "noData", "sClass": "center", defaultContent: '', "orderable": false},
                    {"data": "clinicQuantity", "sClass": "center", "orderable": false},
                    {"data": "hospitalQuantity", "sClass": "center", "orderable": false},
                    {"data": "bringQuantity", "sClass": "center", "orderable": false},//9
                    {"data": "total", "sClass": "center", "orderable": false},
                    {"data": "DDDs", "sClass": "center", render: renderAmount0, "orderable": false}
                ],
                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    }
                ],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                "ajax": {
                    url: url.format(month.format("YYYY-MM"), ""),
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                },
                searching: false,
                paging: false,
                "processing": true,
                "serverSide": true,
                select: {style: 'single'},
                "footerCallback": function (row, data, start, end, display) {
                    var api = this.api(), data;

                    // Remove the formatting to get integer data for summation
                    var intVal = function (i) {
                        return typeof i === 'string' ?
                            i.replace(/[\$,]/g, '') * 1 :
                            typeof i === 'number' ?
                                i : 0;
                    };

                    // Total over all pages
                    /*total = api
                        .column(4)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);*/
                    var sumCol = [7, 8, 9, 10, 11];
                    for (var i = 0; i < sumCol.length; i++) {
                        // Total over this page
                        pageTotal = api
                            .column(sumCol[i], {page: 'current'})
                            .data()
                            .reduce(function (a, b) {
                                return intVal(a) + intVal(b);
                            }, 0);

                        // Update footer
                        $(api.column(sumCol[i]).footer()).html(
                            accounting.format(pageTotal)
                        );
                    }
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

        $('.btn-info').click(function () {
            var mm = moment($('#PastDateDemo').val(), "YYYY-MM");
            if (mm.isValid())
                window.location.href = "/excel/antiDrug.jspa?month={0}&quarter={1}".format(month.format("YYYY-MM"), "");
            else
                window.location.href = "/excel/antiDrug.jspa?month={0}&quarter={1}".format("", $("select.chosen-select").val());
        });

        $('#PastDateDemo').MonthPicker({
            MaxMonth: 0, MonthFormat: 'yy-mm', Button: false, SelectedMonth: month.format("YYYY-MM")
        });
        $('.btn-success').click(function () {
            var mm = moment($('#PastDateDemo').val(), "YYYY-MM");
            if (mm.isValid())
                myTable.ajax.url(url.format(mm.format("YYYY-MM"), "")).load();
            else
                myTable.ajax.url(url.format("", $("select.chosen-select").val())).load();
        });

        var currentQuarter = moment().quarter();
        var currentYear = moment().year();
        for (var i = 0; i < 20; i++) {
            if (currentQuarter === 0) {
                currentYear--;
                currentQuarter = 4;
            }
            //console.log("quarter：" + currentYear + "-" + currentQuarter);
            $(".chosen-select").append("<option value='{0}'>{1}</option>".format((currentYear + "-" + currentQuarter), (currentYear + "-" + currentQuarter)))
            currentQuarter--;
        }
        $("select.chosen-select").change(function () {
            // console.log("select quarter:" + $(this).val());
            $('#PastDateDemo').MonthPicker('Clear')
        });
        $('#PastDateDemo').change(function () {
            //console.log("select month:" + $(this).val());
            var mm = moment($('#PastDateDemo').val(), "YYYY-MM");
            if (mm.isValid())
                $("select.chosen-select option[value='']").prop("selected", "selected");
        });

        $('#PastDateDemo').MonthPicker('option', 'OnAfterChooseMonth', function () {
            //console.log("select month2:" + $(this).val());
            $("select.chosen-select option[value='']").prop("selected", "selected");
        });

    })
</script>

<!-- #section:basics/content.breadcrumbs -->
<div class="breadcrumbs ace-save-state" id="breadcrumbs">
    <ul class="breadcrumb">
        <li>
            <i class="ace-icon fa fa-home home-icon"></i>
            <a href="/index.jspa">首页</a>
        </li>
        <li class="active">抗菌药按品种统计</li>

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


            <label>月份：</label>
            <input id="PastDateDemo" type="text" class="month-year-input nav-search-input">

            <label for="form-field-select-3">&nbsp;&nbsp;&nbsp;季度：</label>
            <select class="chosen-select nav-search-input " style="" id="form-field-select-3" data-placeholder="选择季度...">
                <option value=""></option>
            </select>
            &nbsp;&nbsp;&nbsp;
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
                        查询结果
                        <div class="pull-right tableTools-container"></div>

                    </div>

                    <!-- div.table-responsive -->

                    <!-- div.dataTables_borderWrap -->
                    <div>
                        <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                            <thead>
                            <tr>
                                <th rowspan="2">序号</th>
                                <th rowspan="2">药品通用名称</th>
                                <th rowspan="2">管理级别</th>
                                <th rowspan="2">剂型</th>
                                <th rowspan="2">规格</th>
                                <th rowspan="2">计量单位</th>
                                <th rowspan="2">计数单位</th>
                                <th colspan="4" style="text-align: center">用量</th>
                                <th rowspan="2">用药频度<br/>(DDDs)</th>
                            </tr>
                            <tr>
                                <th>门诊</th>
                                <th>住院</th>
                                <th>出院带药</th>
                                <th>总计</th>
                            </tr>
                            </thead>
                            <tfoot>
                            <tr>
                                <th colspan="7" style="text-align:right">总计</th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                            </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>


            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->

    <div id="dialog-error" class="hide alert" title="提示">
        <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
    </div>
</div>
<!-- /.page-content -->