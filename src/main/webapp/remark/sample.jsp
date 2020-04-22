<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script src="../components/datatables/jquery.dataTables.min.js"></script>
<script src="../components/datatables/jquery.dataTables.bootstrap.min.js"></script>
<script src="../components/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="../components/datatables/dataTables.select.min.js"></script>
<%--<script src="../assets/js/ace.js"></script>--%>
<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>
<%--<script src="../assets/js/jquery.gritter.min.js"></script>--%>
<script src="../js/accounting.min.js"></script>
<script src="../js/jquery.cookie.min.js"></script>
<script src="../assets/js/jquery.validate.min.js"></script>
<script src="../components/monthpicker/MonthPicker.js"></script>
<script src="../components/moment/moment.min.js"></script>
<script src="../components/bootstrap-daterangepicker/daterangepicker.js"></script>
<script src="../components/bootstrap-daterangepicker/daterangepicker.zh-CN.js"></script>
<script src="../components/typeahead.js/dist/typeahead.bundle.min.js"></script>
<script src="../components/typeahead.js/handlebars.js"></script>
<link rel="stylesheet" href="../components/bootstrap-daterangepicker/daterangepicker.css"/>


<!-- bootstrap & fontawesome -->

<link rel="stylesheet" href="../components/monthpicker/MonthPicker.css"/>
<style>
    .month-year-input {
        width: 80px;
        margin-right: 2px;
    }
</style>
<script type="text/javascript">
    jQuery(function ($) {
        var samleBatch;
        var currentAjax;
        //var editor = new $.fn.dataTable.Editor({});
        //initiate dataTables plugin
        var dynamicTable = $('#dynamic-table');
        var myTable = dynamicTable
        //.wrap("<div class='dataTables_borderWrap' />")  //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                "columns": [
                    {"data": "sampleBatchID"},
                    /*{"data": "remarkType", "sClass": "center"},*/
                    {"data": "name", "sClass": "center"},
                    {"data": "year", "sClass": "center"},
                    {"data": "month", "sClass": "center"},
                    {"data": "num", "sClass": "center"},
                    {"data": "type", "sClass": "center"},
                    {"data": "surgery", "sClass": "center"},
                    {"data": "remarkType", "sClass": "center"},
                    {"data": "doctor", "sClass": "center"},
                    {"data": "createDate", "sClass": "center"},
                    {"data": "sampleBatchID"}
                ],
                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {"orderable": false, "targets": 1, title: '批次名称'},
                    {"orderable": false, "targets": 2, title: '年份'},
                    {"orderable": false, "targets": 3, title: '月份'},
                    {"orderable": false, "targets": 4, title: '样本数量'},
                    {
                        "orderable": false, "targets": 5, title: '类型', render: function (data, type, row, meta) {
                            return data === 1 ? "门诊" : "住院";
                        }
                    }, {
                        "orderable": false, "targets": 6, title: '手术', render: function (data, type, row, meta) {
                            if (row['type'] === 1) return "";
                            return data === 1 ? "仅手术" : "全部";
                        }
                    },
                    {
                        "orderable": false, "targets": 7, title: '点评类型', render: function (data, type, row, meta) {
                            if (row['type'] === 1) return "";
                            return data === 0 ? "医嘱点评" : "抗菌药调查";
                        }
                    },
                    {"orderable": false, "targets": 8, title: '医生'},
                    {"orderable": false, "targets": 9, title: '抽样日期', width: 130},
                    {
                        'targets': 10, 'searchable': false, 'orderable': false, width: 80, title: '点评/删除',
                        render: function (data, type, row, meta) {
                            var jsp = row['type'] === 1 ? "clinic_list.jsp" : "inpatient_list.jsp";
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="hasDetail green" href="#" data-Url="/index.jspa?content=/remark/{2}&sampleBatchID={0}&remarkType={1}&menuID=14&batchName={3}">'.format(data, row["remarkType"], jsp, encodeURI(encodeURI(row["name"]))) +
                                '<i class="ace-icon fa fa-chain bigger-110"></i>' +
                                '</a>&nbsp;&nbsp;&nbsp;' +
                                '<a class="hasDetail" href="#" data-Url="javascript:deleteBatch({0},\'{1}\');">'.format(data, row["name"]) +
                                '<i class="ace-icon fa fa-trash-o red bigger-110"></i>' +
                                '</a>' +
                                '</div>';
                        }
                    }],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                "ajax": {
                    url: "/remark/listSamples.jspa",
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0) //以columns开头的参数删除 || key.indexOf("search") === 0
                                delete d[key];
                    }
                },

                // "processing": true,
                "serverSide": true,
                select: {
                    style: 'single'
                },
                buttons: [{extend: "create"}]
            });
        /*  myTable.on('order.dt search.dt', function () {
              myTable.column(0, {search: 'applied', order: 'applied'}).nodes().each(function (cell, i) {
                  cell.innerHTML = i + 1;
              });
          }).draw();*/
        myTable.on('draw', function () {
            $('#dynamic-table tr').find('.hasDetail').click(function () {
                if ($(this).attr("data-Url").indexOf('javascript:') >= 0) {
                    eval($(this).attr("data-Url"));
                } else
                    window.open($(this).attr("data-Url"), "_blank");
            });
        });

        function deleteBatch(batchID, batchName) {
            if (batchID === undefined) return;
            $('#sampleName').text(batchName);
            $("#dialog-delete").removeClass('hide').dialog({
                resizable: false,
                modal: true,
                title: "确认删除抽样",
                //title_html: true,
                buttons: [
                    {
                        html: "<i class='ace-icon fa fa-trash bigger-110'></i>&nbsp;确定",
                        "class": "btn btn-danger btn-minier",
                        click: function () {

                            $.ajax({
                                type: "POST",
                                url: "/remark/deleteSampleBatch.jspa?batchID=" + batchID,
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

        var sampleForm = $('#sampleForm');
        sampleForm.validate({
            errorElement: 'div',
            errorClass: 'help-block',
            focusInvalid: false,
            ignore: "",
            rules: {
                name: {required: true},
                num: {required: true, digits: true}
            },

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
                var surgery = sampleForm.find("input[name='form-field-surgery']").is(':checked');//=1
                //console.log(sampleForm.serialize());
                //console.log(form);//整个form的html
                var incision = 0;
                sampleForm.find("input[name='form-field-incision']:checked").each(function () {
                    incision += parseInt($(this).val());
                });
                var clinicType = 0;
                sampleForm.find("input[name='form-field-clinicType']:checked").each(function () {
                    clinicType += parseInt($(this).val());
                });

                var dates = $('#form-dateRange').val().split("～");
                var fromDay = moment(dates[0]);
                var toDay = moment(dates[1]);
                //toDay.add(1, 'd');

                var sampleBatch = {
                    type: $('#form-type').children('option:selected').val(),
                    remarkType: $('#form-remarkType').children('option:selected').val(),
                    //remarkType: $("input[name='form-field-remarkType']:checked").val(),
                    sampleType: $("input[name='form-field-algorithm']:checked").val(),
                    doctorID: $('#form-doctorID').val(),//显示
                    doctor: $('#form-doctor').val(),//存数据库
                    goodsID: $('#form-goodsID').val(),//存数据库
                    //medicine: $('#form-medicine').val(),//显示
                    surgery: surgery ? 1 : 0,
                    outPatientNum: $('#form-outPatientNum').val(),
                    total: $('#form-total').val(),
                    incision: incision,
                    clinicType: clinicType,
                    fromDate: fromDay.format("YYYY年MM月DD日"),
                    toDate: toDay.format("YYYY年MM月DD日"),
                    year: toDay.year(),
                    month: toDay.month(),
                    department: departmentE.get(0).selectedIndex > 0 ? departmentE.children('option:selected').val() : "",
                    western: $('#form-western').children('option:selected').val(),
                    name: $('#form-name').val(),
                    num: $('#form-number').val()
                };
                console.log("data:" + JSON.stringify(sampleBatch));
                $.ajax({
                    type: "POST",
                    url: "/remark/newSampling.jspa",
                    data: JSON.stringify(sampleBatch),
                    contentType: "application/json; charset=utf-8",
                    cache: false,
                    success: function (response, textStatus) {
                        /* console.log(textStatus);//内容是success
                         console.log(res);*/
                        //$("#dialog-edit").dialog("close");

                        if (!response.succeed) {
                            //console.log("res.succeed:" + res.succeed);
                            showDialog(response.resultTitle, response.resultData);
                        } else {
                            //console.log("res.succeed:" + response.succeed);
                            samleBatch = response;
                            showSampleResult(response);
                        }
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        showDialog("请求状态码：" + response.status, response.responseText);
                    },
                    // async: false, //同步请求，默认情况下是异步（true）
                    beforeSend: function () {
                        //console.log("beforeSend？");
                        // 禁用按钮防止重复提交                       //$("#submit").attr({ disabled: "disabled" });
                        if (currentAjax) currentAjax.abort();
                        //$("#dialog-edit").dialog("close");
                        /*$('#dialog-loading').text('正在抽样，请稍等！');
                        $("#dialog-loading").removeClass('hide').dialog({modal: true, width: 600, title: '操作提示'});*/
                        //显示
                        $("#loadingModal").modal({backdrop: 'static', keyboard: false});
                        $("#loadingModal").modal('show');
                    },
                    complete: function () {
                        //$("#submit").removeAttr("disabled");
                        //$('#dialog-loading').dialog("close");
                        $("#loadingModal").modal('hide');
                    },
                });
            },
            invalidHandler: function (form) {
                console.log("invalidHandler");
            }
        });
        /*https://www.gyrocode.com/articles/jquery-datatables-checkboxes/*/

        //$.fn.dataTable.Buttons.swfPath = "components/datatables.net-buttons-swf/index.swf"; //in Ace demo ../components will be replaced by correct assets path
        $.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';

        new $.fn.dataTable.Buttons(myTable, {
            buttons: [
                {
                    "text": "<i class='fa fa-calendar-plus-o red'></i>新抽样 ",
                    "className": "btn btn-xs btn-white btn-primary"
                }
            ]
        });
        myTable.buttons().container().appendTo($('.tableTools-container'));


        //$.gritter.options.class_name = 'gritter-center';

        var departmentE = $('#form-department');

        function loadDepartment(type) {
            departmentE.empty();
            //if ($("#form-department option").length === 0)
            $.getJSON("/common/dict/listDict.jspa?parentID=108&value={0}".format(type === '1' ? '门诊科室' : '住院科室'), function (result) {
                if (result.iTotalRecords > 0) {
                    $("#form-department option:gt(0)").remove();
                    $.each(result.data, function (n, value) {
                        departmentE.append('<option value="{0}">{1}</option>'.format(value.name, value.name));
                    });
                    departmentE.val("");
                }
            });
        }


        var doctorBloodHound = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.obj.whitespace('doctorID'),
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            // 在文本框输入字符时才发起请求
            remote: {url: "/remark/liveDoctor.jspa?pinyin=%QUERY", wildcard: '%QUERY'}
        });

        doctorBloodHound.initialize();

        //https://blog.haohtml.com/archives/17456
        $('#form-doctor').typeahead({hint: true},
            {
                //name: 'result-list',
                limit: 100,
                source: doctorBloodHound.ttAdapter(),
                display: function (item) {
                    return item.name
                },
                /* template: ['<p class="repo-language">{{item.doctorID}}</p>',
                   '<p class="repo-name">{{item.name}}</p>'
                 ].join('')*/
                templates: {
                    suggestion: function (item) {
                        /*  return ['<p class="repo-language">', item.name, '</p>',
                            '<p class="repo-name">', item.doctorID, '</p>'
                          ].join('');*/
                        return '<p><strong>' + item.name + '</strong> - <span class="light-grey">' + item.title + '</span></p>';
                    },

                    notFound: '<div class="red">没匹配</div>'
                    /*, header: '<h3 class="tt-suggestion-title">可使用键盘↑↓选择。  </h3>'*/
                    // footer: '<h3>支持剪头移动选择项</h3>'
                }
            }
        );
        $('#form-doctor').bind('typeahead:select', function (ev, suggestion) {
            // console.log("doctorID:" + suggestion.doctorID);
            $('#form-doctorID').val(suggestion.doctorID);
        });
        $('#form-medicine').bind('typeahead:select', function (ev, suggestion) {
            //console.log('goodsID: ' + suggestion.goodsID);
            $('#form-goodsID').val(suggestion.goodsID);
        });
        $('#form-medicine').keydown(function (event) {
            if (event.which === 8)
                $('#form-goodsID').val('');

        });
        $('#form-doctor').keydown(function (event) {
            if (event.which === 8)
                $('#form-doctorID').val('');
        });
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


        $('#form-dateRange').daterangepicker({
            'applyClass': 'btn-sm btn-success',
            'cancelClass': 'btn-sm btn-default',
            startDate: moment().subtract(30, 'd'),
            endDate: moment(),
            ranges: {
                '本月': [moment().startOf('month')],
                '上月': [moment().month(moment().month() - 1).startOf('month'), moment().month(moment().month() - 1).endOf('month')],
                '本季': [moment().startOf('quarter')],
                '上季': [moment().quarter(moment().quarter() - 1).startOf('month'), moment().quarter(moment().quarter() - 1).endOf('quarter')],
                '今年': [moment().startOf('year')],
                '去年': [moment().year(moment().year() - 1).startOf('year'), moment().year(moment().year() - 1).endOf('year')]
            },
            locale: locale
        }).next().on(ace.click_event, function () {
            $(this).prev().focus();
        });

        function showSampleDialog() {
            loadDepartment('2');
            sampleForm.find("input[name='form-field-incision']").attr("disabled", true);
            $("#dialog-edit").removeClass('hide').dialog({
                resizable: false,
                width: 760,
                height: 530,
                modal: true,
                title: "新抽样",
                title_html: true,

                buttons: [
                    {
                        html: "<i class='ace-icon fa fa-play-circle-o bigger-110'></i>&nbsp;开始",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            //todo 直接从#form-closingTime获取时间的毫秒值!
                            if (sampleForm.valid()) {
                                sampleForm.submit();
                                $(this).dialog("close");
                            }
                            //$(this).dialog("close");
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
        }

        function showSampleResult(result) {
            if (result.sampleBatch.type === 2)
                $('#dynamic-table2').DataTable({
                    // bAutoWidth: false,
                    paging: false,
                    searching: false,

                    ordering: false,
                    "destroy": true,
                    "columns": [
                        {"data": "inPatientID"},
                        {"data": "hospID", "sClass": "center"},
                        {"data": "inDate", "sClass": "center"},
                        {"data": "outDate", "sClass": "center"},
                        {"data": "inHospitalDay", "sClass": "center"},
                        {"data": "patientName", "sClass": "center"},
                        {"data": "age", "sClass": "center"},
                        {"data": "diagnosis2", "sClass": "center"},
                        {"data": "masterDoctorName", "sClass": "center"}
                    ],

                    'columnDefs': [
                        {
                            "orderable": false, "targets": 0, width: 15, render: function (data, type, row, meta) {
                                return meta.row + 1 + meta.settings._iDisplayStart;
                            }
                        },
                        {"orderable": false, "targets": 1, title: '住院号'},
                        {"orderable": false, "targets": 2, title: '入院日期', width: 130},
                        {"orderable": false, "targets": 3, title: '出院日期', width: 130},
                        {"orderable": false, "targets": 4, title: '住院天数'},
                        {"orderable": false, "targets": 5, title: '病人姓名'},
                        {"orderable": false, "targets": 6, title: '年龄'},
                        {"orderable": false, "targets": 7, title: '出院诊断', width: 250},
                        {"orderable": false, "targets": 8, title: '主管医生'}],
                    "aaSorting": [],
                    language: {
                        url: '../components/datatables/datatables.chinese.json'
                    },
                    "ajax": {
                        url: "/remark/getSamplingList.jspa?type=" + result.sampleBatch.type + "&ids=" + result.sampleBatch.ids,
                        "data": function (d) {//删除多余请求参数
                            for (var key in d)
                                if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                    delete d[key];
                        }
                    }
                });
            else
                $('#dynamic-table2').DataTable({
                    // bAutoWidth: false,
                    paging: false,
                    searching: false,

                    ordering: false,
                    "destroy": true,
                    "columns": [
                        {"data": "rxID"},
                        {"data": "clinicDate", "sClass": "center"},
                        {"data": "hospID", "sClass": "center"},
                        {"data": "patientName", "sClass": "center"},
                        {"data": "age", "sClass": "center"},
                        {"data": "drugNum", "sClass": "center"},
                        {"data": "antibiosis", "sClass": "center", "defaultContent": "0"},
                        {"data": "money", "sClass": "center"},
                        {"data": "doctorName", "sClass": "center"}
                    ],

                    'columnDefs': [
                        {
                            "orderable": false, "targets": 0, width: 15, render: function (data, type, row, meta) {
                                return meta.row + 1 + meta.settings._iDisplayStart;
                            }
                        },
                        {"orderable": false, "targets": 1, title: '处方日期', width: 130},
                        {"orderable": false, "targets": 2, title: '门诊号'},
                        {"orderable": false, "targets": 3, title: '病人'},
                        {"orderable": false, "targets": 4, title: '年龄'},
                        {"orderable": false, "targets": 5, title: '药品品种数'},
                        {
                            "orderable": false, "targets": 6, title: '抗菌素', render: function (data, type, row, meta) {
                                return data === 1 ? "有" : "无";
                            }
                        },
                        {"orderable": false, "targets": 7, title: '金额'},
                        {"orderable": false, "targets": 8, title: '医生'}],
                    "aaSorting": [],
                    language: {
                        url: '../components/datatables/datatables.chinese.json'
                    },
                    "ajax": {
                        url: "/remark/getSamplingList.jspa?type=" + result.sampleBatch.type + "&ids=" + result.sampleBatch.ids,
                        "data": function (d) {//删除多余请求参数
                            for (var key in d)
                                if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                    delete d[key];
                        }
                    }
                });
            $("#dialog-sample_list").removeClass('hide').dialog({
                resizable: false,
                width: 1000,
                height: 600,
                modal: true,
                title: "批次名称：" + result.sampleBatch.name + " - 抽样结果",
                title_html: true,
                buttons: [
                    {
                        html: "<i class='ace-icon fa fa-pencil-square-o bigger-110'></i>&nbsp;保存",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            $.ajax({
                                type: "POST",
                                url: "/remark/saveSampling.jspa",
                                data: JSON.stringify(result.sampleBatch),
                                contentType: "application/json; charset=utf-8",
                                cache: false,
                                success: function (response, textStatus) {
                                    /* console.log(textStatus);//内容是success
                                     console.log(response);*/
                                    //$("#dialog-edit").dialog("close");
                                    if (!response.succeed) { //失败
                                        showDialog(response.resultTitle, response.resultData);
                                    } else {//成功
                                        $("#dialog-sample_list").dialog("close");
                                        myTable.ajax.reload();
                                    }
                                },
                                error: function (response, textStatus) {/*能够接收404,500等错误*/
                                    showDialog("请求状态码：" + response.status, response.responseText);
                                },

                            });
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
        }

        $("#form-quantity,#form-amount").keyup(function (e) {
            /* $("#form-amount").css("background-color", "#FFFFCC");
             $("#form-quantity").css("background-color", "#FFFFCC");*/
            var quantity = $("#form-quantity").val();
            var amount = $("#form-amount").val();
            if (!isNaN(quantity) && quantity > 0 && !isNaN(amount))
                $("#form-price").val(accounting.formatMoney(amount / quantity, '￥'));
            else
                $("#form-price").val(0);
        });
        myTable.button(0).action(function (e, dt, button, config) {
            e.preventDefault();
            showSampleDialog(null);
        });
        sampleForm.find("#form-type").change(function () {
            loadDepartment(sampleForm.find('#form-type').children('option:selected').val());
        });
        //设置批次名称
        sampleForm.find("#form-department,#form-doctor,#form-medicine,#form-dateRange").change(function () {
            /*var batchName = $('#form-type').children('option:selected').val() === "1" ? "门诊" : "住院";*/
            var batchName = "";
            if (departmentE.get(0).selectedIndex > 0)
                batchName = departmentE.children('option:selected').val();
            if ($('#form-doctor').val() !== '')
                batchName += (batchName === "" ? "" : "-") + $('#form-doctor').val();
            if ($('#form-medicine').val() !== '')
                batchName += (batchName === "" ? "" : "-") + $('#form-medicine').val();
            //console.log("medicine:" + $('#form-medicine').val());

            $('#form-name').val(batchName + '：' + $('#form-dateRange').val());
        });
        //计算符合条件的数量
        sampleForm.find("#form-type,#form-department,#form-doctor,#form-western,#form-medicine,input[type=checkbox],#form-dateRange").change(function () {//[name!='form-field-surgery']
            var p1 = sampleForm.find('#form-type').children('option:selected').val();//这就是selected的值 门诊为1,住院未2
            /*console.log("p2:" + p1);*/
            if (p1 === '1') {
                $(".clinicType").removeClass("light-grey");
                $(".surgeryTypeLbl").addClass("light-grey");
            } else {
                $(".clinicType").addClass("light-grey");
                $(".surgeryTypeLbl").removeClass("light-grey");
            }
            $("input[name='form-field-clinicType']").attr('disabled', p1 === "2");
            $("input[name='form-field-surgery']").attr('disabled', p1 === "1");
            $("#form-remarkType").attr('disabled', p1 === "1");
            var surgery = p1 === '2' && sampleForm.find("input[name='form-field-surgery']").is(':checked');
            if (surgery) {
                $(".surgeryItem").removeClass("light-grey");
            } else {
                $(".surgeryItem").addClass("light-grey");
            }
            sampleForm.find("input[name='form-field-incision']").attr("disabled", !surgery);

            var incision = 0;
            sampleForm.find("input[name='form-field-incision']:checked").each(function () {
                incision += parseInt($(this).val());
            });
            var clinicType = 0;
            sampleForm.find("input[name='form-field-clinicType']:checked").each(function () {
                clinicType += parseInt($(this).val());
            });

            var params = {
                type: p1,
                doctorID: $('#form-doctorID').val(),
                goodsID: $('#form-goodsID').val(),
                surgery: surgery ? 1 : 0,
                incision: incision,
                clinicType: clinicType,
                dateRange: $('#form-dateRange').val(),
                department: departmentE.children('option:selected').val(),
                western: $('#form-western').children('option:selected').val(),
                draw: Math.random()
            };

            if (currentAjax) currentAjax.abort();

            $('.icon_total').addClass("ace-icon fa fa-spinner fa-spin fa-3x fa-fw");//动画
            $('#form-total').val("");
            currentAjax = $.getJSON("/remark/getObjectCount.jspa", params, function (result) {
                $('#form-total').val(result.count);
                $('#form-outPatientNum').val(result.outPatientNum);
                $('.icon_total').removeClass("ace-icon fa fa-spinner fa-spin fa-3x fa-fw");
            });
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

        $('#PastDateDemo').MonthPicker({MaxMonth: 0, MonthFormat: 'yy-mm', Button: false});
        $('.btn-success').click(function () {
            var mm = moment($('#PastDateDemo').val(), "YYYY-MM");
            if (mm.isValid()) {
                url = "/remark/listSamples.jspa?month=" + (mm.month() + 1) + '&year=' + mm.year();
                myTable.ajax.url(url).load();
            } else
                myTable.ajax.url("/remark/listSamples.jspa").load();
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
        <li class="active">抽样点评</li>

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
            <label>月份 ：</label>
            <input id="PastDateDemo" type="text" class="month-year-input nav-search-input">

            <button type="button" class="btn btn-sm btn-success">
                查询
                <i class="ace-icon glyphicon glyphicon-search icon-on-right bigger-110"></i>
            </button>

        </form>
    </div><!-- /.page-header -->

    <div class="row">
        <div class="col-xs-12">

            <div class="row">

                <div class="col-xs-12">
                    <div class="table-header">
                        抽样 "全部列表"
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
    <div class="modal fade" id="loadingModal">
        <div style="width: 200px;height:20px; z-index: 20000; position: absolute; text-align: center; left: 50%; top: 50%;margin-left:-100px;margin-top:-10px">
            <div class="progress progress-striped active" style="margin-bottom: 0;">
                <div class="progress-bar" style="width: 100%;" id="loadingText">正在抽样……</div>
            </div>
        </div>
    </div>
    <div id="dialog-loading" class="hide info" title="提示">
        <p id="infoText" class="ace-icon fa fa-spinner fa-spin fa-3x fa-fw">请稍后……</p>
    </div>

    <div id="dialog-delete" class="hide">
        <div class="alert alert-info bigger-110">
            永久删除 <span id="sampleName" class="red"></span> ，不可恢复！
        </div>

        <div class="space-6"></div>

        <p class="bigger-110 bolder center grey">
            <i class="icon-hand-right blue bigger-120"></i>
            确认吗？
        </p>
    </div>
    <div id="dialog-sample_list" class="hide dialogs">
        <div class="col-xs-12 col-md-12 col-sm-12 col-lg-12">
            <%--<div class="table-header col-xs-12">
                抽样结果
                <div class="pull-right tableTools-container"></div>
            </div>--%>

            <!-- div.table-responsive -->

            <!-- div.dataTables_borderWrap -->
            <table id="dynamic-table2" class="table table-bordered table-hover" style="width: 100%;">
            </table>
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div>
    <div id="dialog-edit" class="hide">
        <form class="form-horizontal" role="form" id="sampleForm">
            <div class="col-xs-12">
                <div class="col-xs-5">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-type">门诊住院 </label>

                        <div class="col-sm-9">
                            <select id="form-type" data-placeholder="门诊住院">
                                <option value="1">门诊</option>
                                <option value="2" selected>住院</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right surgeryTypeLbl"
                               for="form-remarkType">抽样类型 </label>

                        <div class="col-sm-9">
                            <select id="form-remarkType" data-placeholder="抽样类型">
                                <option value="0" selected>医嘱点评</option>
                                <option value="1">抗菌药物调查</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xs-12">
                <div class="col-xs-5">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-department">科室 </label>

                        <div class="col-sm-9">
                            <select id="form-department" data-placeholder="选择科室"></select>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-doctor">医生 </label>

                        <div class="col-sm-9">
                            <div class="input-group">
                                <input class="typeahead scrollable" type="text" id="form-doctor" name="form-doctor"
                                       autocomplete="off"
                                       placeholder="医生拼音字母 匹配鼠标选择"/>
                                <input type="hidden" id="form-doctorID"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xs-12">
                <div class="col-xs-5">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-western">中西药 </label>

                        <div class="col-sm-9">
                            <select id="form-western">
                                <option value="0" selected>不限</option>
                                <option value="1">西药</option>
                                <option value="2">中草药</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-medicine">药品名称 </label>

                        <div class="col-sm-9">
                            <input class="typeahead scrollable" type="text" id="form-medicine" name="form-medicine"
                                   autocomplete="off" style="width: 250px;font-size: 9px;color: black"
                                   placeholder="药品拼音首字母 匹配鼠标选择"/><input type="hidden" id="form-goodsID"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xs-12">
                <div class="col-xs-5">
                    <div class="form-group">
                        <div class="control-group">
                            <label class="col-sm-3 control-label no-padding-right surgeryTypeLbl">手术</label>
                            <div class="checkbox col-sm-4">
                                <label>
                                    <input name="form-field-surgery" type="checkbox" class="ace" value="1"/>
                                    <span class="lbl surgeryTypeLbl">是</span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6">
                    <div class="form-group">
                        <div class="control-group">
                            <label class="col-sm-3 control-label no-padding-right surgeryItem">手术类型</label>
                            <div class="checkbox col-sm-3">
                                <label>
                                    <input name="form-field-incision" type="checkbox" class="ace" value="1"/>
                                    <span class="lbl no-padding-right surgeryItem">Ⅰ类</span>
                                </label>
                            </div>

                            <div class="checkbox col-sm-3">
                                <label>
                                    <input name="form-field-incision" type="checkbox" class="ace" value="2"/>
                                    <span class="lbl no-padding-right surgeryItem">Ⅱ类</span>
                                </label>
                            </div>

                            <div class="checkbox col-sm-3">
                                <label>
                                    <input name="form-field-incision" type="checkbox" class="ace" value="4"/>
                                    <span class="lbl no-padding-right surgeryItem">Ⅲ类</span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div class="col-xs-12">
                <div class="col-xs-5">


                    <div class="form-group">
                        <div class="control-group">
                            <label class="col-sm-3 control-label no-padding-right light-grey clinicType">处方类型 </label>
                            <div class="checkbox col-sm-4">
                                <label>
                                    <input name="form-field-clinicType" checked disabled type="checkbox" class="ace"
                                           value="1"/>
                                    <span class="lbl light-grey clinicType">普通</span>
                                </label>
                            </div>

                            <div class="checkbox col-sm-4">
                                <label>
                                    <input name="form-field-clinicType" checked disabled type="checkbox" class="ace"
                                           value="2"/>
                                    <span class="lbl light-grey clinicType">急诊</span>
                                </label>
                            </div>
                        </div>
                    </div>


                </div>
                <div class="col-xs-6">


                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-dateRange">时间范围</label>
                        <div class="col-sm-9">
                            <!-- #section:plugins/date-time.datepicker -->
                            <div class="input-group">
                                <input class="form-control col-xs-10 col-sm-12" name="dateRangeString"
                                       id="form-dateRange"
                                       data-date-format="YYYY-MM-DD"/>
                                <span class="input-group-addon"><i class="fa fa-calendar bigger-110"></i></span>
                            </div>
                        </div>
                    </div>


                </div>
            </div>
            <div class="col-xs-12 panel panel-primary widget-color-orange no-padding" style="margin-top: 5px">

                <div class="col-xs-5 col-md-5 " style="padding-top:10px">
                    <div class="form-group">
                        <label class="col-sm-4 control-label no-padding-right">总体数量</label>
                        <div class="col-sm-5">
                            <span class="input-icon input-icon-right">
                                <input type="text" id="form-total" readonly name="form-total" autocomplete="off"
                                       class="col-sm-10"/>
                                <i class="icon_total"></i>
                                <input type="hidden" id="form-outPatientNum">
                            </span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label no-padding-right" for="form-number">抽样数量 </label>

                        <div class="col-sm-5">
                            <input type="text" id="form-number" name="num" autocomplete="off" class="col-sm-10"/>
                        </div>
                    </div>
                </div>

                <div class="col-xs-6 col-md-6" style="padding-top:10px">
                    <div class="form-group">
                        <div class="control-group">
                            <label class="col-sm-3 control-label no-padding-right">抽样算法 </label>
                            <div class="radio col-sm-4">
                                <label>
                                    <input name="form-field-algorithm" type="radio" class="ace" checked value="1"/>
                                    <span class="lbl">随机</span>
                                </label>
                            </div>

                            <div class="radio col-sm-4">
                                <label>
                                    <input name="form-field-algorithm" type="radio" class="ace" value="2"/>
                                    <span class="lbl">等差</span>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-name">批次名称 </label>

                        <div class="col-sm-9">
                            <input type="text" id="form-name" name="name" class="col-sm-12" autocomplete="off"/>
                        </div>
                    </div>

                    <!-- /section:plugins/jquery.slider -->
                </div>
            </div>
        </form>
    </div><!-- #dialog-edit -->
    <%--<div id="dialog-null" class="hidden">
        <div id="dialog-content"></div>
    </div>--%>
</div>
<!-- /.page-content -->