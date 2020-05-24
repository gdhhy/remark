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
<script type="text/javascript" src="../components/zTree_v3/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="../components/jquery.autofill/jquery.formautofill.min.js"></script>

<!-- bootstrap & fontawesome -->

<link rel="stylesheet" href="../components/font-awesome/css/font-awesome.css"/>
<link rel="stylesheet" href="../components/chosen/chosen.min.css"/>
<link rel="stylesheet" href="../components/datatables/select.dataTables.min.css"/>
<link rel="stylesheet" href="../components/jquery.editable-select/jquery.editable-select.min.css"/>
<link rel="stylesheet" href="../components/zTree_v3/css/zTreeStyle/zTreeStyle.css" type="text/css">
<style>
    .form-group {
        margin-bottom: 3px;
        margin-top: 3px;
    }

    .ui-dialog .ui-dialog-titlebar {
        padding: 0em 0em;
        position: relative;
    }

    .ui-dialog {
        overflow: hidden;
        position: absolute;
        top: 0;
        left: 0;
        padding: 0em;
        outline: 0;
    }
</style>
<script type="text/javascript">
    //https://www.iteye.com/blog/happyqing-2414664  解决jquery ui dialog 标题为html显示样式问题
    $.widget("ui.dialog", $.extend({}, $.ui.dialog.prototype, {
        _title: function (title) {
            if (!this.options.title) {
                title.html("&#160;");
            } else {
                title.html(this.options.title);
            }
        }
    }));
    jQuery(function ($) {
        //initiate dataTables plugin
        var dynamicTable = $('#dynamic-table');
        var myTable = dynamicTable
        //.wrap("<div class='dataTables_borderWrap' />") //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                autoWidth: true,
                "searching": true,
                // "iDisplayLength": 25,
                "columns": [
                    {"data": "drugID", "sClass": "center", "orderable": false, width: 40},
                    {"data": "chnName", "sClass": "center", "orderable": false, className: 'middle'},
                    {"data": "healthName", "sClass": "center", "orderable": false, defaultContent: ''},
                    /*{"data": "dose", "sClass": "center", "orderable": false, defaultContent: ''},*/
                    {"data": "base", "sClass": "center", defaultContent: '', "orderable": false, render: renderBase2},
                    {"data": "gravida", "sClass": "center", "orderable": false, render: renderNoNo},//4
                    {"data": "lactation", "sClass": "center", "orderable": false, render: renderNoNo},
                    {"data": "oldFolks", "sClass": "center", "orderable": false, render: renderNoNo},
                    {"data": "children", "sClass": "center", "orderable": false, render: renderNoNo},
                    {"data": "maxEffectiveDose", "sClass": "center", "orderable": false, render: renderNoZero},
                    {"data": "maxDose", "sClass": "center", "orderable": false, render: renderNoZero},//9
                    {"data": "ddd", "sClass": "center", "orderable": false, render: renderNoZero},
                    {"data": "instructionName", "sClass": "center", "orderable": false, defaultContent: ''},
                    {"data": "incompNum", "sClass": "center", "orderable": false},
                    {"data": "medicineName", "sClass": "center", "orderable": false, defaultContent: ''},
                    {"data": "updateUser", "sClass": "center", "orderable": false, defaultContent: ''},//14
                    {"data": "drugID", "sClass": "center", "orderable": false}
                ],
                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
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

        function renderNoNo(value, type, row, meta) {
            if (value === 1) return "<span style='color: #7f0000'>慎用</span>";
            else if (value === 2) return "<span style='color: deeppink'>禁用</span>";
            else return "";
        }

        function renderNoZero(value) {
            return value > 0.0000001 ? value : "";
        }

        $('.btn-success').click(function () {
            var url = '/drug/liveDrug.jspa?matchInstruction=' + $('#instructionType').val();
            if ($("#antiClass").is(':checked'))
                url += '&antiClass=1';
            if ($('#hasInteract').is(':checked'))
                url += '&hasInteract=1';
            if ($('#linkMe').is(':checked'))
                url += '&linkMe=1';
            myTable.ajax.url(url).load();
        });

        /*------------------通用名管理------------------------------*/
        function showDrug(drugID) {
            $.getJSON("/drug/getDrug.jspa?drugID=" + drugID, function (result) {
                editDrug(result);
            });
        }

        //level 1
        function editDrug(drug) {
            editingDrug = drug;
            loadPinyin(drug.chnName);

            //$("#drugForm input:radio").attr("checked", false);
            $("#drugForm").autofill(drug, {
                findbyname: true,//if true, find elements by name attribute. if false, find elements by id.
                restrict: true//if true, restrict the fields search in the node childs. if false, search in all the document.
            });
            $('#healthName3').val(drug.healthName);


            $("#dialog-edit").removeClass('hide').dialog({
                resizable: false,
                width: 760,
                height: 430,
                modal: true,
                //title: "通用名资料",
                title: "<h4 class='smaller'>&nbsp;<i class='ace-icon fa fa-pencil-square-o green' ></i> 通用名资料</h4> ",//标题栏带了图标，偏高,
                title_html: true,
                buttons: [{
                    html: "<i class='ace-icon fa fa-floppy-o bigger-110'></i>&nbsp;保存",
                    "class": "btn btn-danger btn-minier",
                    click: function () {
                        if (drugForm.valid())
                            drugForm.submit();
                    }
                }, {
                    html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp;关闭",
                    "class": "btn btn-minier",
                    click: function () {
                        $('#dialog-edit').dialog('close');
                    }
                }]
            });
        }


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

        //level 1
        function deleteDialog(drugID, chnName) {
            if (drugID === undefined) return;
            $('#drugName').text(chnName);
            $("#dialog-delete").removeClass('hide').dialog({
                resizable: false,
                modal: true,
                // title: "确认删除通用名",
                title: "<h4 class='smaller'>&nbsp;<i class='ace-icon fa fa-trash-o red' ></i> 确认删除通用名</h4> ",
                title_html: true,
                buttons: [{
                    html: "<i class='ace-icon fa fa-trash-o bigger-110'></i>&nbsp;删除",
                    "class": "btn btn-danger btn-minier",
                    click: function () {
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
                    html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 取消",
                    "class": "btn btn-minier",
                    click: function () {
                        $('#dialog-delete').dialog("close");
                    }
                }]
            });
        }

        //--------------配伍禁忌管理函数------------------------------------
        //level 1
        function showCompatibility(drugID, chnName, healthName) {
            $('input[name="drugID_compatibility"]').val(drugID);
            $('#chnName_span').text(chnName);
            $('#healthName').text(healthName);
            dgCompatibility.ajax.url("/drug/getIncompatibility.jspa?drugID={0}".format(drugID)).load();
            $("#dialog-compatibility").removeClass('hide').dialog({
                title: "<h4 class='smaller'>&nbsp;<i class='ace-icon fa fa-share-alt purple' ></i> 配伍禁忌维护</h4> ",//标题栏带了图标，偏高
                //title: "配伍禁忌维护",
                title_html: true,
                resizable: false,
                modal: true,
                width: 830, height: 350
            });
        }

        var dgCompatibility = $('#dgCompatibility').DataTable({
            dom: 't',
            //autoWidth: true,
            //width: 820,
            paging: false, searching: false, "info": false,
            ordering: false, "destroy": true,
            "columns": [
                {"data": "incompatibilityID"},
                {"data": "chnName1", "sClass": "center"},
                {"data": "chnName2", "sClass": "center"},
                {"data": "result", "sClass": "center", defaultContent: ''},
                {"data": "level", "sClass": "center"},//4
                {"data": "inBody", "sClass": "center"},
                {"data": "warning", "sClass": "center", defaultContent: ''},
                {"data": "mechanism", "sClass": "center", defaultContent: ''},
                {"data": "source", "sClass": "center", defaultContent: ''},
                {"data": "incompatibilityID", "sClass": "center"}
            ],

            'columnDefs': [
                {
                    "orderable": false, "targets": 0, width: 40, render: function (data, type, row, meta) {
                        return meta.row + 1 + meta.settings._iDisplayStart;
                    }
                },
                {"orderable": false, "targets": 1, title: '通用名1', width: 120},
                {"orderable": false, "targets": 2, title: '通用名2', width: 120},
                {"orderable": false, "targets": 3, title: '相互作用', width: 200},
                {"orderable": false, "targets": 4, title: '程度', width: "20%"},
                {
                    'targets': 5, 'searchable': false, 'orderable': false, title: '类型', width: 60, render: function (data, type, row, meta) {
                        if (data === 2) return "体内";
                        else if (data === 3) return "体外";
                        else return "不明";
                    }
                },
                {
                    'targets': 6, 'searchable': false, 'orderable': false, title: '措施', width: 60, render: function (data, type, row, meta) {
                        if (data === 2) return "<font color='orange'>警告</font>";
                        if (data === 3) return "<font color='deeppink'>禁止</font>";
                        else return "<font color='#006400'>通过</font>";
                    }
                },
                {"orderable": false, "targets": 7, title: '机理', width: 120},
                {"orderable": false, "targets": 8, title: '来源', width: 60},
                {
                    'targets': 9, 'searchable': false, 'orderable': false, title: '操作', width: 80, render: function (data, type, row, meta) {
                        return '<div class="hidden-sm hidden-xs action-buttons">' +
                            '<a class="hasDetail" href="#" data-Url="javascript:showDlgIncompatibility();">' +
                            '<i class="ace-icon fa  fa-pencil-square-o green bigger-130"></i>' +
                            '</a>' +
                            '<a class="hasDetail" href="#" data-Url="javascript:deleteIncompatibility();">' +
                            '<i class="ace-icon fa  fa-remove red bigger-130"></i>' +
                            '</a>' +
                            '</div>';
                    }
                }],
            "aaSorting": [],
            language: {
                url: '../components/datatables/datatables.chinese.json'
            },
            "ajax": {
                url: "/drug/getIncompatibility.jspa",
                "data": function (d) {//删除多余请求参数
                    for (var key in d)
                        if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                            delete d[key];
                }
            },
            "serverSide": true,
            select: {style: 'single'}
        });

        dgCompatibility.on('draw', function () {
            $('#dgCompatibility tr').find('.hasDetail').click(function () {
                //var tdSeq = $(this).parent().parent().parent().find("td").index($(this).parent().parent()[0]);
                var trSeq = $(this).parent().parent().parent().parent().find("tr").index($(this).parent().parent().parent()[0]);//todo 利用这个找到row数据对象，避免编辑时再去ajax
                //alert("第" + (trSeq + 1) + "行，第" + (tdSeq + 1) + "列");

                var data = dgCompatibility.rows(trSeq).data();
                //console.log("data:" + JSON.stringify(data[0], null, 4));

                if ($(this).attr("data-Url").indexOf('javascript:showDlgIncompatibility') >= 0)
                    showDlgIncompatibility(data[0]);

                if ($(this).attr("data-Url").indexOf('javascript:deleteIncompatibility') >= 0)
                    deleteIncompatibility(data[0]);
            });
        });
        new $.fn.dataTable.Buttons(dgCompatibility, {
            buttons: [
                {
                    "text": "<i class='fa fa-plus-square bigger-130'></i>&nbsp;&nbsp;新增",
                    "className": "btn btn-xs btn-white btn-primary "
                }
            ]
        });
        dgCompatibility.buttons().container().appendTo($('.tableTools-container2'));
        dgCompatibility.button(0).action(function (e, dt, button, config) {
            e.preventDefault();

            showDlgIncompatibility({
                incompatibilityID: 0, drugID1: $('input[name="drugID_compatibility"]').val(), drugID2: 0, chnName1: $('#chnName_span').text(), chnName2: '',
                "level": "", "result": "", "warning": 0, "inBody": 0, "source": "", "mechanism": "",
            });
        });


        function showDlgIncompatibility(row) {
            // console.log("row:" + JSON.stringify(row, null, 4));
            var title = "新建配伍禁忌";
            if (row.incompatibilityID > 0) {
                title = "编辑配伍禁忌";
                $('#chnName2').attr("readonly", true);
            } else {
                $('#chnName2').removeAttr("readonly");
            }
            $('#dlgIncompatibility').removeClass('hide').dialog({
                title: title,
                width: 500, height: 440,
                buttons: [{
                    html: "<i class='ace-icon fa fa-floppy-o bigger-110'></i>&nbsp;保存",
                    "class": "btn btn-danger btn-minier",
                    click: function () {
                        if (incompatibilityForm.valid())
                            incompatibilityForm.submit();
                    }
                }, {
                    html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 关闭",
                    "class": "btn btn-minier",
                    click: function () {
                        $(this).dialog('close');
                    }
                }]
            });
            $("#incompatibilityFm").autofill(row, {
                findbyname: true,//if true, find elements by name attribute. if false, find elements by id.
                restrict: true//if true, restrict the fields search in the node childs. if false, search in all the document.
            });
        }

        //https://github.com/twitter/typeahead.js/blob/master/doc/jquery_typeahead.md
        //两个药品配伍禁忌的第二个药品：可选择
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
                            showDialog(result.title, "保存失败！");
                        else {
                            dgCompatibility.ajax.reload();
                            //showDialog(result.title, "保存成功！");
                            $('#dlgIncompatibility').dialog('close');
                        }
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        showDialog("请求状态码：" + response.status, response.responseText);
                    }
                });
            }
        });

        function deleteIncompatibility(row) {
            if (row) {
                $('#drugName').text(row.chnName1 + " 与 " + row.chnName2 + " 的配伍禁忌");
                $("#dialog-delete").removeClass('hide').dialog({
                    resizable: false,
                    modal: true,
                    title: "删除配伍禁忌",
                    //title_html: true,
                    buttons: [{
                        html: "<i class='ace-icon fa fa-trash-o bigger-110'></i>&nbsp;删除",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            $.ajax({
                                type: "POST",
                                url: '/drug/deleteIncompatibility.jspa',
                                data: {incompatibilityID: row.incompatibilityID},
                                cache: false,
                                success: function (response, textStatus) {
                                    // var msg = response.message;
                                    var result = JSON.parse(response);
                                    if (!result.succeed)
                                        showDialog(result.title, "删除失败！");
                                    else {
                                        dgCompatibility.ajax.reload();
                                    }
                                },
                                error: function (response, textStatus) {/*能够接收404,500等错误*/
                                    showDialog("请求状态码：" + response.status, response.responseText);
                                }
                            });
                            $(this).dialog("close");
                        }
                    }, {
                        html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 取消",
                        "class": "btn btn-minier",
                        click: function () {
                            $(this).dialog("close");
                        }
                    }]
                });
            }
        }

        /*-----------------------剂型说明书管理函数-----------------------------*/

        //level 1
        function showDose(drugID, chnName, healthName) {
            $('input[name="drugID_dose"]').val(drugID);
            $('#chnName_span2').text(chnName);
            $('#healthName2').text(healthName);
            dgDose.ajax.url("/drug/getDrugDoseList.jspa?drugID={0}".format(drugID)).load();
            $("#dialog-dose").removeClass('hide').dialog({
                title: "<h4 class='smaller'>&nbsp;<i class='ace-icon fa fa-paperclip orange' ></i> 剂型与对应说明书</h4> ",//标题栏带了图标，偏高
                //title: "配伍禁忌维护",
                title_html: true,
                resizable: false,
                modal: true,
                width: 650, height: 300
            });
        }

        var dgDose = $('#dgDose').DataTable({
            dom: 't',
            //autoWidth: true,
            //width: 420,
            paging: false, searching: false, "info": false,
            ordering: false, "destroy": true,
            "columns": [
                {"data": "drugDoseID"},
                {"data": "dose", "sClass": "center"},
                {"data": "instructionName", "sClass": "center"},
                /*{"data": "instructCount", "sClass": "center", defaultContent: ''},*/
                {"data": "drugDoseID"}
            ],

            'columnDefs': [
                {
                    "orderable": false, "targets": 0, width: 40, render: function (data, type, row, meta) {
                        return meta.row + 1 + meta.settings._iDisplayStart;
                    }
                },
                {"orderable": false, "targets": 1, title: '剂型'},
                {"orderable": false, "targets": 2, title: '对应说明书'},
                /*{"orderable": false, "targets": 3, title: '数量', width: 50},*/
                {
                    'targets': 3, 'searchable': false, 'orderable': false, title: '操作', width: 60, render: function (data, type, row, meta) {
                        return '<div class="hidden-sm hidden-xs action-buttons">' +
                            '<a class="hasDetail" href="#" data-Url="javascript:showDlgDose();" data-indexID="{0}">'.format(meta.row) +
                            '<i class="ace-icon fa  fa-pencil-square-o green bigger-130"></i>' +
                            '</a>' +
                            '<a class="hasDetail" href="#" data-Url="javascript:destroyDose();" data-indexID="{0}">'.format(meta.row) +
                            '<i class="ace-icon fa  fa-remove red bigger-130"></i>' +
                            '</a>' +
                            '</div>';
                    }
                }],
            "aaSorting": [],
            language: {
                url: '../components/datatables/datatables.chinese.json'
            },
            "ajax": {
                url: "/drug/getDrugDoseList.jspa",
                "data": function (d) {//删除多余请求参数
                    for (var key in d)
                        if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                            delete d[key];
                }
            },
            "serverSide": true,
            select: {style: 'single'}
        });

        dgDose.on('draw', function () {
            $('#dgDose tr').find('.hasDetail').click(function () {
                var trSeq = $(this).parent().parent().parent().parent().find("tr").index($(this).parent().parent().parent()[0]);
                var data = dgDose.rows(trSeq).data();

                if ($(this).attr("data-Url").indexOf('javascript:showDlgDose') >= 0)
                    showDlgDose(data[0]);

                if ($(this).attr("data-Url").indexOf('javascript:destroyDose') >= 0)
                    destroyDose(data[0]);
            });
        });
        new $.fn.dataTable.Buttons(dgDose, {
            buttons: [
                {
                    "text": "<i class='fa fa-plus-square bigger-130'></i>&nbsp;&nbsp;新增",
                    "className": "btn btn-xs btn-white btn-primary "
                }
            ]
        });
        dgDose.buttons().container().appendTo($('.tableTools-container3'));
        dgDose.button(0).action(function (e, dt, button, config) {
            e.preventDefault();
            showDlgDose({drugDoseID: 0, drugID: $('input[name="drugID_dose"]').val(), instructionName: '', dose: ''});
        });

        function showDlgDose(row) {
            var title = "<h4 class='smaller'>&nbsp;<i class='ace-icon fa fa-book orange' ></i> 新建剂型对应说明书</h4> ";//标题栏带了图标，偏高
            //console.log("dose:" + JSON.stringify(row, null, 4));
            $("#doseInstrFm").autofill(row, {findbyname: true, restrict: true});
            if (row.drugDoseID > 0) {
                title = "<h4 class='smaller'>&nbsp;<i class='ace-icon fa fa-book orange' ></i> 编辑剂型对应说明书</h4> ";
                showInstruction(row.instructionID, true);
            } else {
                tableDoseInstruction.ajax.url("/instruction/instructionList.jspa").load();
                $('#instruction').text("");
            }

            $('#dlgDoseInstruction').removeClass('hide').dialog({
                title: title,
                title_html: true,
                width: 860, height: 530,
                buttons: [{
                    html: "<i class='ace-icon fa fa-floppy-o bigger-110'></i>&nbsp;保存",
                    "class": "btn btn-danger btn-minier",
                    click: function () {
                        if (doseInstrForm.valid())
                            doseInstrForm.submit();
                    }
                }, {
                    html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 关闭",
                    "class": "btn btn-minier",
                    click: function () {
                        $(this).dialog('close');
                    }
                }]
            });
        }

        //https://github.com/twitter/typeahead.js/blob/master/doc/jquery_typeahead.md
        $('#instructionName').typeahead({hint: true},
            {
                limit: 1000,
                source: function (queryStr, processSync, processAsync) {
                    var params = {'generalName': queryStr, length: 100, hasInstruction: 1};

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
                        '<div style="font-weight:bold">{{chnName}} <span class="light-grey">&nbsp;&nbsp;说明书数量：</span>{{generalInstNum}} </div>' +
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
            $('#instructionID').val("");
            tableDoseInstruction.ajax.url("/instruction/instructionList.jspa?generalInstrID={0}&hasInstruction=1".format(suggestion["generalInstrID"])).load();
        });
        $('#instructionName').on("input propertychange", function () {
            $('#instructionID').val("");
            $('#instruction').text("");
            //tableDoseInstruction.ajax.url("/instruction/instructionList.jspa".format()).load();
            //tableDoseInstruction.clear().draw(); 这行无效！
        });

        $('#dose').typeahead({minLength: 0, hint: true},
            {
                limit: 1000,
                source: function (queryStr, processSync, processAsync) {
                    var params = {parentDictNo: '00018', length: 1000};

                    $.getJSON('/common/dict/listDict.jspa', params, function (json) {
                        return processAsync(json.data);
                    });
                },
                display: function (item) {
                    return item.name;//+ " - " + item.spec;
                },
                templates: {
                    /*header: function (query) {//header or footer
                        if (query.suggestions.length > 1)
                            return '<div style="text-align:center" class="green" >发现 {0} 项</div>'.format(query.suggestions.length);
                    },*/
                    suggestion: Handlebars.compile('<div style="font-size: 9px"><span style="font-weight:bold">{{name}}</span><br/>' +
                        '<span style="color:#888">{{note}}</span></div>'),
                    pending: function (query) {
                        return '<div>查询中...</div>';
                    },
                    notFound: '<div class="red">没匹配</div>'
                }
            }
        );
         /*$('#dose').bind('typeahead:select', function (ev, suggestion) { 有可能先选说明书，再选剂型
             $('#instructionID').val("");
         });
         $('#dose').on("input propertychange", function () {
             $('#instructionID').val("");
             $('#instruction').text("");
         });*/

        var tableDoseInstruction = $('#tableDoseInstruction').DataTable({
            dom: 't',
            autoWidth: true,
            //width: 420,
            //height: 240,
            scrollY: 260, scrollCollapse: true,
            // scroller: true,
            pageLength: 200,
            //paging: true,
            searching: false, "info": false,
            ordering: false, "destroy": true,
            select: {
                style: 'single'//, selector: 'td:first-child'
            },

            'columnDefs': [
                {targets: 0, data: null, defaultContent: '', orderable: false, width: 20, className: 'select-checkbox'},//"instructionID",
                {"data": "chnName", "orderable": false, "targets": 1, title: '说明书'},
                {"data": "hasInstruction", "orderable": false, "targets": 2, title: '内容', width: 60, className: 'center', render: renderHasNo},
                {"data": "dose", "orderable": false, "targets": 3, title: '剂型', width: 80, defaultContent: '', className: 'center'},
                {"data": "source", "orderable": false, "targets": 4, title: '来源', width: 60, defaultContent: '', className: 'center'}],
            "aaSorting": [],
            language: {
                url: '../components/datatables/datatables.chinese.json'
            },
            "ajax": {
                url: "/instruction/instructionList.jspa",
                "data": function (d) {//删除多余请求参数
                    for (var key in d)
                        if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                            delete d[key];
                }
            },
            "serverSide": true
        });

        tableDoseInstruction.on('draw', function () {
            var instructionID = parseInt($('#instructionID').val());
            //console.log(" tableDoseInstruction  draw instructionID:" + instructionID);

            tableDoseInstruction.data().each(function (element, index) {
                if (element["instructionID"] === instructionID)
                    tableDoseInstruction.row(index).select();
            });
            // only 1 ,auto show instruction text
            if (tableDoseInstruction.data().length === 1 && tableDoseInstruction.row(0).data()["hasInstruction"] > 0) {
                tableDoseInstruction.row(0).select();
            }
        }).on('select', function (e, dt, type, indexes) {
            showInstruction(tableDoseInstruction.row(indexes).data()["instructionID"], false);
        });

        function renderHasNo(value, row, index) {
            if (value === 1) return "有";
            else return "无";
        }


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
                            showDialog(result.title, "保存失败！");
                        else {
                            dgDose.ajax.reload();
                            $('#dlgDoseInstruction').dialog('close');
                        }
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        showDialog("请求状态码：" + response.status, response.responseText);
                    }
                });
            }
        });

        function destroyDose(row) {
            if (row) {
                $('#drugName').text($('#chnName_span2').text() + (row.dose !== null ? " -  " + row.dose : "") + "说明书");
                $("#dialog-delete").removeClass('hide').dialog({
                    resizable: false,
                    modal: true,
                    title: "删除剂型对应说明书",
                    //title_html: true,
                    buttons: [{
                        html: "<i class='ace-icon fa fa-trash-o bigger-110'></i>&nbsp;删除",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            $.ajax({
                                type: "POST",
                                url: '/drug/deleteDrugDose.jspa',
                                data: {drugDoseID: row.drugDoseID},
                                cache: false,
                                success: function (response, textStatus) {
                                    var result = JSON.parse(response);
                                    if (!result.succeed)
                                        showDialog(result.title, "删除失败！");
                                    else {
                                        dgDose.ajax.reload();
                                    }
                                },
                                error: function (response, textStatus) {/*能够接收404,500等错误*/
                                    showDialog("请求状态码：" + response.status, response.responseText);
                                }
                            });
                            $(this).dialog("close");
                        }
                    }, {
                        html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 取消",
                        "class": "btn btn-minier",
                        click: function () {
                            $(this).dialog("close");
                        }
                    }]
                });
            }
        }

        //第一次editDose调用，loadGeneral为true，第二次dgDoseInstruction 的onSelect事件调用，loadGeneral为true为false
        function showInstruction(instructionID, loadGeneral) {
            //console.log("showInstuctionID:" + instructionID);
            $('#instructionID').val(instructionID);
            if (instructionID > 0)
                $.getJSON("/instruction/getInstruction.jspa?instructionID=" + instructionID, function (ret) {
                    if (loadGeneral)//&& ret.generalInstrID !== null
                        tableDoseInstruction.ajax.url("/instruction/instructionList.jspa?generalInstrID={0}"
                            .format(ret.generalInstrID === null ? 0 : ret.generalInstrID)).load();
                    else
                        $('#instruction').html(ret.instruction);
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
            <label>说明书：</label>
            <select class="chosen-select form-control" id="instructionType">
                <option value="0">全部</option>
                <option value="1">已配对</option>
                <option value="2">未配对</option>
            </select>&nbsp;&nbsp;&nbsp;
            <label>抗菌药：</label>
            <div class="input-group">
                <input type="checkbox" id="antiClass">&nbsp;&nbsp;&nbsp;
            </div>&nbsp;&nbsp;&nbsp;
            <label>配伍：</label>
            <div class="input-group">
                <input type="checkbox" id="hasInteract">&nbsp;&nbsp;&nbsp;
            </div>&nbsp;&nbsp;&nbsp;
            <label>本院相关：</label>
            <div class="input-group">
                <input type="checkbox" id="linkMe">&nbsp;&nbsp;&nbsp;
            </div> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
                        通用名列表
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
                                <%-- <th style="text-align: center">剂型</th>--%>
                                <th style="text-align: center;width:45px">基药</th>
                                <th style="text-align: center;width:45px">孕妇</th>
                                <th style="text-align: center;width:60px">哺乳期</th>
                                <th style="text-align: center;width:60px">老年人</th>
                                <th style="text-align: center;width:45px">儿童</th>
                                <th style="text-align: center;width:70px">最大剂量</th>
                                <th style="text-align: center;width:45px">极量</th>
                                <th style="text-align: center;width:60px;">DDD值</th>
                                <th style="text-align: center">对应说明书</th>
                                <th style="text-align: center;width:45px;">配伍</th>
                                <th style="text-align: center">本院药品</th>
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

    <div id="dialog-edit" class="hide">
        <div class="col-xs-12  no-padding  ">
            <!-- PAGE CONTENT BEGINS -->
            <form class="form-horizontal" role="form" id="drugForm">
                <fieldset>
                    <div class="col-sm-12 ">
                        <div class="form-group  no-padding no-margin">
                            <label class="col-sm-2 control-label" style="white-space: nowrap">通用名&nbsp;&nbsp;&nbsp;</label>
                            <input type="text" id="chnName" name="chnName" placeholder="通用名" style="font-size:  large;color: black ;" class="col-xs-9 col-sm-9  "/>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="form-group">
                            <label for="healthNo" class="col-sm-4 control-label" style="white-space: nowrap">药理分类</label>
                            <input id="healthName3" type="text" style="width:180px;" onclick="showMenu();"/>
                            <input type="hidden" id="healthNo" name="healthNo"/>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-4 control-label" style="white-space: nowrap">基本药物 </label>
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
                            <label class="col-sm-4 control-label" style="white-space: nowrap">辅助用药 </label>
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
                            <label class="col-sm-4 control-label" for="divPinyin">拼音码</label>
                            <span id="divPinyin"></span>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-4 control-label" style="white-space: nowrap">最大剂量 </label>
                            <input type="text" id="maxEffectiveDose" name="maxEffectiveDose" placeholder="最大剂量"/>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-4 control-label" style="white-space: nowrap">极量 </label>
                            <input type="text" id="maxDose" name="maxDose" placeholder="极量"/>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-4 control-label" style="white-space: nowrap">DDD值 </label>
                            <input type="text" id="ddd" name="ddd" placeholder="DDD值"/>
                        </div>

                    </div><!-- /.col -->

                    <div class="col-xs-6">
                        <div class="form-group  control-label">
                            <label class="col-xs-3" style="white-space: nowrap">类别</label>
                            <label>
                                <input name="drugtype" type="radio" class="ace" value="西药"/>
                                <span class="lbl">西药</span>
                            </label>
                            <label class="col-xs-offset-1">
                                <input name="drugtype" type="radio" class="ace" value="中成药"/>
                                <span class="lbl">中成药</span>
                            </label>
                            <label class="col-xs-offset-1">
                                <input name="drugtype" type="radio" class="ace" value="中草药"/>
                                <span class="lbl">中草药</span>
                            </label>
                        </div>
                        <div class="form-group  control-label">
                            <label class="col-xs-3" style="white-space: nowrap">孕妇</label>
                            <label>
                                <input name="gravida" type="radio" class="ace" value="0"/>
                                <span class="lbl">无&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-xs-offset-1">
                                <input name="gravida" type="radio" class="ace" value="1"/>
                                <span class="lbl" style='color: #7f0000'>慎用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-xs-offset-1">
                                <input name="gravida" type="radio" class="ace" value="2"/>
                                <span class="lbl" style='color: deeppink'>禁用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                        </div>

                        <div class="form-group control-label">
                            <label class="col-xs-3" style="white-space: nowrap">哺乳期</label>
                            <label>
                                <input name="lactation" type="radio" class="ace" value="0"/>
                                <span class="lbl">无&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-xs-offset-1">
                                <input name="lactation" type="radio" class="ace" value="1"/>
                                <span class="lbl" style='color: #7f0000'>慎用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-xs-offset-1">
                                <input name="lactation" type="radio" class="ace" value="2"/>
                                <span class="lbl" style='color: deeppink'>禁用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                        </div>
                        <div class="form-group  control-label">
                            <label class="col-xs-3" style="white-space: nowrap">老年人</label>
                            <label>
                                <input name="oldFolks" type="radio" class="ace" value="0"/>
                                <span class="lbl">无&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-xs-offset-1">
                                <input name="oldFolks" type="radio" class="ace" value="1"/>
                                <span class="lbl" style='color: #7f0000'>慎用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-xs-offset-1">
                                <input name="oldFolks" type="radio" class="ace" value="2"/>
                                <span class="lbl" style='color: deeppink'>禁用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                        </div>
                        <div class="form-group  control-label">
                            <label class="col-xs-3" style="white-space: nowrap">儿童</label>
                            <label>
                                <input name="children" type="radio" class="ace" value="0"/>
                                <span class="lbl">无&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-xs-offset-1">
                                <input name="children" type="radio" class="ace" value="1"/>
                                <span class="lbl" style='color: #7f0000'>慎用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-xs-offset-1">
                                <input name="children" type="radio" class="ace" value="2"/>
                                <span class="lbl" style='color: deeppink'>禁用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                        </div>
                        <div class="form-group  control-label">
                            <label class="col-xs-3" style="white-space: nowrap">肝功能不全 </label>
                            <label>
                                <input name="liver" type="radio" class="ace" value="0"/>
                                <span class="lbl">无&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-xs-offset-1">
                                <input name="liver" type="radio" class="ace" value="1"/>
                                <span class="lbl" style='color: #7f0000'>慎用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-xs-offset-1">
                                <input name="liver" type="radio" class="ace" value="2"/>
                                <span class="lbl" style='color: deeppink'>禁用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                        </div>
                        <div class="form-group  control-label">
                            <label class="col-xs-3" style="white-space: nowrap">肾功能不全 </label>
                            <label>
                                <input name="kidney" type="radio" class="ace" value="0"/>
                                <span class="lbl">无&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-xs-offset-1">
                                <input name="kidney" type="radio" class="ace" value="1"/>
                                <span class="lbl" style='color: #7f0000'>慎用&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            </label>
                            <label class="col-xs-offset-1">
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
    <div id="dialog-compatibility" class="hide">
        <div class="col-xs-12">
            <div class="row">
                <label class="col-xs-6" style="white-space: nowrap">药品名称：<span id="chnName_span" style="white-space: nowrap"/> </label>
                <label class="col-xs-5" style="white-space: nowrap">药理：<span id="healthName" style="white-space: nowrap"/> </label>
                <div class="col-xs-1  tableTools-container2"></div>
                <input type="hidden" name="drugID_compatibility">
            </div>
            <div class="row">
                <table id="dgCompatibility" class="table table-striped table-bordered table-hover" style="width: 100%;">
                </table>
            </div>
        </div>
    </div>

    <div id="dlgIncompatibility" class="hide">
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
        </div>
    </div>
    <div id="dialog-dose" class="hide dialogs">
        <div class="col-xs-12 col-md-12 col-sm-12 col-lg-12">
            <div class="row">
                <label class="col-xs-5" style="white-space: nowrap">药品名称：<span id="chnName_span2" style="white-space: nowrap"/> </label>
                <label class="col-xs-5" style="white-space: nowrap">药理：<span id="healthName2" style="white-space: nowrap"/> </label>
                <div class="col-xs-2  tableTools-container3"></div>
                <input type="hidden" name="drugID_dose">
            </div>
            <div class="row">
                <table id="dgDose" class="table table-striped table-bordered table-hover" style="width: 100%;">
                </table>
            </div>
        </div>
    </div>
    <div id="dlgDoseInstruction" class="hide">
        <form id="doseInstrFm" method="post" class="form-horizontal">
            <div class="container-fluid">
                <input type="hidden" name="drugDoseID">
                <input type="hidden" name="drugID">
                <div class="row">
                    <div class="col-xs-7">
                        <div class="form-group" style="margin-top: 5px">
                            <label class="col-xs-2 control-label no-padding-left" for="dose"> 剂型 </label>
                            <input class="typeahead scrollable nav-search-input" type="text" id="dose" name="dose" tabindex="-1"
                                   autocomplete="off" style="width:280px;font-size: 9px;color: black"
                                   placeholder="编码或拼音匹配，鼠标选择">
                        </div>
                        <div class="form-group" style="margin-bottom: 3px;margin-top: 5px">
                            <label class="col-xs-2 control-label no-padding-left" for="instructionName"> 通用名 </label>
                            <input class="typeahead scrollable nav-search-input" type="text" id="instructionName" name="instructionName" tabindex="-1"
                                   autocomplete="off" style="width:280px;font-size: 9px;color: black"
                                   placeholder="编码或拼音匹配，鼠标选择">
                        </div>
                        <input type="hidden" id="instructionID" name="instructionID" required>
                        <label class="col-xs-12 no-padding-left" for="tableDoseInstruction"> 可选说明书 </label>
                        <table class="col-xs-12  table table-striped table-bordered table-hover" id="tableDoseInstruction" style="width:100%;"></table>
                    </div>
                    <div class="col-xs-5">
                        <div class="widget-box" id="widget-box-1">
                            <div class="widget-header widget-header-small">
                                <h5 class="widget-title">说明书内容</h5>
                            </div>

                            <div class="widget-body">
                                <div class="widget-main no-margin no-padding">
                                    <div id="instruction" title="说明书内容" style="height:360px;overflow:auto; padding: 0 0 0 5px">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>


    <div id="dialog-delete" class="hide" title="删除通用名">
        <div class="alert alert-info bigger-110">
            永久删除 <span id="drugName" class="red"></span> ，不可恢复！
        </div>
    </div>
    <div id="dialog-error" class="hide alert" title="操作确认" style="width:400px;height:200px;padding:10px">
        <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
    </div>
</div>

<!-- 模态框（Modal） -->
<div class="modal hide ui-dialog-titlebar2 no-padding no-margin" id="myModal" tabindex="-1" role="dialog"> <%-- --%>
    <div class="zTreeDemoBackground left no-padding no-margin">
        <ul id="treeDemo" class="ztree"></ul>
    </div>
</div>
<!-- /.page-content -->
<script type="text/javascript">
    /*tree*/
    var setting = {
        async: {
            enable: true,
            url: "/health/zTree.jspa",
            autoParam: ["id=parentID"],//, "name=n", "level=lv"
            type: "get"
        },
        callback: {
            onClick: zTreeOnClick,
            beforeAsync: beforeAsync,
            onAsyncSuccess: onAsyncSuccess
        }
    };

    function beforeAsync() {
        curAsyncCount++;
    }

    function onAsyncSuccess(event, treeId, treeNode, msg) {
        curAsyncCount--;
        if (curStatus === "expand") {
            expandNodes(treeNode.children);
        } else if (curStatus === "async") {
            asyncNodes(treeNode.children);
        }

        if (curAsyncCount <= 0) {
            curStatus = "";
            console.log("finish load");
            showPath();
        }
    }

    var curStatus = "init", curAsyncCount = 0, goAsync = false;

    function expandNodes(nodes) {
        if (!nodes) return;
        curStatus = "expand";
        var zTree = $.fn.zTree.getZTreeObj("treeDemo");
        for (var i = 0, l = nodes.length; i < l; i++) {
            zTree.expandNode(nodes[i], true, false, false);//展开节点就会调用后台查询子节点
            if (nodes[i].isParent && nodes[i].zAsync) {
                expandNodes(nodes[i].children);//递归
            } else {
                goAsync = true;
            }
        }
    }

    var selectedNode;

    function zTreeOnClick(event, treeId, treeNode) {
        selectedNode = treeNode;
        $('#healthNo').val(treeNode.healthNo);
        $('#healthName3').val(treeNode.name);
        $('#myModal').dialog('close');
    }

    function showPath() {
        var zTree = $.fn.zTree.getZTreeObj("treeDemo");

        zTree.expandAll(false);
        zTree.expandNode(zTree.getNodes()[0], true);
        selectedNode = zTree.getNodesByParam("healthNo", $('#healthNo').val(), null);
        //console.log("init healthNo:" + $('#healthNo').val());
        if (selectedNode.length > 0) {
            selectedNode = selectedNode[0];

            var parent = [];
            var node = selectedNode.getParentNode();
            while (node != null) {
                parent.push(node);
                node = node.getParentNode();
            }

            while (parent.length > 0)
                zTree.expandNode(parent.pop(), true);

            zTree.selectNode(selectedNode);
        }
    }

    function showMenu() {
        var zTree = $.fn.zTree.getZTreeObj("treeDemo");
        zTree.expandNode(zTree.getNodes()[0], true, false, false);//展开节点就会调用后台查询子节点
        //展开
        expandNodes(zTree.getNodes());
        if (!goAsync) {
            curStatus = "";
        }
        //console.log("tree length:" + zTree.getNodes()[0].children.length);
        if (zTree.getNodes()[0].children) //已加载，显示选择的路径，否则，onAsyncSuccess调用完毕执行
            showPath();

        $("#myModal").removeClass('hide').dialog({
            modal: true,
            height: 500,
            class: 'ui-dialog-titlebar2',
            title: '选择药理分类'
        });
    }

    $(document).ready(function () {
        $.fn.zTree.init($("#treeDemo"), setting, {id: '1', name: '药理分类', isParent: true});
    });
</script>