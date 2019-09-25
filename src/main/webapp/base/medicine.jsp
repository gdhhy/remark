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

<script type="text/javascript">
    jQuery(function ($) {
        var url = "/medicine/getMedicineList.jspa?queryChnName={0}";

        //initiate dataTables plugin
        var dynamicTable = $('#dynamic-table');
        var myTable = dynamicTable
        //.wrap("<div class='dataTables_borderWrap' />") //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                "searching": true,
                "iDisplayLength": 50,
                "columns": [
                    {"data": "medicineID", "sClass": "center", "orderable": false, width: 40},
                    {"data": "no", "sClass": "center", "orderable": false, searchable: true},
                    {"data": "chnName", "sClass": "center", "orderable": false, className: 'middle'},
                    {"data": "healthName", "sClass": "center", "orderable": false},
                    {"data": "route", "sClass": "center", defaultContent: '', "orderable": false},//4
                    {"data": "dose", "sClass": "center", "orderable": false},
                    {"data": "spec", "sClass": "center", "orderable": false},
                    {"data": "base", "sClass": "center", defaultContent: '', "orderable": false, render: renderBase2},
                    {"data": "insurance", "sClass": "center", "orderable": false, render: renderInsurance},
                    {"data": "antiClass", "sClass": "center", "orderable": false, render: renderAntiClass},//9
                    {"data": "generalName", "sClass": "center", "orderable": false},
                    {"data": "instructionName", "sClass": "center", "orderable": false},
                    {"data": "updateTime", "sClass": "center", "orderable": false, render: renderTime},
                    {"data": "lastPurchaseTime", "sClass": "center", "orderable": false, render: renderTime},
                    {"data": "updateUser", "sClass": "center", "orderable": false},//14
                    {"data": "medicineID", "sClass": "center", "orderable": false}
                ],
                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    }, {
                        'targets': 15, 'searchable': false, 'orderable': false, width: 110, //title: '科室明细',
                        render: function (data, type, row, meta) {
                            var jsp = row['type'] === 1 ? "clinic_list.jsp" : "recipe_list.jsp";
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="hasDetail" href="#" data-Url="javascript:showDepartmentDetail(\'{0}\');">'.format(data) +
                                '<i class="ace-icon glyphicon  glyphicon-list  bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '</div>';
                        }
                    }
                ],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                "ajax": {
                    url: url.format(""),
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                },
                /* "fnServerParams": function ( aoData ) {
                     aoData.push(
                         { "name": "queryChnName", "value": $("#form-medicine").val() },
                         { "name": "goodsNo", "value": $("#form-goodsNo").val() }
                     );
                 },*/
                // paging: false,
                "processing": true,
                "serverSide": true,
                select: {style: 'single'},

            });
        var route = [];
        myTable.on('draw', function () {
            $('#dynamic-table tr').find('.hasDetail').click(function () {
                if ($(this).attr("data-Url").indexOf('javascript:') >= 0) {
                    eval($(this).attr("data-Url"));
                } else
                    window.open($(this).attr("data-Url"), "_blank");
            });
            if (route.length === 0)
                $.getJSON("/common/dict/listDict.jspa?parentID=261", function (result) {
                    $.each(result.data, function (index, object) {
                        route[index] = object;
                        //console.log("object:" + object.value);
                    });
                    renderRoute();
                });
            else renderRoute();
        });

        function renderRoute() {
            $('#dynamic-table tr').each(function () {
                var tdArr = $(this).children();
                //console.log("route:" + tdArr.eq(4).text());
                $.each(route, function (index, object) {
                    if (object.value === tdArr.eq(4).text())
                        tdArr.eq(4).text(object.name);
                });
            });
        }

        function renderTime(data, type, row, meta) {
            var mm = moment(data);
            if (mm.isValid())
                return moment(data).format("YY-MM-DD");
            return "";
        }

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
            if ($('#form-goodsNo').val() !== '')
                myTable.ajax.url("/medicine/getMedicineList.jspa?goodsNo={0}".format($('#form-goodsNo').val())).load();
            else
                myTable.ajax.url("/medicine/getMedicineList.jspa?queryChnName={0}".format($('#form-medicine').val())).load();

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
            console.log("no:" + suggestion["goodsNo"]);
            $('#form-goodsNo').val(suggestion["goodsNo"]);
        });
        $('#form-medicine').on("input propertychange", function () {
            $('#form-goodsNo').val("");
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
            <label class=" control-label no-padding-right" for="form-medicine">药品名称： </label>
            <div class="input-group">
                <input class="typeahead scrollable nav-search-input" type="text" id="form-medicine" name="form-medicine"
                       autocomplete="off" style="width: 250px;font-size: 9px;color: black"
                       placeholder="编码或拼音匹配，鼠标选择"/><input type="hidden" id="form-goodsNo"/>
            </div>

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
                    <div class="table-header">
                        药品列表
                        <div class="pull-right tableTools-container"></div>

                    </div>

                    <!-- div.table-responsive -->

                    <!-- div.dataTables_borderWrap -->
                    <div>
                        <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                            <thead>
                            <tr>
                                <th style="text-align: center">序号</th>
                                <th style="text-align: center">药品<br/>编码</th>
                                <th style="text-align: center">药品名称</th>
                                <th style="text-align: center">药理分类</th>
                                <th style="text-align: center;width:45px;">给药<br/>途径</th>
                                <th style="text-align: center">剂型</th>
                                <th style="text-align: center">规格</th>
                                <th style="text-align: center;width:45px">基药</th>
                                <th style="text-align: center;width:45px">医保</th>
                                <th style="text-align: center;width:45px">特别<br/>标记</th>
                                <th style="text-align: center">对应<br/>通用名</th>
                                <th style="text-align: center">对应<br/>说明书</th>
                                <th style="text-align: center;width:80px">更新日期</th>
                                <th style="text-align: center;width:80px">最后<br/>采购日期</th>
                                <th style="text-align: center;width:60px;">维护人</th>
                                <th style="text-align: center;width:60px;">编辑/配对</th>
                            </tr>
                            </thead>

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