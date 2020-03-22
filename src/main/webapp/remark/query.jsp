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
        var urlParam = "fromDate={0}&toDate={1}&queryItem={2}&queryField={3}&goodsID={4}";
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
                    {"data": "hospID", "sClass": "center"},
                    {"data": "patientName", "sClass": "center"},
                    {"data": "sex", "sClass": "center"},//4
                    {"data": "age", "sClass": "center"},
                    {"data": "diagnosis", "sClass": "center"},
                    {"data": "department", "sClass": "center"},
                    {"data": "doctorName", "sClass": "center"},
                    {"data": "reviewDate", "sClass": "center"}
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
                    {"orderable": false, "targets": 8, title: '医生'},
                    {
                        "orderable": false, "targets": 9, title: '点评', width: 45, render: function (data, type, row, meta) {
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="hasDetail" href="#" data-Url="/remark/viewClinic.jspa?clinicID={0}">'.format(row['clinicID']) +
                                (data === null ? '<i class="ace-icon glyphicon glyphicon-pencil  bigger-130"></i>' : data.substring(0, 10)) +
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
                    {"data": "inPatientID", "sClass": "center"},
                    {"data": "outDate", "sClass": "center"},
                    {"data": "hospNo", "sClass": "center"},
                    {"data": "patientName", "sClass": "center"},
                    {"data": "sex", "sClass": "center"},//4
                    {"data": "age", "sClass": "center"},
                    {"data": "diagnosis", "sClass": "center", defaultContent: ''},
                    {"data": "department", "sClass": "center", defaultContent: ''},
                    {"data": "masterDoctorName", "sClass": "center", defaultContent: ''},
                    {"data": "reviewTime", "sClass": "center", defaultContent: ''}
                ],
                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {"orderable": false, "targets": 1, title: '出院日期'},
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
                    {"orderable": false, "targets": 8, title: '主管医生'},
                    {
                        "orderable": false, "targets": 9, title: '点评', render: function (data, type, row, meta) {
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                /*'<a class="hasDetail" href="#" data-Url="/index.jspa?content=/remark/viewInPatient.jspa&inPatientID={0}">'.format(data) +*/
                                '<a class="hasDetail" href="#" data-Url="/remark/viewInPatient{0}.jspa?inPatientID={1}">'.format(0, row['inPatientID']) +
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
                    url: url2.format('2100-01-01', '2100-01-01', "", "", ""),/*目的查询返回空*/
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
            if ($('#form-type').val() === '1') {
                myTable.ajax.url(
                    url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), $('#queryItem').val(), $('#queryField').val(), $('#form-goodsID').val())
                ).load();
            } else {
                myTable2.ajax.url(
                    url2.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), $('#queryItem').val(), $('#queryField').val(), $('#form-goodsID').val())
                ).load();
            }
        });

        $('#form-type').on('change', function (e) {
            if (this.selectedIndex === 0) {
                $('#dt2').addClass("hide");
                $('#dt').removeClass("hide");
                $("#queryItem option:first").remove();
                $("#queryItem").prepend("<option value='hospID'>门诊号</option>");
                $("#queryItem option:first").attr("selected", true);
                $("#dateLabel").html("处方日期：");
                //$("#queryItem option:first").val("门诊号");
            } else {
                $('#dt').addClass("hide");
                $('#dt2').removeClass("hide");
                $("#queryItem option:first").remove();
                $("#queryItem").prepend("<option value='hospNo'>住院号</option>");
                $("#queryItem option:first").attr("selected", true);
                $("#dateLabel").html("出院日期：");
            }
            $('#queryField').attr("placeholder", $("#queryItem option:first").text());
        });
        $('#queryItem').on('change', function (e) {//console.log("value:" + this.options[this.selectedIndex].innerHTML );
            $('#queryField').attr("placeholder", this.options[this.selectedIndex].innerHTML);
        });


        //https://github.com/twitter/typeahead.js/blob/master/doc/jquery_typeahead.md
        $('#form-medicine').typeahead({hint: true},
            {
                limit: 1000,
                source: function (queryStr, processSync, processAsync) {
                    var params = {queryChnName: queryStr, length: 1000};
                    $.getJSON('/medicine/liveMedicine.jspa', params, function (json) {
                        //medicineLiveCount = json.iTotalRecords;
                        //console.log("count:" + medicineLiveCount);
                        return processAsync(json.data);
                    });
                },
                display: function (item) {
                    return item.chnName + " - " + item.spec;
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
            $('#form-goodsID').val(suggestion["goodsID"]);
        });
        $('#form-medicine').on("input propertychange", function () {
            $('#form-goodsID').val("");
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
                    <option value="hospID">门诊号</option>
                    <option value="doctorName">医生</option>
                    <option value="patientName">病人</option>
                </select>&nbsp;
                <input class="nav-search-input" type="text" id="queryField" name="queryField"
                       style="width: 120px;font-size: 9px;color: black"
                       placeholder="处方号"/>
            </div> &nbsp;&nbsp;&nbsp;
            <label id="dateLabel">处方日期：</label>
            <!-- #section:plugins/date-time.datepicker -->
            <div class="input-group">
                <input class="form-control nav-search-input" name="dateRangeString" id="form-dateRange"
                       style="color: black"
                       data-date-format="YYYY-MM-DD"/>
                <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
            </div>&nbsp;&nbsp;&nbsp;

            <label class=" control-label no-padding-right" for="form-medicine">药品名称： </label>
            <div class="input-group">
                <input class="typeahead scrollable nav-search-input" type="text" id="form-medicine" name="form-medicine"
                       autocomplete="off" style="width: 250px;font-size: 9px;color: black"
                       placeholder="编码或拼音匹配，鼠标选择"/><input type="hidden" id="form-goodsID"/>
            </div>&nbsp;&nbsp;&nbsp;

            <button type="button" class="btn btn-sm btn-success">
                查询
                <i class="ace-icon glyphicon glyphicon-search icon-on-right bigger-100"></i>
            </button>
        </form>
    </div><!-- /.page-header -->

    <div class="row">
        <div class="col-xs-12">

            <div class="row">

                <div class="col-xs-12">
                    <div class="table-header">查询结果
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