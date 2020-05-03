<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script src="../components/datatables/jquery.dataTables.min.js"></script>
<script src="../components/datatables/jquery.dataTables.bootstrap.min.js"></script>
<script src="../components/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="../components/datatables/dataTables.select.min.js"></script>
<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>
<%--<script src="../assets/js/jquery.gritter.min.js"></script>--%>
<script src="../js/accounting.min.js"></script>
<script src="../js/render_func.js"></script>
<script src="../js/jquery.cookie.min.js"></script>
<script src="../assets/js/jquery.validate.min.js"></script>
<script src="../assets/js/jquery.validate.messages_cn.js"></script>
<%--<script src="../components/moment/moment.min.js"></script>--%>
<script src="../components/moment/min/moment-with-locales.min.js"></script>
<script src="../components/typeahead.js/dist/typeahead.bundle.min.js"></script>
<script src="../components/typeahead.js/handlebars.js"></script>
<script src="../components/chosen/chosen.jquery.js"></script>
<script src="../components/jquery.editable-select/jquery.editable-select.min.js"></script>
<script type="text/javascript" src="../components/jquery-easyui-1.9.4/jquery.easyui.min.js"></script>
<script type="text/javascript" src="../components/jquery-easyui-1.9.4/locale/easyui-lang-zh_CN.js"></script>

<!-- bootstrap & fontawesome -->

<link rel="stylesheet" href="../components/font-awesome/css/font-awesome.css"/>
<link rel="stylesheet" href="../components/chosen/chosen.min.css"/>
<link rel="stylesheet" type="text/css" href="../components/jquery-easyui-1.9.4/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="../components/jquery-easyui-1.9.4/themes/icon.css">
<link rel="stylesheet" href="../components/jquery.editable-select/jquery.editable-select.min.css"/>
<style>
    .form-group {
        margin-bottom: 3px;
        margin-top: 3px;
    }

    .modal-body2 {
        overflow-y: scroll;
        position: absolute;
        top: 38px;
        bottom: 0;
        width: 100%;
    }
</style>
<script type="text/javascript">
    jQuery(function ($) {

        //var url = "/drug/getMedicineList.jspa?queryChnName={0}";

        //initiate dataTables plugin
        var dynamicTable = $('#dynamic-table');
        var myTable = dynamicTable
        //.wrap("<div class='dataTables_borderWrap' />") //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                "searching": true,
                // "iDisplayLength": 25,
                "columns": [
                    {"data": "drugID", "sClass": "center", "orderable": false, width: 40},
                    {"data": "chnName", "sClass": "center", "orderable": false, className: 'middle'},
                    {"data": "healthName", "sClass": "center", "orderable": false},
                    {"data": "dose", "sClass": "center", "orderable": false, defaultContent: ''},
                    {"data": "base", "sClass": "center", defaultContent: '', "orderable": false, render: renderBase2},//4
                    {"data": "gravida", "sClass": "center", "orderable": false, render: renderNoNo},
                    {"data": "lactation", "sClass": "center", "orderable": false, render: renderNoNo},
                    {"data": "oldFolks", "sClass": "center", "orderable": false, render: renderNoNo},
                    {"data": "children", "sClass": "center", "orderable": false, render: renderNoNo},
                    {"data": "maxEffectiveDose", "sClass": "center", "orderable": false, render: renderNoZero},//9
                    {"data": "maxDose", "sClass": "center", "orderable": false, render: renderNoZero},
                    {"data": "ddd", "sClass": "center", "orderable": false, render: renderNoZero},
                    {"data": "instructionName", "sClass": "center", "orderable": false, defaultContent: ''},
                    {"data": "incompNum", "sClass": "center", "orderable": false},
                    {"data": "updateUser", "sClass": "center", "orderable": false},//14
                    {"data": "drugID", "sClass": "center", "orderable": false}
                ],
                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    /*{'targets': 4, 'searchable': false, 'orderable': false},
                    {'targets': 9, 'searchable': false, 'orderable': false},*/
                    {
                        'targets': 15, 'searchable': false, 'orderable': false,
                        render: function (data, type, row, meta) {
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="hasDetail" href="#" data-Url="javascript:showDrug({0});">'.format(data) +
                                '<i class="ace-icon fa fa-pencil-square-o green bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasDetail" href="#" data-Url="javascript:showCompatibility({0},\'{1}\',\'{2}\');">'.format(data, row['chnName'], row['healthName']) +
                                '<i class="fa fa-share-alt purple bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasDetail" href="#" data-Url="javascript:showDose({0},\'{1}\',\'{2}\');">'.format(data, row['chnName'], row['healthName']) +
                                '<i class="ace-icon fa fa-paperclip orange bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasDetail" href="#" data-Url="javascript:deleteDialog({0},\'{1}\');">'.format(data, row['chnName']) +
                                '<i class="ace-icon fa fa-trash-o fa-confirm red bigger-130"></i>' +
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
                    url: '/drug/liveDrug.jspa',
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                },
                "processing": true,
                "serverSide": true,
                select: {style: 'single'}
            });
        myTable.on('draw', function () {
            $('#dynamic-table tr').find('.hasDetail').click(function () {
                if ($(this).attr("data-Url").indexOf('javascript:') >= 0) {
                    eval($(this).attr("data-Url"));
                } else
                    window.open($(this).attr("data-Url"), "_blank");
            });

        });


        function renderNoNo(value, type, row, meta) {
            if (value === 1) return "<span style='color: #7f0000'>慎用</span>";
            else if (value === 2) return "<span style='color: deeppink'>禁用</span>";
            else return "";
        }

        function renderNoNo2(value, type, row, meta) {
            if (value === 1) return "慎用";
            else if (value === 2) return "禁用";
            else return "无";
        }

        function renderNoZero(value) {
            return value > 0.0000001 ? value : "";
        }

        $('.btn-success').click(function () {
            if ($('#form-goodsNo').val() !== '') {
                myTable.ajax.url("/drug/liveDrug.jspa?goodsNo={0}&matchType={1}&type={2}"
                    .format($('#form-goodsNo').val(), $('#matchType').val(), $('#type').val())).load();
            } else {
                myTable.ajax.url("/drug/liveDrug.jspa?queryChnName={0}&matchType={1}&type={2}"
                    .format($('#form-medicine').val(), $('#matchType').val(), $('#type').val())).load();
            }
        });
        //https://github.com/twitter/typeahead.js/blob/master/doc/jquery_typeahead.md
        $('#form-medicine').typeahead({hint: true},
            {
                limit: 1000,
                source: function (queryStr, processSync, processAsync) {
                    var params = {queryChnName: queryStr, length: 100};
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
        $('#form-medicine').bind('typeahead:select', function (ev, suggestion) {
            //console.log("no:" + suggestion["goodsNo"]);
            $('#form-goodsNo').val(suggestion["goodsNo"]);
        });
        $('#form-medicine').on("input propertychange", function () {
            $('#form-goodsNo').val("");
        });
        //https://github.com/twitter/typeahead.js/blob/master/doc/jquery_typeahead.md
        $('#chnName2').typeahead({hint: true},
            {
                limit: 1000,
                source: function (queryStr, processSync, processAsync) {
                    var params = {'search[value]': queryStr, length: 100};
                    $.getJSON('/drug/liveDrug.jspa', params, function (json) {
                        return processAsync(json.data);
                    });
                },
                display: function (item) {
                    return item.chnName;//+ " - " + item.spec;
                },
                templates: {
                    header: function (query) {//header or footer
                        //console.log("query:" + JSON.stringify(query, null, 4));
                        if (query.suggestions.length > 1)
                            return '<div style="text-align:center" class="green" >发现 {0} 项</div>'.format(query.suggestions.length);
                    },
                    suggestion: Handlebars.compile('<div style="font-size: 9px">' +
                        '<div style="font-weight:bold">{{chnName}}</div></div>'),
                    pending: function (query) {
                        return '<div>查询中...</div>';
                    },
                    notFound: '<div class="red">没匹配</div>'
                }
            }
        );
        $('#chnName2').bind('typeahead:select', function (ev, suggestion) {
            //console.log("drugID2:" + suggestion["drugID"]);
            $('#drugID2').val(suggestion["drugID"]);
        });
        $('#chnName2').on("input propertychange", function () {
            $('#drugID2').val("");
        });

        //https://github.com/twitter/typeahead.js/blob/master/doc/jquery_typeahead.md
        $('#instructionName').typeahead({hint: true},
            {
                limit: 1000,
                source: function (queryStr, processSync, processAsync) {
                    var params = {'generalName': queryStr, length: 100};

                    $.getJSON('/instruction/instructionList.jspa', params, function (json) {
                        return processAsync(json.aaData);
                    });
                },
                display: function (item) {
                    return item.chnName;//+ " - " + item.spec;
                },
                templates: {
                    header: function (query) {//header or footer
                        //console.log("query:" + JSON.stringify(query, null, 4));
                        if (query.suggestions.length > 1)
                            return '<div style="text-align:center" class="green" >发现 {0} 项</div>'.format(query.suggestions.length);
                    },
                    suggestion: Handlebars.compile('<div style="font-size: 9px">' +
                        '<div style="font-weight:bold">{{chnName}}</div>' +
                        '{{#if dose}}<span class="light-grey">剂型：</span>{{dose}}<span class="space-4"/>{{/if}}' +
                        '{{#if producer}}<span class="light-grey">厂家：</span>{{producer}}{{/if}}' +
                        '</div>'),
                    pending: function (query) {
                        return '<div>查询中...</div>';
                    },
                    notFound: '<div class="red">没匹配</div>'
                }
            }
        );
        $('#instructionName').bind('typeahead:select', function (ev, suggestion) {
            //$('#instructionID').val(suggestion["generalInstrID"]);
            $('#instructionID').val("");
            $('#dgDoseInstruction').datagrid('load', {generalInstrID: suggestion["generalInstrID"]});
        });
        $('#instructionName').on("input propertychange", function () {
            $('#instructionID').val("");
            $('#dgDoseInstruction').datagrid('load', {generalInstrID: 0});
        });

        var drugForm = $('#drugForm');
        drugForm.validate({
            errorElement: 'div',
            errorClass: 'help-block',
            focusInvalid: false,
            ignore: "",

            highlight: function (e) {
                $(e).closest('.form-group').removeClass('has-info').addClass('has-error');
            },

            success: function (e) {
                $(e).closest('.form-group').removeClass('has-error');//.addClass('has-info');
                $(e).remove();
            },

            errorPlacement: function (error, element) {
                error.insertAfter(element.parent());
            },

            submitHandler: function (form) {
                // console.log(drugForm.serialize());// + "&productImage=" + av atar_ele.get(0).src);
                //console.log("form:" + form);
                $.ajax({
                    type: "POST",
                    url: "/drug/saveDrug.jspa",
                    data: drugForm.serialize(),//+ "&productImage=" + av atar_ele.get(0).src,
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                    cache: false,
                    success: function (response, textStatus) {
                        var result = JSON.parse(response);
                        if (!result.succeed) {
                            $("#errorText").html(result.errmsg);
                            $("#dialog-error").removeClass('hide').dialog({
                                modal: true,
                                width: 600,
                                title: result.title,
                                buttons: [{
                                    text: "确定", "class": "btn btn-primary btn-xs", click: function () {
                                        $(this).dialog("close");
                                        myTable.ajax.reload();
                                    }
                                }]
                            });
                        } else {
                            myTable.ajax.reload();
                            $("#dialog-edit").dialog("close");
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
                    }
                });
            },
            invalidHandler: function (form) {
                console.log("invalidHandler");
            }
        });

        var divPinyin = $('#divPinyin');
        var editingDrug;
        $('#chnName').on('keyup', function () {
            loadPinyin($(this).val());
        });

        function loadPinyin(chinese) {
            divPinyin.empty();
            divPinyin.append("<select class='chosen-select' id='pinyin' style='font-size: 9px;color: black ;' name='pinyin'></select>");

            $.getJSON("/pinyin/getPinyin.jspa?chinese=" + chinese, function (result) {
                $.each(result.data, function (index, object) {
                    //console.log("index1:" + index);
                    $('#pinyin').append("<option value='{0}'>{1}</option>".format(object.toUpperCase(), object.toUpperCase()));
                });
                $('#pinyin').editableSelect({filter: false});

                if (editingDrug.pinyin !== null && editingDrug.pinyin !== '')
                    $('#pinyin').val(editingDrug.pinyin);
            });
        }

        function showDrug(drugID) {
            $.getJSON("/drug/getDrug.jspa?drugID=" + drugID, function (result) {
                editDrug(result);
            });
        }

        function editDrug(drug) {
            editingDrug = drug;
            loadPinyin(drug.chnName);

            $('input[name="drugID"]').val(drug.drugID);
            $('#chnName').val(drug.chnName);
            if (drug.healthNo !== null) {
                $('#healthNo').combotree('setValue', drug.healthNo);
            }
            $('#pinyin').val(drug.pinyin);
            $("input[name='drugtype']").attr("checked", false);//清空选中
            $("input[name='base']").attr("checked", false);
            $("input[name='adjuvantDrug']").attr("checked", false);
            $("input[name='gravida']").attr("checked", false);
            $("input[name='lactation']").attr("checked", false);
            $("input[name='oldFolks']").attr("checked", false);
            $("input[name='children']").attr("checked", false);
            $("input[name='liver']").attr("checked", false);
            $("input[name='kidney']").attr("checked", false);

            $("input[name='drugtype'][value='" + drug.drugtype + "']").attr("checked", true);
            $("input[name='base'][value='" + drug.base + "']").attr("checked", true);
            $("input[name='adjuvantDrug'][value='" + drug.adjuvantDrug + "']").attr("checked", true);
            $("input[name='gravida'][value='" + drug.gravida + "']").attr("checked", true);
            $("input[name='lactation'][value='" + drug.lactation + "']").attr("checked", true);
            $("input[name='oldFolks'][value='" + drug.oldFolks + "']").attr("checked", true);
            $("input[name='children'][value='" + drug.children + "']").attr("checked", true);
            $("input[name='liver'][value='" + drug.liver + "']").attr("checked", true);
            $("input[name='kidney'][value='" + drug.kidney + "']").attr("checked", true);

            $('#maxEffectiveDose').val(drug.maxEffectiveDose);
            $('#maxDose').val(drug.maxDose);
            $('#ddd').val(drug.ddd);


            $("#dialog-edit").removeClass('hide').dialog({
                resizable: false,
                width: 760,
                height: 430,
                modal: true,
                title: "通用名资料",
                buttons: [{
                    text: '保存',
                    iconCls: 'ace-icon fa fa-floppy-o bigger-110',
                    handler: function () {
                        if (drugForm.valid())
                            drugForm.submit();
                    }
                }, {
                    text: '关闭',
                    iconCls: 'ace-icon fa fa-times bigger-130',
                    handler: function () {
                        $('#dialog-edit').dialog('close');
                    }
                }],
                title_html: true
            });
        }

        $('#chooseInstruction').on('change', function (e) {
            $('#instructionContent').html("");
            if ($(this).val() > 0)
                showInstructionContent($(this).val())
        });

        function showInstructionContent(instructionID) {
            $.ajax({
                type: "GET",
                url: '/instruction/getInstruction.jspa',
                data: 'instructionID=' + instructionID,
                contentType: "application/json; charset=utf-8",
                cache: false,
                success: function (response, textStatus) {
                    var respObject = JSON.parse(response);
                    if (respObject)
                        $('#instructionContent').html(respObject.instruction);
                },
                error: function (response, textStatus) {/*能够接收404,500等错误*/
                    $.messager.alert("请求状态码：" + response.status, response.responseText);
                },
            });
        }

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

        var dgCompatibility = $('#dgCompatibility').datagrid({
            columns: [[
                {field: 'chnName1', title: '通用名1', width: 120},
                {field: 'chnName2', title: '通用名2', width: 120},
                {field: 'result', title: '相互作用', width: 300},
                {field: 'level', title: '程度', width: 50, align: 'center'},
                {
                    field: 'inBody', title: '类型', width: 50, align: 'center', formatter: function (value, row, index) {
                        if (value === 0) return "体内";
                        else if (value === 1) return "体外";
                        else return "不明";
                    }
                },
                {
                    field: 'warning', title: '措施', width: 50, align: 'center', formatter: function (value, row, index) {
                        if (value === 2) return "<font color='orange'>警告</font>";
                        if (value === 3) return "<font color='deeppink'>禁止</font>";
                        else return "<font color='#006400'>通过</font>";
                    }
                },
                {field: 'mechanism', title: '机理', width: 60, align: 'center'},
                {field: 'source', title: '来源', width: 60, align: 'center'}
            ]]
        });
        var dgDose = $('#dgDose').datagrid({
            columns: [[
                {field: 'dose', title: '剂型', width: 120},
                {field: 'instructionName', title: '对应说明书', width: 200}/*,
                {field: 'instructCount', title: '数量', width: 50, align: 'center'}*/
            ]]
        });

        function showCompatibility(drugID, chnName, healthName) {
            $('input[name="drugID_compatibility"]').val(drugID);
            $('#chnName_span').text(chnName);
            $('#healthName').text(healthName);
            dgCompatibility.datagrid('load', {drugID: drugID});
            $("#dialog-compatibility").removeClass('hide').dialog({});
        }

        function showDose(drugID, chnName, healthName) {
            $('input[name="drugID_dose"]').val(drugID);
            $('#chnName_span2').text(chnName);
            $('#healthName2').text(healthName);
            dgDose.datagrid('load', {drugID: drugID});
            $("#dialog-dose").removeClass('hide').dialog({});
        }


        function deleteDialog(drugID, chnName) {
            if (drugID === undefined) return;
            $('#drugName').text(chnName);
            $("#dialog-delete").removeClass('hide').dialog({
                resizable: false,
                modal: true,
                // title: "确认删除通用名",
                //title_html: true,
                buttons: [{
                    text: '删除',
                    iconCls: 'ace-icon fa fa-trash-o red bigger-110',
                    handler: function () {
                        $.ajax({
                            type: "POST",
                            url: "/drug/deleteDrug.jspa?drugID=" + drugID,
                            cache: false,
                            success: function (response, textStatus) {
                                var result = JSON.parse(response);
                                if (result.succeed)
                                    myTable.ajax.reload();
                                else
                                    showDialog("请求结果：" + result.succeed, result.message);
                            },
                            error: function (response, textStatus) {/*能够接收404,500等错误*/
                                showDialog("请求状态码：" + response.status, response.responseText);
                            }
                        });
                        $('#dialog-delete').dialog("close");
                    }
                }, {
                    text: '关闭',
                    iconCls: 'ace-icon fa fa-times bigger-130',
                    handler: function () {
                        $('#dialog-delete').dialog("close");
                    }
                }]
            });
        }

        new $.fn.dataTable.Buttons(myTable, {
            buttons: [
                {
                    "text": "<i class='fa fa-plus-square bigger-130'></i>&nbsp;&nbsp;新增 ",
                    "className": "btn btn-xs btn-white btn-primary "
                }
            ]
        });
        myTable.buttons().container().appendTo($('.tableTools-container'));
        myTable.button(0).action(function (e, dt, button, config) {
            e.preventDefault();
            editDrug({});
        });
    });
</script>

<!-- #section:basics/content.breadcrumbs -->
<div class="breadcrumbs ace-save-state" id="breadcrumbs">
    <ul class="breadcrumb">
        <li>
            <i class="ace-icon fa fa-home home-icon"></i>
            <a href="/index.jspa?content=/admin/hello.html">首页</a>
        </li>
        <li class="active">通用名资料</li>

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
            </div>&nbsp;&nbsp;&nbsp;
            <label>配对：</label>
            <select class="chosen-select form-control" id="matchType">
                <option value="0">全部</option>
                <option value="1">未配对</option>
                <option value="2">已配对</option>
                <option value="3">已配对通用名</option>
                <option value="4">已配对说明书</option>
            </select>&nbsp;&nbsp;&nbsp;
            <label>药品类别：</label>
            <select class="chosen-select form-control" id="type">
                <option value="0">全部</option>
                <option value="1">西药</option>
                <option value="9">西药-口服</option>
                <option value="10">西药-注射</option>
                <option value="11">西药-大输液</option>
                <%--<option value="12">西药-外用</option>--%>
                <option value="3">中成药</option>
                <option value="4">中草药</option>
                <option value="5">抗菌药</option>
                <option value="6">基本药物</option>
                <option value="7">甲类医保</option>
                <option value="8">乙类医保</option>
            </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
                                <th></th>
                                <th style="text-align: center">药品名称</th>
                                <th style="text-align: center">药理分类</th>
                                <th style="text-align: center">剂型</th>
                                <th style="text-align: center;width:45px">基药</th>
                                <th style="text-align: center;width:45px">孕妇</th>
                                <th style="text-align: center;width:60px">哺乳期</th>
                                <th style="text-align: center;width:60px">老年人</th>
                                <th style="text-align: center;width:45px">儿童</th>
                                <th style="text-align: center;width:80px">最大剂量</th>
                                <th style="text-align: center;width:45px">极量</th>
                                <th style="text-align: center;width:60px;">DDD值</th>
                                <th style="text-align: center">对应说明书</th>
                                <th style="text-align: center;width:45px;">配伍</th>
                                <th style="text-align: center;width:60px;">维护人</th>
                                <th style="text-align: center;width:150px;">编辑/配伍/说明书/删除</th>
                            </tr>
                            </thead>

                        </table>
                    </div>
                </div>
            </div>


            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->

    <div id="dialog-edit" class="hide" data-options="iconCls:'ace-icon fa fa-pencil-square-o green bigger-130',modal:true">
        <div class="col-xs-12" style="padding-top: 10px">
            <!-- PAGE CONTENT BEGINS -->
            <form class="form-horizontal" role="form" id="drugForm">
                <fieldset>
                    <div class="col-sm-12 no-padding">
                        <div class="form-group">
                            <label class="col-sm-2  control-label " style="white-space: nowrap">通用名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
                            <input type="text" id="chnName" name="chnName" placeholder="通用名" style="font-size:  large;color: black ;" class="col-xs-9 col-sm-9"/>
                        </div>
                    </div>
                    <div class="col-sm-6 ">
                        <div class="form-group">
                            <label for="healthNo" class="col-sm-3 control-label ">药理分类</label>
                            <input id="healthNo" name="healthNo" type="text" width="200" class="easyui-combotree " style="width:250px;color: black ;"
                                   data-options="url:'/health/easyUITree.jspa?healthID=1', method: 'get'"/>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">基本药物 </label>
                            <div class="radio col-sm-3">
                                <label>
                                    <input name="base" type="radio" class="ace" value="1"/>
                                    <span class="lbl">是</span>
                                </label>
                            </div>
                            <div class="radio col-sm-3">
                                <label>
                                    <input name="base" type="radio" class="ace" value="0"/>
                                    <span class="lbl">否</span>
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">辅助用药 </label>
                            <div class="radio col-sm-3">
                                <label>
                                    <input name="adjuvantDrug" type="radio" class="ace" value="1"/>
                                    <span class="lbl">是</span>
                                </label>
                            </div>
                            <div class="radio col-sm-3">
                                <label>
                                    <input name="adjuvantDrug" type="radio" class="ace" value="0"/>
                                    <span class="lbl">否</span>
                                </label>
                            </div>
                            <span class="col-sm-push-6"></span>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label" for="divPinyin">拼音码</label>
                            <span id="divPinyin"></span>
                            <%--<select class='chosen-select' id='divPinyin' style='font-size: 9px;color: black ;' name='pinyin'></select>--%>
                        </div>
                        <%--   <div class="form-group" style="margin-top: 5px">
                               <label class="col-sm-3 control-label">剂型 </label>
                               <div class="col-sm-5" style="border-bottom: 1px solid; border-bottom-color: lightgrey" id="dose">&nbsp;</div>
                           </div>--%>
                        <div class="form-group">
                            <label class="col-sm-3 control-label" style="white-space: nowrap">最大剂量 </label>
                            <input type="text" id="maxEffectiveDose" name="maxEffectiveDose" placeholder="最大剂量"/>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label" style="white-space: nowrap">极量 </label>
                            <input type="text" id="maxDose" name="maxDose" placeholder="极量"/>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label" style="white-space: nowrap">DDD值 </label>
                            <input type="text" id="ddd" name="ddd" placeholder="DDD值"/>
                        </div>

                    </div><!-- /.col -->

                    <div class="col-sm-6">
                        <div class="form-group  control-label">
                            <label class="col-sm-4" style="white-space: nowrap">类别</label>
                            <label>
                                <input name="drugtype" type="radio" class="ace" value="西药"/>
                                <span class="lbl">西药</span>
                            </label>
                            <label class="col-sm-offset-1">
                                <input name="drugtype" type="radio" class="ace" value="中成药"/>
                                <span class="lbl">中成药</span>
                            </label>
                            <label class="col-sm-offset-1">
                                <input name="drugtype" type="radio" class="ace" value="中草药"/>
                                <span class="lbl">中草药</span>
                            </label>
                        </div>
                        <div class="form-group  control-label">
                            <label class="col-sm-4" style="white-space: nowrap">孕妇</label>
                            <label>
                                <input name="gravida" type="radio" class="ace" value="0"/>
                                <span class="lbl">无&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-sm-offset-1">
                                <input name="gravida" type="radio" class="ace" value="1"/>
                                <span class="lbl" style='color: #7f0000'>慎用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-sm-offset-1">
                                <input name="gravida" type="radio" class="ace" value="2"/>
                                <span class="lbl" style='color: deeppink'>禁用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                        </div>

                        <div class="form-group  control-label">
                            <label class="col-sm-4" style="white-space: nowrap">哺乳期</label>
                            <label>
                                <input name="lactation" type="radio" class="ace" value="0"/>
                                <span class="lbl">无&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-sm-offset-1">
                                <input name="lactation" type="radio" class="ace" value="1"/>
                                <span class="lbl" style='color: #7f0000'>慎用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-sm-offset-1">
                                <input name="lactation" type="radio" class="ace" value="2"/>
                                <span class="lbl" style='color: deeppink'>禁用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                        </div>
                        <div class="form-group  control-label">
                            <label class="col-sm-4" style="white-space: nowrap">老年人</label>
                            <label>
                                <input name="oldFolks" type="radio" class="ace" value="0"/>
                                <span class="lbl">无&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-sm-offset-1">
                                <input name="oldFolks" type="radio" class="ace" value="1"/>
                                <span class="lbl" style='color: #7f0000'>慎用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-sm-offset-1">
                                <input name="oldFolks" type="radio" class="ace" value="2"/>
                                <span class="lbl" style='color: deeppink'>禁用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                        </div>
                        <div class="form-group  control-label">
                            <label class="col-sm-4" style="white-space: nowrap">儿童</label>
                            <label>
                                <input name="children" type="radio" class="ace" value="0"/>
                                <span class="lbl">无&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-sm-offset-1">
                                <input name="children" type="radio" class="ace" value="1"/>
                                <span class="lbl" style='color: #7f0000'>慎用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-sm-offset-1">
                                <input name="children" type="radio" class="ace" value="2"/>
                                <span class="lbl" style='color: deeppink'>禁用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                        </div>
                        <div class="form-group  control-label">
                            <label class="col-sm-4" style="white-space: nowrap">肝功能不全 </label>
                            <label>
                                <input name="liver" type="radio" class="ace" value="0"/>
                                <span class="lbl">无&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-sm-offset-1">
                                <input name="liver" type="radio" class="ace" value="1"/>
                                <span class="lbl" style='color: #7f0000'>慎用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-sm-offset-1">
                                <input name="liver" type="radio" class="ace" value="2"/>
                                <span class="lbl" style='color: deeppink'>禁用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                        </div>
                        <div class="form-group  control-label">
                            <label class="col-sm-4" style="white-space: nowrap">肾功能不全 </label>
                            <label>
                                <input name="kidney" type="radio" class="ace" value="0"/>
                                <span class="lbl">无&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-sm-offset-1">
                                <input name="kidney" type="radio" class="ace" value="1"/>
                                <span class="lbl" style='color: #7f0000'>慎用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-sm-offset-1">
                                <input name="kidney" type="radio" class="ace" value="2"/>
                                <span class="lbl" style='color: deeppink'>禁用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                        </div>

                    </div>
                    <input type="hidden" id="drugID" name="drugID">
                </fieldset>
            </form>
        </div>
    </div>
    <div id="dialog-compatibility" class="hide easyui-layout" title="配伍禁忌维护" style="font-family:'宋体';width:850px;height:350px;padding:10px"
         data-options="iconCls:'ace-icon fa fa-share-alt bigger-130',modal:true">
        <div class="row">
            <label class="col-xs-6" style="white-space: nowrap">药品名称：<span id="chnName_span" style="white-space: nowrap"/> </label>
            <label class="col-xs-6" style="white-space: nowrap">药理：<span id="healthName" style="white-space: nowrap"/> </label>
            <input type="hidden" name="drugID_compatibility">
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12" style="margin: 0;padding: 0">
                <table class="easyui-datagrid" toolbar="#toolbar" id="dgCompatibility" style="height: 275px"
                       data-options="singleSelect:true,method:'get', url:'/drug/getIncompatibility.jspa', rownumbers: true">

                </table>
            </div>
        </div>
        <div id="toolbar">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newIncompatibility()">增加</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editIncompatibility()">编辑</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroyIncompatibility()">删除</a>
        </div>
    </div>

    <div id="dlgIncompatibility" class="easyui-dialog" style="width:500px;height:440px" data-options="closed:true,modal:true,border:'thin',buttons:'#dlg-buttons'">
        <div class="col-xs-12">
            <form id="incompatibilityFm" method="post" class="form-horizontal">
                <input type="hidden" name="incompatibilityID">
                <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                    <label class="col-xs-3 control-label" style="white-space: nowrap">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;阻止方式 </label>
                    <div class="col-xs-8">
                        <div class="row">
                            <div class="radio col-xs-3">
                                <label style="white-space: nowrap">
                                    <input name="warning" type="radio" class="ace" value="3" required/>
                                    <span class="lbl red">禁止</span>
                                </label>
                            </div>
                            <div class="radio col-xs-3">
                                <label style="white-space: nowrap">
                                    <input name="warning" type="radio" class="ace" value="2" required/>
                                    <span class="lbl orange">警告</span>
                                </label>
                            </div>
                            <div class="radio col-xs-3">
                                <label style="white-space: nowrap">
                                    <input name="warning" type="radio" class="ace" value="1" required/>
                                    <span class="lbl green">通过</span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                    <label class="col-xs-3 control-label" style="white-space: nowrap">通用名1 </label>
                    <input class="col-xs-8" id="chnName1" name="chnName1" readonly style="font-size: 9px;color: black">
                    <input type="hidden" name="drugID1">
                </div>
                <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                    <label class="col-xs-3 control-label">通用名2 </label>
                    <%-- <input class="col-xs-8" id="chnName2" name="chnName2" readonly style="font-size: 9px;color: black">--%>
                    <input class="typeahead scrollable nav-search-input col-xs-8" type="text" id="chnName2" name="chnName2"
                           autocomplete="off" style="width: 300px; font-size: 9px;color: black" readonly
                           placeholder="编码或拼音匹配，鼠标选择"/>
                    <input type="hidden" id="drugID2" name="drugID2" required>
                </div>
                <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                    <label class="col-xs-3 control-label">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;类型 </label>
                    <div class="col-xs-8">
                        <div class="row">
                            <div class="radio col-xs-3">
                                <label style="white-space: nowrap">
                                    <input name="inBody" type="radio" class="ace" value="2" required/>
                                    <span class="lbl">体内</span>
                                </label>
                            </div>
                            <div class="radio col-xs-3">
                                <label style="white-space: nowrap">
                                    <input name="inBody" type="radio" class="ace" value="3" required/>
                                    <span class="lbl">体外</span>
                                </label>
                            </div>
                            <div class="radio col-xs-3">
                                <label style="white-space: nowrap">
                                    <input name="inBody" type="radio" class="ace" value="1" required/>
                                    <span class="lbl">不明</span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label for="level" class="col-xs-3 control-label" style="white-space: nowrap">相互作用程度</label>
                    <select class="col-xs-8" id="level" name="level" required>
                        <option value="禁止">禁止</option>
                        <option value="严重">严重</option>
                        <option value="中等">中等</option>
                        <option value="微弱">微弱</option>
                        <option value="有利作用">有利作用</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="result" class="col-xs-3 control-label" style="white-space: nowrap">相互作用结果</label>
                    <textarea class="col-xs-8" id="result" name="result" rows="3" required> </textarea>
                </div>
                <div class="form-group">
                    <label for="mechanism" class="col-xs-3 control-label" style="white-space: nowrap">机制</label>
                    <input class="col-xs-8" id="mechanism" name="mechanism">
                </div>
                <div class="form-group">
                    <label for="source" class="col-xs-3 control-label" style="white-space: nowrap">来源</label>
                    <input class="col-xs-8" id="source" name="source">
                </div>
            </form>
            <div id="dlg-buttons">
                <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveIncompatibility()" style="width:90px">保存</a>
                <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgIncompatibility').dialog('close'); " style="width:90px">取消</a>
            </div>
        </div>
    </div>
    <div id="dialog-dose" class="hide easyui-layout" title="剂型与对应说明书" style="font-family:'宋体';width:850px;height:350px;padding:10px"
         data-options="iconCls:'ace-icon fa fa-share-alt bigger-130',modal:true">
        <div class="row">
            <label class="col-xs-6" style="white-space: nowrap">药品名称：<span id="chnName_span2" style="white-space: nowrap"/> </label>
            <label class="col-xs-6" style="white-space: nowrap">药理：<span id="healthName2" style="white-space: nowrap"/> </label>
            <input type="hidden" name="drugID_dose">
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12" style="margin: 0;padding: 0">
                <table class="easyui-datagrid" toolbar="#toolbar3" id="dgDose" style="height: 275px"
                       data-options="singleSelect:true,method:'get', url:'/drug/getDrugDoseList.jspa', rownumbers: true">
                </table>
            </div>
        </div>
        <div id="toolbar3">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newDose()">增加</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editDose()">编辑</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroyDose()">删除</a>
        </div>
    </div>
    <div id="dlgDoseInstruction" class="easyui-dialog" title="剂型对应说明书" style="width:800px;height:440px" data-options="closed:true,modal:true,border:'thin',buttons:'#dlg-buttons2'">
        <form id="doseInstrFm" method="post" class="form-horizontal">
            <input type="hidden" name="drugDoseID">
            <input type="hidden" name="drugID">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-xs-6">
                        <div class="form-group" style="margin-top: 5px">
                            <label class="col-xs-3 control-label no-padding-left" for="dose"> 剂型 </label>
                            <input class="easyui-combobox col-xs-8" name="dose" id="dose" data-options="url: '/common/dict/listDict2.jspa?parentDictNo=00018',
                                method: 'get', valueField: 'name', textField: 'name', panelHeight: '300px', formatter: formatItem" required>
                        </div>
                        <div class="form-group" style="margin-bottom: 3px;margin-top: 5px">
                            <label class="col-xs-3 control-label no-padding-left" for="instructionName"> 通用名 </label>
                            <input class="typeahead scrollable nav-search-input" type="text" id="instructionName" name="instructionName"
                                   autocomplete="off" style="width:280px;font-size: 9px;color: black"
                                   placeholder="编码或拼音匹配，鼠标选择">
                        </div>
                        <label class="col-xs-12 no-padding-left" for="dgDoseInstruction"> 可选说明书 </label>
                        <table class="col-xs-12 easyui-datagrid" id="dgDoseInstruction" style="height: 240px;width:100%;" idField="instructionID" ,
                               data-options="singleSelect:true,method:'get',singleSelect:true,   url:'/instruction/instructionList2.jspa', rownumbers: true">
                            <thead>
                            <tr>
                                <th data-options="field:'ck',checkbox:true"></th>
                                <th data-options="field:'chnName',width:140">说明书</th>
                                <th data-options="field:'hasInstruction',width:50,align:'center',formatter:renderHasNo">内容</th>
                                <th data-options="field:'dose',width:50,align:'center'">剂型</th>
                                <th data-options="field:'source',width:60,align:'center'">来源</th>
                            </tr>
                            </thead>
                        </table>
                        <input type="hidden" id="instructionID" name="instructionID" required>
                    </div>
                    <div class="col-xs-6" style="margin-bottom: 3px;margin-top: 5px;">
                        <div id="instruction" class="easyui-panel no-margin " title="说明书内容" style="height:340px;padding: 5px 0 0 0;">
                        </div>
                    </div>
                </div>
            </div>
        </form>
        <div id="dlg-buttons2">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveDoseInstrct()" style="width:90px">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgDoseInstruction').dialog('close'); " style="width:90px">取消</a>
        </div>
    </div>


    <div id="dialog-delete" class="hide" title="删除通用名" style="width:400px;height:200px;padding:10px"
         data-options="iconCls:'ace-icon fa fa-exclamation-triangle bigger-130',modal:true">
        <div class="alert alert-info bigger-110">
            永久删除 <span id="drugName" class="red"></span> ，不可恢复！
        </div>
    </div>
    <%-- <div id="dialog-error" class="hide alert" title="提示">
         <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
     </div>--%>
    <div id="dialog-error" class="hide" title="操作确认" data-options="iconCls:'ace-icon fa fa-info bigger-130'" style="width:400px;height:200px;padding:10px">
        <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
    </div>
</div>
<script type="text/javascript">
    function newIncompatibility() {
        $('#dlgIncompatibility').dialog('open').dialog('center').dialog('setTitle', '新建配伍禁忌');
        $('#incompatibilityFm').form('clear');
        //console.log("drugID1:" + $('input[name="drugID_compatibility"]').val());
        $('#incompatibilityFm').form('load', {drugID1: $('input[name="drugID_compatibility"]').val(), chnName1: $('#chnName_span').text()});
        $('#chnName2').removeAttr("readonly");
    }

    function editIncompatibility() {
        var row = $('#dgCompatibility').datagrid('getSelected');
        if (row) {
            $('#dlgIncompatibility').dialog('open').dialog('center').dialog('setTitle', '编辑配伍禁忌');
            $('#incompatibilityFm').form('load', row);
            $('#chnName2').attr("readonly", true);
        }
    }

    function destroyIncompatibility() {
        var row = $('#dgCompatibility').datagrid('getSelected');
        if (row) {
            //$.messager.defaults = {ok: "是", cancel: "否"};  /*修改显示文字*/
            $.messager.confirm("操作提示", "您确定要删除配伍禁忌吗？", function (confirm) {
                if (confirm) {
                    $.ajax({
                        type: "POST",
                        url: '/drug/deleteIncompatibility.jspa',
                        data: {incompatibilityID: row.incompatibilityID},
                        cache: false,
                        success: function (response, textStatus) {
                            // var msg = response.message;
                            var result = JSON.parse(response);
                            if (!result.succeed)
                                $.messager.alert(result.title, "删除失败！", 'error');
                            else {
                                $('#dgCompatibility').datagrid('reload');
                                $.messager.alert(result.title, "删除成功！", 'info');
                                $('#dlgIncompatibility').dialog('close');
                            }
                        },
                        error: function (response, textStatus) {/*能够接收404,500等错误*/
                            $.messager.alert("请求状态码：" + response.status, response.responseText);
                        }
                    });
                }
            });
        }
    }

    var incompatibilityForm = $('#incompatibilityFm');
    incompatibilityForm.validate({
        errorElement: 'div',
        errorClass: 'help-block',
        focusInvalid: false,
        ignore: "",

        highlight: function (e) {
            $(e).closest('.form-group').addClass('has-error');
        },

        success: function (e) {
            $(e).closest('.form-group').removeClass('has-error');//.addClass('has-info');
            $(e).remove();
        },

        errorPlacement: function (error, element) {
            error.insertAfter(element.parent());
        },

        submitHandler: function (form) {
            $.ajax({
                type: "POST",
                url: '/drug/saveIncompatibility.jspa',
                data: $('#incompatibilityFm').serialize(),
                cache: false,
                success: function (response, textStatus) {
                    var result = JSON.parse(response);
                    if (!result.succeed)
                        $.messager.alert(result.title, "保存失败！", 'error');//icon四种设置："error"、"info"、"question"、"warning"
                    else {
                        $('#dgCompatibility').datagrid('reload');
                        $.messager.alert(result.title, "保存成功！", 'info');
                        $('#dlgIncompatibility').dialog('close');
                    }
                },
                error: function (response, textStatus) {/*能够接收404,500等错误*/
                    $.messager.alert("请求状态码：" + response.status, response.responseText);
                }
            });
        }
    });

    function saveIncompatibility() {
        if (incompatibilityForm.valid())
            incompatibilityForm.submit();
    }

    /*剂型说明书管理函数*/
    var doseInstrForm = $('#doseInstrFm');
    doseInstrForm.validate({
        errorElement: 'div',
        errorClass: 'help-block',
        focusInvalid: false,
        ignore: "",

        highlight: function (e) {
            $(e).closest('.form-group').addClass('has-error');
        },

        success: function (e) {
            $(e).closest('.form-group').removeClass('has-error');//.addClass('has-info');
            $(e).remove();
        },

        errorPlacement: function (error, element) {
            error.insertAfter(element.parent());
        },

        submitHandler: function (form) {
            $.ajax({
                type: "POST",
                url: '/drug/saveDrugDose.jspa',
                data: $('#doseInstrFm').serialize(),
                cache: false,
                success: function (response, textStatus) {
                    var result = JSON.parse(response);
                    if (!result.succeed)
                        $.messager.alert(result.title, "保存失败！", 'error');//icon四种设置："error"、"info"、"question"、"warning"
                    else {
                        $('#dgDose').datagrid('reload');
                        $.messager.alert(result.title, "保存成功！", 'info');
                        $('#dlgDoseInstruction').dialog('close');
                    }
                },
                error: function (response, textStatus) {/*能够接收404,500等错误*/
                    $.messager.alert("请求状态码：" + response.status, response.responseText);
                }
            });
        }
    });

    function saveDoseInstrct() {
        if (doseInstrForm.valid())
            doseInstrForm.submit();
    }

    function newDose() {
        $('#dlgDoseInstruction').dialog('open').dialog('center').dialog('setTitle', '增加剂型对应说明书');
        $('#doseInstrFm').form('clear');
        $('#dgDoseInstruction').datagrid('load', {generalInstrID: 0});
        $('#doseInstrFm').form('load', {drugID: $('input[name="drugID_dose"]').val()});
    }

    function editDose() {
        var row = $('#dgDose').datagrid('getSelected');
        if (row) {
            $('#dlgDoseInstruction').dialog('open').dialog('center').dialog('setTitle', '编辑剂型对应说明书');
            $('#doseInstrFm').form('load', row);

            showInstruction(row.instructionID, true);
        }
    }

    function destroyDose() {
        var row = $('#dgDose').datagrid('getSelected');
        if (row) {
            //$.messager.defaults = {ok: "是", cancel: "否"};  /*修改显示文字*/
            $.messager.confirm("操作提示", "您确定要删除剂型对应说明书吗？", function (confirm) {//todo 删除显示具体剂型-说明书
                if (confirm) {
                    $.ajax({
                        type: "POST",
                        url: '/drug/deleteDrugDose.jspa',
                        data: {drugDoseID: row.drugDoseID},
                        cache: false,
                        success: function (response, textStatus) {
                            var result = JSON.parse(response);
                            if (!result.succeed)
                                $.messager.alert(result.title, "删除失败！", 'error');
                            else {
                                $('#dgDose').datagrid('reload');
                                $.messager.alert(result.title, "删除成功！", 'info');
                                $('#dlgDoseInstruction').dialog('close');
                            }
                        },
                        error: function (response, textStatus) {/*能够接收404,500等错误*/
                            $.messager.alert("请求状态码：" + response.status, response.responseText);
                        }
                    });
                }
            });
        }
    }

    $('#dgDoseInstruction').datagrid({
        'onSelect': function (index, row) {
            showInstruction(row.instructionID, false);
        },
        'onLoadSuccess': function (data) {
            //console.log("insID:" + $('#instructionID').val());
            if ($('#instructionID').val() > 0)
                $('#dgDoseInstruction').datagrid('selectRecord', $('#instructionID').val());
        }
    });

    //第一次editDose调用，loadGeneral为true，第二次dgDoseInstruction 的onSelect事件调用，loadGeneral为true为false
    function showInstruction(instructionID, loadGeneral) {
        $('#instructionID').val(instructionID);
        $.getJSON("/instruction/getInstruction.jspa?instructionID=" + instructionID, function (ret) {
            if (loadGeneral)
                $('#dgDoseInstruction').datagrid('load', {generalInstrID: ret.generalInstrID});
            else
                $('#instruction').html(ret.instruction);
        });
    }

    function formatItem(row) {
        return '<span style="font-weight:bold;font-size: 9px">' + row.name + '</span><br/>' +
            '<span style="color:#888;font-size: 9px">' + row.note + '</span>';
    }

    function renderHasNo(value, row, index) {
        if (value === 1) return "有";
        else return "无";
    }

</script>
<!-- /.page-content -->