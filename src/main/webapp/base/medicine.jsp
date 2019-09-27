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
<script src="../components/typeahead.js/dist/typeahead.bundle.min.js"></script>
<script src="../components/typeahead.js/handlebars.js"></script>
<script src="../components/chosen/chosen.jquery.js"></script>
<script src="../components/combotree/comboTreePlugin.js?v2"></script>

<!-- bootstrap & fontawesome -->

<link rel="stylesheet" href="../components/font-awesome/css/font-awesome.css"/>
<link rel="stylesheet" href="../components/jquery-ui/jquery-ui.min.css"/>
<link rel="stylesheet" href="../components/chosen/chosen.min.css"/>
<%--<link href="https://www.jqueryscript.net/css/jquerysctipttop.css" rel="stylesheet" type="text/css">--%>
<link rel="stylesheet" href="../components/combotree/style.css"/>
<style>
    .form-group {
        margin-bottom: 3px;
        margin-top: 3px;
    }
</style>
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
                        'targets': 15, 'searchable': false, 'orderable': false,
                        render: function (data, type, row, meta) {
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="hasDetail" href="#" data-Url="javascript:showMedicine(\'{0}\');">'.format(data) +
                                '<i class="ace-icon fa  fa-pencil-square-o bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasDetail" href="#" data-Url="javascript:showMedicine(\'{0}\');">'.format(data) +
                                '<i class="ace-icon fa  fa-exchange  bigger-130"></i>' +
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
                    url: url.format(""),
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                },
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
                    });
                    renderRoute();
                    setRouteOption();
                });
            //else renderRoute();
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


        //下拉多选
        $('.chosen-select').chosen({allow_single_deselect: true, no_results_text: "未找到此选项!"});

        //$('.chosen-select').css({'width': 190});
        /*resize the chosen on window resize*/
        $(window)
            .off('resize.chosen')
            .on('resize.chosen', function () {
                $('.chosen-select').each(function () {
                    var $this = $(this);
                    $this.next().css({'width': 190});
                })
            }).trigger('resize.chosen');
        //resize chosen on sidebar collapse/expand
        $(document).on('settings.ace.chosen', function (e, event_name, event_val) {
            console.log("settings.ace.chosen");
            if (event_name !== 'sidebar_collapsed') return;
            $('.chosen-select').each(function () {
                var $this = $(this);
                $this.next().css({'width': 190});
            })
        });//下拉多选结束

        function setRouteOption() {
            $.each(route, function (index, object) {
                $('#route').append("<option value='{0}'>{1}</option>".format(object.value, object.name));
            });
            $("#route").trigger("chosen:updated");
        }

        $.getJSON("/common/dict/listDict.jspa?parentDictNo=00015", function (result) {
            $.each(result.data, function (index, object) {
                $('#injection').append("<option value='{0}'>{1}</option>".format(object.value, object.name));
            });
            $("#injection").trigger("chosen:updated");
        });
        $.getJSON("/common/dict/listDict.jspa?parentDictNo=00017", function (result) {
            $.each(result.data, function (index, object) {
                $('#menstruum').append("<option value='{0}'>{1}</option>".format(object.value, object.name));
            });
            $("#menstruum").trigger("chosen:updated");
        });

        function showMedicine(medicineID) {
            $.getJSON("/medicine/getMedicineList.jspa?medicineID=" + medicineID, function (ret) {
                var result = ret.aaData[0];
                $('#chnName').text(result.chnName);
                $('#goodsNo').text(result.no);
                $('#pinyin').text(result.pinyin);
                $('#spec').text(result.spec);
                $('#producer').text(result.producer);
                $('#dealer').text(result.dealer);
                $('#price').text(result.price);
                $('#insurance').text(renderInsurance(result.insurance));
                $('#dose').html(result.dose == null ? "&nbsp;" : result.dose);
                $('#lastPurchaseTime').html(result.lastPurchaseTime == null ? "&nbsp;" : result.lastPurchaseTime);
                $('#generalName').html(result.generalName == null ? "&nbsp;" : result.generalName);
                $('#instructionName').html(result.instructionName == null ? "&nbsp;" : result.instructionName);
                $('#contents').val(result.contents);
                $('#DDDs').val(result.DDDs);
                $('#maxDay').val(result.maxDay);
                $('#antiClass').val(result.antiClass);
                $('#base').val(result.base);
                $('#mental').val(result.mental);
                $("input[name='isStat'][value='" + result.isStat + "']").attr("checked", true);

                $("#dialog-edit").removeClass('hide').dialog({
                    resizable: false,
                    width: 760,
                    height: 530,
                    modal: true,
                    title: "药品资料",
                    title_html: true,

                    buttons: [
                        {
                            html: "<i class='ace-icon fa fa-pencil-square-o bigger-110'></i>&nbsp;保存",
                            "class": "btn btn-danger btn-minier",
                            click: function () {

                            }
                        }, {
                            html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 取消",
                            "class": "btn btn-minier",
                            click: function () {
                                $(this).dialog("close");
                            }
                        }
                    ]
                });
            });
        }

        $.getJSON("/health/tree.jspa?healthID=1", function (result) {
            $('#healthNo').comboTree({
                source: result
            });
        });

    });
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
                                <th style="text-align: center;width:75px;">编辑/配对</th>
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
    <div id="dialog-edit" class="hide">
        <div class="col-xs-12">
            <!-- PAGE CONTENT BEGINS -->
            <form class="form-horizontal" role="form">
                <div class="col-sm-4 no-padding">
                    <%-- <div class="widget-header">
                         <h4 class="smaller">
                             Tooltips
                             <small>different directions and colors</small>
                         </h4>
                     </div>--%>

                    <div class="row ">
                        <label class="col-sm-4" style="white-space: nowrap">药品名称 </label>
                        <div class="col-sm-8 no-padding" id="chnName" style="border-bottom: 1px solid; border-bottom-color: lightgrey;font-size:  large"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4">编码 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="goodsNo"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4">规格 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="spec"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4">拼音码 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="pinyin"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4" style="white-space: nowrap">生产厂家 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="producer"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4" style="white-space: nowrap">经销商 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="dealer"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4" style="white-space: nowrap">单价 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="price"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4" style="white-space: nowrap">医保 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="insurance"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4" style="white-space: nowrap">剂型 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="dose"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4" style="white-space: nowrap">最后采购 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="lastPurchaseTime"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4" style="white-space: nowrap">通用名 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="generalName"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4" style="white-space: nowrap">说明书 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="instructionName"></div>
                    </div>

                    <hr/>
                </div><!-- /.col -->

                <div class="col-xs-7" style="margin: 2px;">
                    <div class="form-group" style="margin-bottom: 3px;margin-top: 3px;">
                        <label class="col-sm-3 control-label no-padding-right " for="contents"> 含量 </label>
                        <div class="col-sm-9">
                            <input type="text" id="contents" placeholder="含量" class="col-xs-10 col-sm-5"/>
                            <span class="help-inline col-xs-12 col-sm-7"><span class="middle red">g</span></span>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                        <label class="col-sm-3 control-label no-padding-right " for="DDDs"> DDD值 </label>
                        <div class="col-sm-9">
                            <input type="text" id="DDDs" placeholder="DDD值" class="col-xs-10 col-sm-5"/>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                        <label class="col-sm-3 control-label no-padding-right " for="maxDay"> 最大用药天数 </label>
                        <div class="col-sm-9">
                            <input type="text" id="maxDay" placeholder="最大用药天数" class="col-xs-10 col-sm-5"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="healthNo" class="col-sm-3 control-label no-padding-right">药理分类</label>
                        <div class="col-sm-9">
                            <input id="healthNo" type="text" value="" style="width:120px;" class="col-xs-10 col-sm-5"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="route" class="col-sm-3 control-label no-padding-right">给药途径</label>
                        <div class="col-sm-9">
                            <div class="input-group">
                                <select class="chosen-select" id="route" data-placeholder="给药途径" name="route" multiple>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="injection" class="col-sm-3 control-label no-padding-right">注射方法</label>
                        <div class="col-sm-9">
                            <div class="input-group">
                                <select class="chosen-select" id="injection" data-placeholder="注射方法" name="injection" multiple>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="menstruum" class="col-sm-3 control-label no-padding-right">溶媒</label>
                        <div class="col-sm-9">
                            <div class="input-group">
                                <select class="chosen-select" id="menstruum" data-placeholder="溶媒" name="menstruum" multiple style="z-index: 1000000">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                        <label class="col-sm-3 control-label no-padding-right " for="antiClass"> 抗菌药级别 </label>
                        <div class="col-sm-9">
                            <select class="form-control" id="antiClass">
                                <option value="0"></option>
                                <option value="1">非限制</option>
                                <option value="2">限制</option>
                                <option value="3">特殊</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                        <label class="col-sm-3 control-label no-padding-right " for="mental"> 基本药物 </label>
                        <div class="col-sm-9">
                            <select class="form-control" id="base">
                                <option value="0">否</option>
                                <option value="1">基药</option>
                                <option value="2">国基</option>
                                <option value="3">省基</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                        <label class="col-sm-3 control-label no-padding-right " for="mental"> 特殊分类 </label>
                        <div class="col-sm-9">
                            <select class="form-control" id="mental">
                                <option value="0">无</option>
                                <option value="1">精神药品</option>
                                <option value="4">麻醉药品</option>
                                <option value="8">糖皮质激素</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right "> 统计品种 </label>
                        <div class="col-sm-5">
                            <div class="radio col-sm-6">
                                <label style="white-space: nowrap">
                                    <input name="isStat" type="radio" class="ace" checked value="1"/>
                                    <span class="lbl">是</span>
                                </label>
                            </div>

                            <div class="radio col-sm-6">
                                <label style="white-space: nowrap">
                                    <input name="isStat" type="radio" class="ace" value="0"/>
                                    <span class="lbl">否</span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

</div>
<!-- /.page-content -->