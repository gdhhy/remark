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
        var url = "/sunning/doctorAnti.jspa?fromDate={0}&toDate={1}&goodsID={2}";
        var totalAntiAmount;
        //initiate dataTables plugin
        var dynamicTable = $('#dynamic-table');
        var myTable = dynamicTable
            //.wrap("<div class='dataTables_borderWrap' />") //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                bProcessing: true,
                "columns": [
                    {"data": "doctorID", "sClass": "center"},
                    {"data": "doctorName", "sClass": "center", defaultContent: ''},
                    {"data": "antiAmount", "sClass": "center"},
                    {"data": "antiQty", "sClass": "center"},
                    {"data": "amountRatio", "sClass": "center"},//4
                    {"data": "antiAmountRatio", "sClass": "center"},//求和后计算
                    {"data": "outAntiPatient", "sClass": "center"},
                    {"data": "antiPatientRatio", "sClass": "center"},
                    {"data": "hospitalDay", "sClass": "center", defaultContent: ''},
                    {"data": "DDDs", "sClass": "center"},//9
                    {"data": "AUD", "sClass": "center"},
                    {"data": "clinicAntiPatient", "sClass": "center"},
                    {"data": "clinicAntiPatientRatio", "sClass": "center"},
                    {"data": "clinicAntiCompose", "sClass": "center"},
                    {"data": "doctorID", "sClass": "center"}
                ],
                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {"orderable": false, "targets": 1, title: '医生', searchable: true},
                    {"orderable": false, "targets": 2, title: '抗菌药<br/>金额', render: renderAmount},
                    {"orderable": false, "targets": 3, title: '抗菌药<br/>数量'},
                    {"orderable": false, "targets": 4, title: '抗菌药金<br/>额比例', render: renderPercent1},
                    {"orderable": false, "targets": 5, title: '占总抗菌<br/>药比例', render: renderPercent1},
                    {"orderable": false, "targets": 6, title: '住院抗菌<br/>药病人数'},
                    {"orderable": false, "targets": 7, title: '住院抗菌<br/>药医嘱率', render: renderPercent1},
                    {"orderable": false, "targets": 8, title: '出院患者<br/>住院天数'},
                    {"orderable": false, "targets": 9, title: 'DDDs', render: renderAmount0},
                    {"orderable": false, "targets": 10, title: '使用强度', render: renderAmount0},
                    {"orderable": false, "targets": 11, title: '门诊抗菌</br>药处方数'},
                    {"orderable": false, "targets": 12, title: '门诊抗菌药</br>处方比例', render: renderPercent1},
                    {"orderable": false, "targets": 13, title: '门诊抗菌药</br>处方占比', render: renderPercent1},
                    {
                        'targets': 14, 'searchable': false, 'orderable': false, width: 110, title: '医生明细',
                        render: function (data, type, row, meta) {

                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="hasDetail" href="#" data-Url="javascript:showDoctorDetail(\'{0}\',\'{1}\');">'.format(data, row['doctorName']) +
                                '<i class="ace-icon glyphicon  glyphicon-list  bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '</div>';
                        }
                    }],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },/* drawCallback: function () {
                    var api = this.api();

                    //Calculates the total of the column
                    totalAntiAmount = api
                        .column(5)  //the salary column
                        .data()
                        .reduce(function (a, b) {
                            return a + b;
                        }, 0);
                    console.log(totalAntiAmount);
                },*/
                "ajax": {
                    url: url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), ""),
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                },
                //'paging': false,
                // "processing": true,
                //"serverSide": true,
                select: {
                    style: 'single'
                }
            });
        myTable.on('draw', function () {
            $('#dynamic-table tr').find('.hasDetail').click(function () {
                if ($(this).attr("data-Url").indexOf('javascript:') >= 0) {
                    console.log($(this).attr("data-Url"));
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


        $('.btn-success').click(function () {
            var goodsID = $('#form-goodsID').val();
            // console.log("medicine:" + goodsID);
            myTable.ajax.url(url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), goodsID)).load();
        });
        $('.btn-info').click(function () {
            window.location.href = "/excel/byDoctorAnti.jspa?fromDate={0}&toDate={1}".format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"));
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

        function showDoctorDetail(doctorID, doctorName) {
            var url = "/sunning/medicineList.jspa?fromDate={0}&toDate={1}&doctorID={2}&limit=1000&antiClass=0";

            //console.log("text=" + $('#disItem').val());
            $.ajax({
                type: "GET",
                url: url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), doctorID),
                contentType: "application/json; charset=utf-8",
                cache: false,
                success: function (response, textStatus) {
                    var respObject = JSON.parse(response);
                    if (respObject.data.length > 0) {

                        $('#doctorTable tbody tr').remove();
                        var i = 0;
                        $.each(respObject.data, function () {
                            var $tr = ('<tr><td style="text-align: center">{0}</td><td style="text-align: center">{1}</td>' +
                                '<td style="text-align: right">{2}</td><td style="text-align: right">{3}</td>' +
                                '<td style="text-align: right">{4}</td><td style="text-align: right">{5}</td></tr>'
                            ).format(++i, this.chnName, this.spec, this.quantity, accounting.format(this.amount, 2), accounting.format(this.amountRatio * 100, 2) + '%');
                            // console.log($tr);
                            $("#doctorTable tbody").append($tr);
                        });
                        $('#dialog-title').text(doctorName + " - 用药明细");
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
        <li class="active">医生用药趋势</li>

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
                       placeholder="编码或拼音匹配，鼠标选择"/><input type="hidden" id="form-goodsID"/>
            </div>

            <label>日期：</label>
            <!-- #section:plugins/date-time.datepicker -->
            <div class="input-group">
                <input class="form-control nav-search-input" name="dateRangeString" id="form-dateRange"
                       style="color: black;width:200px"
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

    <div id="showDepartDoctorDialog" class="modal fade" tabindex="-1">
        <div class="modal-dialog" style="width: 600px">
            <div class="modal-content">
                <div class="modal-header no-padding">
                    <div class="table-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                            <span class="white">&times;</span>
                        </button>
                        <span id="dialog-title">医生用药明细</span>
                    </div>
                </div>

                <div class="modal-body no-padding">
                    <table id="doctorTable" class="table table-striped table-bordered table-hover no-margin-bottom no-border-top">
                        <thead>
                        <tr>
                            <th class="col-xs-1" style="text-align: center">排名</th>
                            <th class="col-xs-4" style="text-align: center">药品</th>
                            <th class="col-xs-2" style="text-align: center">规格</th>
                            <th class="col-xs-1" style="text-align: center">数量</th>
                            <th class="col-xs-2" style="text-align: center">金额</th>
                            <th class="col-xs-2" style="text-align: center">占本科<br/>室比例</th>
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