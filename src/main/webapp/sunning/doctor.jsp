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
        var url = "/sunning/byDoctor.jspa?fromDate={0}&toDate={1}";

        //initiate dataTables plugin
        var dynamicTable = $('#dynamic-table');
        var myTable = dynamicTable
        //.wrap("<div class='dataTables_borderWrap' />") //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                bProcessing: true,
                "columns": [
                    {"data": "doctorName", "sClass": "center"},
                    {"data": "doctorName", "sClass": "center"},
                    {"data": "amount", "sClass": "center"},
                    {"data": "clinicAmount", "sClass": "center"},
                    {"data": "hospitalAmount", "sClass": "center"},//4
                    {"data": "clinicPatient", "sClass": "center"},
                    {"data": "clinicPatient2", "sClass": "center"},
                    {"data": "hospitalPatient", "sClass": "center"},
                    {"data": "clinicAmount", "sClass": "center"},
                    {"data": "hospitalAmount", "sClass": "center"}
                ],
                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {"orderable": false, "targets": 1, title: '医生'},
                    {"orderable": false, "targets": 2, title: '金额', render: renderAmount},
                    {"orderable": false, "targets": 3, title: '门诊金额', render: renderAmount},
                    {"orderable": false, "targets": 4, title: '住院金额', render: renderAmount},
                    {"orderable": false, "targets": 5, title: '门诊病人', defaultContent: ''},
                    {"orderable": false, "targets": 6, title: '门诊病人<br/>（西药）', defaultContent: ''},
                    {"orderable": false, "targets": 7, title: '出院病人', defaultContent: ''},
                    {"orderable": false, "targets": 8, title: '门诊平均', render: clinicAvr},
                    {"orderable": false, "targets": 9, title: '出院平均', render: hospitalAvr}
                ],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                "ajax": {
                    url: url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD")),
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                },

                // "processing": true,
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
        });

        function clinicAvr(data, type, row, meta) {
            if (row["clinicPatient"] > 0)
                return accounting.format(data / row["clinicPatient"], 2);
            else
                return "-";
        }

        function hospitalAvr(data, type, row, meta) {
            if (row["hospitalPatient"] > 0)
                return accounting.format(data / row["hospitalPatient"], 2);
            else return "-";
        }

        $('#form-dateRange').daterangepicker({
            'applyClass': 'btn-sm btn-success',
            'cancelClass': 'btn-sm btn-default',
            startDate: startDate,
            endDate: endDate,
            ranges: {
                '本月': [moment().startOf('month')],
                '上月': [moment().month(moment().month() - 1).startOf('month'),  moment().month(moment().month() - 1).endOf('month')],
                '本季': [moment().startOf('quarter')],
                '上季': [moment().quarter(moment().quarter() - 1).startOf('month'),  moment().quarter(moment().quarter() - 1).endOf('quarter')],
                '今年': [moment().startOf('year')],
                '去年':  [moment().year(moment().year() - 1).startOf('year'),  moment().year(moment().year() - 1).endOf('year')]
            },
            locale: locale
        }, function (start, end, label) {
            startDate = start;
            endDate = end;
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
            myTable.ajax.url(url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"))).load();
        });
        $('.btn-info').click(function () {
            window.location.href = "/excel/byDoctor.jspa?fromDate={0}&toDate={1}".format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"));
        });


        /* function showDepartmentDetail(department) {
             var url = "/sunning/byDepartDetail.jspa?fromDate={0}&toDate={1}&department={2}&limit=1000";

             //console.log("text=" + $('#disItem').val());
             $.ajax({
                 type: "GET",
                 url: url.format(startDate.format("YYYY-MM-DD"), endDate.format("YYYY-MM-DD"), department),
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
                                 '<td style="text-align: right">{2}</td><td style="text-align: right">{3}</td>' +
                                 '<td style="text-align: right">{4}</td><td style="text-align: right">{5}</td></tr>'
                             ).format(++i, this.chnName, this.spec, this.quantity, accounting.format(this.amount, 2), accounting.format(this.ratioInDepart * 100, 2) + '%');
                             // console.log($tr);
                             $("#departmentTable tbody").append($tr);
                         });
                         $('#dialog-title').text(department + " - 用药明细");
                         $('#showDepartDoctorDialog').modal();
                         console.log("i=" + i);
                     }
                 },
                 error: function (response, textStatus) {/!*能够接收404,500等错误*!/
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
         }*/
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

    <%--<div id="showDepartDoctorDialog" class="modal fade" tabindex="-1">
        <div class="modal-dialog" style="width: 600px">
            <div class="modal-content">
                <div class="modal-header no-padding">
                    <div class="table-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                            <span class="white">&times;</span>
                        </button>
                        <span id="dialog-title">科室用药明细</span>
                    </div>
                </div>

                <div class="modal-body no-padding">
                    <table id="departmentTable" class="table table-striped table-bordered table-hover no-margin-bottom no-border-top">
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
    </div>--%>
</div>
<!-- /.page-content -->