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
                                '<a class="hasDetail" href="#" data-Url="javascript:showDrug(\'{0}\');">'.format(data) +
                                '<i class="ace-icon fa fa-pencil-square-o bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasDetail" href="#" data-Url="javascript:showMatch(\'{0}\');">'.format(data) +
                                '<i class="ace-icon fa fa-exchange bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasDetail" href="#" data-Url="javascript:showSync(\'{0}\');">'.format(data) +
                                '<i class="fa fa-share-alt bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasDetail" href="#" data-Url="javascript:showSync(\'{0}\');">'.format(data) +
                                '<i class="ace-icon fa fa-paperclip bigger-130"></i>' +
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
            return value > 0.0000001 ? value  : "";
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
        //liveDrug
        $('#liveDrug').typeahead({hint: true},
            {
                limit: 1000,
                source: function (queryStr, processSync, processAsync) {
                    var params = {'search[value]': queryStr, length: 100};
                    $.getJSON('/medicine/liveDrug.jspa', params, function (json) {
                        return processAsync(json.data);
                    });
                },
                display: function (item) {
                    //console.log("item:" + JSON.stringify(item, null, 4));
                    /*if (item.drugDose.length > 0)
                    return item.chnName + " - " + item.drugDose[0].dose;*/
                    return item.chnName;//+ '(' + item.drugDose.length + ')';

                },
                templates: {
                    header: function (query) {//header or footer
                        //console.log("query:" + JSON.stringify(query, null, 4));
                        if (query.suggestions.length > 1)
                            return '<div style="text-align:center" class="green" >发现 {0} 项</div>'.format(query.suggestions.length);
                    },
                    suggestion: Handlebars.compile('<div style="font-size: 9px">' +
                        '<div><span style="font-weight:bold">{{chnName}}</span>{{#if drugDose.[0]}}<span class="light-red">({{drugDose.[0].instructCount}})</span>{{/if}}</div>' +
                        '<span class="grey">{{#if healthName}}{{healthName}} - {{/if}}{{#if drugDose.[0]}}{{drugDose.[0].dose}}{{/if}}</span></div>'),
                    pending: function (query) {
                        return '<div>查询中...</div>';
                    },
                    notFound: '<div class="red">没匹配</div>'
                }
            }
        );
        var matchDrug;
        $('#liveDrug').bind('typeahead:select', function (ev, suggestion) {
            console.log("no:" + suggestion["drugID"]);
            chooseDrug(suggestion);
        });
        $('#liveDrug').on("input propertychange", function () {
            $('#drugID').val("");
            matchDrug = null;
        });
        $('#liveDrug').on("focus", function () {
            $(this).select();//全选
        });

        function chooseDrug(suggestion, instructionName) {
            matchDrug = suggestion;

            $('#drugID').val(matchDrug["drugID"]);

            if (matchDrug["antiClass"] > 0 && matchDrug["antiClass"] <= 3) {
                var antiChn = ["非限制抗菌药", "限制抗菌药", "特殊抗菌药"];
                $('#antiClass_DDD').text(antiChn[matchDrug["antiClass"] - 1] + " - DDD：" + matchDrug["ddd"]);
            } else {
                if (matchDrug["drugDose"].length > 0)
                    $('#antiClass_DDD').text(matchDrug["healthName"] + "-" + matchDrug["drugDose"][0].dose);
                else
                    $('#antiClass_DDD').text(matchDrug["healthName"]);
            }
            $('#antiClass_DDD').removeClass('hide');

            $('#chooseInstruction').empty();
            $('#instructionContent').html("");

            if (matchDrug["drugDose"].length > 0) {
                var instrIDs = '';
                for (var i = 0; i < matchDrug["drugDose"].length; i++) {
                    instrIDs += matchDrug["drugDose"][i].instructionID;
                    if (i < matchDrug["drugDose"].length - 1) instrIDs += ',';
                }
                $.getJSON("/medicine/matchInstruct.jspa?instrIDs=" + instrIDs, function (result) {
                    $('#chooseInstruction').append("<option value='0'>请选择</option>");

                    $.each(result.data, function (index, object) {
                        $('#chooseInstruction').append("<option value='{0}'{2}>{1}</option>".format(object.instructionID, object.chnName,
                            object.chnName === instructionName ? " selected" : ""));

                    });

                });
            }
        }


        $('#antiClass').on('change', function (e) {
            if ($(this).val() === "0") {
                /* $('#ddd').val('');
                 $('#maxDay').val('');*/
                $('#ddd').attr("disabled", true);
                $('#maxDay').attr("disabled", true);
            } else {
                $('#ddd').removeAttr("disabled");
                $('#maxDay').removeAttr("disabled");
            }
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
                console.log(drugForm.serialize());// + "&productImage=" + av atar_ele.get(0).src);
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
            divPinyin.append("<select class='chosen-select  ' id='pinyin' style='font-size: 9px;color: black ;' name='pinyin'></select>");

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
                    iconCls: 'ace-icon fa fa-pencil-square-o bigger-110',
                    handler: function () {
                        if (drugForm.valid())
                            drugForm.submit();
                    }
                }, {
                    text: '关闭',
                    iconCls: 'ace-icon fa fa-times bigger-130 red',
                    handler: function () {
                        $('#dialog-edit').dialog('close');
                    }
                }],
                title_html: true
            });
        }

        function showMatch(drugID) {
            $.getJSON("/medicine/getMedicineList.jspa?drugID=" + drugID, function (ret) {
                var result = ret.aaData[0];
                $('#chnName2').text(result.chnName);
                $('#spec2').text(result.spec);
                $('#producer2').text(result.producer === null ? "　" : result.producer);
                $('#dealer2').text(result.dealer);
                $('#insurance2').text(renderInsurance(result.insurance));
                $('#dose2').html(result.dose == null ? "&nbsp;" : result.dose);
                var json = $.parseJSON(result.json);
                $('#authCode').html(json.批准文号 == null ? "&nbsp;" : json.批准文号);
                $('#generalName').html(result.generalName == null ? "&nbsp;" : result.generalName);
                //todo 如果已经匹配，显示出来 2019国庆
                if (result.matchDrugID > 0) {
                    $.getJSON("/medicine/liveDrug.jspa?drugID=" + result.matchDrugID, function (ret) {
                        //matchDrug = ret.data[0];
                        $('#liveDrug').val(ret.data[0].chnName);
                        chooseDrug(ret.data[0], result.instructionName);
                        //matchDrug = ret.data[0];
                        /* console.log("matchDrug:" + JSON.stringify(matchDrug, null, 4)); */
                    });

                    $('#drugID').val(result.matchDrugID);
                } else {
                    $('#liveDrug').val('');
                    $('#drugID').val();
                    $('#chooseInstruction').val('');

                    $('#antiClass_DDD').addClass('hide');
                }
                if (result.matchInstrID > 0) {
                    //$('#chooseInstruction')
                    showInstructionContent(result.matchInstrID);
                }

                $("#dialog-match").removeClass('hide').dialog({
                    resizable: false,
                    width: 760,
                    height: 550,
                    modal: true,
                    title: "配对",
                    buttons: [{
                        text: '保存',
                        iconCls: 'ace-icon fa fa-pencil-square-o bigger-110',
                        handler: function () {
                            if (matchDrug) {
                                var submitForm = {drugID: drugID, matchDrugID: matchDrug.drugID};

                                //console.log("checkbox:" + $('#ckbox1').prop("checked"));
                                if ($('#ckbox1').prop("checked")) {
                                    submitForm.antiClass = matchDrug.antiClass;
                                    submitForm.ddd = matchDrug.ddd;
                                    submitForm.healthNo = matchDrug.healthNo;
                                }
                                if ($('#chooseInstruction').val() > 0) {
                                    submitForm.matchInstrID = $('#chooseInstruction').val();
                                }
                                //console.log("submitForm:" + JSON.stringify(submitForm));

                                $.ajax({
                                    type: "POST",
                                    url: "/medicine/saveMatch.jspa",
                                    data: submitForm,//+ "&productImage=" + av atar_ele.get(0).src,
                                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                                    cache: false,
                                    success: function (response, textStatus) {
                                        var result = JSON.parse(response);
                                        if (!result.succeed) {
                                            $("#errorText").html(result.message);
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
                                            $("#dialog-match").dialog("close");
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
                            }
                        }
                    }, {
                        text: '关闭',
                        iconCls: 'ace-icon fa fa-times bigger-130 red',
                        handler: function () {
                            $('#dialog-match').dialog('close');
                        }
                    }],
                    title_html: true
                });
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
            editDrug( {});
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
                                <th style="text-align: center;width:140px;">操作</th>
                            </tr>
                            </thead>

                        </table>
                    </div>
                </div>
            </div>


            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->
    <div id="dialog-applyData" class="hide" data-options="iconCls:'icon-save',modal:true" style="width:400px;height:300px;">
        <div class="col-xs-12" style="padding-top: 10px">
            <!-- PAGE CONTENT BEGINS -->
            <form class="form-horizontal" role="form" id="applyForm">
                <div>
                    <label for="fromDate">开始日期:</label>
                    <input id="fromDate" type="text" class="easyui-datebox" required="required">
                </div>
                <div>
                    <label for="toDate">结束日期:</label>
                    <input id="toDate" type="text" class="easyui-datebox" required="required">
                </div>
                <div>
                    说明：
                    <ul>
                        <li>修改药品资料后，需要把门诊处方、住院医嘱和发药数据按修改后的药品资料更新，例如更新抗菌药物、基药、药理分类相关数据等。</li>
                        <li>每次执行的开始日期与结束日期限定在同一年内。</li>
                        <li>一般操作是把今年、去年分别执行一次。</li>
                    </ul>
                </div>
            </form>
        </div>
    </div>
    <div id="dialog-edit" class="hide" data-options="iconCls:'icon-save',modal:true">
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
    <div id="dialog-match" class="hide" style="font-family:'宋体'" data-options="iconCls:'ace-icon fa fa-exchange bigger-130',modal:true">
        <form class="form-horizontal " role="form" id="matchForm">
            <div class="col-xs-12 col-sm-12" style="padding-top: 10px">
                <!-- PAGE CONTENT BEGINS -->
                <div class="col-sm-6 col-xs-6 ">
                    <div class="row">

                        <label class="col-sm-3" style="white-space: nowrap">药品名称 </label>
                        <div class="col-sm-8 no-padding" id="chnName2" style="border-bottom: 1px solid; border-bottom-color: lightgrey;font-size: large"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-3">规格 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="spec2"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-3" style="white-space: nowrap">生产厂家 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="producer2"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-3" style="white-space: nowrap">经销商 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="dealer2"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-3" style="white-space: nowrap">医保 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="insurance2"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-3" style="white-space: nowrap">剂型 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="dose2"></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-3" style="white-space: nowrap">批准文号 </label>
                        <div class="col-sm-8 no-padding " style=" border-bottom: 1px solid; border-bottom-color: lightgrey" id="authCode"></div>
                    </div>
                    <div class="row" style="margin-bottom: 3px;margin-top: 10px;">
                        <label class="col-sm-3" style="white-space: nowrap;padding-top: 10px;" for="liveDrug">对应通用名</label>
                        <div class="col-sm-7 no-padding">
                            <input class="typeahead scrollable" type="text" id="liveDrug" name="liveDrug"
                                   autocomplete="off" style="font-size: 9px;color: black ;width:200px;"
                                   placeholder="拼音匹配，鼠标选择"/>
                        </div>
                        <div class="col-sm-1 no-padding"><span class="middle red bigger-160">①</span></div>
                    </div>
                </div>

            </div>
        </form>
    </div>
</div>
<!-- /.page-content -->
<div id="dialog-error" class="hide alert" title="提示">
    <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
</div>