<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script src="../components/datatables/jquery.dataTables.min.js"></script>
<script src="../components/datatables/jquery.dataTables.bootstrap.min.js"></script>
<script src="../components/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="../components/datatables/dataTables.select.min.js"></script>
<%--<script src="../assets/js/ace.js"></script>--%>
<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>
<%--<script src="../assets/js/jquery.gritter.min.js"></script>--%>
<script src="../js/accounting.min.js"></script>
<script src="../js/render_func.js"></script>
<script src="../js/jquery.cookie.min.js"></script>
<script src="../assets/js/jquery.validate.min.js"></script>
<script src="../components/moment/moment.min.js"></script>
<script src="../components/bootstrap-daterangepicker/daterangepicker.js"></script>
<script src="../components/bootstrap-daterangepicker/daterangepicker.zh-CN.js"></script>
<script src="../components/typeahead.js/dist/typeahead.bundle.min.js"></script>
<script src="../components/typeahead.js/handlebars.js"></script>

<link rel="stylesheet" href="../components/bootstrap-daterangepicker/daterangepicker.css"/>
<!-- bootstrap & fontawesome -->

<link rel="stylesheet" href="../assets/css/ace.css"/>

<script type="text/javascript">
    jQuery(function ($) {
        var startDate = moment().month(moment().month() - 1).startOf('month');
        var endDate = moment().month(moment().month() - 1).endOf('month');
        var urlParam = "fromDate={0}&toDate={1}&queryItem={2}&queryField={3}&rational={4}";
        var url = "/remark/getClinicList.jspa?" + urlParam;

        //initiate dataTables plugin
        var dynamicTable = $('#dynamic-table');
        var myTable = dynamicTable
        //.wrap("<div class='dataTables_borderWrap' />") //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                bProcessing: true,
                "columns": [
                    {"data": "clinicID", "sClass": "center"},
                    {"data": "clinicDate", "sClass": "center"},
                    {"data": "serialNo", "sClass": "center"},
                    {"data": "patientName", "sClass": "center"},
                    {"data": "sex", "sClass": "center"},//4
                    {"data": "age", "sClass": "center"},
                    {"data": "diagnosis", "sClass": "center"},
                    {"data": "department", "sClass": "center"},
                    {"data": "doctorName", "sClass": "center"},
                    {"data": "result", "sClass": "center"},
                    {"data": "rational", "sClass": "center"},
                    {"data": "reviewDate", "sClass": "center"},
                    {"data": "reviewUser", "sClass": "center"}
                ],
                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {"orderable": false, "targets": 1, title: '处方日期'},
                    {"orderable": false, "targets": 2, title: '门诊号'},
                    {"orderable": false, "targets": 3, title: '病人姓名'},
                    {
                        "orderable": false, "targets": 4, title: '性别', render: function (data) {
                            return data ? "男" : "女";
                        }
                    },
                    {"orderable": false, "targets": 5, title: '年龄'},
                    {"orderable": false, "targets": 6, title: '诊断'},
                    {"orderable": false, "targets": 7, title: '科室'},
                    {"orderable": false, "targets": 8, title: '医生',},
                    {
                        "orderable": false, "targets": 9, title: '点评内容', render: function (data) {
                            if (data.length > 12) return data.substring(0, 10) + "...";
                            return data;
                        }
                    },
                    {
                        "orderable": false, "targets": 10, title: '结果', render: function (data) {
                            return data === 1 ? "√" : "×";
                        }
                    },
                    {"orderable": false, "targets": 11, title: '点评日期'},
                    {"orderable": false, "targets": 12, title: '点评人'}
                ],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                "ajax": {
                    url: url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), "", "", ""),
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                },

                "processing": true,
                "serverSide": true,
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


        var url2 = "/remark/getHospitalList.jspa?" + urlParam;
        var dynamicTable2 = $('#dynamic-table2');
        var myTable2 = dynamicTable2
        //.wrap("<div class='dataTables_borderWrap' />") //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                bProcessing: true,
                "columns": [
                    {"data": "recipeID", "sClass": "center"},
                    {"data": "inDate", "sClass": "center"},
                    {"data": "patientNo", "sClass": "center"},
                    {"data": "patientName", "sClass": "center"},
                    {"data": "sex", "sClass": "center"},//4
                    {"data": "age", "sClass": "center"},
                    {"data": "diagnosis", "sClass": "center"},
                    {"data": "department", "sClass": "center"},
                    {"data": "masterDoctorName", "sClass": "center"},
                    {"data": "result", "sClass": "center"},
                    {"data": "rational", "sClass": "center"},
                    {"data": "reviewDate", "sClass": "center"},
                    {"data": "reviewUser", "sClass": "center"}
                ],
                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {"orderable": false, "targets": 1, title: '入院日期'},
                    {"orderable": false, "targets": 2, title: '住院号'},
                    {"orderable": false, "targets": 3, title: '病人姓名'},
                    {
                        "orderable": false, "targets": 4, title: '性别', render: function (data) {
                            return data ? "男" : "女";
                        }
                    },
                    {"orderable": false, "targets": 5, title: '年龄'},
                    {"orderable": false, "targets": 6, title: '诊断'},
                    {"orderable": false, "targets": 7, title: '科室'},
                    {"orderable": false, "targets": 8, title: '主管医生',},
                    {
                        "orderable": false, "targets": 9, title: '点评内容', render: function (data) {
                            if (data.length > 12) return data.substring(0, 10) + "...";
                            return data;
                        }
                    },
                    {
                        "orderable": false, "targets": 10, title: '结果', render: function (data) {
                            return data === 1 ? "√" : "×";
                        }
                    },
                    {"orderable": false, "targets": 11, title: '点评日期'},
                    {"orderable": false, "targets": 12, title: '点评人'}
                ],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                "ajax": {
                    url: url2.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), "", "", ""),
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                },

                "processing": true,
                "serverSide": true,
                select: {
                    style: 'single'
                }
            });
        myTable2.on('draw', function () {
            $('#dynamic-table2 tr').find('.hasDetail').click(function () {
                if ($(this).attr("data-Url").indexOf('javascript:') >= 0) {
                    eval($(this).attr("data-Url"));
                } else
                    window.open($(this).attr("data-Url"), "_blank");
            });
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
        }).next().on(ace.click_event, function () {
            $(this).prev().focus();
        });


        $('.btn-success').click(function () {//查询
            var rational = $('input:radio[name="rational"]:checked').val() === undefined ? "" : $('input:radio[name="rational"]:checked').val();

            if ($('#form-type').val() === '1') {
                myTable.ajax.url(
                    url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), $('#queryItem').val(), $('#queryField').val(), rational)
                ).load();
            } else {
                myTable2.ajax.url(
                    url2.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), $('#queryItem').val(), $('#queryField').val(), rational)
                ).load();
            }
        });
        $('.btn-info').click(function () {
            var rational = $('input:radio[name="rational"]:checked').val() === undefined ? "" : $('input:radio[name="rational"]:checked').val();
            if ($('#form-type').val() === '1')
                window.location.href = "/excel/getClinicList.jspa?" + urlParam
                    .format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), $('#queryItem').val(), $('#queryField').val(), rational);
            else
                window.location.href = "/excel/getRecipeList.jspa?" + urlParam
                    .format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), $('#queryItem').val(), $('#queryField').val(), rational);
        });

        $('#form-type').on('change', function (e) {
            if (this.selectedIndex === 0) {
                $('#dt2').addClass("hide");
                $('#dt').removeClass("hide");
                $("#queryItem option:first").remove();
                $("#queryItem").prepend("<option value='serialNo'>门诊号</option>");
                $("#queryItem option:first").attr("selected", true);
                //$("#queryItem option:first").val("门诊号");
            } else {
                $('#dt').addClass("hide");
                $('#dt2').removeClass("hide");
                $("#queryItem option:first").remove();
                $("#queryItem").prepend("<option value='patientNo'>住院号</option>");
                $("#queryItem option:first").attr("selected", true);
            }
            $('#queryField').attr("placeholder", $("#queryItem option:first").text());
        });
        $('#queryItem').on('change', function (e) {//console.log("value:" + this.options[this.selectedIndex].innerHTML );
            $('#queryField').attr("placeholder", this.options[this.selectedIndex].innerHTML);
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
        <li class="active">医生用药分析</li>

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
            <label class=" control-label no-padding-right" for="form-type">门诊住院： </label>
            <div class="input-group">
                <select id="form-type" class=" nav-search-input ace" style="font-size: 9px;color: black">
                    <option value="1" selected>门诊</option>
                    <option value="2">住院</option>
                </select></div> &nbsp;&nbsp;&nbsp;

            <div class="input-group">
                <select class="nav-search-input   ace" id="queryItem" name="queryItem" style="font-size: 9px;color: black">
                    <option value="serialNo">门诊号</option>
                    <option value="doctorName">医生</option>
                    <option value="patientName">病人</option>
                </select>&nbsp;
                <input class="nav-search-input" type="text" id="queryField" name="queryField"
                       style="width: 120px;font-size: 9px;color: black"
                       placeholder="处方号"/>
            </div> &nbsp;&nbsp;&nbsp;
            <label>日期：</label>
            <!-- #section:plugins/date-time.datepicker -->
            <div class="input-group">
                <input class="form-control nav-search-input" name="dateRangeString" id="form-dateRange"
                       style="color: black"
                       data-date-format="YYYY-MM-DD"/>
                <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
            </div>&nbsp;&nbsp;&nbsp;

            <label>结果判断：</label>
            <div class="input-group">
                <label style="white-space: nowrap">
                    <input type="radio" name="rational" value="1" class="ace">&nbsp;&nbsp;&nbsp;
                    <span class="lbl">合理</span></label>
                <label style="white-space: nowrap">
                    <input type="radio" name="rational" value="0" class="ace">&nbsp;&nbsp;&nbsp;
                    <span class="lbl">不合理</span></label>
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
                        点评结果
                        <div class="pull-right tableTools-container"></div>

                    </div>

                    <!-- div.table-responsive -->

                    <!-- div.dataTables_borderWrap -->
                    <div id="dt">
                        <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                        </table>
                    </div>
                    <div id="dt2" class="hide">
                        <table id="dynamic-table2" class="table table-striped table-bordered table-hover">
                        </table>
                    </div>
                </div>
            </div>


            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->

</div>
<!-- /.page-content -->