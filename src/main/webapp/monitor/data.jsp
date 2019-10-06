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
<%--<script src="../js/jquery.cookie.min.js"></script>--%>
<%--<script src="../assets/js/jquery.validate.min.js"></script>--%>
<script src="../components/moment/moment.min.js"></script>
<script src="../components/bootstrap-daterangepicker/daterangepicker.js"></script>
<link rel="stylesheet" href="../components/bootstrap-daterangepicker/daterangepicker.css"/>
<!-- bootstrap & fontawesome -->

<link rel="stylesheet" href="../assets/css/ace.css"/>

<script type="text/javascript">
    jQuery(function ($) {
        var endDate = moment();
        var startDate = moment().month(endDate.month() - 3);
        var url = "/monitor/getDataList.jspa?fromDate={0}&toDate={1}";

        //initiate dataTables plugin
        var dynamicTable = $('#dynamic-table');
        var myTable = dynamicTable
        //.wrap("<div class='dataTables_borderWrap' />") //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                bProcessing: true,
                "columns": [
                    {"data": "monitorID", "sClass": "center"},
                    {"data": "dataDate", "sClass": "center", orderable: false},
                    {"data": "clinicCount", "sClass": "center", orderable: false},
                    {"data": "rxDetailCount", "sClass": "center", orderable: false},
                    {"data": "rxCount", "sClass": "center", orderable: false},//4
                    {"data": "lydCount", "sClass": "center", orderable: false},
                    {"data": "lydmxCount", "sClass": "center", orderable: false},
                    {"data": "recipeCount", "sClass": "center", orderable: false},
                    {"data": "recipeItemCount", "sClass": "center", orderable: false},
                    {"data": "doctorCount", "sClass": "center", orderable: false},//9
                    {"data": "medicineCount", "sClass": "center", orderable: false},
                    {"data": "surgeryCount", "sClass": "center", orderable: false},
                    {"data": "updateTime", "sClass": "center", orderable: false},
                    {"data": "dataDate", "sClass": "center", orderable: false},
                ],
                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 45, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    }, {
                        'targets': 13, 'searchable': false, 'orderable': false,
                        render: function (data, type, row, meta) {
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="hasDetail" href="#" data-Url="javascript:deleteDialog(\'{0}\');">'.format(data) +
                                '<i class="ace-icon  glyphicon glyphicon-trash  bigger-110"></i>' +
                                '</a> ' +
                                '</div>';
                        }
                    }],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                "ajax": {
                    url: url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), ""),
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                },

                // "processing": true,
                //"serverSide": true,
                searching: false,
                select: {
                    style: 'single'
                }
            });
        myTable.on('draw', function () {
            var $tr = $('#dynamic-table tr');
            $tr.find('.hasDetail').click(function () {
                if ($(this).attr("data-Url").indexOf('javascript:') >= 0) {
                    eval($(this).attr("data-Url"));
                } else
                    window.open($(this).attr("data-Url"), "_blank");
            });
            $tr.find("td:eq(1)").each(function () {
                //console.log($(this).text());
                var mm = moment($(this).text());
                if (mm.day() === 0 || mm.day() === 6) {
                    $(this).css('background-color', '#c4ffdb');
                }
            });
            $tr.find("td:eq(2),td:eq(6),td:eq(8)").each(function (index, object) {
                ///console.log("object:" + JSON.stringify(object, null, 4));
                warningColor(object._DT_CellIndex.row, object._DT_CellIndex.column, this);
            });
            /*  $tr.find("td:eq(6)").each(function (rowIndex, object) {
                  warningColor(rowIndex + myTable.page.info().start, object._DT_CellIndex.column, this);
              });
              $tr.find("td:eq(8)").each(function (rowIndex, object) {
                  warningColor(rowIndex + myTable.page.info().start, object._DT_CellIndex.column, this);
              });*/

        });

        function warningColor(rowIndex, colIndex, td) {
            var compareIndex = rowIndex >= myTable.data().length - 7 ? rowIndex - 7 : rowIndex + 7;
            while (compareIndex < myTable.data().length - 7 && compareIndex > 0 && myTable.data()[compareIndex][colIndex] === 0)
                if (compareIndex > rowIndex) compareIndex += 7;
                else compareIndex -= 7;
            if (compareIndex < 0 || compareIndex >= myTable.data().length)
                return;

            var colorValue;
            // var compareValue = parseInt(myTable.columns().data()[colIndex][compareIndex]);//todo 7天之和

            var sum = 0;
            for (var k = Math.min(rowIndex, compareIndex); k < Math.max(rowIndex, compareIndex); k++)
                sum += parseInt(myTable.columns().data()[colIndex][k]);
            var compareValue = sum / 7;
            var me = parseInt($(td).text());
            /*   console.log("compareIndex:" + compareIndex);*/
            if ($(td).text() < compareValue && compareValue > 0) {
                colorValue = parseInt(me / compareValue * 256);
                if (colorValue <= 15)
                    $(td).css('background-color', '#FF0' + colorValue.toString(16) + '0' + colorValue.toString(16));
                else if (colorValue < 128)
                    $(td).css('background-color', '#FF' + colorValue.toString(16) + colorValue.toString(16));
            } else if (me > compareValue && me > 0) {
                colorValue = parseInt(compareValue / me * 256);
                if (colorValue <= 15)
                    $(td).css('background-color', '#FFFF' + '0' + colorValue.toString(16));
                else if (colorValue < 192)
                    $(td).css('background-color', '#FFFF' + colorValue.toString(16));
            }
            //console.log("colorValue:" + colorValue);
            // console.log("");
        }

        $('#form-dateRange').daterangepicker({
            'applyClass': 'btn-sm btn-success',
            'cancelClass': 'btn-sm btn-default',
            startDate: startDate,
            endDate: endDate,
            locale: {
                format: 'YYYY-MM-DD',
                separator: ' ～ ',
                applyLabel: '确定',
                cancelLabel: '取消'
            }
        }, function (start, end, label) {
            startDate = start;
            endDate = end;
        }).next().on(ace.click_event, function () {
            $(this).prev().focus();
        });

        var calcEndDate = moment(endDate),
            calcStartDate = moment(calcEndDate).subtract(10, "days");


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
            myTable.ajax.url(url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"))).load();
        });
        $('.btn-info').click(function () {

            $("#dialog-calcData").removeClass('hide').dialog({
                resizable: false,
                width: 360,
               // height: 220,
                 modal: true,
                /* title: "确认统计时间段",*/
                buttons: [
                    {
                        html: "<i class='ace-icon  glyphicon   glyphicon-play-circle bigger-130'></i>&nbsp;执行",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            $.ajax({
                                type: "POST",
                                url: "/monitor/calcDataRowCount.jspa?fromDate={0}&toDate={1}"
                                    .format(calcStartDate.format("YYYY-MM-DD"), calcEndDate.format("YYYY-MM-DD")),
                                //data: {"fromDate": calcStartDate.format("YYYY-MM-DD"), "toDate": calcEndDate.format("YYYY-MM-DD")},
                                contentType: "application/json; charset=utf-8",
                                cache: false,
                                success: function (response, textStatus) {
                                    showDialog("统计数据量", response.succeed ? "统计成功" : "统计失败");
                                    if (response.succeed)
                                        myTable.ajax.reload();
                                },
                                error: function (response, textStatus) {/*能够接收404,500等错误*/
                                    showDialog("请求状态码：" + response.status, response.responseText.substr(0, 1000));
                                },
                                // async: false, //同步请求，默认情况下是异步（true）
                                beforeSend: function () {
                                    $('#loadingText').text("正在统计……");
                                    $("#loadingModal").modal({backdrop: 'static', keyboard: false});
                                    $("#loadingModal").modal('show');
                                    $("#dialog-calcData").dialog("close");
                                },
                                complete: function () {
                                    $("#loadingModal").modal('hide');
                                }
                            });

                        }
                    }, {
                        html: "<i class='ace-icon fa fa-times bigger-150'></i>&nbsp; 取消",
                        "class": "btn btn-minier",
                        click: function () {
                            $(this).dialog("close");
                        }
                    }
                ]
            });

            $('#calcDateRange').daterangepicker({
                'applyClass': 'btn-sm btn-success',
                'cancelClass': 'btn-sm btn-default',
                startDate: calcStartDate, //设置开始日期
                endDate: calcEndDate, //设置结束器日期
                locale: {
                    format: 'YYYY-MM-DD',
                    separator: ' ～ ',
                    applyLabel: '确定',
                    cancelLabel: '取消'
                }
            }, function (start, end, label) {
                calcStartDate = start;
                calcEndDate = end;
            }).next().on(ace.click_event, function () {
                $(this).prev().focus();
            });
        });

        function deleteDialog(dataDate) {
            $('#deleteDate').text(dataDate);
            $("#dialog-delete").removeClass('hide').dialog({
                resizable: false,
                modal: true,
                title: "确认删除数据",
                //title_html: true,
                buttons: [
                    {
                        html: "<i class='ace-icon fa  fa-trash bigger-110'></i>&nbsp;确定",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            $.ajax({
                                type: "POST",
                                url: "/monitor/deleteData.jspa?fromDate={0}&toDate={1}".format(dataDate, dataDate),
                                //contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                                cache: false,
                                success: function (response, textStatus) {
                                    // var result = JSON.parse(response);
                                    /* if (result.succeed)
                                         myTable.ajax.reload();
                                     else*/
                                    showDialog("请求结果：" + response.succeed, response.message);
                                },
                                error: function (response, textStatus) {/*能够接收404,500等错误*/
                                    showDialog("请求状态码：" + response.status, response.responseText.substr(0, 1000));
                                },
                                beforeSend: function () {
                                    $('#loadingText').text("正在删除……");
                                    $("#loadingModal").modal({backdrop: 'static', keyboard: false});
                                    $("#loadingModal").modal('show');
                                    $("#dialog-delete").dialog("close");
                                },
                                complete: function () {
                                    $("#loadingModal").modal('hide');
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
        <li class="active">数据监控</li>

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
            <label>日期：</label>
            <!-- #section:plugins/date-time.datepicker -->
            <div class="input-group">
                <input class="form-control nav-search-input" name="dateRangeString" id="form-dateRange"
                       style="color: black"
                       data-date-format="YYYY-MM-DD"/>
                <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
            </div>&nbsp;&nbsp;&nbsp;

            <button type="button" class="btn btn-sm btn-success">
                查询
                <i class="ace-icon glyphicon glyphicon-search icon-on-right bigger-100"></i>
            </button>
            <button type="button" class="btn btn-sm btn-info">
                重新统计
                <i class="ace-icon glyphicon glyphicon-refresh  icon-on-right bigger-100"></i>
            </button>
        </form>
    </div><!-- /.page-header -->

    <div class="row">
        <div class="col-xs-12">

            <div class="row">

                <div class="col-xs-12">
                    <div class="table-header">
                        数据列表
                        <div class="pull-right tableTools-container"></div>

                    </div>

                    <!-- div.table-responsive -->

                    <!-- div.dataTables_borderWrap -->
                    <div>
                        <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                            <thead>
                            <th style="text-align: center">序号</th>
                            <th style="text-align: center">数据日期</th>
                            <th style="text-align: center">处方</th>
                            <th style="text-align: center">处方明细</th>
                            <th style="text-align: center">原始处方</th>
                            <th style="text-align: center">药房领用单</th>
                            <th style="text-align: center">药房明细</th>
                            <th style="text-align: center">出院病人</th>
                            <th style="text-align: center">住院医嘱</th>
                            <th style="text-align: center">医生</th>
                            <th style="text-align: center">药品</th>
                            <th style="text-align: center">手术数</th>
                            <th style="text-align: center">统计时间</th>
                            <th style="text-align: center">删除</th>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>


            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->
    <div id="dialog-calcData" class="hide" title="执行时间段确认">
        重新计算指定时间段的数据量
        <div class="col-xs-12" style="padding-top: 10px">
            <label class="col-xs-3  no-padding-right" style="white-space: nowrap;margin-top: 7px;">日期：</label>
            <div class="input-group col-xs-9">
                <input class="form-control nav-search-input" name="dateRangeString" id="calcDateRange"
                       style="color: black"
                       data-date-format="YYYY-MM-DD"/>
                <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
            </div>
        </div>
    </div>
    <div class="modal fade" id="loadingModal">
        <div style="width: 200px;height:20px; z-index: 20000; position: absolute; text-align: center; left: 50%; top: 50%;margin-left:-100px;margin-top:-10px">
            <div class="progress progress-striped active" style="margin-bottom: 0;">
                <div class="progress-bar" style="width: 100%;" id="loadingText">正在抽样……</div>
            </div>
        </div>
    </div>
    <div id="dialog-delete" class="hide">
        <div class="alert alert-info bigger-110">
            删除 <span id="deleteDate" class="red"></span>的<span class="purple">处方、病历、药房领用</span>数据，<br/>
            删除后不可恢复，只可重新导入。<br/>
            小心谨慎！
        </div>

        <div class="space-6"></div>

        <p class="bigger-110 bolder center grey">
            <i class="icon-hand-right blue bigger-120"></i>
            确认吗？
        </p>
    </div>
</div>
<!-- /.page-content -->