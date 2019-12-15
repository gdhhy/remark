<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script src="../components/datatables/jquery.dataTables.min.js"></script>
<script src="../components/datatables/jquery.dataTables.bootstrap.min.js"></script>
<script src="../components/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="../components/datatables/dataTables.select.min.js"></script>
<%--<script src="../assets/js/ace.js"></script>--%>
<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>
<%--<script src="../assets/js/jquery.gritter.min.js"></script>--%>
<script src="../js/accounting.min.js"></script>
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
<style type="text/css">
    #showDepartDoctorDialog .modal-dialog {
        position: absolute;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
    }

    #showDepartDoctorDialog .modal-content {
        /*overflow-y: scroll; */
        position: absolute;
        top: 0;
        bottom: 0;
        width: 100%;
    }

    #showDepartDoctorDialog .modal-body {
        overflow-y: scroll;
        position: absolute;
        top: 38px;
        bottom: 0;
        width: 100%;
    }

    #showDepartDoctorDialog .modal-header .close {
        margin-right: 15px;
    }
</style>
<script type="text/javascript">
    jQuery(function ($) {
        var startDate = moment().month(moment().month() - 1).startOf('month');
        var endDate = moment().month(moment().month() - 1).endOf('month');
        var table = $.getUrlParam("table") == null ? 0 : $.getUrlParam("table");
        var url = "/sunning/statMedicine.jspa?fromDate={0}&toDate={1}&top3={2}&special={3}&medicineNo={4}&table=" + table;
        var baseChn = ["", "基药", "国基", "省基"];
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
                    {"data": "base", "sClass": "center"},
                    /*{"data": "minOfpack", "sClass": "center", defaultContent: ''},*/
                    {"data": "quantity", "sClass": "center"},
                    {"data": "amount", "sClass": "center"},//4
                    {"data": "patient", "sClass": "center"},
                    {"data": "amountRatio", "sClass": "center"},
                    {"data": "patientRatio", "sClass": "center"},
                    {"data": "topDepartment", "sClass": "center", defaultContent: ''},
                    {"data": "topDoctor", "sClass": "center", defaultContent: ''},
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
                    {
                        "orderable": false, "targets": 3, title: '基药'
                    },
                    /*{"orderable": false, "targets": 4, title: '包装转换比'},*/
                    {"orderable": false, "targets": 4, title: '数量'},
                    {
                        "orderable": false, "targets": 5, title: '金额', render: function (data, type, row, meta) {
                            if (data === "-") return "未授权";
                            return data.toFixed(2);
                        }
                    },
                    {"orderable": false, "targets": 6, title: '病人数'},
                    {
                        "orderable": false, "targets": 7, title: '金额占全院', render: function (data, type, row, meta) {
                            return (data * 100).toFixed(3) + "%";
                        }
                    },
                    {
                        "orderable": false, "targets": 8, title: '病人占全院', render: function (data, type, row, meta) {
                            return (data * 100).toFixed(3) + "%";
                        }
                    },
                    {"orderable": false, "targets": 9, title: '排名前三科室'},
                    {"orderable": false, "targets": 10, title: '排名前三医生'},
                    {
                        'targets': 11, 'searchable': false, 'orderable': false, width: 110, title: '走势/科室/医生',
                        render: function (data, type, row, meta) {
                            var jsp = row['type'] === 1 ? "clinic_list.jsp" : "recipe_list.jsp";
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="hasDetail" href="#" data-Url="javascript:showMedicineChart({0},\'{1}\');">'.format(data, row["chnName"]) +
                                '<i class="ace-icon fa fa-line-chart bigger-110"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasDetail" href="#" data-Url="javascript:showDepartmentDetail({0},\'{1}\',\'department\');">'.format(data, row["chnName"]) +
                                '<i class="ace-icon glyphicon glyphicon-th bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasDetail" href="#" data-Url="javascript:showDoctorDetail({0},\'{1}\',\'doctor\');">'.format(data, row["chnName"]) +
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
                    url: url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), false, '', ""),
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
        myTable.on('draw', function () {
            $('#dynamic-table tr').find('.hasDetail').click(function () {
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
        }).css("min-width", "210px").next("i").click(function () {
            // 对日期的i标签增加click事件，使其在鼠标点击时可以拉出日期选择
            $(this).parent().find('input').click();
        }).next().on(ace.click_event, function () {
            $(this).prev().focus();
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

        $('.btn-success').click(function () {
            var special = $('#special').val();
            var top3 = $('#top3').is(':checked');
            var medicineNo = $('#form-medicineNo').val();
            // console.log("medicine:" + medicineNo);
            //console.log('url=' + url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), top3, mental, medicineNo));
            if (startDate.year() !== endDate.year())
                showDialog("日期错误", "查询日期不能跨年！");
            else
                myTable.ajax.url(url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), top3, special, medicineNo)).load();
        });
        $('.btn-info').click(function () {
            var special = $('#special').val();
            var top3 = $('#top3').is(':checked');
            var medicineNo = $('#form-medicineNo').val();
            window.location.href = "/excel/statMedicine.jspa?fromDate={0}&toDate={1}&top3={2}&special={3}&medicineNo={4}"
                .format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), top3, special, medicineNo);
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
            $('#form-medicineNo').val(suggestion["medicineNo"]);
        });
        $('#form-medicine').on("input propertychange", function () {
            $('#form-medicineNo').val("");
        });

        function showMedicineChart(medicineNo, chnName) {
            var url = "/chart/medicine.jspa?fromDate={0}&toDate={1}&medicineNo={2}&chartWidth={3}&chartHeight={4}";
            /*   console.log($("#imagePic").width());
               console.log($("#imagePic").height());*/
            $('#dialog-title').text(chnName + " - 走势图");
            $('#showChartDialog').modal();
            $("#imagePic").attr("src", url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), medicineNo, $("#imagePic").width(), $("#imagePic").height()));

        }

        function showDepartmentDetail(medicineNo, chnName) {
            $('#doctorTable').hide();
            $('#departmentTable').show();
            var url = "/sunning/statMedicineGroupByDepart.jspa?fromDate={0}&toDate={1}&medicineNo={2}";

            //console.log("text=" + $('#disItem').val());
            $.ajax({
                type: "GET",
                url: url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), medicineNo),
                contentType: "application/json; charset=utf-8",
                cache: false,
                success: function (response, textStatus) {
                    var respObject = JSON.parse(response);
                    if (respObject.data.length > 0) {
                        //if($("#departmentTable tbody tr").length === 0)
                        //$('#departmentTable').empty();

                        $('#departmentTable tbody tr').remove();
                        var i = 0;
                        $.each(respObject.data, function () {
                            var $tr = ('<tr><td style="text-align: center">{0}</td><td style="text-align: center">{1}</td>' +
                                '<td style="text-align: right">{2}</td><td style="text-align: right">{3}</td></tr>')
                                .format(++i, this.department, accounting.format(this.amount, 2), accounting.format(this.ratio * 100, 1) + '%');
                            // console.log($tr);
                            $("#departmentTable tbody").append($tr);
                        });
                        $('#dialog-title2').text(chnName + " - 按科室汇总");
                        $('#showDepartDoctorDialog').modal();
                        //console.log("i=" + i);
                    }
                },
                error: function (response, textStatus) {/*能够接收404,500等错误*/
                    $("#errorText").html(response.responseText);
                    $("#dialog-error").removeClass('hide').dialog({
                        modal: true,
                        width: 600,
                        title: "请求状态码：" + response.status,//404，500等
                        buttons: [{
                            text: "确定", "class": "btn btn-primary btn-xs", click: function () {
                                $(this).dialog("close");
                            }
                        }]
                    });
                },

            });
        }

        function showDoctorDetail(medicineNo, chnName) {
            $('#doctorTable').show();
            $('#departmentTable').hide();
            url = "/sunning/getDoctorListByMedicine.jspa?fromDate={0}&toDate={1}&medicineNo={2}";
            $.ajax({
                type: "GET",
                url: url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), medicineNo),
                contentType: "application/json; charset=utf-8",
                cache: false,
                success: function (response, textStatus) {
                    var respObject = JSON.parse(response);
                    if (respObject.data.length > 0) {
                        //if($("#doctorTable tbody tr").length === 0)
                        //$('#doctorTable').empty();
                        $('#doctorTable tbody tr').remove();
                        var i = 0;
                        $.each(respObject.data, function () {
                            var $tr = ('<tr><td style="text-align: center">{0}</td><td style="text-align: center">{1}</td>' +
                                '<td style="text-align: right">{2}</td><td style="text-align: right">{3}</td></tr>')
                                .format(++i, this.doctorName, accounting.format(this.amount, 2), this.quantity);
                            // console.log($tr);
                            $("#doctorTable tbody").append($tr);
                        });
                        $('#dialog-title2').text(chnName + " - 按医生汇总");
                        $('#showDepartDoctorDialog').modal();
                        //console.log("i=" + i);
                    }
                },
                error: function (response, textStatus) {/*能够接收404,500等错误*/
                    $("#errorText").html(response.responseText);
                    $("#dialog-error").removeClass('hide').dialog({
                        modal: true,
                        width: 600,
                        title: "请求状态码：" + response.status,//404，500等
                        buttons: [{
                            text: "确定", "class": "btn btn-primary btn-xs", click: function () {
                                $(this).dialog("close");
                            }
                        }]
                    });
                },

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
        <li class="active">药品分析（天）</li>

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
            <label>选项：</label>
            <select class="chosen-select form-control" id="special" data-placeholder="选择职业">
                <option value="all">全部</option>
                <option value="base1">基药</option>
                <option value="base2">国基</option>
                <option value="base3">省基</option>
                <option value="assist">辅助</option>
                <option value="mental">精神</option>
            </select>&nbsp;&nbsp;&nbsp;
            <%--  辅助：
              <div class="input-group">
                  <input type="checkbox" id="assist">&nbsp;&nbsp;&nbsp;
              </div>
              精神：
              <div class="input-group">
                  <input type="checkbox" id="mental">&nbsp;&nbsp;&nbsp;
              </div>--%>
            <label>前三：</label>
            <div class="input-group">
                <input type="checkbox" id="top3">&nbsp;&nbsp;&nbsp;
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
                        查询结果
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

    <div id="showChartDialog" class="modal fade text-center" tabindex="-1">
        <div class="modal-dialog" style="display: inline-block; width: auto;">
            <div class="modal-content">
                <div class="modal-header no-padding">
                    <div class="table-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                            <span class="white">&times;</span>
                        </button>
                        <span id="dialog-title">走势图</span>
                    </div>
                </div>

                <div class="modal-body no-padding"><img id="imagePic" alt="走势图" width="650px" height="300px"/></div>

            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div>
    <div id="showDepartDoctorDialog" class="modal fade" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header no-padding">
                    <div class="table-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                            <span class="white">&times;</span>
                        </button>
                        <span id="dialog-title2">科室汇总</span>
                    </div>
                </div>

                <div class="modal-body no-padding">
                    <table id="departmentTable" class="table table-striped table-bordered table-hover no-margin-bottom no-border-top">
                        <thead>
                        <tr>
                            <th class="col-xs-1" style="text-align: center">排名</th>
                            <th class="col-xs-5" style="text-align: center">科室</th>
                            <th class="col-xs-3" style="text-align: center">金额</th>
                            <th class="col-xs-3" style="text-align: center">占比</th>
                        </tr>
                        </thead>

                        <tbody>

                        </tbody>
                    </table>
                    <table id="doctorTable" class="table table-striped table-bordered table-hover no-margin-bottom no-border-top">
                        <thead>
                        <tr>
                            <th class="col-xs-1" style="text-align: center">排名</th>
                            <th class="col-xs-5" style="text-align: center">医生</th>
                            <th class="col-xs-3" style="text-align: center">金额</th>
                            <th class="col-xs-3" style="text-align: center">数量</th>
                        </tr>
                        </thead>

                        <tbody>

                        </tbody>
                    </table>
                </div>

            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div>
</div>
<!-- /.page-content -->