<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script src="../components/datatables/jquery.dataTables.min.js"></script>
<script src="../components/datatables/jquery.dataTables.bootstrap.min.js"></script>
<script src="../components/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="../components/datatables/dataTables.select.min.js"></script>
<script src="../components/jquery-ui/jquery-ui.min.js"></script>
<%--<script src="../assets/js/ace.js"></script>--%>
<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>
<script src="../assets/js/jquery.gritter.min.js"></script>
<script src="../js/accounting.min.js"></script>
<script src="../js/render_func.js"></script>
<script src="../js/jquery.cookie.min.js"></script>
<%--<script src="../assets/js/jquery.validate.min.js"></script>--%>
<script src="../components/moment/moment.min.js"></script>
<script src="../components/bootstrap-daterangepicker/daterangepicker.js"></script>
<link rel="stylesheet" href="../components/bootstrap-daterangepicker/daterangepicker.css"/>
<!-- bootstrap & fontawesome -->

<link rel="stylesheet" href="../components/jquery-ui/jquery-ui.min.css"/>
<link rel="stylesheet" href="../assets/css/ace.css"/>
<script type="text/javascript">
    jQuery(function ($) {
        var dynamicTable = $('#taskLogTable');
        var myTable = dynamicTable
        //.wrap("<div class='dataTables_borderWrap' />") //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                bProcessing: true,
                lengthChange: false,
                pageLength: 5,
                "bServerSide": true,
                "columns": [
                    {"data": "logID", "sClass": "center"},
                    {"data": "exeTime", "sClass": "center", orderable: false, render: renderLongTime},
                    {"data": "timeSpent", "sClass": "center", orderable: false, defaultContent: "", render: renderMS},
                    {"data": "method", "sClass": "center", orderable: false},
                    {"data": "timeFrom", "sClass": "center", orderable: false},//4
                    {"data": "timeTo", "sClass": "center", orderable: false},
                    {"data": "deleteCount", "sClass": "center", orderable: false},
                    {"data": "insertCount", "sClass": "center", orderable: false},
                    {"data": "updateCount", "sClass": "center", orderable: false},
                    {
                        "data": "errMsg", "sClass": "center", orderable: false, render: function (data, type, row, meta) {
                            if (data !== null && data !== '') return "有";
                            return "";
                        }
                    }//9
                ],
                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 45, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    }],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                "ajax": {
                    url: "/monitor/getTaskLogList.jspa",
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                },

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
        });
        myTable.on('select', function (e, dt, type, indexes) {
            if (type === 'row') {
                var logID = myTable.rows(indexes).data()["0"]["logID"];
                var errMsg = myTable.rows(indexes).data()["0"]["errMsg"];
                console.log("data:" + JSON.stringify(myTable.rows(indexes).data()["0"], null, 4));
                if (logID)
                    $('#detailTable tbody tr').remove();
                if (errMsg) {
                    $('#alertMessage').html(errMsg);
                    $('.alert-danger').removeClass("hide");
                } else
                    $('.alert-danger').addClass("hide");
                //detailTable.ajax.url("/monitor/getTaskDetailList.jspa?logID="+logID).load();
                $.getJSON("/monitor/getTaskDetailList.jspa?logID=" + logID, function (result) {
                    $.each(result.data, function (index, object) {
                        // console.log("object:" + JSON.stringify(object, null, 4));
                        var $tr = ('<tr><td style="text-align: center">{0}</td><td style="text-align: center">{1}</td>' +
                            '<td style="text-align: right">{2}</td><td style="text-align: right">{3}</td>' +
                            '<td style="text-align: right">{4}</td><td style="text-align: right">{5}</td>' +
                            '<td style="text-align: right">{6}</td><td style="text-align: right">{7}</td><td style="text-align: right">{8}</td>' +
                            '</tr>').format(index + 1, object.exeTime, renderMS(object.timeSpent), this.procedureName,
                            this.tableName, this.lastID, this.deleteCount, this.insertCount, this.updateCount);
                        // console.log($tr);
                        $("#detailTable tbody").append($tr);
                    });
                });

                // do something with the ID of the selected items
            }
        });
        $.getJSON("/monitor/listTask.jspa", function (result) {
            if (result.data.length > 0)
                $('#taskTable tbody tr').remove();
            $.each(result.data, function (index, object) {
                // console.log("object:" + JSON.stringify(object, null, 4));
                var $tr = ('<tr><td style="text-align: center">{0}</td><td style="text-align: center">{1}</td>' +
                    '<td style="text-align: right">{2}</td></tr>').format(index + 1, object.taskName, rendeTimerTime(this.timerTime, this.timerMode));
                // console.log($tr);
                $("#taskTable tbody").append($tr);
            });
        });
        $.getJSON("/monitor/getRunningThread.jspa", function (result) {
            // if (result.data.length > 0)
            $('#threadInfo').html(result.threadInfo);
        });

        function rendeTimerTime(value, timerMode) {
            var dateValue = moment(value);
            if (timerMode === 0)
                return "每天" + dateValue.format('HH:mm');
            if (timerMode === 2)
                return "每月{0}日{1}".format(dateValue.format('DD'), dateValue.format('HH:mm'));
            else
                return dateValue.format('YYYY-MM-DD HH:mm');
        }

        /*
         var detailTable = dynamicTable2
        // .wrap("<div class='dataTables_borderWrap' />") //if you are applying horizontal scrolling (sScrollX)
             .DataTable({
                 "scrollY": "200px",
                 "scrollCollapse": true,
                 "paging": false,
                 info: false,
                 searching: false,
                 bAutoWidth: false,
                 bProcessing: true,
                 "columns": [
                     {"data": "detailID", "sClass": "center"},
                     {"data": "exeTime", "sClass": "center", orderable: false, render: renderLongTime},
                     {"data": "timeSpent", "sClass": "center", orderable: false, defaultContent: "", render: renderMS},
                     {"data": "procedureName", "sClass": "center", orderable: false},
                     {"data": "tableName", "sClass": "center", orderable: false},//4
                     {"data": "lastID", "sClass": "center", orderable: false},
                     {"data": "deleteCount", "sClass": "center", orderable: false},
                     {"data": "insertCount", "sClass": "center", orderable: false},
                     {"data": "updateCount", "sClass": "center", orderable: false}
                 ],
                 'columnDefs': [
                     {
                         "orderable": false, "targets": 0, width: 45, render: function (data, type, row, meta) {
                             return meta.row + 1 + meta.settings._iDisplayStart;
                         }
                     }],
                 "aaSorting": [],
                 language: {
                     url: '../components/datatables/datatables.chinese.json'
                 },


                 select: {
                     style: 'single'
                 }
             });*/
        function renderLongTime(data, type, row, meta) {
            return moment(data).format("YYYY-MM-DD HH:mm");
        }

        function renderMS(data, type, row, meta) {
            if (data === undefined) return '';
            if (data > 1000) return accounting.format(data / 1000, 1) + '秒';
            return data + "毫秒";
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
        <li class="active">导入任务</li>

    </ul><!-- /.breadcrumb -->

    <!-- #section:basics/content.searchbox -->
    <div class="nav-search" id="nav-search">

    </div><!-- /.nav-search -->

    <!-- /section:basics/content.searchbox -->
</div>

<!-- /section:basics/content.breadcrumbs -->
<div class="page-content">
    <div class="row">
        <div class="col-xs-12">


            <div class="row">
                <div class="col-sm-3">

                    <div class="widget-box widget-color-green">
                        <div class="widget-header widget-header-flat">
                            <h4 class="widget-title">
                                设定任务
                            </h4>
                            <div class="widget-toolbar no-border">
                                <button class="btn btn-xs btn-danger smaller">
                                   新任务 <i class="ace-icon fa fa-tasks"></i>
                                </button>


                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main no-padding" style="height:125px; overflow-y:auto">
                                <table class="table table-striped table-bordered table-hover table-detail " id="taskTable">
                                    <thead class="thin-border-bottom">
                                    <tr>
                                        <th>序号</th>
                                        <th>任务类型</th>
                                        <th>设定时间</th>
                                    </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="clearfix smaller">
                        <div class="pull-left alert alert-success no-margin smaller" id="threadInfo">
                        </div>
                    </div>
                </div>

                <div class="col-sm-9">
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="widget-box widget-color-blue">
                                <div class="widget-header widget-header-small">
                                    <h6 class="widget-title smaller ">运行记录</h6>
                                </div>

                                <div class="widget-body">
                                    <div class="widget-main no-padding">
                                        <table class="table table-striped table-bordered table-hover" id="taskLogTable">
                                            <thead class="thin-border-bottom">
                                            <tr>
                                                <th>序号</th>
                                                <th>执行时间</th>
                                                <th>耗时</th>
                                                <th>执行说明</th>
                                                <th>参数1</th>
                                                <th>参数2</th>
                                                <th>总删除</th>
                                                <th>总插入</th>
                                                <th>总更新</th>
                                                <th>错误</th>
                                            </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%--<div class="space-6"></div>--%>
                    <div class="alert alert-danger hide" style="margin-bottom: 0">
                        <button type="button" class="close" data-dismiss="alert">
                            <i class="ace-icon fa fa-times"></i>
                        </button>
                        <span id="alertMessage"></span>
                    </div>

                    <div class="row">
                        <div class="col-xs-12">
                            <div class="widget-box">
                                <div class="widget-header widget-header-small">
                                    <h6 class="widget-title smaller">
                                        执行结果
                                    </h6>
                                </div>

                                <div class="widget-body">
                                    <div class="widget-main no-padding" style="height:225px; overflow-y:auto">

                                        <table class="table table-striped table-bordered table-hover table-detail " id="detailTable">
                                            <thead class="thin-border-bottom">
                                            <tr>
                                                <th>序号</th>
                                                <th>执行时间</th>
                                                <th>耗时</th>
                                                <th>存储过程名</th>
                                                <th>表名</th>
                                                <th>ID值</th>
                                                <th>删除</th>
                                                <th>插入</th>
                                                <th>更新</th>
                                            </tr>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->

    <div id="dialog-error" class="hide alert" title="提示">
        <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
    </div>
    <div class="modal fade" id="loadingModal">
        <div style="width: 200px;height:20px; z-index: 20000; position: absolute; text-align: center; left: 50%; top: 50%;margin-left:-100px;margin-top:-10px">
            <div class="progress progress-striped active" style="margin-bottom: 0;">
                <div class="progress-bar" style="width: 100%;" id="loadingText">正在抽样……</div>
            </div>
        </div>
    </div>
    <div id="dialog-calcData" class="hide" title="执行时间段确认">
        重新计算指定时间段的数据量
        <div class="col-xs-12" style="padding-top: 10px">
            <label class="col-xs-2  no-padding-right" style="white-space: nowrap;margin-top: 7px;">日期：</label>
            <div class="input-group col-xs-10">
                <input class="form-control nav-search-input" name="dateRangeString" id="calcDateRange"
                       style="color: black"
                       data-date-format="YYYY-MM-DD"/>
                <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
            </div>
        </div>
    </div>
</div>
<!-- /.page-content -->