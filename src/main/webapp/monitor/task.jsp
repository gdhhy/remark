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
<script src="../components/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script src="../components/bootstrap-datepicker/locales/bootstrap-datepicker.zh-CN.min.js"></script>

<link rel="stylesheet" href="../components/bootstrap-daterangepicker/daterangepicker.css"/>
<link rel="stylesheet" href="../components/bootstrap-datepicker/css/bootstrap-datepicker3.css"/>
<!-- bootstrap & fontawesome -->

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
                //console.log("data:" + JSON.stringify(myTable.rows(indexes).data()["0"], null, 4));
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

        function listTask() {
            $.getJSON("/monitor/listTask.jspa", function (result) {
                if (result.data.length > 0)
                    $('#taskTable tbody tr').remove();
                $.each(result.data, function (index, object) {
                    // console.log("object:" + JSON.stringify(object, null, 4));
                    var $tr = ('<tr><td style="text-align: center">{0}</td><td style="text-align: center">{1}</td>' +
                        '<td style="text-align: right">{2}</td><td style="text-align: center">' +
                        '<i class="ace-icon glyphicon glyphicon-trash red bigger-110" data-id={3} data-time="{4}" data-name={5}></i></td></tr>')
                        .format(index + 1, object.taskName, rendeTimerTime(this.timerTime, this.timerMode),
                            object.taskID, rendeTimerTime(this.timerTime, this.timerMode), object.taskName);
                    // console.log($tr);
                    $("#taskTable tbody").append($tr);
                });

                $('#taskTable tbody tr').find(".fa-trash-o").bind("click", function () {
                    deleteDialog($(this).attr("data-id"), $(this).attr("data-time"), $(this).attr("data-name"))
                });
            });
        }

        listTask();
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

        $('.btn-danger').click(function (e) {
            $("#dialog-task").removeClass('hide').dialog({
                modal: true,
                width: 600,
                title_html: true,
                buttons: [{
                    html: "<i class='ace-icon fa fa-check bigger-110'></i>&nbsp; 提交", "class": "btn  btn-xs btn-success btn-primary", click: function () {
                        var param = {
                            runType: $("input[name='runType']:checked").val(),
                            timerMode: $('#timerMode').children('option:selected').val(),
                            exeDateField: $('#execDate').val(),
                            exeTimeField: $('#execTime').children('option:selected').val(),
                            timeFrom: timeFrom.format("YYYY-MM-DD"),
                            timeTo: timeTo.format("YYYY-MM-DD"),
                        };
                        console.log("param:" + JSON.stringify(param));
                        $.ajax({
                            type: "POST",
                            url: "/monitor/submitTask.jspa",
                            data: param,
                            contentType: "application/x-www-form-urlencoded; charset=UTF-8", //https://www.cnblogs.com/yoyotl/p/5853206.html
                            cache: false,
                            success: function (response, textStatus) {
                                showDialog("定时任务", response.message);
                                if (param.timerMode !== 2)
                                    listTask();
                                $('#dialog-task').dialog("close");
                            },
                            error: function (response, textStatus) {/*能够接收404,500等错误*/
                                showDialog("请求状态码：" + response.status, response.responseText);
                            }
                        });
                    },
                }, {
                    html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 取消",
                    "class": "btn btn-primary btn-xs btn-grey",
                    click: function () {
                        $(this).dialog("close");
                    }
                }]
            });

        });
        var timeFrom = moment().subtract(1, 'd'), timeTo = moment().subtract(1, 'd');
        $('#form-dateRange').daterangepicker({
            'applyClass': 'btn-sm btn-success',
            'cancelClass': 'btn-sm btn-default',
            startDate: timeFrom,
            endDate: timeTo,
            locale: {
                format: 'YYYY-MM-DD',
                separator: ' ～ ',
                applyLabel: '确定',
                cancelLabel: '取消'
            }
        }, function (start, end, label) {
            timeFrom = start;
            timeTo = end;
        }).next().on(ace.click_event, function () {
            $(this).prev().focus();
        });
        $("input[name='runType']").on('change', function () {
            //console.log("value:" + $(this).val());
            var tips = ["执行从医院HIS系统导入数据（相当于每日定时：review.daily)", "统计每张处方使用药品情况，例如抗菌药、基本药物、注射等",
                "生成部门、医生、药品等维度的日统计汇总", "根据药物相互作用，搜索疑有配伍禁忌处方，生成处方点评的配伍禁忌处方模块数据"];
            $('#taskInfo').html(tips[$(this).val() - 1]);
        });
        //datepicker plugin
        //link
        $('.date-picker').datepicker({
            autoclose: true,
            format: "yyyy-mm-dd", //选择日期后，文本框显示的日期格式
            language: 'zh-CN', //汉化
            //startDate: '-3d',
            todayHighlight: true
        })
        //show datepicker when clicking on the icon
            .next().on(ace.click_event, function () {
            $(this).prev().focus();
        });
        $('#execDate').val(moment().add(1, "days").format("YYYY-MM-DD"));

        var mm = moment({hour: 0, minute: 0});
        var mm2 = moment({hour: 23, minute: 59});
        var execTime = $('#execTime');
        while (mm < mm2) {
            if ("04:00" === mm.format("HH:mm"))
                execTime.append("<option value='{0}' selected>{1}</option>".format(mm.format("HH:mm"), mm.format("HH:mm")));
            else
                execTime.append("<option value='{0}'>{1}</option>".format(mm.format("HH:mm"), mm.format("HH:mm")));
            mm.add(10, "minutes");
        }

        $('#timerMode').on('change', function () {
            switch (parseInt($(this).val())) {
                case 0:
                    $('#divDate').hide();
                    $('#divTime').show();
                    break;
                case 1:
                    $('#divDate').show();
                    $('#divTime').show();
                    break;
                default://2
                    $('#divDate').hide();
                    $('#divTime').hide();
            }
        });

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

        function deleteDialog(taskID, taskTime, taskName) {

            /*    console.log("taskID:" + taskID);
                console.log("taskTime:" + taskTime);
                console.log("taskName:" + taskName);
                return;*/
            $('#deleteTaskTime').text(taskTime);
            $('#deleteTaskName').text(taskName);
            $("#dialog-delete").removeClass('hide').dialog({
                resizable: false,
                modal: true,
                title: "确认删除任务",
                //title_html: true,
                buttons: [
                    {
                        html: "<i class='ace-icon fa  fa-trash bigger-110'></i>&nbsp;确定",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            $.ajax({
                                type: "POST",
                                url: "/monitor/deleteTask.jspa?taskID={0}".format(taskID),
                                //contentType: "application/x-www-form-urlencoded",//http://www.cnblogs.com/yoyotl/p/5853206.html
                                cache: false,
                                success: function (response, textStatus) {
                                    showDialog("请求结果：" + response.succeed, response.message);
                                    if (response.succeed)
                                        listTask();
                                },
                                error: function (response, textStatus) {/*能够接收404,500等错误*/
                                    showDialog("请求状态码：" + response.status, response.responseText);
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
                                <button class="btn btn-xs btn-danger">
                                    新任务 <i class="ace-icon fa fa-tasks"></i>
                                </button>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main no-padding" style="height:290px; overflow-y:auto">
                                <table class="table table-striped table-bordered table-hover table-detail " id="taskTable">
                                    <thead class="thin-border-bottom">
                                    <tr>
                                        <th style="text-align: center">序号</th>
                                        <th>任务类型</th>
                                        <th style="text-align: right">设定时间</th>
                                        <th style="text-align: center">删除</th>
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
                    <div class="alert alert-danger no-padding  hide" style="margin-bottom: 0">
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
    <div class="modal fade" id="loadingModal">
        <div style="width: 200px;height:20px; z-index: 20000; position: absolute; text-align: center; left: 50%; top: 50%;margin-left:-100px;margin-top:-10px">
            <div class="progress progress-striped active" style="margin-bottom: 0;">
                <div class="progress-bar" style="width: 100%;" id="loadingText">正在抽样……</div>
            </div>
        </div>
    </div>
    <div id="dialog-task" class="hide" title="设定新任务">
        <div class="col-xs-12 ">
            <div class="col-xs-12">重新计算指定时间段的数据量</div>
            <div class="row ">
                <div class="col-xs-5">
                    <div class="row">
                        <label class="col-xs-3 bolder blue" style="white-space: nowrap;margin-top: 10px;">任务类型</label>
                        <div class="col-xs-9">
                            <div class="radio">
                                <label>
                                    <input name="runType" type="radio" class="ace" value="3" checked>
                                    <span class="lbl"> 每日统计汇总</span>
                                </label>
                            </div>

                            <div class="radio">
                                <label>
                                    <input name="runType" type="radio" class="ace" value="2">
                                    <span class="lbl">重建处方数据</span>
                                </label>
                            </div>

                            <div class="radio">
                                <label>
                                    <input name="runType" type="radio" class="ace" value="4">
                                    <span class="lbl" style="white-space: nowrap">搜索有配伍禁忌处方</span>
                                </label>
                            </div>

                            <div class="radio">
                                <label>
                                    <input name="runType" type="radio" class="ace" value="1">
                                    <span class="lbl" style="white-space: nowrap"> 亿通HIS->处方点评</span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xs-7">
                    <div class="row">
                        <label class="col-xs-3 bolder blue  no-padding-right" style="white-space: nowrap;margin-top: 7px;">时间范围</label>
                        <div class="input-group col-xs-9">
                            <input class="form-control nav-search-input" name="form-dateRange" id="form-dateRange"
                                   style="color: black"
                                   data-date-format="YYYY-MM-DD"/>
                            <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
                        </div>
                    </div>
                </div>
            </div>
            <hr class="row no-margin no-padding"/>
            <div class="row">
                <div class="col-xs-5" style="margin-top: 10px;">
                    <label class="control-label bolder blue  no-padding-right" for="timerMode"> 执行方式&nbsp;&nbsp;&nbsp;</label>

                    <select id="timerMode">
                        <option value="0">每天循环</option>
                        <option value="1" selected>指定时间</option>
                        <option value="2">马上执行</option>
                    </select>
                </div>
                <div class="col-xs-7">
                    <div class="row form-inline" id="divDate" style="margin-top: 10px;">
                        <label class="control-label  bolder blue" for="execDate" style="text-overflow:ellipsis; white-space:nowrap;">执行日期&nbsp;&nbsp;&nbsp;</label>
                        <div class="input-group">
                            <input class="date-picker " style="width: 110px" id="execDate" type="text"/>
                            <span class="input-group-addon  "><i class="fa fa-calendar bigger-110"></i></span>
                        </div>
                    </div>
                    <div class="row form-inline" id="divTime" style="margin-top: 10px;">
                        <label class="control-label  bolder blue" for="execTime" style="text-overflow:ellipsis; white-space:nowrap;">执行时间&nbsp;&nbsp;&nbsp;</label>
                        <select id="execTime">
                        </select>
                    </div>
                </div>
            </div>
            <div class="row" style="margin-top: 10px;">
                <div class="pull-left alert alert-info  no-margin col-xs-12" id="taskInfo">
                    生成部门、医生、药品等维度的日统计汇总
                </div>
            </div>
        </div>
    </div>
    <div id="dialog-delete" class="hide">
        <div class="alert alert-info bigger-110">
            您确定要删除 <span id="deleteTaskTime"></span> 执行的 <span id="deleteTaskName"></span> 任务吗?
        </div>
    </div>
</div>
<!-- /.page-content -->