<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script src="../components/datatables/jquery.dataTables.min.js"></script>
<script src="../components/datatables/jquery.dataTables.bootstrap.min.js"></script>
<script src="../components/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="../components/datatables/dataTables.select.min.js"></script>
<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>
<script src="../js/accounting.min.js"></script>
<script src="../js/render_func.js"></script>
<script src="../js/jquery.cookie.min.js"></script>
<script src="../assets/js/jquery.validate.min.js"></script>
<script src="../components/moment/min/moment-with-locales.min.js"></script>
<script src="../components/typeahead.js/dist/typeahead.bundle.min.js"></script>
<script src="../components/typeahead.js/handlebars.js"></script>
<script src="../components/chosen/chosen.jquery.js"></script>
<script src="../components/jquery.editable-select/jquery.editable-select.min.js"></script>

<script src="../components/bootstrap-wysiwyg/jquery.hotkeys.index.min.js"></script>
<script src="../components/bootstrap-wysiwyg/bootstrap-wysiwyg.min.js"></script>

<!-- bootstrap & fontawesome -->

<link rel="stylesheet" href="../components/font-awesome/css/font-awesome.css"/>
<link rel="stylesheet" href="../components/jquery.editable-select/jquery.editable-select.min.css"/>
<link rel="stylesheet" href="../components/chosen/chosen.min.css"/>
<style>
    .form-group {
        margin-bottom: 3px;
        margin-top: 3px;
    }
</style>
<script type="text/javascript">
    jQuery(function ($) {
            var url = "/instruction/instructionList.jspa";
            //initiate dataTables plugin
            var dynamicTable = $('#dynamic-table');
            var myTable = dynamicTable
            //.wrap("<div class='dataTables_borderWrap' />") //if you are applying horizontal scrolling (sScrollX)
                .DataTable({
                    bAutoWidth: false,
                    "searching": true,
                    "columns": [
                        {"data": "instructionID", "sClass": "center", "orderable": false, width: 45},
                        {"data": "chnName", "sClass": "center", "orderable": false, className: 'middle'},
                        {"data": "general", "sClass": "center", "orderable": false, className: 'middle', defaultContent: ''},
                        {"data": "matchGeneralName", "sClass": "center", "orderable": false, className: 'middle', defaultContent: ''},
                        {"data": "dose", "sClass": "center", "orderable": false, className: 'middle', defaultContent: ''},//4
                        {"data": "hasInstruction", "sClass": "center", "orderable": false, className: 'middle', width: 60},
                        {"data": "source", "sClass": "center", "orderable": false, className: 'middle', defaultContent: ''},
                        {"data": "producer", "sClass": "center", "orderable": false, className: 'middle', defaultContent: ''},
                        {"data": "authCode", "sClass": "center", "orderable": false, className: 'middle', defaultContent: ''},
                        {"data": "updateTime", "sClass": "center", "orderable": false, className: 'middle', width: 130},//9
                        {"data": "createUser", "sClass": "center", "orderable": false, className: 'middle', defaultContent: ''},
                        {"data": "updateUser", "orderable": false, defaultContent: ''},
                        {"data": "instructionID", "orderable": false, width: 80, className: 'middle'}
                    ],
                    'columnDefs': [
                        {
                            "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
                                return meta.row + 1 + meta.settings._iDisplayStart;
                            }
                        },
                        {
                            'targets': 2, 'searchable': false, 'orderable': false, render: function (data, type, row, meta) {
                                return data === 1 ? "通用名" : "别名";
                            }
                        },
                        {
                            'targets': 5, 'searchable': false, 'orderable': false, render: function (data, type, row, meta) {
                                if (data === 1)
                                    return "<a href='#' class='hasInstruction' data-instructionID='{0}'>自有</a>".format(row['instructionID']);
                                //"<a href='#'  onclick='displayInstruction(\"" + row['instructionID'] + "\",\"" + row['chnName'] + "\",420,30)'><div style='color: blue '>自有</div></a>";
                                else if (row['matchInstruction'] === 1)
                                    return "<a href='#' class='hasInstruction2' data-generalInstrID='{0}'>匹配</a>".format(row['generalInstrID']);
                                //return "<a href='#'  onclick='displayInstrByGeneralInstrID(\"" + row['generalInstrID'] + "\",\"" + row['matchGeneralName'] + "\", 420,30)'><div style='color: green'>匹配</div></a>";
                                else if (row['generalInstNum'] > 0)
                                    return "<a href='#' class='hasInstruction2' data-generalInstrID='{0}'>关联({1})</a>".format(row['generalInstrID'], row['generalInstNum']);
                                //return "<a href='#'  onclick='displayInstrByGeneralInstrID(\"" + row['generalInstrID'] + "\",\"" + row['matchGeneralName'] + "\", 420,30)'><div style='color: green'>关联(" + row['generalInstNum'] + ")</div></a>";
                                else return "否";
                            }
                        },
                        {
                            "orderable": false, "targets": 7, render: function (data) {
                                if (data !== undefined && data.length > 8) return data.substring(0, 6) + "...";
                                return data;
                            }
                        },
                        {
                            'targets': 12, 'searchable': false, 'orderable': false,
                            render: function (data, type, row, meta) {
                                return '<div class="hidden-sm hidden-xs action-buttons">' +
                                    '<a class="hasDetail" href="#" data-Url="javascript:editInstruction({0});">'.format(data) +
                                    '<i class="ace-icon fa  fa-pencil-square-o green bigger-130"></i>' +
                                    '</a>&nbsp;&nbsp;&nbsp;' +
                                    '<a class="hasDetail" href="#" data-Url="javascript:deleteDialog({0},\'{1}\');">'.format(data, row['chnName']) +
                                    '<i class="ace-icon fa  fa-remove red bigger-130"></i>' +
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
                                if (key.indexOf("columns") === 0 || key.indexOf("order") === 0) //以columns开头的参数删除 ,保留|| key.indexOf("search") === 0
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
                $('#dynamic-table tr').find('.hasInstruction').click(function () {//点击显示说明书
                    showInstructionContent($(this).attr("data-instructionID"));

                });
                $('#dynamic-table tr').find('.hasInstruction2').click(function () {
                    showGeneralContent($(this).attr("data-generalInstrID"));
                });
            });

            $('.btn-success').click(function () {
                myTable.ajax.url("/instruction/instructionList.jspa?hasInstruction={0}&source={1}"
                    .format($('#hasInstruction').val(), $('#sourceType').val())).load();
                /*  if ($('#form-instructionID').val() !== '') {
                      myTable.ajax.url("/instruction/instructionList.jspa?instructionID={0}&hasInstruction={1}&source={2}"
                          .format($('#form-instructionID').val(), $('#hasInstruction').val(), $('#sourceType').val())).load();
                  } else if ($('#form-generalInstrID').val() !== '') {
                      myTable.ajax.url("/instruction/instructionList.jspa?generalInstrID={0}&hasInstruction={1}&source={2}"
                          .format($('#form-generalInstrID').val(), $('#hasInstruction').val(), $('#sourceType').val())).load();
                  } else {
                      myTable.ajax.url("/instruction/instructionList.jspa?chnName={0}&hasInstruction={1}&source={2}&generalName={3}"
                          .format($('#form-instruction').val(), $('#hasInstruction').val(), $('#sourceType').val(), $('#form-general').val())).load();
                  }*/
            });
            //https://github.com/twitter/typeahead.js/blob/master/doc/jquery_typeahead.md
            /*$('#form-instruction').typeahead({hint: true, minLength: 1},
                {
                    limit: 100,
                    async: true,
                    source: function (queryStr, syncResults, asyncResults) {
                        var params = {chnName: queryStr, length: 100};
                        $.getJSON('/instruction/instructionList.jspa', params, function (json) {
                            //console.log("json:" + JSON.stringify(json, null, 4));
                            return asyncResults(json.aaData);
                        });
                    },
                    display: function (item) {
                        return item.chnName;//+ " - " + item.matchGeneralName;
                    },
                    templates: {
                        header: function (query) {//header or footer
                            //console.log("query:" + JSON.stringify(query, null, 4));
                            if (query.suggestions.length > 1)
                                return '<div style="text-align:center" class="green" >发现 {0} 项</div>'.format(query.suggestions.length);
                        },
                        suggestion: Handlebars.compile('<div style="font-size: 9px">' +
                            '<div style="font-weight:bold">{{chnName}}</div>' +
                            '{{#if general}} 通用名 {{else}} 别名 {{/if}}<span class="space-4"/>{{producer}}</div>'),
                        pending: function (query) {
                            return '<div>查询中...</div>';
                        },
                        notFound: '<div class="red">没匹配</div>'
                    }
                }
            );
            $('#form-instruction').bind('typeahead:select', function (ev, suggestion) {
                //console.log("instructionID:" + suggestion["instructionID"]);
                $('#form-instructionID').val(suggestion["instructionID"]);
            });
            $('#form-instruction').on("input propertychange", function () {
                $('#form-instructionID').val("");
            });*/
            //form-general
            $('#matchGeneralName').typeahead({hint: true, minLength: 1},
                {
                    limit: 1000,//要大于http请求返回的长度
                    source: function (queryStr, processSync, processAsync) {
                        var params = {generalName: queryStr, length: 100};
                        $.getJSON('/instruction/instructionList.jspa', params, function (json) {
                            console.log("length:" + json.iTotalRecords);
                            return processAsync(json.aaData);
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
                            '<span style="font-weight:bold">{{chnName}}</span>' +
                            '<span class="light-grey">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;说明书：</span>{{#if hasInstruction}}有{{else}}无{{/if}}' +
                            '{{#if producer}}<br/><span class="light-grey">厂家：</span>{{producer}}{{/if}}' +
                            '</div>'),
                        pending: function (query) {
                            return '<div>查询中...</div>';
                        },
                        notFound: '<div class="red">没匹配</div>'
                    }
                }
            );
            $('#matchGeneralName').bind('typeahead:select', function (ev, suggestion) {
                //console.log("generalInstrID:" + suggestion["generalInstrID"]);
                //chooseDrug(suggestion);
                $('#generalInstrID').val(suggestion["generalInstrID"]);
            });
            $('#matchGeneralName').on("input propertychange", function () {
                $('#drugID').val("");
            });
            $('#matchGeneralName').on("focus", function () {
                $(this).select();//全选
            });


            var instructionForm = $('#instructionForm');
            instructionForm.validate({
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
                    //console.log(instructionForm.serialize());
                    instructionForm.append("<input name='instruction'>");//因富文本编辑是div，需要创建input去提交
                    $('input[name="instruction"]').val($('#instruction').html());
                    //console.log(instructionForm.serialize());
                    $.ajax({
                        type: "POST",
                        url: "/instruction/saveInstruction.jspa",
                        data: instructionForm.serialize(),//+ "&productImage=" + av atar_ele.get(0).src,
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
                        },
                        complete: function (data) {
                            console.log("complete");
                            $('input[name="instruction"]').remove();
                        }
                    });
                },
                invalidHandler: function (form) {
                    console.log("invalidHandler");
                }
            });

            var similarTable = $('#similarTable').DataTable({
                dom: 't',
                bAutoWidth: true,
                "scrollY": "200px",
                "scrollCollapse": true,
                paging: false,
                searching: false, "info": false,

                ordering: false,
                "destroy": true,
                "columns": [
                    {"data": "instructionID"},
                    {"data": "chnName", "sClass": "center"},
                    {"data": "general", "sClass": "center"},
                    {"data": "dose", "sClass": "center", defaultContent: ''},
                    {"data": "hasInstruction", "sClass": "center"},//4
                    {"data": "source", "sClass": "center", defaultContent: ''}
                ],

                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 40, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {"orderable": false, "targets": 1, title: '药品名称'},
                    {
                        'targets': 2, 'searchable': false, 'orderable': false, title: '类别', render: function (data, type, row, meta) {
                            return data === 1 ? "通用名" : "别名";
                        }
                    },
                    {"orderable": false, "targets": 3, title: '剂型'},
                    {
                        'targets': 4, 'searchable': false, 'orderable': false, title: '说明书', render: function (data, type, row, meta) {
                            if (data === 1)
                                return "<a href='#' class='hasInstruction' data-instructionID='{0}'>自有</a>".format(row['instructionID']);
                            else if (row['matchInstruction'] === 1)
                                return "<a href='#' class='hasInstruction2' data-generalInstrID='{0}'>匹配</a>".format(row['generalInstrID']);
                            else if (row['generalInstNum'] > 0)
                                return "<a href='#' class='hasInstruction2' data-generalInstrID='{0}'>关联({1})</a>".format(row['generalInstrID'], row['generalInstNum']);
                            else return "否";
                        }
                    }, {"orderable": false, "targets": 5, title: '厂家或来源'}],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                "ajax": {
                    url: "/instruction/instructionList.jspa?generalInstrID=0",
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                }
            });

            similarTable.on('draw', function () {
                $('#similarTable tr').find('.hasDetail').click(function () {
                    if ($(this).attr("data-Url").indexOf('javascript:') >= 0) {
                        eval($(this).attr("data-Url"));
                    } else
                        window.open($(this).attr("data-Url"), "_blank");
                });
                $('#similarTable tr').find('.hasInstruction').click(function () {//点击显示说明书
                    showInstructionContent($(this).attr("data-instructionID"));

                });
                $('#similarTable tr').find('.hasInstruction2').click(function () {
                    showGeneralContent($(this).attr("data-generalInstrID"));
                });
            });
            var divPinyin = $('#divPinyin');
            var editingInst;
            $('#chnName').on('keyup', function () {
                loadPinyin($(this).val());
            });

            function loadPinyin(chinese) {
                divPinyin.empty();
                divPinyin.append("<select class='chosen-select form-control' id='pinyin' style='font-size: 9px;color: black ;' name='pinyin'></select>");

                $.getJSON("/pinyin/getPinyin.jspa?chinese=" + chinese, function (result) {
                    $.each(result.data, function (index, object) {
                        //console.log("index1:" + index);
                        $('#pinyin').append("<option value='{0}'>{1}</option>".format(object.toUpperCase(), object.toUpperCase()));
                    });
                    $('#pinyin').editableSelect({filter: false});//{filter: false}

                    /* $('#pinyin').find("option").each(function () { //editableSelect后不能遍历
                         console.log("index:" + index);
                         if (editingInst.pinyin.toLowerCase() === object) {
                             console.log("choose:" + index);
                             $('#pinyin').find("option").eq(index).prop("selected", true)
                         }
                     });*/

                    if (editingInst.pinyin !== null && editingInst.pinyin !== '')
                        $('#pinyin').val(editingInst.pinyin);
                });
            }

            function showInstructionDialog(inst) {
                editingInst = inst;
                //divPinyin.append("<select class='chosen-select form-control' id='pinyin' style='font-size: 9px;color: black ;' name='pinyin'></select>");
                loadPinyin(inst.chnName);

                $('input[name="instructionID"]').val(inst.instructionID);
                $('#chnName').val(inst.chnName);
                $('#matchGeneralName').val(inst.matchGeneralName);
                $('#producer').val(inst.producer);
                $('#sourceType2').val(inst.source);
                $('#instruction').html(inst.instruction);
                //$('#instruction').focus();
                $('#general').val(inst.general);
                $('#dose').val(inst.dose);

                //var dialogOwn = $('#dialog-edit').clone();
                $("#dialog-edit").removeClass('hide').dialog({
                    resizable: false, width: 770, height: 630, modal: true, title: "编辑说明书", title_html: true,
                    onClose: function () {//todo 两个函数无效
                        console.log("close");
                        $('#pinyin').remove();
                    },
                    onDestroy: function () {//todo 两个函数无效
                        console.log("destroy");
                        $('#pinyin').remove();
                    },
                    buttons: [
                        {
                            html: "<i class='ace-icon fa fa-flag  bigger-110'></i>&nbsp;设为本组唯一通用名",
                            "class": "btn btn-info btn-minier",
                            click: function () {
                                $.ajax({
                                    type: "POST",
                                    url: "/instruction/setOnlyGeneral.jspa",
                                    data: {instructionID: inst.instructionID, generalInstrID: inst.generalInstrID},
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
                                $(this).dialog("close");
                            }
                        }, {
                            html: "<i class='ace-icon fa fa-floppy-o bigger-110'></i>&nbsp;保存",
                            "class": "btn btn-danger btn-minier",
                            click: function () {
                                if (instructionForm.valid()) {
                                    instructionForm.submit();
                                    divPinyin.empty();
                                }
                            }
                        }, {
                            html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 关闭",
                            "class": "btn btn-minier",
                            click: function () {
                                $('#dialog-edit').dialog('close');
                                //$('#pinyin').remove();
                                divPinyin.empty();
                            }
                        }]
                });
                //console.log('ret.generalInstrID:'+ret.generalInstrID);
                if (inst.generalInstrID !== undefined && inst.generalInstrID !== null) {
                    similarTable.ajax.url("/instruction/instructionList.jspa?generalInstrID={0}".format(inst.generalInstrID)).load();
                    similarTable.columns.adjust().draw();
                } else
                    similarTable.clear().draw();
            }

            function editInstruction(instructionID) {
                $.getJSON("/instruction/getInstruction.jspa?instructionID=" + instructionID, function (ret) {
                    showInstructionDialog(ret);
                });
            }

            $('#instruction').ace_wysiwyg({
                toolbar:
                    [
                        'font',
                        null,
                        'fontSize',
                        null,
                        {name: 'bold', className: 'btn-info'},
                        {name: 'italic', className: 'btn-info'},
                        {name: 'strikethrough', className: 'btn-info'},
                        {name: 'underline', className: 'btn-info'},
                        null,
                        {name: 'insertunorderedlist', className: 'btn-success'},
                        {name: 'insertorderedlist', className: 'btn-success'},
                        {name: 'outdent', className: 'btn-purple'},
                        {name: 'indent', className: 'btn-purple'},
                        null,
                        {name: 'justifyleft', className: 'btn-primary'},
                        {name: 'justifycenter', className: 'btn-primary'},
                        {name: 'justifyright', className: 'btn-primary'},
                        {name: 'justifyfull', className: 'btn-inverse'},
                        null,
                        {name: 'createLink', className: 'btn-pink'},
                        {name: 'unlink', className: 'btn-pink'},
                        null,
                        {name: 'insertImage', className: 'btn-success'},
                        null,
                        'foreColor',
                        null,
                        {name: 'undo', className: 'btn-grey'},
                        {name: 'redo', className: 'btn-grey'}
                    ]/*,
            'wysiwyg': {
                fileUploadError: showErrorAlert
            }*/
            }).prev().addClass('wysiwyg-style2');

            function deleteDialog(instructionID, chnName) {
                if (instructionID === undefined) return;
                $('#instructionName').text(chnName);
                $("#dialog-delete").removeClass('hide').dialog({
                    resizable: false,
                    modal: true,
                    title: "确认删除说明书",
                    //title_html: true,
                    buttons: [
                        {
                            html: "<i class='ace-icon fa fa-trash bigger-110'></i>&nbsp;确定",
                            "class": "btn btn-danger btn-minier",
                            click: function () {
                                $.ajax({
                                    type: "POST",
                                    url: "/instruction/deleteInstruction.jspa?instructionID=" + instructionID,
                                    //contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
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


            function showInstructionContent(instructionID) {
                $.ajax({
                    type: "GET",
                    url: '/instruction/getInstruction.jspa',
                    data: 'instructionID=' + instructionID,
                    contentType: "application/json; charset=utf-8",
                    cache: false,
                    success: function (response, textStatus) {
                        var respObject = JSON.parse(response);
                        $('#instruction-title').text(respObject.chnName);
                        $('#instruction-content').html(respObject.instruction);
                        $('#showInstructionDialog').modal();
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        showDialog("请求状态码：" + response.status, response.responseText);
                    }
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

            function showGeneralContent(generalInstrID) {
                $.ajax({
                    type: "GET",
                    url: '/instruction/viewInstrByGeneralInstrID.jspa',
                    data: 'generalInstrID=' + generalInstrID,
                    contentType: "application/json; charset=utf-8",
                    cache: false,
                    success: function (response, textStatus) {
                        var respObject = JSON.parse(response);
                        $('#instruction-title').text(respObject.chnName);
                        $('#instruction-content').html(respObject.instruction);
                        $('#showInstructionDialog').modal();
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        showDialog("请求状态码：" + response.status, response.responseText);
                    }
                });
            }


            $.getJSON("/instruction/liveSource.jspa", function (result) {
                $.each(result.data, function (index, object) {
                    $('#sourceType').append("<option value='{0}'>{1}</option>".format(object, object));
                    $('#sourceType2').append("<option value='{0}'>{1}</option>".format(object, object));
                });
                $('#sourceType2').editableSelect({});
            });
            $.getJSON("/common/dict/listDict.jspa?parentID=2", function (result) {
                $.each(result.data, function (index, object) {
                    $('#dose').append("<option value='{0}'>{1}</option>".format(object.name, object.name));
                });
            });

            //$.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap padding-4';
            new $.fn.dataTable.Buttons(myTable, {
                buttons: [
                    {
                        "text": "<i class='fa fa-plus-square bigger-130'></i>&nbsp;&nbsp;新增",
                        "className": "btn btn-xs btn-white btn-primary "
                    }
                ]
            });
            myTable.buttons().container().appendTo($('.tableTools-container'));
            myTable.button(0).action(function (e, dt, button, config) {
                e.preventDefault();
                showInstructionDialog({instruction: ''});
            });
        }
    );
</script>

<!-- #section:basics/content.breadcrumbs -->
<div class="breadcrumbs ace-save-state" id="breadcrumbs">
    <ul class="breadcrumb">
        <li>
            <i class="ace-icon fa fa-home home-icon"></i>
            <a href="/index.jspa?content=/admin/hello.html">首页</a>
        </li>
        <li class="active">说明书库</li>

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
            <%-- <label class=" control-label no-padding-right" for="form-instruction">药品名称： </label>
             <div class="input-group">
                 <input class="typeahead scrollable nav-search-input" type="text" id="form-instruction" name="form-instruction"
                        autocomplete="off" style="width: 250px;font-size: 9px;color: black"
                        placeholder="编码或拼音匹配，鼠标选择"/><input type="hidden" id="form-instructionID"/>
             </div>&nbsp;&nbsp;&nbsp;--%>
            <%--<label class=" control-label no-padding-right" for="form-generalInstrID">通用名： </label>
            <div class="input-group">
                <input class="typeahead scrollable nav-search-input" type="text" id="form-general" name="form-general"
                       autocomplete="off" style="width: 250px;font-size: 9px;color: black"
                       placeholder="编码或拼音匹配，鼠标选择"/><input type="hidden" id="form-generalInstrID"/>
            </div>&nbsp;&nbsp;&nbsp;--%>
            <label>有说明书：</label>
            <select class="chosen-select form-control" id="hasInstruction">
                <option value="">全部</option>
                <option value="0">无</option>
                <option value="1">有</option>
            </select>&nbsp;&nbsp;&nbsp;
            <label>来源：</label>
            <select class="chosen-select form-control" id="sourceType">
                <option value="">全部</option>
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
                        说明书列表
                        <div class="pull-right tableTools-container"></div>

                    </div>

                    <!-- div.table-responsive -->

                    <!-- div.dataTables_borderWrap -->
                    <div>
                        <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                            <thead>
                            <tr>
                                <th style="text-align: center">序号</th>
                                <th style="text-align: center">药品名称</th>
                                <th style="text-align: center">类别</th>
                                <th style="text-align: center">对应通用名</th>
                                <th style="text-align: center">剂型</th>
                                <%--4--%>
                                <th style="text-align: center;width:45px;">说明书</th>
                                <th style="text-align: center">来源</th>
                                <th style="text-align: center">厂家</th>
                                <th style="text-align: center">批准文号</th>
                                <th style="text-align: center;width:80px">更新时间</th>
                                <%--9--%>
                                <th style="text-align: center;width:60px;">创建人</th>
                                <th style="text-align: center;width:60px;">维护人</th>
                                <th style="text-align: center;width:75px;">修改/删除</th>
                            </tr>
                            </thead>

                        </table>
                    </div>
                </div>
            </div>


            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->
    <div id="dialog-edit" class="hide" data-options="iconCls:'icon-save',modal:true">
        <form class="form-horizontal" role="form" id="instructionForm">
            <input type="hidden" name="instructionID">
            <!-- PAGE CONTENT BEGINS -->
            <div class="container-fluid">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="col-sm-7 col-xs-7 no-padding no-margin">
                            <div class="row" style="margin-bottom: 3px;margin-top: 5px;">
                                <label class="col-sm-3 control-label no-padding-right " for="chnName"> 药品名称 </label>
                                <div class="col-sm-9">
                                    <input type="text" id="chnName" name="chnName" placeholder="药品名称" style="font-size: 9px;color: black ;" class="col-xs-10 col-sm-10"/>
                                </div>
                            </div>
                            <div class="row" style="margin-bottom: 3px;margin-top: 5px;">
                                <label class="col-sm-3 control-label no-padding-right " for="matchGeneralName">对应通用名</label>
                                <div class="col-sm-9">
                                    <input class="typeahead scrollable" type="text" id="matchGeneralName" name="matchGeneralName"
                                           autocomplete="off" style="font-size: 9px;color: black;width:250px;"
                                           placeholder="对应通用名"/>
                                    <input type="hidden" id="generalInstrID" name="generalInstrID"/>
                                </div>
                            </div>
                            <div class="form-group" style="margin-bottom: 3px;margin-top: 5px">
                                <label class="col-sm-3 control-label no-padding-right" for="producer"> 生产厂家 </label>
                                <div class="col-sm-9">
                                    <input type="text" id="producer" name="producer" placeholder="生产厂家" style="font-size: 9px;color: black ;" class="col-xs-10 col-sm-10"/>
                                </div>
                            </div>
                            <div class="form-group" style="margin-bottom: 3px;margin-top: 5px">
                                <label class="col-sm-3 control-label no-padding-right" for="sourceType2">来源</label>
                                <div class="col-sm-9">
                                    <select class="chosen-select form-control" id="sourceType2" style="font-size: 9px;color: black ;width:200px;" name="source">
                                    </select>
                                </div>
                            </div>
                        </div><!-- /.col -->

                        <div class="col-sm-5 col-xs-5 no-padding no-margin">
                            <div class="form-group" style="margin-bottom: 3px;margin-top: 5px">
                                <label class="col-sm-3 control-label no-padding-right" for="general">类别</label>
                                <div class="col-sm-9">
                                    <select class="chosen-select form-control" id="general" name="general" style="font-size: 9px;color: black ;">
                                        <option value="1">通用名</option>
                                        <option value="0">别名</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" style="margin-bottom: 3px;margin-top: 5px">
                                <label class="col-sm-3 control-label no-padding-right" for="divPinyin">拼音码</label>
                                <div class="col-sm-9" id="divPinyin">

                                </div>
                            </div>
                            <div class="form-group" style="margin-bottom: 3px;margin-top: 5px">
                                <label class="col-sm-3 control-label no-padding-right" for="dose">剂型</label>
                                <div class="col-sm-9">
                                    <select class="chosen-select form-control" id="dose" style="font-size: 9px;color: black ;" name="dose">
                                    </select>
                                </div>
                            </div>
                        </div>

                        <input type="hidden" id="instructionID" name="instructionID">
                    </div>
                    <div class="col-sm-12">
                        <div class="tabbable">
                            <ul class="nav nav-tabs" id="myTab2">
                                <li class="active"><a data-toggle="tab" href="#home1">说明书</a></li>
                                <li><a data-toggle="tab" href="#home2">同类药品</a></li>
                            </ul>
                        </div>

                        <div class="tab-content padding-4">
                            <div id="home1" class="tab-pane in active">
                                <div class="wysiwyg-editor" id="instruction" style="height: 240px"></div>
                            </div>

                            <div id="home2" class="tab-pane ">
                                <table id="similarTable" class="table table-striped table-bordered table-hover ">
                                    <%--  <thead>
                                      <tr>
                                          <th style="text-align: center"></th>
                                          <th style="text-align: center">药品名称</th>
                                          <th style="text-align: center">类别</th>
                                          <th style="text-align: center">剂型</th>
                                          <th style="text-align: center">说明书</th>
                                          <th style="text-align: center">厂家或来源</th>
                                      </tr>
                                      </thead>--%>
                                </table>

                                <!-- /section:custom/scrollbar.horizontal -->
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <div id="showInstructionDialog" class="modal fade" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header no-padding">
                    <div class="table-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                            <span class="white">&times;</span>
                        </button>
                        <span id="instruction-title">药品名称</span>
                    </div>
                </div>

                <div class="modal-body2" id="instruction-content"></div>

            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div>

    <div id="dialog-delete" class="hide">
        <div class="alert alert-info bigger-110">
            永久删除 <span id="instructionName" class="red"></span> ，不可恢复！
        </div>

        <div class="space-6"></div>

        <p class="bigger-110 bolder center grey">
            <i class="icon-hand-right blue bigger-120"></i>
            确认吗？
        </p>
    </div>
    <div id="dialog-error" class="hide alert" title="提示">
        <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
    </div>
</div>
<!-- /.page-content -->