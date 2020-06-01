<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>医嘱点评</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>

    <!-- basic styles -->
    <link href="../components/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet"/>

    <!-- text fonts -->
    <link rel="stylesheet" href="../assets/css/ace-fonts.css"/>
    <!-- page specific plugin styles -->
    <!-- ace styles -->
    <link rel="stylesheet" href="../assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/> <!--重要-->
    <link rel="stylesheet" href="../assets/css/ace-skins.min.css"/>


    <link rel="stylesheet" href="../components/jquery-ui/jquery-ui.min.css"/>
    <link rel="stylesheet" href="../components/jquery-ui.custom/jquery-ui.custom.css"/>
    <link rel="stylesheet" href="../components/datatables/select.dataTables.min.css"/>
    <link rel="stylesheet" href="../components/bootstrap-datepicker/css/bootstrap-datepicker3.css"/>
    <link rel="stylesheet" href="../components/bootstrap-timepicker/css/bootstrap-timepicker.css"/>
    <link rel="stylesheet" href="../components/bootstrap-daterangepicker/daterangepicker.css"/>
    <link rel="stylesheet" href="../components/bootstrap-datetimepicker/bootstrap-datetimepicker.css"/>
    <link rel="stylesheet" href="../assets/css/bootstrap-editable.css"/>
    <link rel="stylesheet" href="../components/datatables/select.dataTables.css"/>

    <!-- basic scripts -->
    <script src="../js/jquery-1.12.4.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>

    <!-- ace scripts -->
    <%--<script src="../assets/js/src/elements.scroller.js"></script>--%>
    <script src="../assets/js/ace.js"></script>
    <script src="../assets/js/ace-elements.js"></script>
    <script src="../assets/js/src/ace.widget-box.js"></script>
    <!-- ace settings handler -->
    <script src="../assets/js/ace-extra.js"></script>

    <!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->
    <!--[if lte IE 8]>
    <script src="../components/html5shiv/dist/html5shiv.js"></script>
    <script src="../components/respond/dest/respond.min.js"></script>
    <![endif]-->

    <!-- page specific plugin scripts -->
    <!-- static.html end-->
    <%--<script src="../components/jquery-ui.custom/jquery-ui.custom.js"></script>--%>
    <script src="../components/datatables/jquery.dataTables.min.js"></script>
    <%--<link rel="stylesheet" href="../components/chosen/chosen.css" />--%>

    <script src="../components/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
    <script src="../components/moment/moment.min.js"></script>
    <script src="../components/bootstrap-datetimepicker/bootstrap-datetimepicker.min.js"></script>
    <script src="../components/datatables/jquery.dataTables.bootstrap.min.js"></script>
    <script src="../components/datatables/dataTables.select.min.js"></script>
    <script src="../components/jquery-ui/jquery-ui.min.js"></script>
    <script src="../components/typeahead.js/handlebars.js"></script>
    <script src="../assets/js/x-editable/bootstrap-editable.min.js"></script>

    <script src="../js/string_func.js"></script>
    <style type="text/css">
        .modal-dialog {
            position: absolute;
            top: 0;
            bottom: 0;
            left: 0;
            right: 0;
        }

        .modal-content {
            /*overflow-y: scroll; */
            position: absolute;
            top: 0;
            bottom: 0;
            width: 100%;
        }

        .modal-body {
            overflow-y: scroll;
            position: absolute;
            top: 38px;
            bottom: 65px;
            width: 100%;
        }

        .modal-body2 {
            overflow-y: scroll;
            position: absolute;
            top: 38px;
            bottom: 0;
            width: 100%;
        }

        .modal-header .close {
            margin-right: 15px;
        }

        .modal-footer {
            position: absolute;
            width: 100%;
            bottom: 0;
        }

        .dropdown-preview {
            margin: 0 5px;
            display: inline-block;
        }

        .dropdown-preview > .dropdown-menu {
            display: block;
            position: static;
            margin-bottom: 5px;
        }
    </style>

    <script type="text/javascript">
        jQuery(function ($) {
            var inPatientID = '${inPatient.inPatientID}';
            if (inPatientID === '') {
                showDialog("加载失败", "请检查数据或联系系统开发！");
                return;
            }
            var saveJson = JSON.parse('${inPatient.review.reviewJson}'.replace('\n', '\\n'));
            //var saveJson = JSON.parse('{"inPatientID":"1251","hospID":"2623","inPatientReviewID":"8904","reviewUser":"陈会玲","masterDoctor":"陈国优","基本情况":{"sex":"女","age":"69","weight":"","inHospital":"2020年03月12日","outHospital":"2020年03月19日"},"诊断":[{"diagnosisNo":"19808","type":"住院诊断","disease":"急性上消化道出血"},{"diagnosisNo":"22259","type":"住院诊断","disease":"十二指肠溃疡"},{"diagnosisNo":"22260","type":"住院诊断","disease":"重度贫血"},{"diagnosisNo":"22261","type":"住院诊断","disease":"幽门螺旋杆菌感染"},{"diagnosisNo":"22262","type":"住院诊断","disease":"肾结石"},{"diagnosisNo":"22263","type":"住院诊断","disease":"肝囊肿"},{"diagnosisNo":"22264","type":"住院诊断","disease":"脂肪肝"}],"细菌培养和药敏":{"micro":false,"micro_time":"","sample":"","germName":"","sensitiveDrug":""},"围手术期用药":{"incision":0,"surgery":false,"surgeryName":"","startTime":"","lastTime":"","beforeDrug":"0","afterDrug":"0","surgeryAppend":false},"长嘱":[],"临嘱":[],"用药情况":{"symptom":"","symptom2":""},"点评":{"review":"刘昌海：肾功能不全选用药物不适宜。患者年龄68岁，肌酐247umol/L，体重45kg，肌酐清除率为13.64ml/min，使用二甲双胍、阿卡波糖、双氯芬酸钠不适宜。肌酐清除率＜45ml/min禁用，肌酐清除率＜25ml/min禁用，晚期肾脏病避免使用双氯芬酸钠。\\n2、肾功能减退未按照肌酐清除率调整剂量不适宜。患者肌酐清除率为13.64ml/min，使用阿莫西林克拉维酸钾1.2g q8h不适宜，根据《国家抗微生物指南》肌酐清除率10~30ml/min时阿莫西林克拉维酸钾首剂1.2g 维持0.6g q12h","rational":"2"},"reviewType":0}');
            //左侧用药情况
            var longDrugTb = $('#longDrugTb').DataTable({
                bAutoWidth: false,
                language: {info: '', infoEmpty: '', sZeroRecords: '', emptyTable: ''},
                paging: false, searching: false, ordering: false, "destroy": true,
                'columnDefs': [
                    {
                        "orderable": false, "data": "advice", "targets": 0, width: 100, title: '医嘱内容', render: function (data, type, row, meta) {
                            return data + (typeof (row["menstruum"]) === 'undefined' ? "" : "<br/><span class=\"light-grey\">溶剂</span>" + row["menstruum"]);
                        }
                    },
                    {
                        "orderable": false, "data": "adviceType", "targets": 1, width: 80, title: '用法', className: 'center', render: function (data, type, row, meta) {
                            return '<a href="#" data-value="{0}" data-type="text" >{1}</a>'.format(data, data);
                        }
                    },
                    {
                        "orderable": false, "data": "quantity", "targets": 2, width: 40, title: '数量', className: 'center', render: function (data, type, row, meta) {
                            return '<a href="#" data-value="{0}" data-type="text" >{1}</a>'.format(data, data);
                        }
                    },
                    {
                        "orderable": false, "data": "adviceDate", "targets": 3, width: 80, title: '起止时间', render: function (data, type, row, meta) {
                            return '<a href="#" data-value="{0}" data-type="text" >{1}</a>'.format(data, data);
                        }
                    },
                    {
                        "orderable": false, "data": "question", "targets": 4, width: 40, title: '问题', className: 'center', render: function (data, type, row, meta) {
                            return '<a href="#" id="question" data-value="{0}" data-type="text">{1}</a>'.format(data, data === '' ? '设置' : data);
                        }
                    }
                ]

            });

            longDrugTb.on('draw', function (e, setting) {
                $("#longDrugTb tr").find("td a[id!='question']").editable();
                $("#longDrugTb tr").find("td a[id='question']").on('click', function () {
                    showQuestionDialog(this, '#longDrugTb', $(this).parent().parent().prevAll().length);
                    //$(this).text('4a');
                });
            });
            var shortDrugTb = $('#shortDrugTb').DataTable({
                bAutoWidth: false,
                language: {info: '', infoEmpty: '', sZeroRecords: '', emptyTable: ''},
                paging: false, searching: false, ordering: false, "destroy": true,
                'columnDefs': [
                    {
                        "orderable": false, "data": "advice", "targets": 0, width: 100, title: '医嘱内容', render: function (data, type, row, meta) {
                            return data + (typeof (row["menstruum"]) === 'undefined' ? "" : "<br/><span class=\"light-grey\">溶剂</span>" + row["menstruum"]);
                        }
                    },
                    {
                        "orderable": false, "data": "adviceType", "targets": 1, width: 80, title: '用法', className: 'center', render: function (data, type, row, meta) {
                            return '<a href="#" data-value="{0}" >{1}</a>'.format(data, data);
                        }
                    },
                    {
                        "orderable": false, "data": "quantity", "targets": 2, width: 40, title: '数量', className: 'center', render: function (data, type, row, meta) {
                            return '<a href="#" data-value="{0}" data-type="text" >{1}</a>'.format(data, data);
                        }
                    },
                    {
                        "orderable": false, "data": "adviceDate", "targets": 3, width: 80, title: '起止时间', render: function (data, type, row, meta) {
                            return '<a href="#" data-value="{0}" data-type="text" >{1}</a>'.format(data, data);
                        }
                    },
                    {
                        "orderable": false, "data": "question", "targets": 4, width: 40, title: '问题', className: 'center', render: function (data, type, row, meta) {
                            return '<a href="#" id="question" data-value="{0}" data-type="text">{1}</a>'.format(data, data === '' ? '设置' : data);
                        }
                    }
                ]

            });
            shortDrugTb.on('draw', function (e, setting) {
                $("#shortDrugTb tr").find("td a[id!='question']").editable();

                $("#shortDrugTb tr").find("td a[id='question']").on('click', function () {
                    //$(this).parent().prevAll().length + 1;//行号
                    showQuestionDialog(this, '#shortDrugTb', $(this).parent().parent().prevAll().length);
                    //$(this).text('asdfasf');
                });
            });
            //右侧原始长嘱
            var longTable = $('#long-table').DataTable({
                bAutoWidth: false,
                paging: false, searching: false, ordering: false, "destroy": true,
                select: {style: 'multi', selector: 'td:first-child :checkbox'},
                'columnDefs': [
                    {
                        targets: 0, data: "adviceItemID", defaultContent: '', orderable: false, width: 10, render: function (data, type, row, meta) {
                            if (row['goodsID'] > 0) {
                                //console.log("row['adviceType']:" + row['adviceType']);
                                if (typeof (saveJson.长嘱) !== 'undefined')
                                    for (var i = 0; i < saveJson.长嘱.length; i++) {
                                        if (saveJson.长嘱[i].adviceItemID === data)
                                            return '<input type="checkbox" checked>';
                                    }
                                return '<input type="checkbox">';
                            }
                            return "";
                        }
                    },
                    {"orderable": false, "data": "adviceDate", "targets": 1, title: '开始时间', width: 90, className: 'center'},
                    {
                        "orderable": false, "data": "advice", "targets": 2, title: '医嘱内容', defaultContent: '', /*width: 120,*/ render: function (data, type, row, meta) {
                            var advice;
                            if (row["instructionID"] > 0)
                                if (row["antiClass"] > 0)
                                    advice = "<a href='#' class='hasInstruction' data-instructionID='{1}'><span class='pink2'>{0}</span></a>".format(data, row["instructionID"]);
                                else
                                    advice = "<a href='#' class='hasInstruction' data-instructionID='{1}'>{0}</a>".format(data, row["instructionID"]);
                            else
                                advice = row["antiClass"] > 0 ? "<span class='pink2'>" + data + "</span>" : data;

                            if (row["adviceType"] === 1)
                                advice = advice + ' ' + row["spec"];
                            return advice;
                        }
                    },
                    {
                        "orderable": false, "data": "quantity", "targets": 3, title: '每次量', width: 65, className: 'center', render: function (data, type, row, meta) {
                            return data + row["unit"];
                        }
                    },
                    {"orderable": false, "data": "frequency", "targets": 4, title: '频率', width: 45, className: 'center'},
                    {"orderable": false, "data": "total", "targets": 5, title: '当天量', width: 60, className: 'center'},
                    {"orderable": false, "data": "usage", "targets": 6, title: '用法', width: 55, className: 'center'},
                    {"orderable": false, "data": "doctorName", "targets": 7, title: '医生', width: 60},
                    /*{"orderable": false, "data": "nurseName", "targets": 8, title: '护士', width: 60},*/
                    {"orderable": false, "data": "endDate", "targets": 8, title: '停止时间', width: 90, className: 'center'}
                ],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json',
                    select: {
                        rows: {
                            _: "已选择 %d 行", 0: "", 1: "仅选了 1 行"
                        }
                    }
                },

                scrollY: '55vh',
                "ajax": {
                    url: "/remark/getAdviceItemList.jspa?longAdvice=1&hospID=${inPatient.hospID}&year=${inPatient.year}",
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                }
            });
            var shortTable = $('#short-table').DataTable({
                bAutoWidth: false,
                paging: false, searching: false, ordering: false, "destroy": true,
                select: {style: 'multi', selector: 'td:first-child :checkbox'},
                'columnDefs': [
                    {
                        targets: 0, data: "adviceItemID", defaultContent: '', orderable: false, width: 10, render: function (data, type, row, meta) {
                            if (row['goodsID'] > 0) {
                                if (typeof (saveJson.临嘱) !== 'undefined')
                                    for (var i = 0; i < saveJson.临嘱.length; i++) {
                                        if (saveJson.临嘱[i].adviceItemID === data)
                                            return '<input type="checkbox" checked>';
                                    }
                                return '<input type="checkbox">';
                            }
                            return "";
                        }
                    },
                    {"orderable": false, "data": "adviceDate", "targets": 1, title: '开始时间', width: 90, className: 'center'},
                    {
                        "orderable": false, "data": "advice", "targets": 2, title: '医嘱内容', defaultContent: '', width: 120, render: function (data, type, row, meta) {
                            var advice;
                            if (row["instructionID"] > 0)
                                if (row["antiClass"] > 0)
                                    advice = "<a href='#' class='hasInstruction' data-instructionID='{1}'><span class='pink2'>{0}</span></a>".format(data, row["instructionID"]);
                                else
                                    advice = "<a href='#' class='hasInstruction' data-instructionID='{1}'>{0}</a>".format(data, row["instructionID"]);
                            else
                                advice = row["antiClass"] > 0 ? "<span class='pink2'>" + data + "</span>" : data;

                            if (row["adviceType"] === 1)
                                advice = advice + ' ' + row["spec"];
                            return advice;
                        }
                    },
                    {
                        "orderable": false, "data": "quantity", "targets": 3, title: '每次量', width: 60, className: 'center', render: function (data, type, row, meta) {
                            return data + row["unit"];
                        }
                    },
                    /*{"orderable": false, "data": "unit", "targets": 4, title: '单位', width: 40, className: 'center'},*/
                    {"orderable": false, "data": "frequency", "targets": 4, title: '频率', width: 45, className: 'center'},
                    {"orderable": false, "data": "total", "targets": 5, title: '当天量', width: 60, className: 'center'},
                    {"orderable": false, "data": "usage", "targets": 6, title: '用法', width: 55, className: 'center'},
                    {"orderable": false, "data": "doctorName", "targets": 7, title: '医生', width: 60},
                    /*{"orderable": false, "data": "nurseName", "targets": 7, title: '护士', width: 60},*/
                    {"orderable": false, "data": "endDate", "targets": 8, title: '停止时间', width: 90, className: 'center'}
                ],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json',
                    select: {
                        rows: {
                            _: "已选择 %d 行", 0: "", 1: "仅选了 1 行"
                        }
                    }
                },

                scrollY: '55vh',
                "ajax": {
                    url: "/remark/getAdviceItemList.jspa?longAdvice=2&hospID=${inPatient.hospID}&year=${inPatient.year}",
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                }
            });

            shortTable.on('draw', function (e, settings) {
                //加载时，通过render函数增加了checked，这里把整行选上
                $('#short-table tr').find('input[type="checkbox"]:checked').parent().parent().each(function (index, element) {
                    shortTable.row(element).select();
                });
                $('#short-table tr').find('.hasInstruction').on('click', function () {
                    $.ajax({
                        type: "GET",
                        url: '/instruction/getInstruction.jspa',
                        data: 'instructionID=' + $(this).attr("data-instructionID"),
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
                        },
                    });
                });
            }).on('select', function (e, dt, type, indexes) {
                chooseTab('#dropdown17');

                var index = parseInt(indexes);
                var rowData = jQuery.extend({}, shortTable.row(index).data());//浅层复制（克隆）
                var exists = false;
                //先判断是否存在，如存在不添加
                shortDrugTb.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    if (typeof (this.data()) !== 'undefined' && rowData["adviceItemID"] === this.data()["adviceItemID"])
                        exists = true;
                });
                if (exists) return;

                //rowData['frequency'] = rowData['quantity'];
                rowData['question'] = '';

                //不是每一行都有日期，向前找日期
                var dateIndex = -1;
                if (rowData['adviceDate'] == null || rowData['adviceDate'] === '') {
                    for (var aa = index - 1; aa >= 0; aa--)
                        if (shortTable.row(aa).data()['adviceDate'] !== '' && shortTable.row(aa).data()['adviceDate'] !== null) {
                            dateIndex = aa;
                            rowData['adviceDate'] = shortTable.row(aa).data()['adviceDate'];
                            break;
                        }
                }// else dateIndex = index;
                if (rowData['adviceDate'] !== null && rowData['adviceDate'] !== '')
                    rowData['adviceDate'] = rowData['adviceDate'].replace(/20\d\d-/g, '');
                rowData['advice'] = rowData["advice"] + ' ' + rowData["spec"];
                rowData['adviceType'] = +rowData["quantity"] + rowData["unit"] + ' ' + rowData["usage"] + ' ' + rowData["frequency"];
                rowData['quantity'] = +rowData["total"];

                shortDrugTb.row.add(rowData).draw(true);
            }).on('deselect', function (e, dt, type, indexes) {
                var rowData = shortTable.row(indexes).data();

                shortDrugTb.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    if (typeof (this.data()) !== 'undefined' && rowData["adviceItemID"] === this.data()["adviceItemID"])
                        shortDrugTb.row(rowIdx).remove().draw();
                });
            });

            longTable.on('draw', function (e, settings) {
                //加载时，通过render函数增加了checked，这里把整行选上
                $('#long-table tr').find('input[type="checkbox"]:checked').parent().parent().each(function (index, element) {
                    longTable.row(element).select();
                });
                $('#long-table tr').find('.hasInstruction').on('click', function () {
                    $.ajax({
                        type: "GET",
                        url: '/instruction/getInstruction.jspa',
                        data: 'instructionID=' + $(this).attr("data-instructionID"),
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
                        },
                    });
                });
            }).on('select', function (e, dt, type, indexes) {
                chooseTab('#dropdown17');

                var index = parseInt(indexes);
                var rowData = jQuery.extend({}, longTable.row(index).data());//浅层复制（克隆）
                //var rowSig;
                var exists = false;
                //先判断是否存在，如存在不添加
                longDrugTb.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    if (typeof (this.data()) !== 'undefined' && rowData["adviceItemID"] === this.data()["adviceItemID"])
                        exists = true;
                });
                if (exists) return;

                //rowData['frequency'] = rowData['quantity'];
                rowData['question'] = '';

                //不是每一行都有日期，向前找日期
                var dateIndex = -1;
                if (rowData['adviceDate'] == null || rowData['adviceDate'] === '') {
                    for (var aa = index - 1; aa >= 0; aa--)
                        if (longTable.row(aa).data()['adviceDate'] !== '' && longTable.row(aa).data()['adviceDate'] !== null) {
                            dateIndex = aa;
                            rowData['adviceDate'] = longTable.row(aa).data()['adviceDate'];
                            break;
                        }
                }

                if (rowData['endDate'] === null)
                    rowData['endDate'] = '<fmt:formatDate value='${outDate}' pattern='MM-dd HH:mm'/>';
                else
                //if (rowData['endDate'].match(/^20\d\d-/)) {
                    rowData['endDate'] = rowData['endDate'].replace(/^20\d\d-/g, '');
                //}
                if (rowData['adviceDate'] !== null && rowData['adviceDate'] !== '')
                    rowData['adviceDate'] = rowData['adviceDate'].replace(/^20\d\d-/g, '');
                rowData['adviceDate'] = rowData['adviceDate'] + "～" + rowData['endDate'];

                rowData['advice'] = rowData["advice"] + ' ' + rowData["spec"];
                rowData['adviceType'] = +rowData["quantity"] + rowData["unit"] + ' ' + rowData["usage"] + ' ' + rowData["frequency"];
                rowData['quantity'] = +rowData["total"];

                longDrugTb.row.add(rowData).draw(true);
            }).on('deselect', function (e, dt, type, indexes) {
                var rowData = longTable.row(indexes).data();

                longDrugTb.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    if (typeof (this.data()) !== 'undefined' && rowData["adviceItemID"] === this.data()["adviceItemID"])
                        longDrugTb.row(rowIdx).remove().draw();
                });
            });
            var surgeryTable = $('#surgery-table').DataTable({
                bAutoWidth: true,
                dom:'t',
                paging: false, searching: false, ordering: false, "destroy": true,
                select: {style: 'single', selector: 'td:first-child :radio'},
                "columns": [
                    {"data": "surgeryID"},
                    {"data": "surgeryDate", "sClass": "center", defaultContent: ''},
                    {"data": "incision", "sClass": "center", defaultContent: ''},
                    {"data": "surgeryName", "sClass": "left"}
                ],

                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, className: 'select-checkbox', width: 20, render: function (data, type, row, meta) {
                            return '<input name="a123" type="radio">';
                        }
                    },
                    {"orderable": false, "targets": 1, title: '手术时间', width: 140},
                    {"orderable": false, "targets": 2, title: '切口类型', width: 100},
                    {"orderable": false, "targets": 3, title: '操作名称'}
                ],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                scrollY: '60vh',
                "ajax": {
                    url: "/remark/getSurgerys.jspa?hospID=<c:choose><c:when test="${deployLocation eq 'wy_test'}">1038</c:when><c:otherwise>${inPatient.hospID}</c:otherwise></c:choose>",
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                }
            });
            surgeryTable.on('select', function (e, dt, type, indexes) {
                var rowData = jQuery.extend({}, surgeryTable.row(parseInt(indexes)).data());//浅层复制（克隆）
                //console.log("indexes" + rowData['incision']);
                $('#form-field-surgeryName').val(rowData['surgeryName']);
                $('#form-field-surgeryTime').val(rowData['surgeryDate']);

                $("input:checkbox[name='form-field-incision']").eq(0).attr("checked", rowData['incision'].trim() === 'Ⅰ');
                $("input:checkbox[name='form-field-incision']").eq(1).attr("checked", rowData['incision'].trim() === 'Ⅱ');
                $("input:checkbox[name='form-field-incision']").eq(2).attr("checked", rowData['incision'].trim() === 'Ⅲ');
            });

            function chooseTab(tabId) {
                //$('#myTab3 a[href="' + tabId + '"]').parent().tab('show');
                /* $('#myTab3 li').removeClass("active");
                $('#myTab3 a[href="' + tabId + '"]').parent().addClass("active");
                $("#divTab1 div").removeClass("active");
                $(tabId).addClass("active");*/
            }

            var diagnosisTable = $('#diagnosis-table').DataTable({
                bAutoWidth: false,dom:'t',
                paging: false, searching: false, ordering: false, "destroy": true, "info": false,
                select: {style: 'multi', selector: 'td:first-child :checkbox'},
                'columnDefs': [
                    {
                        targets: 0, data: "diagnosisNo", orderable: false, width: 10, //className: 'select-checkbox',
                        render: function (data, type, row, meta) {
                            if (typeof (saveJson.诊断) !== 'undefined')
                                for (var i = 0; i < saveJson.诊断.length; i++) {
                                    if (saveJson.诊断[i].diagnosisNo === data + "")
                                        return '<input type="checkbox" checked>';
                                }
                            return '<input type="checkbox">';
                        }
                    },
                    {"orderable": false, "data": "type", "targets": 1, title: '类型', defaultContent: ''},
                    {"orderable": false, "data": "disease", "targets": 2, title: '诊断', defaultContent: ''},
                    {"orderable": false, "data": "icd", "targets": 3, title: 'ICD', defaultContent: ''}/*,
                    {"orderable": false, "data": "originalChs", "targets": 4, title: '入院病情', defaultContent: ''}*/
                ],
                "aaSorting": [],
                language: {
                    url: '../components/datatables/datatables.chinese.json'
                },
                scrollY: '60vh',
                "ajax": {
                    url: "/remark/getDiagnosis.jspa?hospID=${inPatient.hospID}",
                    //url: "/remark/getDiagnosis.jspa?hospID=0000593702&archive=1",
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                }
            });
            diagnosisTable.on('select', function (e, dt, type, indexes) {
                chooseTab('#home3');//函数chooseTab屏蔽了代码
                var rowData = diagnosisTable.row(indexes).data();
                var exists = false;
                /*先判断是否存在，如存在不添加*/
                var no = "" + rowData["diagnosisNo"];
                $("#chooseDiagnosis tr").each(function (i, item) {
                    if ($(item).attr("data-id") !== undefined && no === $(item).attr("data-id"))
                        exists = true;
                });
                if (exists) return;

                $("#chooseDiagnosis tr:last").after(Handlebars.compile("<tr data-id='{{diagnosisNo}}'><td>{{type}}</td><td>{{disease}}</td></tr>")(rowData));
            }).on('deselect', function (e, dt, type, indexes) {
                var rowData = diagnosisTable.row(indexes).data();
                var no = "" + rowData["diagnosisNo"];
                $("#chooseDiagnosis tr").each(function (i, item) {
                    if (no === $(item).attr("data-id"))
                        $(this).remove();
                });
            }).on('draw', function (e, settings) {
                //加载时，通过render函数增加了checked，这里把整行选上
                $('#diagnosis-table tr').find('input[type="checkbox"]:checked').parent().parent().each(function (index, element) {
                    diagnosisTable.row(element).select();
                });
            });

            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                //当切换tab时，强制重新计算列宽
                $.fn.dataTable.tables({visible: true, api: true}).columns.adjust().draw();
            });
            $("#myTab2 a").on("shown.bs.tab", function (e) {
                /* var activeTab = $(e.target).text();
                 var previousTab = $(e.relatedTarget).text(); */
                if ($(e.target).text().startsWith("检验")) {
                    showLis();
                }
                if ($(e.target).text().startsWith("影像")) {
                    showPacsResult();
                }
                if ($(e.target).text() === "病历") {
                    window.open('http://168.168.168.233:8090/Main.aspx?HospId=${inPatient.hospID}', "_blank");
                    $(e.relatedTarget).trigger("click");
                }
            });
            getCount();

            function getCount() {
                $.ajax({
                    type: "GET",
                    url: '/remark/getSurgeryCount.jspa',
                    data: 'hospID=<c:choose><c:when test="${deployLocation eq 'wy_test'}">1038</c:when><c:otherwise>${inPatient.hospID}</c:otherwise></c:choose>',
                    contentType: "application/json; charset=utf-8",
                    cache: false,
                    success: function (response, textStatus) {
                        $("#myTab2 a:eq(4)").text("手术(" + response + ")");
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        showDialog("请求状态码：" + response.status, response.responseText);
                    },
                });
                $.ajax({
                    type: "GET",
                    url: '/check/lisCount.jspa',
                    data: 'hospID=<c:choose><c:when test="${deployLocation eq 'wy_test'}">4101</c:when><c:otherwise>${inPatient.hospID}</c:otherwise></c:choose>',//4101、4090、4100
                    contentType: "application/json; charset=utf-8",
                    cache: false,
                    success: function (response, textStatus) {
                        var respObject = JSON.parse(response);
                        $("#myTab2 a:eq(5)").text("检验(" + respObject.techCount + ")");
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        showDialog("请求状态码：" + response.status, response.responseText);
                    },
                });
                $.ajax({
                    type: "GET",
                    url: '/check/pacsCount.jspa',
                    data: 'hospID=<c:choose><c:when test="${deployLocation eq 'wy_test'}">4112</c:when><c:otherwise>${inPatient.hospID}</c:otherwise></c:choose>',//4112,4106,4123,4125,4136,4116
                    contentType: "application/json; charset=utf-8",
                    cache: false,
                    success: function (response, textStatus) {
                        var respObject = JSON.parse(response);
                        $("#myTab2 a:eq(6)").text("影像(" + respObject.pacsCount + ")");
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        showDialog("请求状态码：" + response.status, response.responseText);
                    },
                });
            }

            function showLis() {
                $.ajax({
                    type: "GET",
                    url: '/check/lisDir.jspa',
                    data: 'hospID=<c:choose><c:when test="${deployLocation eq 'wy_test'}">4101</c:when><c:otherwise>${inPatient.hospID}</c:otherwise></c:choose>',//4101、4090、4100
                    contentType: "application/json; charset=utf-8",
                    cache: false,
                    success: function (response, textStatus) {
                        var respObject = JSON.parse(response);
                        var line = "";
                        $.each(respObject, function (index, item) {
                            line += "<li><a href='#' tabindex='-1' data-labID='{0}'>{1}</a></li>".format(item.labID,
                                item.checkName.length > 12 ? item.checkName.substring(0, 11) + "…" : item.checkName);
                        });

                        $('.dropdown-menu').html(line);

                        $('.dropdown-menu a').click(function () {
                            showLisItem($(this).attr("data-labID"));
                        });
                        $('.dropdown-menu a:eq(0)').trigger("click");
                        //if(respObject.length>0) showLisItem($(this).attr("data-labID"));
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        showDialog("请求状态码：" + response.status, response.responseText);
                    },
                });
            }

            function showLisItem(labID) {
                $('#lis-table tbody tr').remove();
                $.ajax({
                    type: "GET",
                    url: '/check/lisResult.jspa',
                    data: 'labID=' + labID,
                    contentType: "application/json; charset=utf-8",
                    cache: false,
                    success: function (response, textStatus) {
                        var items = JSON.parse(response);
                        if (items.length > 0) {
                            var tpl = "<div class=\"col-xs-6\">检查日期：{{checkTime}}</div><div class=\"col-xs-6\">检查医生：{{checkDoc}}</div>";
                            $('#itemHead').html(Handlebars.compile(tpl)(items[0]));
                            var $tr = "";
                            $.each(items, function (index, item) {
                                $tr = "<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td></tr>".format(item.itemName, item.result, item.unit, item.refrence, item.status);
                                $("#lis-table tbody").append($tr);
                            });
                        }
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        showDialog("请求状态码：" + response.status, response.responseText);
                    },
                });
            }

            function showPacsResult() {
                $('#lis-table tbody tr').remove();
                $.ajax({
                    type: "GET",
                    url: '/check/pacsResult.jspa',
                    data: 'hospID=<c:choose><c:when test="${deployLocation eq \'wy_test\'}">4125</c:when><c:otherwise>${inPatient.hospID}</c:otherwise></c:choose>',
                    //4112,4106,4123,4125,4136,4116
                    contentType: "application/json; charset=utf-8",
                    cache: false,
                    success: function (response, textStatus) {
                        var items = JSON.parse(response);
                        $('#pacsContent').html(Handlebars.compile($('#pacsContent').html())(items));
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        showDialog("请求状态码：" + response.status, response.responseText);
                    },
                });
            }

            // scrollables
            $('.scrollable').each(function () {
                var $this = $(this);
                $(this).ace_scroll({
                    size: $this.attr('data-size') || 100,
                    //styleClass: 'scroll-left scroll-margin scroll-thin scroll-dark scroll-light no-track scroll-visible'
                });
            });
            $('.scrollable-horizontal').each(function () {
                var $this = $(this);
                $(this).ace_scroll(
                    {
                        horizontal: true,
                        styleClass: 'scroll-top',//show the scrollbars on top(default is bottom)
                        size: $this.attr('data-size') || 500,
                        mouseWheelLock: true
                    }
                ).css({'padding-top': 12});
            });

            $(window).on('resize.scroll_reset', function () {
                $('.scrollable-horizontal').ace_scroll('reset');
            });
            //datepicker plugin
            //link
            $('.date-picker').datepicker({
                autoclose: true,
                format: "yyyy-mm-dd", //选择日期后，文本框显示的日期格式
                language: 'zh-CN', //汉化
                todayHighlight: true
            })
            //show datepicker when clicking on the icon
                .next().on(ace.click_event, function () {
                $(this).prev().focus();
            });


            if (!ace.vars['old_ie']) $('#form-field-surgeryTime').datetimepicker({
                //format: 'MM/DD/YYYY h:mm:ss A',//use this option to display seconds
                //language: 'zh-CN',
                icons: {
                    time: 'fa fa-clock-o',
                    date: 'fa fa-calendar',
                    up: 'fa fa-chevron-up',
                    down: 'fa fa-chevron-down',
                    previous: 'fa fa-chevron-left',
                    next: 'fa fa-chevron-right',
                    today: 'fa fa-arrows ',
                    clear: 'fa fa-trash',
                    close: 'fa fa-times'
                }
            }).next().on(ace.click_event, function () {
                $(this).prev().focus();
            });

            //导出
            $('.btn-info').on('click', function (e) {
                window.location.href = "getInPatientExcel0.jspa?inPatientID=${inPatient.inPatientID}";
            });

            var json = {
                inPatientID: '${inPatient.inPatientID}', hospID: '${inPatient.hospID}', inPatientReviewID: '${inPatient.review.inPatientReviewID}',
                reviewUser: '${currentUser.name}', masterDoctor: '${inPatient.masterDoctorName}'
            };
            //保存
            $('.btn-success').on('click', function (e) {
                var baseInfo = {};

                baseInfo.sex = $('input:radio[name="form-field-radio-sex"]:checked').val();
                baseInfo.age = $('#form-field-age').val();
                baseInfo.weight = $('#form-field-weight').val();
                baseInfo.inHospital = $('#id-date-picker-inHospital').val();
                baseInfo.outHospital = $('#id-date-picker-outHospital').val();
                json.基本情况 = baseInfo;

                var diagnosis = [];
                $("#chooseDiagnosis tr:gt(0)").each(function (i, item) {
                    //if ($(item).attr("data-id") !== null) {
                    diagnosis.push({"diagnosisNo": $(item).attr("data-id"), "type": $(item).find("td:eq(0)").text(), "disease": $(item).find("td:eq(1)").text()});
                    //}
                });
                json.诊断 = diagnosis;


                var lab = {micro: false};

                lab.micro = $('input:radio[name="form-field-micro"]:checked').val() == null ? false : $('input:radio[name="form-field-micro"]:checked').val();
                lab.micro_time = $('#micro_time').val();
                lab.sample = $('#form-field-sample').val();
                lab.germName = $('#form-field-germName').val();
                lab.sensitiveDrug = $('#form-field-sensitiveDrug').val();
                json.细菌培养和药敏 = lab;


                <c:if test="${inPatient.surgery==1}">
                var surgery = {incision: 0};

                surgery.surgery = $("input[name='form-field-surgery']").is(':checked');
                surgery.surgeryName = $('#form-field-surgeryName').val();
                surgery.startTime = $('#form-field-surgeryTime').val();
                surgery.lastTime = $('#form-field-lastTime').val();
                surgery.beforeDrug = $("input:radio[name='form-field-beforeDrug']:checked").val() == null ? 0 : $('input:radio[name="form-field-beforeDrug"]:checked').val();
                surgery.afterDrug = $("input:radio[name='form-field-afterDrug']:checked").val() == null ? 0 : $('input:radio[name="form-field-afterDrug"]:checked').val();
                surgery.surgeryAppend = $("input[name='form-field-surgeryAppend']").is(':checked');                //术中追加
                $("input:checkbox[name='form-field-incision']:checked").each(function () {
                    surgery.incision += parseInt($(this).val());
                });

                json.围手术期用药 = surgery;
                </c:if>

                var drug = [];
                longDrugTb.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    if (typeof (this.data()) !== 'undefined') {
                        var trRow = $("#longDrugTb tbody tr").eq(rowIdx);
                        drug.push({
                            "adviceItemID": this.data()["adviceItemID"],
                            "advice": this.data()["advice"],
                            "adviceType": trRow.find("td:eq(1)").text(),
                            "quantity": trRow.find("td:eq(2)").text(),
                            "adviceDate": trRow.find("td:eq(3)").text(),
                            "question": trRow.find("td:eq(4)").text(),
                            "medicineNo": this.data()["medicineNo"]
                        });
                    }
                });
                json.长嘱 = drug;
                var drug2 = [];
                shortDrugTb.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    if (typeof (this.data()) !== 'undefined') {
                        var trRow = $("#shortDrugTb tbody tr").eq(rowIdx);
                        //console.log("eq3:" + trRow.find["td:eq(3)"]);
                        drug2.push({
                            "adviceItemID": this.data()["adviceItemID"],
                            "advice": this.data()["advice"],
                            "adviceType": trRow.find("td:eq(1)").text(),
                            "quantity": trRow.find("td:eq(2)").text(),
                            "question": trRow.find("td:eq(4)").text(),
                            "adviceDate": trRow.find("td:eq(3)").text(),
                            "medicineNo": this.data()["medicineNo"]
                        });
                    }
                });
                json.临嘱 = drug2;

                var drugInfo = {};
                drugInfo.symptom = $('#form-field-symptom').val();
                drugInfo.symptom2 = $('#form-field-symptom2').val();
                json.用药情况 = drugInfo;

                var review = {};
                review.review = $('#form-field-review').val();
                review.rational = $("input[name='form-field-rational']:checked").val();
                json.点评 = review;
                json.reviewType = 0;
                $.ajax({
                    type: "POST",
                    url: 'saveInPatient.jspa',
                    data: JSON.stringify(json),
                    contentType: "application/json; charset=utf-8",
                    cache: false,
                    success: function (response, textStatus) {
                        showDialog(response.succeed ? "保存成功" : "保存失败", response.message);
                        if (response.succeed) {
                            $('.btn-info').removeClass("hidden");
                            json.inPatientReviewID = response.inPatientReviewID;
                        }
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        showDialog("请求状态码：" + response.status, response.responseText);
                    },
                });
            });


            function fillout() {
                if (typeof (saveJson.基本情况) === 'undefined')
                    return;
                $('.btn-info').removeClass("hidden");

                //基本情况
                $('input:radio[name="form-field-radio-sex"][value="' + saveJson.基本情况.sex + '"]').prop("checked", "checked");
                $('#form-field-age').val(saveJson.基本情况.age);
                $('#form-field-weight').val(saveJson.基本情况.weight);
                $('#id-date-picker-inHospital').val(saveJson.基本情况.inHospital);
                $('#id-date-picker-outHospital').val(saveJson.基本情况.outHospital);

                for (var i = 0; i < saveJson.诊断.length; i++)
                    $("#chooseDiagnosis tr:last").after(Handlebars.compile("<tr data-id='{{diagnosisNo}}'><td>{{type}}</td><td>{{disease}}</td></tr>")(saveJson.诊断[i]));

                $('input:radio[name="form-field-micro"][value="' + saveJson.细菌培养和药敏.micro + '"]').prop("checked", "checked");
                $('#micro_time').val(saveJson.细菌培养和药敏.micro_time);
                $('#form-field-sample').val(saveJson.细菌培养和药敏.sample);
                $('#form-field-germName').val(saveJson.细菌培养和药敏.germName);
                $('#form-field-sensitiveDrug').val(saveJson.细菌培养和药敏.sensitiveDrug);

                <c:if test="${inPatient.surgery==1}">
                $('input:checkbox[name="form-field-surgery"]').prop("checked", saveJson.围手术期用药.surgery);
                $('#form-field-surgeryName').val(saveJson.围手术期用药.surgeryName);
                $('#form-field-surgeryTime').val(saveJson.围手术期用药.startTime);
                $('#form-field-lastTime').val(saveJson.围手术期用药.lastTime);
                $("input:checkbox[name='form-field-incision']").each(function () {
                    $(this).attr("checked", (saveJson.围手术期用药.incision & $(this).val()) === parseInt($(this).val()));
                });
                $("input:radio[name='form-field-beforeDrug']").each(function () {
                    $(this).attr("checked", (saveJson.围手术期用药.beforeDrug & $(this).val()) === parseInt($(this).val()));
                });
                $("input:radio[name='form-field-afterDrug']").each(function () {
                    $(this).attr("checked", (saveJson.围手术期用药.afterDrug & $(this).val()) === parseInt($(this).val()));
                });
                $("input:radio[name='form-field-surgeryAppend']").attr("checked", saveJson.围手术期用药.surgeryAppend);
                </c:if>


                for (i = 0; i < saveJson.长嘱.length; i++)
                    longDrugTb.row.add(saveJson.长嘱[i]).draw(false);
                for (i = 0; i < saveJson.临嘱.length; i++)
                    shortDrugTb.row.add(saveJson.临嘱[i]).draw(false);
                $('#form-field-symptom').val(saveJson.用药情况.symptom);
                $('#form-field-symptom2').val(saveJson.用药情况.symptom2);

                $('#form-field-review').val(saveJson.点评.review);
                $("input:radio[name='form-field-rational']").each(function () {
                    $(this).attr("checked", (saveJson.点评.rational & $(this).val()) === parseInt($(this).val()));
                });
            }

            fillout();

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


            /*弹出问题对话框开始*/
            var kk = 0;
            var questionTable = $("#questionTable");

            function showQuestionDialog(selected, tableVar, rowNo) {
                $('#tableVar').val(tableVar);
                /*$("#shortDrugTb tr").find("td a[id='question']").editable();*/
                $('#rowNo').val(rowNo);
                //console.log('html2:' + $($('#tableVar').val()+' tr').find("td a[id='question']").html());
                //console.log('rowNo:' + rowNo);

                if (questionTable.find("tbody tr").length === 0 && kk === 0) {
                    kk = 1;
                    $.ajax({
                        type: "GET",
                        url: "/common/dict/listDict.jspa",
                        data: "parentID=118",
                        contentType: "application/json; charset=utf-8",
                        cache: false,
                        success: function (response, textStatus) {
                            var respObject = JSON.parse(response);
                            if (respObject.data.length > 0)
                                $.each(respObject.data, function () {
                                    var $tr = '<tr><td><input name="dictNo" type="checkbox" value="{0}" /></td><td align="center">{1}</td><td align="left">{2}</td></tr>'.format(this.dictNo, this.dictNo, this.value);
                                    questionTable.append($tr);
                                });

                            setCheckQuestion($(selected).text());
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
                        complete: function (request, textStatus) {
                            kk = 0;
                        }
                    });
                } else {
                    setCheckQuestion($(selected).text());
                }
                $('#question-choose').modal();
            }

            $('#saveQuestionBtn').on('click', function () {
                var question_select = '';
                $("input:checkbox[name='dictNo']:checked").each(function () {
                    question_select += $(this).val() + ', ';
                });
                if (question_select === '') question_select = '设置';
                if (question_select.endWith(', '))
                    question_select = question_select.substring(0, question_select.length - 2);
                $($('#tableVar').val() + ' tr').find("td a[id='question']").eq($('#rowNo').val()).text(question_select);
                $('#question-choose').modal('hide');
            });

            function setCheckQuestion(selected) {
                var selArr = [];
                if (selected.indexOf(',') > 0)
                    selArr = selected.split(',');
                else
                    selArr[0] = selected;
                $("input:checkbox[name='dictNo']").each(function () {
                    var checked = false;
                    for (var t = 0; t < selArr.length; t++) {
                        if (selArr[t].trim() === $(this).val()) {
                            checked = true;
                            break;
                        }
                    }
                    $(this).attr("checked", checked);
                });
            }

            $('.hasInstruction').click(function () {
                $.ajax({
                    type: "GET",
                    url: '/instruction/getInstruction.jspa',
                    data: 'instructionID=' + $(this).attr("data-instructionID"),
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
                    },
                });
            });
        })
    </script>
</head>
<body class="no-skin">
<div id="dialog-error" class="hide alert" title="提示">
    <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
</div>
<div class="main-container ace-save-state" id="main-container">
    <script type="text/javascript">
        try {
            ace.settings.loadState('main-container')
        } catch (e) {
        }
    </script>
    <div class="main-content">
        <div class="main-content-inner">


            <!-- /section:basics/content.breadcrumbs -->
            <div class="page-content">
                <div class="row">
                    <div class="col-sm-5">
                        <%--<h3 class="header smaller lighter red">点评</h3>--%>
                        <h4 class="header smaller lighter blue">点评
                            <span class="light-grey smaller-50">点评人：${currentUser.name}</span>
                            <div class="pull-right">
                                <button type="button" class="btn btn-sm btn-info hidden">
                                    导出
                                    <i class="ace-icon fa fa-file-excel-o icon-on-right bigger-110"></i>
                                </button>&nbsp;
                                <button type="button" class="btn btn-sm btn-success">
                                    保存
                                    <i class="ace-icon fa fa-save icon-on-right bigger-110"></i>
                                </button>
                            </div>
                        </h4>

                        <form id="inPatientForm">
                            <!-- #section:elements.tab.position -->
                            <div class="tabbable tabs-left">
                                <ul class="nav nav-tabs" id="myTab3">
                                    <li class="active"><a data-toggle="tab" href="#dropdown23">基本情况</a></li>
                                    <li><a data-toggle="tab" href="#home3">诊断</a></li>
                                    <li><a data-toggle="tab" href="#dropdown13">细菌培养<br/>和药敏</a></li>

                                    <c:if test="${inPatient.surgery==1}">
                                        <li><a data-toggle="tab" href="#dropdown88">围手术期<br/>用药</a></li>
                                    </c:if>
                                    <li><a data-toggle="tab" href="#dropdown17">用药情况</a></li>
                                    <li><a data-toggle="tab" href="#dropdown21">点评(存在<br/>问题分析)</a></li>
                                </ul>

                                <div class="tab-content" id="divTab1">
                                    <div id="dropdown23" class="tab-pane  in active">
                                        <div class="well well-sm" style="height: 170px">
                                            <div class="control-group col-xs-12">
                                                <span class="lbl">性别：</span>
                                                <input name="form-field-radio-sex" type="radio" class="ace" value="男"
                                                       <c:if test="${inPatient.sex}">checked</c:if> />
                                                <span class="lbl">男</span>
                                                <input name="form-field-radio-sex" type="radio" class="ace" value="女" <c:if test="${!inPatient.sex}">checked</c:if>/>
                                                <span class="lbl">女</span>
                                            </div>
                                            <div class="form-inline col-xs-12" style="margin-top: 10px;">
                                                <label class="control-label" for="form-field-age" style="text-overflow:ellipsis; white-space:nowrap;">年龄</label>
                                                <input type="text" id="form-field-age" placeholder="年龄" class="no-padding" style="width: 60px;text-align: center"
                                                       value="${inPatient.age.trim()}"/>
                                                <span class="lbl light-grey">年龄的单位分别为：天、周、月或岁</span>
                                            </div>
                                            <div class="form-inline col-xs-12" style="margin-top: 10px;">
                                                <label class="control-label" for="form-field-weight" style="text-overflow:ellipsis; white-space:nowrap;">体重</label>
                                                <input type="text" id="form-field-weight" placeholder="kg" class="no-padding" style="width: 60px;text-align: center"/>
                                                <label class="control-label" for="form-field-weight" style="text-overflow:ellipsis; white-space:nowrap;">kg</label>
                                            </div>
                                            <div class="form-inline col-xs-12" style="margin-top: 10px;">
                                                <label class="control-label no-padding" for="id-date-picker-inHospital" style="text-overflow:ellipsis; white-space:nowrap;">入院日期</label>
                                                <div class="input-group">
                                                    <input class="date-picker no-padding" style="width: 110px" id="id-date-picker-inHospital" type="text" data-date-format="YYYY年MM月DD日"
                                                           value="<fmt:formatDate value='${inDate}' pattern='yyyy年MM月dd日'/>"/>
                                                    <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                </div>
                                                <label class="control-label no-padding" for="id-date-picker-outHospital" style="text-overflow:ellipsis; white-space:nowrap;">出院日期</label>
                                                <div class="input-group">
                                                    <input class="date-picker no-padding" style="width: 110px" id="id-date-picker-outHospital" type="text" data-date-format="YYYY年MM月DD日"
                                                           value="<fmt:formatDate value='${outDate}' pattern='yyyy年MM月dd日'/>"/>
                                                    <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="home3" class="tab-pane">
                                        <table id="chooseDiagnosis" class="table table-striped table-bordered table-hover">
                                            <thead class="thin-border-bottom">
                                            <tr>
                                                <th>类型</th>
                                                <th>诊断</th>
                                            </tr>
                                            </thead>
                                            <tbody>

                                            </tbody>
                                        </table>
                                    </div>

                                    <div id="dropdown13" class="tab-pane">
                                        <div class="well well-sm" style="height: 150px">
                                            <div class="form-inline no-padding">
                                                <label class="col-xs-3 control-label" style="text-overflow:ellipsis; white-space:nowrap;">是否送检</label>
                                                <div class="control-group col-xs-3 no-padding">
                                                    <label>
                                                        <input name="form-field-micro" type="radio" class="ace" value="0"/>
                                                        <span class="lbl">否</span>
                                                    </label>

                                                    <label>
                                                        <input name="form-field-micro" type="radio" class="ace" value="1"/>
                                                        <span class="lbl">是</span>
                                                    </label>
                                                </div>

                                                <div class="col-xs-5 no-padding">
                                                    <div class="input-group">
                                                        <label>送检日期</label>
                                                        <input class="date-picker no-padding " style="width: 100px" id="micro_time" type="text" data-date-format="yyyy-mm-dd"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-inline no-padding col-xs-12" style="margin-top: 5px;">
                                                <label class="col-xs-3 control-label" for="form-field-sample" style="text-overflow:ellipsis; white-space:nowrap;">标本</label>
                                                <input type="text" id="form-field-sample" placeholder="标本" class="no-padding col-xs-9"/>
                                            </div>
                                            <div class="form-inline no-padding col-xs-12" style="margin-top: 5px;">
                                                <label class=" control-label  col-xs-3" for="form-field-germName" style="text-overflow:ellipsis; white-space:nowrap;">细菌名称</label>
                                                <input type="text" id="form-field-germName" placeholder="细菌名称" class="no-padding  col-xs-9"/>
                                            </div>
                                            <div class="form-inline no-padding col-xs-12" style="margin-top: 5px;">
                                                <label class=" control-label  col-xs-3" for="form-field-sensitiveDrug" style="text-overflow:ellipsis; white-space:nowrap;">敏感药物</label>
                                                <input type="text" id="form-field-sensitiveDrug" placeholder="敏感药物" class="no-padding col-xs-push-9"/>
                                            </div>


                                        </div>
                                    </div>
                                    <c:if test="${inPatient.surgery==1}">
                                        <div id="dropdown88" class="tab-pane" style="height: 380px">
                                            <div class="well well-sm" style="height: 200px" id="kkk">
                                                <div class="form-inline no-padding col-xs-12" style="margin-top: 5px;">
                                                    <div class="control-group col-xs-2 no-padding">
                                                        <label class="control-label" style="text-overflow:ellipsis; white-space:nowrap;">外科</label>
                                                        <input name="form-field-surgery" type="checkbox" class="ace"/>
                                                        <span class="lbl"></span>
                                                    </div>

                                                    <div class="col-xs-9 no-padding">
                                                        <div class="input-group">
                                                            <label class="col-xs-4 control-label" for="form-field-surgeryName"
                                                                   style="text-overflow:ellipsis; white-space:nowrap;">手术名称</label>
                                                            <div class="col-xs-8">
                                                                <input type="text" id="form-field-surgeryName" placeholder="手术名称" class="no-padding "/>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-inline  no-padding  col-xs-12" style="margin-top: 5px;">
                                                    <div class="input-group">
                                                        <label class="control-label no-padding" for="form-field-surgeryTime" style="text-overflow:ellipsis; white-space:nowrap;width:90px;">
                                                            手术开始时间</label>
                                                        <input class="no-padding" style="width: 130px" id="form-field-surgeryTime" type="text" data-date-format="YYYY-MM-DD HH:mm"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                </div>
                                                <div class="form-inline  no-padding  col-xs-12" style="margin-top: 5px;">
                                                    <div class="input-group">
                                                        <label class="control-label no-padding" for="form-field-lastTime"
                                                               style="text-overflow:ellipsis; white-space:nowrap;width:60px;">持续时间</label>
                                                        <input type="text" id="form-field-lastTime" placeholder="持续时间" class="no-padding" style="width:100px;"/>
                                                    </div>
                                                </div>
                                                <div class="form-inline no-padding col-xs-12" style="margin-top: 5px;">
                                                    <div class="input-group">
                                                        <label class="col-xs-1 control-label  no-padding" style="text-overflow:ellipsis; white-space:nowrap;width: 70px">术前用药</label>
                                                        <label>
                                                            <input name="form-field-beforeDrug" type="radio" class="ace" value="0"/>
                                                            <span class="lbl">≤2h&nbsp;&nbsp;</span>
                                                        </label>
                                                        <label>
                                                            <input name="form-field-beforeDrug" type="radio" class="ace" value="1"/>
                                                            <span class="lbl">>2h&nbsp;&nbsp;</span>
                                                        </label> <label>
                                                        <input name="form-field-beforeDrug" type="radio" class="ace" value="2"/>
                                                        <span class="lbl">未用</span>
                                                    </label>
                                                    </div>
                                                </div>

                                                <div class="form-inline no-padding col-xs-12" style="margin-top: 5px;">
                                                    <div class="input-group  no-padding">
                                                        <label class=" control-label  no-padding" style="text-overflow:ellipsis; white-space:nowrap;width: 70px">术后停药</label>
                                                        <label>
                                                            <input name="form-field-afterDrug" type="radio" class="ace" value="0"/>
                                                            <span class="lbl">≤24h </span>
                                                        </label>
                                                        <label>
                                                            <input name="form-field-afterDrug" type="radio" class="ace" value="1"/>
                                                            <span class="lbl">>24h≤48h </span>
                                                        </label>
                                                        <label>
                                                            <input name="form-field-afterDrug" type="radio" class="ace" value="2"/>
                                                            <span class="lbl">>48h≤72h</span>
                                                        </label>
                                                        <label>
                                                            <input name="form-field-afterDrug" type="radio" class="ace" value="3"/>
                                                            <span class="lbl">>3~7天</span>
                                                        </label>
                                                        <label>
                                                            <input name="form-field-afterDrug" type="radio" class="ace" value="4"/>
                                                            <span class="lbl">>7天</span>
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="form-inline no-padding col-xs-12" style="margin-top: 5px;">
                                                    <div class="control-group col-xs-3 no-padding">
                                                        <label class="control-label" style="text-overflow:ellipsis; white-space:nowrap;">术中追加</label>
                                                        <input name="form-field-surgeryAppend" type="checkbox" class="ace"/>
                                                        <span class="lbl"></span>
                                                    </div>
                                                    <div class="control-group col-xs-9 no-padding">
                                                        <label class="col-xs-1 control-label  no-padding" style="text-overflow:ellipsis; white-space:nowrap;width: 80px">切口类型</label>
                                                        <label>
                                                            <input name="form-field-incision" type="checkbox" class="ace" value="1"/>
                                                            <span class="lbl">Ⅰ</span>
                                                        </label>
                                                        <label>
                                                            <input name="form-field-incision" type="checkbox" class="ace" value="2"/>
                                                            <span class="lbl">Ⅱ</span>
                                                        </label> <label>
                                                        <input name="form-field-incision" type="checkbox" class="ace" value="4"/>
                                                        <span class="lbl">Ⅲ</span>
                                                    </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>

                                    <div id="dropdown17" class="tab-pane">
                                        <div class="well well-sm col-xs-12">
                                            <h6 class="green lighter">长嘱</h6>
                                            <table id="longDrugTb" class="table table-striped table-bordered table-hover">
                                                <thead class="thin-border-bottom">
                                                <tr>
                                                    <th>医嘱内容</th>
                                                    <th>用法</th>
                                                    <th>数量</th>
                                                    <th>起止时间</th>
                                                    <th>问题</th>
                                                </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <div class="form-inline no-padding col-xs-12 control-group" style="margin-top: 5px;">
                                                <label class="control-label" for="form-field-symptom" style="text-overflow:ellipsis; white-space:nowrap;width: 70px;float:left;">症状特征</label>
                                                <input type="text" id="form-field-symptom" placeholder="症状特征" style="overflow:hidden;" class="no-padding"/>
                                            </div>
                                        </div>
                                        <div class="well well-sm col-xs-12">
                                            <h6 class="green lighter">临嘱</h6>
                                            <table id="shortDrugTb" class="table table-striped table-bordered table-hover">
                                                <thead class="thin-border-bottom">
                                                <tr>
                                                    <th>医嘱内容</th>
                                                    <th>用法</th>
                                                    <th>数量</th>
                                                    <th>起止时间</th>
                                                    <th>问题</th>
                                                </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <div class="form-inline no-padding col-xs-12 control-group" style="margin-top: 5px;">
                                                <label class="control-label" for="form-field-symptom2" style="text-overflow:ellipsis; white-space:nowrap;width: 70px;float:left;">症状特征</label>
                                                <input type="text" id="form-field-symptom2" placeholder="症状特征" style="overflow:hidden;" class="no-padding"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="dropdown21" class="tab-pane">
                                        <div class="well well-sm" style="height: 185px">
                                            <textarea class="autosize-transition form-control" rows="6" id="form-field-review" placeholder="点评内容"></textarea>
                                            <div class="control-group col-xs-12 no-padding" style="margin-top: 5px;">
                                                <label class="col-xs-3 control-label" style="text-overflow:ellipsis; white-space:nowrap;">判断结果</label>
                                                <label>
                                                    <input name="form-field-rational" type="radio" class="ace" value="1" checked/>
                                                    <span class="lbl">合理</span>
                                                </label>

                                                <label>
                                                    <input name="form-field-rational" type="radio" class="ace" value="2"/>
                                                    <span class="lbl">不合理</span>
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>

                        </form>
                        <!-- /section:elements.tab.position -->
                    </div><!-- /.col -->
                    <div class="col-sm-7 widget-container-col" id="widget-container-col-13">
                        <div class="widget-box transparent" id="widget-box-13">
                            <div class="widget-header">
                                <h4 class="widget-title lighter">
                                    住院号：${inPatient.hospNo}，姓名：${inPatient.patientName}<%--，出院日期：<fmt:formatDate value='${outDate}' pattern='yyyy-MM-dd HH:mm'/>--%></h4>

                                <div class="widget-toolbar no-border" id="tabDiv">
                                    <ul class="nav nav-tabs" id="myTab2">
                                        <li class="active"><a data-toggle="tab" href="#home1">病人</a></li>
                                        <li><a data-toggle="tab" href="#home2">诊断</a></li>
                                        <li><a data-toggle="tab" href="#longTab">长嘱</a></li>
                                        <li><a data-toggle="tab" href="#shortTab">临嘱</a></li>
                                        <li><a data-toggle="tab" href="#surgeryTab">手术(0)</a></li>
                                        <li><a data-toggle="tab" href="#lisTab">检验(0)</a></li>
                                        <li><a data-toggle="tab" href="#pacsTab">影像(0)</a></li>
                                        <li><a data-toggle="tab">病历</a></li>
                                    </ul>
                                </div>
                            </div>

                            <div class="widget-body">
                                <div class="widget-main padding-12 no-padding-left no-padding-right">
                                    <div class="tab-content padding-4">
                                        <div id="home1" class="tab-pane in active">

                                            <table border="0" cellspacing="1" cellpadding="0" class="col-sm-5 table table-striped table-bordered table-hover">
                                                <tbody>
                                                <tr>
                                                    <td class="col-sm-2">住院号</td>
                                                    <td class="col-sm-4">${inPatient.hospNo}</td>

                                                    <td class="col-sm-2">姓名</td>

                                                    <td class="col-sm-4">${inPatient.patientName}</td>
                                                </tr>
                                                <tr>
                                                    <td class="col-sm-2">入院日期</td>
                                                    <td class="col-sm-4"><fmt:formatDate value='${inDate}' pattern='yyyy-MM-dd HH:mm'/></td>

                                                    <td class="col-sm-2">出院日期</td>
                                                    <td class="col-sm-4"><fmt:formatDate value='${outDate}' pattern='yyyy-MM-dd HH:mm'/></td>
                                                </tr>
                                                <tr>
                                                    <td class="col-sm-2">住院天数</td>
                                                    <td class="col-sm-4">${inPatient.inHospitalDay}</td>

                                                    <td class="col-sm-2">年龄</td>
                                                    <td class="col-sm-4">${inPatient.age}</td>
                                                </tr>
                                                <tr>
                                                    <td class="col-sm-2">性别</td>
                                                    <td class="col-sm-4">
                                                        <c:if test="${inPatient.sex}">男</c:if>
                                                        <c:if test="${!inPatient.sex}">女</c:if>
                                                    </td>

                                                    <td class="col-sm-2">就诊科室</td>
                                                    <td class="col-sm-4">${inPatient.department}</td>
                                                </tr>
                                                <tr>
                                                    <td class="col-sm-2">主管医生</td>
                                                    <td class="col-sm-4">${inPatient.masterDoctorName}</td>

                                                    <td class="col-sm-2">药品组数</td>
                                                    <td class="col-sm-4">${inPatient.drugNum}</td>
                                                </tr>
                                                <tr>
                                                    <td class="col-sm-2">总金额</td>
                                                    <td class="col-sm-4">${inPatient.money}</td>

                                                    <td class="col-sm-2">药品金额</td>
                                                    <td class="col-sm-4">${inPatient.medicineMoney}</td>
                                                </tr>
                                                <tr>
                                                    <td class="col-sm-2">抗菌药品种数</td>
                                                    <td class="col-sm-4">${inPatient.antiNum}</td>

                                                    <td class="col-sm-3">抗菌药联用数</td>
                                                    <td class="col-sm-4">${inPatient.concurAntiNum}</td>
                                                </tr>
                                                </tbody>
                                            </table>

                                        </div>

                                        <div id="home2" class="tab-pane">
                                            <!-- #section:custom/scrollbar.horizontal -->
                                            <%--<div class="scrollable" data-size="600">--%>
                                            <div data-size="600">
                                                <div class="row">
                                                    <div class="col-xs-12">
                                                        <table id="diagnosis-table" class="table table-striped table-bordered table-hover">
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- /section:custom/scrollbar.horizontal -->
                                        </div>

                                        <div id="longTab" class="tab-pane">
                                            <table id="long-table" class="table table-striped table-bordered table-hover">
                                            </table>
                                        </div>

                                        <div id="shortTab" class="tab-pane">
                                            <table id="short-table" class="table table-striped table-bordered table-hover">
                                            </table>
                                        </div>
                                        <div id="surgeryTab" class="tab-pane">
                                            <table id="surgery-table" class="table table-striped table-bordered table-hover">
                                            </table>
                                        </div>
                                        <div id="lisTab" class="tab-pane">
                                            <div class="col-xs-3">
                                                <div class="dropdown dropdown-preview">
                                                    <ul class="dropdown-menu" style="width: 150px">
                                                        <li>
                                                            <a href="#" tabindex="-1">Action</a>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="col-xs-9">
                                                <div class="col-xs-12" id="itemHead">
                                                </div>
                                                <div class="col-xs-12  no-padding no-margin" style="overflow-y: auto;height: 450px ">
                                                    <table id="lis-table" class="table table-striped table-bordered table-hover">
                                                        <thead>
                                                        <tr>
                                                            <th>项目名称</th>
                                                            <th>检查结果</th>
                                                            <th>单位</th>
                                                            <th>参考范围</th>
                                                            <th>提示</th>
                                                        </tr>
                                                        </thead>
                                                        <tbody></tbody>
                                                    </table>
                                                </div>
                                                <%--Bootstrap中，只需为任意的 <table> 元素应用 .table 类，即可使用基本的表格样式。另外，还为表格提供了4个额外的辅助类 .table-striped、.table-bordered、.table-hover
                                                和 .table-condensed，分别用来实现带条纹背景的表格、带边框的表格、带悬停效果的表格、紧凑的表格。这 4个类之间互不排斥，可以根据需要，为一个表格同时应用多个类。--%>
                                            </div>
                                        </div>
                                        <div id="pacsTab" class="tab-pane">
                                            <div class="col-xs-12  no-padding no-margin" style="overflow-y: auto;height: 550px " id="pacsContent">
                                                {{#each data}}
                                                <div class="widget-box widget-color-purple" style="margin:0 0 10px 0"> <%-- widget-color-orange--%>
                                                    <div class="widget-header widget-header-small">
                                                        <h6 class="widget-title">
                                                            <i class="ace-icon fa fa-sort"></i>
                                                            {{xType}}
                                                        </h6>
                                                    </div>
                                                    <div class="widget-body">
                                                        <div class="widget-main">
                                                            {{#each pacs}}
                                                            <div class=" alert alert-info" style="margin: 5px 5px 5px 5px">
                                                                <div class="row">
                                                                    <div class="col-xs-5">{{checkBody}}</div>
                                                                    <div class="col-xs-4">检查日期：{{checkTime}}</div>
                                                                    <div class="col-xs-3">医生：{{doctorName}}</div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-xs-3"><strong>项目名称</strong></div>
                                                                    <div class="col-xs-9"><strong>检查结果</strong></div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-xs-3">{{checkBody}}</div>
                                                                    <div class="col-xs-9">{{checkDesc}}</div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-xs-10 col-xs-offset-1"><strong>小结：</strong>&nbsp;&nbsp;&nbsp;{{checkResult}}</div>
                                                                </div>
                                                            </div>
                                                            {{/each}}
                                                        </div>
                                                    </div>
                                                </div>
                                                {{/each}}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div><!-- /.row -->

            </div><!-- /.page-content -->
        </div><!-- /.main-container-inner -->
    </div><!-- /.main-content -->
    <div class="footer">
        <div class="footer-inner">
            <!-- #section:basics/footer -->
            <div class="footer-content">
 <span class="bigger-120"><span class="blue bolder">广州志创</span>网络科技有限公司 &copy; 2018
 </span>
            </div>
            <!-- /section:basics/footer -->
        </div>
    </div>
</div><!-- /.main-container -->
<div class="detail-row hidden" id="rowDetail">
    <div class="table-detail no-padding">
        溶剂：{{menstruum}}
    </div>
</div>

<div id="question-choose" class="modal fade" tabindex="-1">
    <input id="tableVar" type="hidden"/>
    <input id="rowNo" type="hidden"/>
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header no-padding">
                <div class="table-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        <span class="white">&times;</span>
                    </button>
                    <span id="qrCodeDialog-title">选择问题</span>
                </div>
            </div>

            <div class="modal-body no-padding">

                <table id="questionTable" class="table table-striped table-bordered table-hover no-margin-bottom no-border-top">
                    <thead>
                    <tr>
                        <th class="col-xs-1">选择</th>
                        <th class="col-xs-2" style="alignment: center">问题代码</th>
                        <th class="col-xs-9">问题描述</th>
                    </tr>
                    </thead>

                    <tbody>

                    </tbody>
                </table>
            </div>
            <div class="modal-footer no-margin-top">

                <button class="btn btn-sm btn-warning pull-right" id="saveQuestionBtn">
                    <i class="ace-icon fa fa-save"></i>
                    确定
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
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
</body>
</html>