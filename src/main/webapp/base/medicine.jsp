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
<script type="text/javascript" src="../components/jquery-easyui-1.9.4/jquery.easyui.min.js"></script>
<script type="text/javascript" src="../components/jquery-easyui-1.9.4/locale/easyui-lang-zh_CN.js"></script>

<!-- bootstrap & fontawesome -->

<link rel="stylesheet" href="../components/font-awesome/css/font-awesome.css"/>
<link rel="stylesheet" href="../components/chosen/chosen.min.css"/>
<link rel="stylesheet" type="text/css" href="../components/jquery-easyui-1.9.4/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="../components/jquery-easyui-1.9.4/themes/icon.css">
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
                //"iDisplayLength": 25,
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
                    },
                    {'targets': 4, 'searchable': false, 'orderable': false},
                    {'targets': 9, 'searchable': false, 'orderable': false, width: 60},
                    {
                        'targets': 15, 'searchable': false, 'orderable': false,
                        render: function (data, type, row, meta) {
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="hasDetail" href="#" data-Url="javascript:showMedicine(\'{0}\');">'.format(data) +
                                '<i class="ace-icon fa  fa-pencil-square-o green bigger-130"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasDetail" href="#" data-Url="javascript:showMatch(\'{0}\');">'.format(data) +
                                '<i class="ace-icon fa  fa-exchange orange bigger-130"></i>' +
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
                select: {style: 'single'}
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


        $('.btn-success').click(function () {
            if ($('#form-goodsNo').val() !== '') {
                myTable.ajax.url("/medicine/getMedicineList.jspa?goodsNo={0}&matchType={1}&type={2}"
                    .format($('#form-goodsNo').val(), $('#matchType').val(), $('#type').val())).load();
            } else {
                myTable.ajax.url("/medicine/getMedicineList.jspa?queryChnName={0}&matchType={1}&type={2}"
                    .format($('#form-medicine').val(), $('#matchType').val(), $('#type').val())).load();
            }
        });

        $('.btn-info').click(function () {
            $('#fromDate').datebox('setValue', moment().startOf('year').format("YYYY-MM-DD"));
            $('#toDate').datebox('setValue', moment().format("YYYY-MM-DD"));

            $("#dialog-applyData").removeClass('hide').dialog({
                resizable: false,
                modal: true,
                title: "套用药品资料更新数据",
                buttons: [{
                    text: '执行',
                    iconCls: 'ace-icon fa fa-bolt bigger-110',
                    handler: function () {
                        //todo 同一年判断
                        var param = {
                            taskType: 2,
                            timerMode: 2,
                            exeDateField: '',
                            exeTimeField: '',
                            timeFrom: $('#fromDate').datebox('getValue'),
                            timeTo: $('#toDate').datebox('getValue'),
                        };
                        //console.log("param:" + JSON.stringify(param));
                        $.ajax({
                            type: "POST",
                            url: "/monitor/submitTask.jspa",
                            data: param,
                            contentType: "application/x-www-form-urlencoded; charset=UTF-8", //https://www.cnblogs.com/yoyotl/p/5853206.html
                            cache: false,
                            success: function (response, textStatus) {
                                var msg = response.message;
                                if (response.succeed)
                                    msg += '<br/>可以在“导入任务”查看执行结果和耗时。';
                                $.messager.alert("执行结果", msg);

                                $('#dialog-applyData').dialog("close");
                            },
                            error: function (response, textStatus) {/*能够接收404,500等错误*/
                                $.messager.alert("请求状态码：" + response.status, response.responseText);
                            }
                        });
                    }
                }, {
                    text: '关闭',
                    iconCls: 'ace-icon fa fa-times bigger-130 red',
                    handler: function () {
                        $('#dialog-applyData').dialog('close');
                    }
                }],
                title_html: true
            });
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
                    $.getJSON('/drug/liveDrug.jspa', params, function (json) {
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


        function setRouteOption() {
            $.each(route, function (index, object) {
                $('#route').append("<option value='{0}'>{1}</option>".format(object.value, object.name));
            });
            //$("#route").trigger("chosen:updated");
        }

        $.getJSON("/common/dict/listDict.jspa?parentDictNo=00015", function (result) {
            $.each(result.data, function (index, object) {
                $('#injection').append("<option value='{0}'>{1}</option>".format(object.value, object.name));
            });
            //$("#injection").trigger("chosen:updated");
        });
        $.getJSON("/common/dict/listDict.jspa?parentDictNo=00017", function (result) {
            $.each(result.data, function (index, object) {
                $('#menstruum').append("<option value='{0}'>{1}</option>".format(object.value, object.name));
            });
            //$("#menstruum").trigger("chosen:updated");
        });
        $('#antiClass').on('change', function (e) {
            if ($(this).val() === "0") {
                /*  $('#ddd').val('');
                  $('#maxDay').val('');*/
                $('#ddd').attr("disabled", true);
                $('#maxDay').attr("disabled", true);
            } else {
                $('#ddd').removeAttr("disabled");
                $('#maxDay').removeAttr("disabled");
            }
        });
        $('#route').on('change', function (e) {
            /* console.log("e:" + JSON.stringify(e));
             console.log("val:" + $(this).val());
             console.log("params:" + JSON.stringify(params));*/
            if ($(this).val() === "2") {
                $('#injection').removeAttr("disabled");
                $('#menstruum').removeAttr("disabled");
            } else {
                $('#injection').val(0);
                $('#menstruum').val(0);
                $('#injection').attr("disabled", true);
                $('#menstruum').attr("disabled", true);
            }

            /*  if (params.selected === "2") {
                  console.log("add");

                  $('#injection').attr("disabled", false);
                  $('#menstruum').attr("disabled", false);
              }
              if (params.deselected === "2") {
                  console.log("delete");
                  $("#menstruum option:selected").each(function () {
                      $(this).removeAttr("selected");
                  });
                  $("#injection option:selected").each(function () {
                      $(this).removeAttr("selected");
                  });
                  $('#injection').attr("disabled", true);
                  $('#menstruum').attr("disabled", true);
              }*/
        });

        var medicineForm = $('#medicineForm');
        medicineForm.validate({
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
                console.log(medicineForm.serialize());// + "&productImage=" + av atar_ele.get(0).src);
                //console.log("form:" + form);
                $.ajax({
                    type: "POST",
                    url: "/medicine/saveMedicine.jspa",
                    data: medicineForm.serialize(),//+ "&productImage=" + av atar_ele.get(0).src,
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
        $.getJSON("/common/dict/listDict.jspa?parentID=2", function (result) {
            $.each(result.data, function (index, object) {
                $('#dose').append("<option value='{0}'>{1}</option>".format(object.name.trim(), object.name.trim()));
            });
        });

        function showMedicine(medicineID) {
            $.getJSON("/medicine/getMedicineList.jspa?medicineID=" + medicineID, function (ret) {
                var result = ret.aaData[0];
                $('#chnName').text(result.chnName);
                $('#goodsNo').text(result.no);
                $('#pinyin').text(result.pinyin);
                $('#spec').text(result.spec);
                $('#producer').text(result.producer === null ? "　" : result.producer);
                $('#dealer').text(result.dealer);
                $('#price').text(result.price);
                $('#insurance').text(renderInsurance(result.insurance));
                //console.log("dose:" + result.dose);
                //$("#dose option[text='口服液']").attr("selected", "selected");
                $('#dose').val(result.dose);
                $('#lastPurchaseTime').html(result.lastPurchaseTime == null ? "&nbsp;" : result.lastPurchaseTime);
                $('#generalName').html(result.generalName == null ? "&nbsp;" : result.generalName);
                $('#instructionName').html(result.instructionName == null ? "&nbsp;" : result.instructionName);

                $('#medicineID').val(medicineID);
                $('#contents').html((result.contents === null || result.contents === '') ? '&nbsp;' : result.contents);
                $('#ddd').val(result.ddd);
                $('#maxDay').val(result.maxDay);
                $('#antiClass').val(result.antiClass);
                $("input[name='base']").attr("checked", false);//清空选中
                $("input[name='base'][value='" + (result.base === 2 ? 2 : 0) + "']").attr("checked", true);
                $('#mental').val(result.mental);
                if (result.healthNo !== null) {
                    // console.log("healthNo非空！:" + result.healthNo);
                    $('#healthNo').combotree('setValue', result.healthNo);
                }
                $("input[name='isStat']").attr("checked", false);//清空选中
                $("input[name='isStat'][value='" + result.isStat + "']").attr("checked", true);

                $("#route option[value='" + result.route + "']").attr("selected", "selected");
                $("#injection option[value='" + result.injection + "']").attr("selected", "selected");
                $("#menstruum option[value='" + result.menstruum + "']").attr("selected", "selected");


                $("#dialog-edit").removeClass('hide').dialog({
                    resizable: false,
                    width: 780,
                    height: 570,
                    modal: true,
                    title: "药品资料",
                    buttons: [{
                        text: '保存',
                        iconCls: 'ace-icon fa fa-floppy-o bigger-110',
                        handler: function () {
                            if (medicineForm.valid())
                                medicineForm.submit();
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
            });
        }

        function showMatch(medicineID) {
            $.getJSON("/medicine/getMedicineList.jspa?medicineID=" + medicineID, function (ret) {
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
                    $.getJSON("/drug/liveDrug.jspa?drugID=" + result.matchDrugID, function (ret) {
                        //matchDrug = ret.data[0];
                        $('#liveDrug').val(ret.data[0].chnName);
                        chooseDrug(ret.data[0], result.instructionName);
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
                        iconCls: 'ace-icon fa fa-floppy-o bigger-110',
                        handler: function () {
                            if (matchDrug) {
                                var submitForm = {medicineID: medicineID, matchDrugID: matchDrug.drugID};

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
    });
</script>

<!-- #section:basics/content.breadcrumbs -->
<div class="breadcrumbs ace-save-state" id="breadcrumbs">
    <ul class="breadcrumb">
        <li>
            <i class="ace-icon fa fa-home home-icon"></i>
            <a href="/index.jspa?content=/admin/hello.html">首页</a>
        </li>
        <li class="active">本院药品</li>

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
            </button> &nbsp;&nbsp;&nbsp;
            <button type="button" class="btn btn-sm btn-info">
                套用
                <i class="ace-icon glyphicon glyphicon-asterisk icon-on-right bigger-100"></i>
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
    <div id="dialog-edit" class="hide" data-options="iconCls:'ace-icon fa fa-pencil-square-o green bigger-130',modal:true">
        <div class="col-xs-12" style="padding-top: 10px">
            <!-- PAGE CONTENT BEGINS -->
            <form class="form-horizontal" role="form" id="medicineForm">
                <div class="col-sm-4 no-padding">
                    <div class="row">
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
                    <div class="row">
                        <span style='font-size:12px;' class="grey">
                            <ul>说明： <li>药理分类、剂型、医保和中西药分类在统计分析时使用；</li>
                                        <li>拼音码是作为查询时自动完成；含量是计算抗菌素DDD值必须。DDD是成人限定日剂量。</li></ul></span>
                    </div>
                </div><!-- /.col -->

                <div class="col-xs-7" style="margin: 2px;">
                    <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                        <label class="col-sm-3 control-label no-padding-right" style="white-space: nowrap">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;剂型 </label>
                        <div class="col-sm-5">
                            <select class="form-control" id="dose" name="dose">
                            </select>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                        <label class="col-sm-3 control-label no-padding-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;基本药物 </label>
                        <div class="col-sm-4">
                            <div class="radio col-sm-6">
                                <label style="white-space: nowrap">
                                    <input name="base" type="radio" class="ace" value="2"/>
                                    <span class="lbl">国基</span>
                                </label>
                            </div>

                            <div class="radio col-sm-6">
                                <label style="white-space: nowrap">
                                    <input name="base" type="radio" class="ace" value="0"/>
                                    <span class="lbl">否</span>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                        <label class="col-sm-3 control-label no-padding-right" for="contents">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;含量 </label>
                        <%-- <div class="col-sm-2">
                             <div style="border-bottom: 1px solid; border-bottom-color: lightgrey" id="contents"></div>
                         </div>--%>
                        <div class="col-sm-6">
                            <input type="text" id="contents" name="contents" placeholder="含量" class="col-xs-10 col-sm-5"/>
                        </div>
                        <span class="help-inline col-sm-3 no-padding-left"><span class="left red">g</span></span>
                    </div>
                    <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                        <label class="col-sm-3 control-label no-padding-right" for="antiClass"> 抗菌药级别 </label>
                        <div class="col-sm-5">
                            <select class="form-control" id="antiClass" name="antiClass">
                                <option value="0">否</option>
                                <option value="1">非限制</option>
                                <option value="2">限制</option>
                                <option value="3">特殊</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                        <label class="col-sm-3 control-label no-padding-right " for="ddd"> DDD值 </label>
                        <div class="col-sm-9">
                            <input type="text" id="ddd" name="ddd" placeholder="DDD值" class="col-xs-10 col-sm-5"/>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                        <label class="col-sm-3 control-label no-padding-right " for="maxDay"> 最大用药天数 </label>
                        <div class="col-sm-9">
                            <input type="text" id="maxDay" name="maxDay" placeholder="最大用药天数" class="col-xs-10 col-sm-5"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="healthNo" class="col-sm-3 control-label no-padding-right">药理分类</label>
                        <div class="col-sm-9">
                            <input id="healthNo" name="healthNo" type="text" width="200" class="easyui-combotree" style="width:250px;"
                                   data-options="url:'/health/easyUITree.jspa?healthID=1', method: 'get'"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="route" class="col-sm-3 control-label no-padding-right">给药途径</label>
                        <div class="col-sm-9">
                            <div class="input-group">
                                <select class="form-control" id="route" data-placeholder="给药途径" name="route">
                                    <option value="0"></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="injection" class="col-sm-3 control-label no-padding-right">注射方法</label>
                        <div class="col-sm-9">
                            <div class="input-group">
                                <select class="form-control" id="injection" data-placeholder="注射方法" name="injection">
                                    <option value="0"></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="menstruum" class="col-sm-3 control-label no-padding-right">溶媒</label>
                        <div class="col-sm-9">
                            <div class="input-group">
                                <select class="form-control" id="menstruum" data-placeholder="溶媒" name="menstruum">
                                    <option value="0"></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 3px;margin-top: 3px">
                        <label class="col-sm-3 control-label no-padding-right " for="mental"> 特殊分类 </label>
                        <div class="col-sm-5">
                            <select class="form-control" id="mental" name="mental">
                                <option value="0">无</option>
                                <option value="1">精神药品</option>
                                <option value="4">麻醉药品</option>
                                <option value="8">糖皮质激素</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right "> 统计品种 </label>
                        <div class="col-sm-4">
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
                        <span class="help-inline col-sm-5 grey no-padding">不累计抗菌药的DDDs</span>
                    </div>
                </div>
                <input type="hidden" id="medicineID" name="medicineID">
            </form>
        </div>
    </div>
    <div id="dialog-match" class="hide" style="font-family:'宋体'" data-options="iconCls:'ace-icon fa  fa-exchange bigger-130',modal:true">
        <form class="form-horizontal " role="form" id="matchForm">
            <div class="col-xs-12 col-sm-12" style="padding-top: 10px">
                <!-- PAGE CONTENT BEGINS -->
                <div class="col-sm-6 col-xs-6 ">
                    <div class="row">

                        <label class="col-sm-3" style="white-space: nowrap">药品名称 </label>
                        <div class="col-sm-8 no-padding" id="chnName2" style="border-bottom: 1px solid; border-bottom-color: lightgrey;font-size:  large"></div>
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
                            <input type="hidden" id="drugID" name="drugID"/>
                        </div>
                        <div class="col-sm-1 no-padding"><span class="middle red bigger-160">①</span></div>
                    </div>
                    <div class="row">
                        <label class="col-sm-3" style="white-space: nowrap"></label>
                        <div class="col-sm-8 no-padding hide " style="border-bottom: 1px solid; border-bottom-color: lightgrey;margin-bottom: 10px;" id="antiClass_DDD"></div>
                    </div>
                    <div class="row" style="margin-top: 10px;">
                        <label class="col-sm-3" style="white-space: nowrap ;">&nbsp;</label>
                        <label>
                            <input id="ckbox1" type="checkbox" class="ace" checked>
                            <span class="lbl">配对后，药理分类、抗菌药级别<br/>和DDD值将修改与通用名一致</span>
                        </label>
                    </div>
                    <div class="row">
                        <label class="col-sm-12" style="white-space: nowrap">提示：<br/>
                            ①先输入通用名；<br/>
                            ②选择后通用名后再选说明书。</label>
                    </div>
                </div>
                <div class="col-sm-6 col-xs-6">
                    <div class="row">
                        <label class="col-sm-3 control-label " style="white-space: nowrap " for="chooseInstruction"> 药品说明书 </label>
                        <div class="col-sm-7 no-padding">
                            <select class="form-control" id="chooseInstruction" name="chooseInstruction">
                            </select>
                        </div>
                        <div class="col-sm-1"><span class="help-inline"><span class="middle red bigger-160">②</span></span></div>
                    </div>
                    <div class="row" style="margin-top: 10px">
                        <div class="tabbable" style="margin-left: 20px">
                            <ul class="nav nav-tabs" id="myTab4">
                                <li class="active">
                                    <a data-toggle="tab" href="#instructionContent">说明书内容</a>
                                </li>

                            </ul>

                            <div class="tab-content" style="height: 360px">
                                <div id="instructionContent" class="tab-pane in active" style="position:absolute; height:340px; overflow:auto">

                                </div>

                            </div>
                        </div>
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