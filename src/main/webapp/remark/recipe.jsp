<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>点评处方</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>

    <!-- basic styles -->
    <link href="../components/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet"/>

    <!-- bootstrap & fontawesome -->
    <link rel="stylesheet" href="../components/font-awesome/css/font-awesome.css"/>
    <!-- text fonts -->
    <link rel="stylesheet" href="../assets/css/ace-fonts.css"/>
    <!-- page specific plugin styles -->
    <!-- ace styles -->
    <link rel="stylesheet" href="../assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/> <!--重要-->
    <link rel="stylesheet" href="../assets/css/ace-skins.min.css"/>


    <link rel="stylesheet" href="../css/jqueryui/jquery-ui.min.css"/>
    <link rel="stylesheet" href="../components/jquery-ui.custom/jquery-ui.custom.css"/>
    <link rel="stylesheet" href="../js/datatables/select.dataTables.min.css"/>
    <link rel="stylesheet" href="../components/bootstrap-datepicker/dist/css/bootstrap-datepicker3.css"/>
    <link rel="stylesheet" href="../components/bootstrap-timepicker/css/bootstrap-timepicker.css"/>
    <link rel="stylesheet" href="../components/bootstrap-daterangepicker/daterangepicker.css"/>
    <link rel="stylesheet" href="../components/bootstrap-datetimepicker/bootstrap-datetimepicker.css"/>
    <link href="https://cdn.bootcss.com/bootstrap-datetimepicker/4.17.47/css/bootstrap-datetimepicker.css" rel="stylesheet">
    <link rel="stylesheet" href="../assets/css/bootstrap-editable.css"/>

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
    <script src="../js/html5shiv/dist/html5shiv.js"></script>
    <script src="../js/respond/dest/respond.min.js"></script>
    <![endif]-->
    <%--<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>--%>

    <!-- page specific plugin scripts -->
    <!-- static.html end-->
    <%--<script src="../components/jquery-ui.custom/jquery-ui.custom.js"></script>--%>
    <script src="../js/datatables/jquery.dataTables.min.js"></script>
    <%--<link rel="stylesheet" href="../components/chosen/chosen.css" />--%>

    <script src="../components/bootstrap-datepicker/dist/js/bootstrap-datepicker.js"></script>
    <script src="../components/moment/moment.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap-datetimepicker/4.17.47/js/bootstrap-datetimepicker.min.js"></script>
    <script src="../js/datatables/jquery.dataTables.bootstrap.min.js"></script>
    <script src="../js/datatables/dataTables.select.min.js"></script>
    <script src="../js/jquery-ui/jquery-ui.min.js"></script>
    <script src="../js/jquery-ui/ui/i18n/datepicker-zh-CN.js"></script>
    <script src="../components/typeahead.js/handlebars.js"></script>
    <script src="../assets/js/x-editable/bootstrap-editable.min.js"></script>

    <%--<script src="../assets/js/x-editable/ace-editable.min.js"></script>--%>
    <script src="../js/string_func.js"></script>
    <script src="../js/accounting.min.js"></script>

    <script type="text/javascript">
        jQuery(function ($) {
            var saveJson =${recipe.review.reviewJson};
            //console.log("saveJson:" + JSON.stringify(saveJson));

            var drugTable = $('#drugTable').DataTable({
                bAutoWidth: false,
                language: {info: '', infoEmpty: '', sZeroRecords: '', emptyTable: ''},
                paging: false, searching: false, ordering: false, "destroy": true,
                'columnDefs': [
                    {
                        "orderable": false, "data": 'recipeItemID', "targets": 0, width: 50, className: 'center', title: '治疗<br/>预防', render: function (data, type, row, meta) {
                            return '<input type="radio" name="{0}" value="治疗" {1}>□<br/><input type="radio" name="{2}" value="预防" {3}>△'
                                .format(data, row["purpose"] === "治疗" ? "checked" : "", data, row["purpose"] === "预防" ? "checked" : "");
                        }
                    },
                    {
                        "orderable": false, "data": "advice", "targets": 1, title: '药品通用名', render: function (data, type, row, meta) {
                            return data + (typeof (row["menstruum"]) === 'undefined' ? "" : "<br/><span class=\"light-grey\">溶剂</span>" + row["menstruum"]);
                        }
                    },
                    {
                        "orderable": false, "data": "singleQty", "targets": 2, width: 50, title: '单次<br/>剂量', className: 'center', render: function (data, type, row, meta) {
                            return '<a href="#" data-value="{0}" >{1}</a>'.format(data, data);
                        }
                    },
                    {
                        "orderable": false, "data": "frequency", "targets": 3, width: 50, title: '给药<br/>频次', className: 'center', render: function (data, type, row, meta) {
                            return '<a href="#" data-value="{0}" data-type="text" >{1}</a>'.format(data, data);
                        }
                    },
                    {
                        "orderable": false, "data": "adviceType", "targets": 4, title: '途径', render: function (data, type, row, meta) {
                            return '<a href="#" data-value="{0}" data-type="text" >{1}</a>'.format(data, data);
                        }
                    },
                    {
                        "orderable": false, "data": "quantity", "targets": 5, width: 50, title: '总用量', className: 'center', render: function (data, type, row, meta) {
                            return '<a href="#" id="total_quantity" data-value="{0}" data-type="text" >{1}</a>'.format(data, data);
                        }
                    },
                    {
                        "orderable": false, "data": "recipeDate", "targets": 6, className: 'center', title: '起止时间<br/><span class="light-grey" style="font-size: 7px">月日时分</span>',
                        render: function (data, type, row, meta) {
                            return '<a href="#" data-value="{0}" data-type="text" >{1}</a>'.format(data, data);
                        }
                    }
                ]

            });

            drugTable.on('draw', function (e, setting) {
                $('#form-field-antiNum').val(drugTable.data().length);
                $("#drugTable tr").find("td a[id!='total_quantity']").editable();
                $("#drugTable tr").find("td a[id='total_quantity']").editable({
                    success: function (response, newValue) {
                        var reg = /^[0-9]*$/;
                        if (reg.test(newValue)) {
                            var row = drugTable.row($(this).parent().closest('tr')).data();
                            row['quantity'] = parseInt(newValue);
                            sumAntiMoney();
                        }
                    }
                });

                sumAntiMoney();
            });

            function sumAntiMoney() {
                var antiMoney = 0;
                drugTable.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    var rowData = this.data();
                    antiMoney += rowData['price'] * rowData['quantity'];
                });
                $('#form-field-antiMoney').val(accounting.formatNumber(antiMoney, 2));
            }

            var longTable = $('#long-table').DataTable({
                bAutoWidth: false,
                paging: false, searching: false, ordering: false, "destroy": true,
                select: {style: 'multi', selector: 'td:first-child :checkbox'},
                'columnDefs': [
                    {
                        targets: 0, data: "recipeItemID", defaultContent: '', orderable: false, width: 10, /*className: 'select-checkbox',*/ render: function (data, type, row, meta) {
                            if (row['antiClass'] > 0) {
                                if (typeof (saveJson.用药情况) !== 'undefined')
                                    for (var i = 0; i < saveJson.用药情况.length; i++) {
                                        if (saveJson.用药情况[i].recipeItemID === data)
                                            return '<input type="checkbox" checked>';
                                    }
                                return '<input type="checkbox">';
                            }
                            return "";
                        }
                    },
                    {"orderable": false, "data": "recipeDate", "targets": 1, title: '开始时间', width: 90, className: 'center'},
                    {"orderable": false, "data": "adviceType", "targets": 2, title: '&nbsp;'},
                    {
                        "orderable": false, "data": "advice", "targets": 3, title: '医嘱内容', defaultContent: '', width: 120, render: function (data, type, row, meta) {
                            return row["antiClass"] > 0 ? "<span class='pink2'>" + data + "</span>" : data;
                        }
                    },
                    {"orderable": false, "data": "quantity", "targets": 4, title: '数量', width: 40, className: 'center'},
                    {"orderable": false, "data": "unit", "targets": 5, title: '单位', width: 40, className: 'center'},
                    {"orderable": false, "data": "doctorName", "targets": 6, title: '医生', width: 60},
                    {"orderable": false, "data": "nurseName", "targets": 7, title: '护士', width: 60},
                    {"orderable": false, "data": "endDate", "targets": 8, title: '停止时间', width: 90, className: 'center'},
                    {"orderable": false, "data": "endDoctorName", "targets": 9, title: '医生'},
                    {"orderable": false, "data": "endNurseName", "targets": 10, title: '护士'}
                ],
                "aaSorting": [],
                language: {
                    url: '../js/datatables/datatables.chinese.json',
                    select: {
                        rows: {
                            _: "已选择 %d 行", 0: "单击选行", 1: "仅选了 1 行"
                        }
                    }
                },

                scrollY: '60vh',
                "ajax": {
                    url: "/remark/getRecipeItemList.jspa?longAdvice=1&serialNo=${recipe.serialNo}",
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
                        targets: 0, data: "recipeItemID", defaultContent: '', orderable: false, width: 10, /*className: 'select-checkbox',*/ render: function (data, type, row, meta) {
                            if (row['antiClass'] > 0) {
                                if (typeof (saveJson.用药情况) !== 'undefined')
                                    for (var i = 0; i < saveJson.用药情况.length; i++) {
                                        if (saveJson.用药情况[i].recipeItemID === data)
                                            return '<input type="checkbox" checked>';
                                    }
                                return '<input type="checkbox">';
                            }
                            return "";
                        }
                    },
                    {"orderable": false, "data": "recipeDate", "targets": 1, title: '开始时间', width: 90, className: 'center'},
                    {"orderable": false, "data": "adviceType", "targets": 2, title: '&nbsp;'},
                    {
                        "orderable": false, "data": "advice", "targets": 3, title: '医嘱内容', defaultContent: '', width: 120, render: function (data, type, row, meta) {
                            return row["antiClass"] > 0 ? "<span class='pink2'>" + data + "</span>" : data;
                        }
                    },
                    {"orderable": false, "data": "quantity", "targets": 4, title: '数量', width: 40, className: 'center'},
                    {"orderable": false, "data": "unit", "targets": 5, title: '单位', width: 40, className: 'center'},
                    {"orderable": false, "data": "doctorName", "targets": 6, title: '医生', width: 60},
                    {"orderable": false, "data": "nurseName", "targets": 7, title: '护士', width: 60},
                    {"orderable": false, "data": "endDate", "targets": 8, title: '停止时间', width: 90, className: 'center'},
                    {"orderable": false, "data": "endDoctorName", "targets": 9, title: '医生'},
                    {"orderable": false, "data": "endNurseName", "targets": 10, title: '护士'}
                ],
                "aaSorting": [],
                language: {
                    url: '../js/datatables/datatables.chinese.json',
                    select: {
                        rows: {
                            _: "已选择 %d 行", 0: "单击选行", 1: "仅选了 1 行"
                        }
                    }
                },

                scrollY: '60vh',
                "ajax": {
                    url: "/remark/getRecipeItemList.jspa?longAdvice=2&serialNo=${recipe.serialNo}",
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
                shortTable.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    if (typeof (this.data()) !== 'undefined' && this.data()['antiClass'] > 0) {
                        var rowData = this.data();
                        $.getJSON("/remark/getMedicine.jspa?medicineNo=" + this.data()['medicineNo'], function (result) {
                            rowData['price'] = result.price;
                        });
                    }
                });
            }).on('select', function (e, dt, type, indexes) {
                chooseTab('#dropdown17');

                var index = parseInt(indexes);
                var rowData = jQuery.extend({}, shortTable.row(index).data());//浅层复制（克隆）
                var exists = false;
                //先判断是否存在，如存在不添加
                drugTable.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    //console.log("item:" + JSON.stringify(this.data()));
                    if (typeof (this.data()) !== 'undefined' && rowData["recipeItemID"] === this.data()["recipeItemID"])
                        exists = true;
                });
                if (exists) return;

                rowData['singleQty'] = rowData['quantity'];//todo remove
                rowData['frequency'] = rowData['quantity'];

                //不是每一行都有日期，向前找日期
                var dateIndex = -1;
                if (rowData['recipeDate'] == null || rowData['recipeDate'] === '') {
                    for (var aa = index - 1; aa >= 0; aa--)
                        if (shortTable.row(aa).data()['recipeDate'] !== '') {
                            dateIndex = aa;
                            rowData['recipeDate'] = shortTable.row(aa).data()['recipeDate'];
                            break;
                        }
                } else dateIndex = index;

                //向后找 用法
                for (var cc = index + 1; cc < index + 10; cc++) {//增加表行数判断
                    // console.log("medicineNo:" +JSON.stringify( shortTable.row(cc).data()));
                    if (shortTable.row(cc).data()['recipeDate'] > 0) break;
                    if (typeof (shortTable.row(cc).data()['adviceType']) !== 'undefined' && shortTable.row(cc).data()['adviceType'] === 's') {
                        rowData['adviceType'] = shortTable.row(cc).data()['advice'].replace('Sig:', '').replace(/(^\s+)|(\s+$)/g, '');
                        break;
                    }
                }
                //找 大输液
                if (dateIndex >= 0)
                    for (var cc = dateIndex; cc < index + 10; cc++) {/*增加表行数判断*/
                        //console.log("medicineNo:" + JSON.stringify(shortTable.row(cc).data()));
                        if (typeof (shortTable.row(cc).data()['medicineNo']) !== 'undefined') {

                            $.getJSON("/remark/getMedicine.jspa?medicineNo=" + shortTable.row(cc).data()['medicineNo'], function (result) {
                                //if (result.healthNo === '401801' || result.healthNo === '401802') {
                                if (result.healthNo.startsWith('4018')) {
                                    rowData['menstruum'] = shortTable.row(cc).data()['advice'];
                                    //drugTable.draw(false);
                                    var tr = $("#drugTable tr:last");
                                    tr.find("td:eq(1)").html(tr.find("td:eq(1)").text() + '<br/><span class="light-grey">溶剂：</span>' + rowData['menstruum']);//render无效，只能增加这句
                                }
                            });
                            rowData['medicineNo'] = shortTable.row(cc).data()['medicineNo'];
                            break;
                        }
                    }
                //console.log("recipeDate:" + rowData['recipeDate'].replace(/20\d\d-/g, ''));
                if (rowData['recipeDate'] !== null && rowData['recipeDate'] !== '')
                    rowData['recipeDate'] = rowData['recipeDate'].replace(/20\d\d-/g, '');

                drugTable.row.add(rowData).draw(true);
            }).on('deselect', function (e, dt, type, indexes) {
                var rowData = shortTable.row(indexes).data();

                drugTable.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    // console.log("item:" + JSON.stringify(this.data()));
                    if (typeof (this.data()) !== 'undefined' && rowData["recipeItemID"] === this.data()["recipeItemID"])
                        drugTable.row(rowIdx).remove().draw();
                });
            });
            longTable.on('draw', function (e, settings) {
                //加载时，通过render函数增加了checked，这里把整行选上
                $('#long-table tr').find('input[type="checkbox"]:checked').parent().parent().each(function (index, element) {
                    longTable.row(element).select();
                });
                longTable.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    if (typeof (this.data()) !== 'undefined' && this.data()['antiClass'] > 0) {
                        var rowData = this.data();
                        $.getJSON("/remark/getMedicine.jspa?medicineNo=" + this.data()['medicineNo'], function (result) {
                            rowData['price'] = result.price;
                        });
                    }
                });
            }).on('select', function (e, dt, type, indexes) {
                chooseTab('#dropdown17');

                var index = parseInt(indexes);
                var rowData = jQuery.extend({}, longTable.row(index).data());//浅层复制（克隆）
                var exists = false;
                //先判断是否存在，如存在不添加
                drugTable.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    //console.log("item:" + JSON.stringify(this.data()));
                    if (typeof (this.data()) !== 'undefined' && rowData["recipeItemID"] === this.data()["recipeItemID"])
                        exists = true;
                });
                if (exists) return;
                if (typeof (rowData['price']) === 'undefined' && typeof (rowData['medicineNo']) !== 'undefined')
                    $.getJSON("/remark/getMedicine.jspa?medicineNo=" + rowData['medicineNo'], function (result) {
                        console.log("price:" + result.price);
                        rowData['price'] = result.price;
                    });

                rowData['singleQty'] = rowData['quantity'];//todo remove
                rowData['frequency'] = rowData['quantity'];

                //不是每一行都有日期，向前找日期
                var dateIndex = -1;
                if (rowData['recipeDate'] == null || rowData['recipeDate'] === '') {
                    for (var aa = index - 1; aa >= 0; aa--)
                        if (longTable.row(aa).data()['recipeDate'] !== '') {
                            dateIndex = aa;
                            rowData['recipeDate'] = longTable.row(aa).data()['recipeDate'];
                            break;
                        }
                } else dateIndex = index;

                //向后找 用法
                for (var cc = index + 1; cc < index + 10; cc++) {//增加表行数判断
                    // console.log("medicineNo:" +JSON.stringify( longTable.row(cc).data()));
                    if (longTable.row(cc).data()['recipeDate'] > 0) break;
                    if (typeof (longTable.row(cc).data()['adviceType']) !== 'undefined' && longTable.row(cc).data()['adviceType'] === 's') {
                        rowData['adviceType'] = longTable.row(cc).data()['advice'].replace('Sig:', '').replace(/(^\s+)|(\s+$)/g, '');
                        break;
                    }
                }
                //找 大输液
                if (dateIndex >= 0)
                    for (var cc = dateIndex; cc < index + 10; cc++) {/*增加表行数判断*/
                        //console.log("medicineNo:" + JSON.stringify(longTable.row(cc).data()));
                        if (typeof (longTable.row(cc).data()['medicineNo']) !== 'undefined') {

                            $.getJSON("/remark/getMedicine.jspa?medicineNo=" + longTable.row(cc).data()['medicineNo'], function (result) {
                                //if (result.healthNo === '401801' || result.healthNo === '401802') {
                                if (result.healthNo.startsWith('4018')) {
                                    rowData['menstruum'] = longTable.row(cc).data()['advice'];
                                    //drugTable.draw(false);
                                    var tr = $("#drugTable tr:last");
                                    tr.find("td:eq(1)").html(tr.find("td:eq(1)").text() + '<br/><span class="light-grey">溶剂：</span>' + rowData['menstruum']);//render无效，只能增加这句
                                }
                            });
                            rowData['medicineNo'] = longTable.row(cc).data()['medicineNo'];
                            break;
                        }
                    }
                //console.log("recipeDate:" + rowData['recipeDate'].replace(/20\d\d-/g, ''));
                //console.log("recipeDate:" + rowData['recipeDate'] );

                if (rowData['endDate'] === null)
                    rowData['endDate'] = '<fmt:formatDate value='${outDate}' pattern='MM-dd HH:mm'/>';
                if (rowData['recipeDate'] !== null && rowData['recipeDate'] !== '')
                    rowData['recipeDate'] = rowData['recipeDate'].replace(/20\d\d-/g, '');
                rowData['recipeDate'] = rowData['recipeDate'] + "～" + rowData['endDate'];

                drugTable.row.add(rowData).draw(true);
            }).on('deselect', function (e, dt, type, indexes) {
                var rowData = longTable.row(indexes).data();

                drugTable.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    // console.log("item:" + JSON.stringify(this.data()));
                    if (typeof (this.data()) !== 'undefined' && rowData["recipeItemID"] === this.data()["recipeItemID"])
                        drugTable.row(rowIdx).remove().draw();
                });
            });
            $('#surgery-table').DataTable({
                bAutoWidth: true,
                paging: false, searching: false, ordering: false, "destroy": true,

                "columns": [
                    {"data": "surgeryID"},
                    {"data": "surgeryDate", "sClass": "center"},
                    {"data": "incision", "sClass": "center"},
                    {"data": "surgeryName", "sClass": "center"},
                    {"data": "healOver", "sClass": "center"}
                ],

                'columnDefs': [
                    {
                        "orderable": false, "targets": 0, width: 15, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {"orderable": false, "targets": 1, title: '手术时间', width: 130},
                    {"orderable": false, "targets": 2, title: '切口类型'},
                    {"orderable": false, "targets": 3, title: '操作名称'},
                    {"orderable": false, "targets": 4, title: '愈合方式'}
                ],
                "aaSorting": [],
                language: {
                    url: '../js/datatables/datatables.chinese.json'
                },
                scrollY: '60vh',
                "ajax": {
                    url: "/remark/getSurgerys.jspa?serialNo=${recipe.serialNo}",
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                }
            });

            function chooseTab(tabId) {
                //$('#myTab3 a[href="' + tabId + '"]').parent().tab('show');
                /* $('#myTab3 li').removeClass("active");
                $('#myTab3 a[href="' + tabId + '"]').parent().addClass("active");
                $("#divTab1 div").removeClass("active");
                $(tabId).addClass("active");*/
            }

            var diagnosisTable = $('#diagnosis-table').DataTable({
                bAutoWidth: false,
                paging: false, searching: false, ordering: false, "destroy": true, "info": false,
                select: {style: 'multi', selector: 'td:first-child :checkbox'},
                'columnDefs': [
                    {
                        targets: 0, data: "diagnosisNo", orderable: false, width: 10, //className: 'select-checkbox',
                        render: function (data, type, row, meta) {
                            if (typeof (saveJson.诊断) !== 'undefined')
                                for (var i = 0; i < saveJson.诊断.length; i++) {
                                    if (saveJson.诊断[i].diagnosisNo === data)
                                        return '<input type="checkbox" checked>';
                                }
                            return '<input type="checkbox">';
                        }
                    },
                    {"orderable": false, "data": "type", "targets": 1, title: '类型', defaultContent: ''},
                    {"orderable": false, "data": "disease", "targets": 2, title: '诊断', defaultContent: ''},
                    {"orderable": false, "data": "icd", "targets": 3, title: 'ICD', defaultContent: ''},
                    {"orderable": false, "data": "originalChs", "targets": 4, title: '入院病情', defaultContent: ''}
                ],
                "aaSorting": [],
                language: {
                    url: '../js/datatables/datatables.chinese.json'
                },
                scrollY: '60vh',
                "ajax": {
                    //url:"/remark/getDiagnosis.jspa?serialNo=${recipe.serialNo}&archive=${recipe.archive}",
                    url: "/remark/getDiagnosis.jspa?serialNo=0000593702&archive=1",
                    "data": function (d) {//删除多余请求参数
                        for (var key in d)
                            if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                                delete d[key];
                    }
                }
            });
            diagnosisTable.on('select', function (e, dt, type, indexes) {
                chooseTab('#home3');
                var rowData = diagnosisTable.row(indexes).data();
                var exists = false;
                /*先判断是否存在，如存在不添加*/
                $("#chooseDiagnosis tr").each(function (i, item) {
                    if (rowData["diagnosisNo"] === $(item).attr("data-id"))
                        exists = true;
                });
                if (exists) return;

                $("#chooseDiagnosis tr:last").after(Handlebars.compile("<tr data-id='{{diagnosisNo}}'><td>{{type}}</td><td>{{disease}}</td></tr>")(rowData));
            }).on('deselect', function (e, dt, type, indexes) {
                var rowData = diagnosisTable.row(indexes).data();
                $("#chooseDiagnosis tr").each(function (i, item) {
                    if (rowData["diagnosisNo"] === $(item).attr("data-id"))
                        $(this).remove();
                });
            }).on('draw', function (e, settings) {
                //加载时，通过render函数增加了checked，这里把整行选上
                $('#diagnosis-table tr').find('input[type="checkbox"]:checked').parent().parent().each(function (index, element) {
                    diagnosisTable.row(element).select();
                });
            });

            /* $('#diagnosis-table tbody').on('click', 'input[type="checkbox"]', function (e) {
            console.log("checkbox click");
            var $row = $(this).closest('tr');

            // Get row data
            var data = table.row($row).data();

            // Get row ID
            var rowId = data["diagnosisNo"];
            console.log("rowID:" + rowId);
            });*/

            // Handle click on table cells with checkboxes
            /* $('#diagnosis-table').on('click', 'tbody td, thead th:first-child', function (e) {
            console.log("checkbox click2");
            $(this).parent().find('input[type="checkbox"]').trigger('click');
            });*/
            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                //当切换tab时，强制重新计算列宽
                $.fn.dataTable.tables({visible: true, api: true}).columns.adjust().draw();
            });
            var loadData = 0;
            $('#courseTabIndex').click(function () {
                if ((loadData & 1) === 0)
                    $.getJSON("/remark/getCourse.jspa?serialNo=0014196001&departCode=${recipe.departCode}&archive=${recipe.archive}", function (result) {
                        //$.getJSON("/remark/getCourse.jspa?serialNo=${recipe.serialNo}&departCode=${recipe.departCode}&archive=${recipe.archive}", function (result) {
                        var template = Handlebars.compile($('#courseContent').html());
                        var htmlArray = [];
                        $.each(result.data, function (index, value) {
                            htmlArray.push(template(value));
                        });
                        var html = htmlArray.join('');
                        $('#courseContent').html(html.replace(/&nbsp;/ig, ''));

                        loadData &= 1;
                    });

            });
            $('#historyTabIndex').click(function () {
                if ((loadData & 2) === 0)
                    $.getJSON("/remark/showHistory.jspa?serialNo=0014196001&departCode=${recipe.departCode}&archive=${recipe.archive}", function (result) {
                        //$.getJSON("/remark/getCourse.jspa?serialNo=${recipe.serialNo}&departCode=${recipe.departCode}&archive=${recipe.archive}", function (result) {
                        var template = Handlebars.compile($('#historyContent').html());

                        $('#historyContent').html(template(result));

                        loadData &= 2;
                    });

            });

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

            if (!ace.vars['old_ie']) $('#id-surgeryTime1,#id-surgeryTime2').datetimepicker({
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
            }).on('show', function () {
                console.log("zIndex:" + $("#kkk").zIndex());
                $(".datetimepicker").css("z-index", $("#kkk").zIndex() + 1);
            }).on('hide', function () {
                console.log("hide");
            });
            //导出
            $('.btn-info').on('click', function (e) {
                window.location.href = "getRecipeExcel.jspa?recipeID=${recipe.recipeID}&batchID=${batchID}";
            });

            var json = {recipeID:${recipe.recipeID}, serialNo: '${recipe.serialNo}', recipeReviewID:${recipe.review.recipeReviewID}, reviewUser: '${currentUser}'};
            //保存
            $('.btn-success').on('click', function (e) {
                var baseInfo = {};

                baseInfo.sex = $('input:radio[name="form-field-radio-sex"]:checked').val();
                baseInfo.age = $('#form-field-age').val();
                baseInfo.weight = $('#form-field-weight').val();
                baseInfo.inHospital = $('#id-date-picker-inHospital').val();
                baseInfo.outHospital = $('#id-date-picker-outHospital').val();
                json.基本信息 = baseInfo;

                var diagnosis = [];
                $("#chooseDiagnosis tr:gt(0)").each(function (i, item) {
                    //if ($(item).attr("data-id") !== null) {
                    diagnosis.push({"diagnosisNo": $(item).attr("data-id"), "type": $(item).find("td:eq(0)").text(), "disease": $(item).find("td:eq(1)").text()});
                    //}
                });
                json.诊断 = diagnosis;

                var allergy = {};
                allergy.is = $('input:radio[name="form-field-allergy"]:checked').val();
                allergy.generalName = $('#form-field-generalName').val();
                json.过敏史 = allergy;

                var lab = {micro: "", checkout: ""};
                lab.temperature1 = $('#form-field-temperature1').val();
                lab.temperature1_time = $('#temperature1_time').val();
                lab.wbc1 = $('#form-field-wbc1').val();
                lab.wbc1_time = $('#wbc1_time').val();
                lab.neut1 = $('#form-field-neut1').val();
                lab.neut1_time = $('#neut1_time').val();
                lab.alt1 = $('#form-field-alt1').val();
                lab.alt1_time = $('#alt1_time').val();
                lab.cr1 = $('#form-field-cr1').val();
                lab.cr1_time = $('#cr1_time').val();

                lab.temperature2 = $('#form-field-temperature2').val();
                lab.temperature2_time = $('#temperature2_time').val();
                lab.wbc2 = $('#form-field-wbc2').val();
                lab.wbc2_time = $('#wbc2_time').val();
                lab.neut2 = $('#form-field-neut2').val();
                lab.neut2_time = $('#neut2_time').val();
                lab.alt2 = $('#form-field-alt2').val();
                lab.alt2_time = $('#alt2_time').val();
                lab.cr2 = $('#form-field-cr2').val();
                lab.cr2_time = $('#cr2_time').val();
                lab.micro = $('input:radio[name="form-field-micro"]:checked').val();
                lab.micro_time = $('#micro_time').val();
                lab.sample = $('#form-field-sample').val();
                lab.checkout = $('input:radio[name="form-field-checkout"]:checked').val();
                lab.germName = $('#form-field-germName').val();
                lab.sensitive = $('input:radio[name="form-field-sensitive"]:checked').val();
                lab.sensitive_time = $('#sensitive_time').val();
                lab.match = $('input:radio[name="form-field-match"]:checked').val();
                json.实验室检查 = lab;

                <c:if test="${batch.surgery==0}">
                var imaging = {imaging: 0};
                imaging.part = $('#form-field-part').val();
                imaging.conclusion = $('#form-field-conclusion').val();
                $("input:checkbox[name='form-field-imaging']:checked").each(function () {
                    imaging.imaging += parseInt($(this).val());
                });
                json.影像学检查 = imaging;

                json.临床症状 = $('#form-field-symptom').val();
                </c:if>
                <c:if test="${batch.surgery==1}">
                var surgery = {incision: 0, drugItem: 0};
                surgery.name = $('#form-field-surgeryName').val();
                $("input:checkbox[name='form-field-incision']:checked").each(function () {
                    surgery.incision += parseInt($(this).val());
                });
                surgery.startTime = $('#id-surgeryTime1').val();
                surgery.endTime = $('#id-surgeryTime2').val();

                $("input:checkbox[name='form-field-drugItem']:checked").each(function () {
                    surgery.drugItem += parseInt($(this).val());
                });

                surgery.surgeryDrug = $('input:radio[name="form-field-surgeryDrug"]:checked').val();

                json.手术情况 = surgery;
                </c:if>

                var purpose = {};
                purpose.purpose = $('input:radio[name="form-field-purpose"]:checked').val();
                purpose.infection = $('#form-field-infection').val();
                json.用药目的 = purpose;

                var drug = [];
                //var nullRow = 0;
                drugTable.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    if (typeof (this.data()) !== 'undefined') {
                        var trRow = $("#drugTable tbody tr").eq(rowIdx);
                        /* var check = trRow.find('input:radio:checked').val();
                         console.log("check:" + check);*/
                        drug.push({
                            "recipeItemID": this.data()["recipeItemID"],
                            "advice": this.data()["advice"],
                            "price": this.data()["price"],
                            "medicineNo": this.data()["medicineNo"],
                            "singleQty": trRow.find("td:eq(2)").text(),
                            "frequency": trRow.find("td:eq(3)").text(),
                            "adviceType": trRow.find("td:eq(4)").text(),
                            "quantity": trRow.find("td:eq(5)").text(),
                            "menstruum": this.data()["menstruum"],
                            "purpose": trRow.find('input:radio:checked').val(),//todo valid not null
                            "recipeDate": this.data()["recipeDate"]
                        });
                        //if (this.data()["menstruum"] !== null) nullRow++;
                    }
                });

                json.用药情况 = drug;
                json.用药情况统计 = {antiNum: $('#form-field-antiNum').val(), antiDays: $('#form-field-antiDays').val()};

                var money = {};
                money.money = $('#form-field-money').val();
                money.antiMoney = $('#form-field-antiMoney').val();
                money.medicineMoney = $('#form-field-medicineMoney').val();
                json.费用 = money;

                var result = {};
                result.result = $('input:radio[name="form-field-result"]:checked').val();
                result.secondary = $('input:radio[name="form-field-secondary"]:checked').val();
                result.antimycotic = $('input:radio[name="form-field-antimycotic"]:checked').val();
                json.治疗结果 = result;

                var rational = {me: 0, central: 0};
                $("input:checkbox[name='form-field-me']:checked").each(function () {
                    rational.me += parseInt($(this).val());
                });
                $("input:checkbox[name='form-field-central']:checked").each(function () {
                    rational.central += parseInt($(this).val());
                });
                json.用药合理性评价 = rational;

                json.备注 = $('#form-field-memo').val();

                console.log("json:" + JSON.stringify(json));

                $.ajax({
                    type: "POST",
                    url: 'saveRecipe.jspa',
                    data: JSON.stringify(json),
                    contentType: "application/json; charset=utf-8",
                    cache: false,
                    success: function (response, textStatus) {
                        showDialog(response.succeed ? "保存成功" : "保存失败", response.message);
                        if (response.succeed) {
                            $('.btn-info').removeClass("hidden");
                            json.recipeReviewID = response.recipeReviewID;
                        }
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        showDialog("请求状态码：" + response.status, response.responseText.substr(0, 1000));
                    },
                });
            });


            function fillout() {
                if (typeof (saveJson.基本信息) === 'undefined')
                    return;
                $('.btn-info').removeClass("hidden");

                //基本信息
                $('input:radio[name="form-field-radio-sex"][value="' + saveJson.基本信息.sex + '"]').prop("checked", "checked");
                $('#form-field-age').val(saveJson.基本信息.age);
                $('#form-field-weight').val(saveJson.基本信息.weight);
                $('#id-date-picker-inHospital').val(saveJson.基本信息.inHospital);
                $('#id-date-picker-outHospital').val(saveJson.基本信息.outHospital);

                for (var i = 0; i < saveJson.诊断.length; i++)
                    $("#chooseDiagnosis tr:last").after(Handlebars.compile("<tr data-id='{{diagnosisNo}}'><td>{{type}}</td><td>{{disease}}</td></tr>")(saveJson.诊断[i]));

                //过敏史
                $('input:radio[name="form-field-allergy"][value="' + saveJson.过敏史.is + '"]').prop("checked", "checked");
                $('#form-field-generalName').val(saveJson.过敏史.generalName);

                $('#form-field-temperature1').val(saveJson.实验室检查.temperature1);
                $('#temperature1_time').val(saveJson.实验室检查.temperature1_time);
                $('#form-field-wbc1').val(saveJson.实验室检查.wbc1);
                $('#wbc1_time').val(saveJson.实验室检查.wbc1_time);
                $('#form-field-neut1').val(saveJson.实验室检查.neut1);
                $('#neut1_time').val(saveJson.实验室检查.neut1_time);
                $('#form-field-alt1').val(saveJson.实验室检查.alt1);
                $('#alt1_time').val(saveJson.实验室检查.alt1_time);
                $('#form-field-cr1').val(saveJson.实验室检查.cr1);
                $('#cr1_time').val(saveJson.实验室检查.cr1_time);

                $('#form-field-temperature2').val(saveJson.实验室检查.temperature2);
                $('#temperature2_time').val(saveJson.实验室检查.temperature2_time);
                $('#form-field-wbc2').val(saveJson.实验室检查.wbc2);
                $('#wbc2_time').val(saveJson.实验室检查.wbc2_time);
                $('#form-field-neut2').val(saveJson.实验室检查.neut2);
                $('#neut2_time').val(saveJson.实验室检查.neut2_time);
                $('#form-field-alt2').val(saveJson.实验室检查.alt2);
                $('#alt2_time').val(saveJson.实验室检查.alt2_time);
                $('#form-field-cr2').val(saveJson.实验室检查.cr2);
                $('#cr2_time').val(saveJson.实验室检查.cr2_time);
                $('input:radio[name="form-field-micro"][value="' + saveJson.实验室检查.micro + '"]').prop("checked", "checked");
                $('#micro_time').val(saveJson.实验室检查.micro_time);
                $('#form-field-sample').val(saveJson.实验室检查.sample);
                $('input:radio[name="form-field-checkout"][value="' + saveJson.实验室检查.checkout + '"]').prop("checked", "checked");
                $('#form-field-germName').val(saveJson.实验室检查.germName);
                $('input:radio[name="form-field-sensitive"][value="' + saveJson.实验室检查.sensitive + '"]').prop("checked", "checked");
                $('#sensitive_time').val(saveJson.实验室检查.sensitive_time);
                $('input:radio[name="form-field-match"][value="' + saveJson.实验室检查.match + '"]').prop("checked", "checked");
                <c:if test="${batch.surgery==0}">
                $('#form-field-part').val(saveJson.影像学检查.part);
                $('#form-field-conclusion').val(saveJson.影像学检查.conclusion);
                $("input:checkbox[name='form-field-imaging']").each(function () {
                    $(this).attr("checked", (saveJson.影像学检查.imaging & $(this).val()) === parseInt($(this).val()));
                });

                $('#form-field-symptom').val(saveJson.临床症状);
                </c:if>
                <c:if test="${batch.surgery==1}">
                $('#form-field-surgeryName').val(saveJson.手术情况.name);
                $("input:checkbox[name='form-field-incision']").each(function () {
                    $(this).attr("checked", (saveJson.手术情况.incision & $(this).val()) === parseInt($(this).val()));
                });
                $('#id-surgeryTime1').val(saveJson.手术情况.startTime);
                $('#id-surgeryTime2').val(saveJson.手术情况.endTime);
                $("input:checkbox[name='form-field-drugItem']").each(function () {
                    $(this).attr("checked", (saveJson.手术情况.drugItem & $(this).val()) === parseInt($(this).val()));
                });

                $('input:radio[name="form-field-surgeryDrug"][value="' + saveJson.手术情况.surgeryDrug + '"]').prop("checked", "checked");
                </c:if>

                $('#form-field-infection').val(saveJson.用药目的.infection);
                $('input:radio[name="form-field-purpose"][value="' + saveJson.用药目的.purpose + '"]').prop("checked", "checked");

                for (i = 0; i < saveJson.用药情况.length; i++)
                    drugTable.row.add(saveJson.用药情况[i]).draw(false);

                $('#form-field-antiNum').val(saveJson.用药情况统计.antiNum);
                $('#form-field-antiDays').val(saveJson.用药情况统计.antiDays);

                $('#form-field-money').val(saveJson.费用.money);
                $('#form-field-antiMoney').val(saveJson.费用.antiMoney);
                $('#form-field-medicineMoney').val(saveJson.费用.medicineMoney);

                $('input:radio[name="form-field-result"][value="' + saveJson.治疗结果.result + '"]').prop("checked", "checked");
                $('input:radio[name="form-field-secondary"][value="' + saveJson.治疗结果.secondary + '"]').prop("checked", "checked");
                $('input:radio[name="form-field-antimycotic"][value="' + saveJson.治疗结果.antimycotic + '"]').prop("checked", "checked");

                $("input:checkbox[name='form-field-me']").each(function () {
                    $(this).attr("checked", (saveJson.用药合理性评价.me & $(this).val()) === parseInt($(this).val()));
                });
                $("input:checkbox[name='form-field-central']").each(function () {
                    $(this).attr("checked", (saveJson.用药合理性评价.central & $(this).val()) === parseInt($(this).val()));
                });

                $('#form-field-memo').val(saveJson.备注);

            }

            fillout();

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
                    <div class="col-sm-6">
                        <%--<h3 class="header smaller lighter red">点评</h3>--%>
                        <h4 class="header smaller lighter blue">点评
                            <span class="light-grey smaller-50">点评人：${currentUser}</span>
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

                        <form id="recipeForm">
                            <!-- #section:elements.tab.position -->
                            <div class="tabbable tabs-left">
                                <ul class="nav nav-tabs" id="myTab3">
                                    <li class="active"><a data-toggle="tab" href="#dropdown23">基本情况</a></li>
                                    <li><a data-toggle="tab" href="#home3">诊断</a></li>
                                    <li><a data-toggle="tab" href="#profile3">过敏史</a></li>
                                    <li><a data-toggle="tab" href="#dropdown13">实验室检查</a></li>
                                    <c:if test="${batch.surgery==0}">
                                        <li><a data-toggle="tab" href="#dropdown14">影像学诊断</a></li>
                                        <li><a data-toggle="tab" href="#dropdown15">临床症状</a></li>
                                    </c:if>
                                    <c:if test="${batch.surgery==1}">
                                        <li><a data-toggle="tab" href="#dropdown88">手术情况</a></li>
                                    </c:if>
                                    <li><a data-toggle="tab" href="#dropdown16">用药目的</a></li>
                                    <li><a data-toggle="tab" href="#dropdown17">用药情况</a></li>
                                    <li><a data-toggle="tab" href="#dropdown18">费用</a></li>
                                    <li><a data-toggle="tab" href="#dropdown19">治疗结果</a></li>
                                    <li><a data-toggle="tab" href="#dropdown20">用药合理<br/>性评价</a></li>
                                    <li><a data-toggle="tab" href="#dropdown21">备注</a></li>
                                    <li><a data-toggle="tab" href="#dropdown22">说明</a></li>
                                </ul>

                                <div class="tab-content" id="divTab1">
                                    <div id="dropdown23" class="tab-pane  in active">
                                        <div class="well well-sm" style="height: 170px">
                                            <div class="control-group col-xs-12">
                                                <span class="lbl">性别：</span>
                                                <input name="form-field-radio-sex" type="radio" class="ace" value="男"
                                                       <c:if test="${recipe.sex}">checked</c:if> />
                                                <span class="lbl">男</span>
                                                <input name="form-field-radio-sex" type="radio" class="ace" value="女" <c:if test="${!recipe.sex}">checked</c:if>/>
                                                <span class="lbl">女</span>
                                            </div>
                                            <div class="form-inline col-xs-12" style="margin-top: 10px;">
                                                <label class="control-label" for="form-field-age" style="text-overflow:ellipsis; white-space:nowrap;">年龄</label>
                                                <input type="text" id="form-field-age" placeholder="年龄" class="no-padding" style="width: 60px;text-align: center" value="${recipe.age.trim()}"/>
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

                                    <div id="profile3" class="tab-pane">
                                        <div class="well well-sm" style="height: 80px">
                                            <div class="control-group form-inline col-xs-12">
                                                <input name="form-field-allergy" type="radio" class="ace" value="无" checked/><%--默认：checked，否则空错误--%>
                                                <span class="lbl">无</span>
                                                <input name="form-field-allergy" type="radio" class="ace" value="有"/>
                                                <span class="lbl">有</span>
                                            </div>
                                            <div class="form-inline col-xs-12" style="margin-top: 10px;">
                                                <label class="control-label col-xs-4" for="form-field-generalName" style="text-overflow:ellipsis; white-space:nowrap;">抗菌药品通用名</label><%--style="text-overflow:ellipsis; white-space:nowrap;"--%>
                                                <input type="text" id="form-field-generalName" placeholder="通用名" class="no-padding col-xs-8"/>
                                            </div>
                                        </div>
                                    </div>

                                    <div id="dropdown13" class="tab-pane">
                                        <div class="well well-sm" style="height: 160px;">
                                            <h6 class="green lighter">用药前</h6>
                                            <div class="form-inline no-padding">
                                                <label class="control-label col-xs-4" for="form-field-temperature1" style="text-overflow:ellipsis; white-space:nowrap;">体温</label>
                                                <div class="col-xs-3">
                                                    <div class="input-group col-xs-3">
                                                        <input type="text" id="form-field-temperature1" placeholder="℃" class="no-padding"/>
                                                        <%--<label class="control-label" style="text-overflow:ellipsis; white-space:nowrap;">℃</label>--%>
                                                    </div>
                                                </div>
                                                <div class="col-xs-5">
                                                    <div class="input-group col-xs-4">
                                                        <input class="date-picker no-padding" style="width: 100px" id="temperature1_time" type="text" data-date-format="YYYY-MM-DD"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class=" form-inline no-padding">
                                                <label class="col-xs-4 control-label" for="form-field-wbc1" style="text-overflow:ellipsis; white-space:nowrap;">
                                                    白细胞计数（WBC）</label>
                                                <div class="col-xs-3">
                                                    <div class="input-group">
                                                        <input type="text" id="form-field-wbc1" placeholder="白细胞" class="no-padding"/>
                                                    </div>
                                                </div>

                                                <div class="col-xs-5">
                                                    <div class="input-group">
                                                        <input class="date-picker no-padding" style="width: 100px" id="wbc1_time" type="text" data-date-format="yyyy-mm-dd"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                </div>
                                            </div><!--row-->
                                            <div class="form-inline no-padding">
                                                <label class="col-xs-4 control-label" for="form-field-neut1" style="text-overflow:ellipsis; white-space:nowrap;">
                                                    中性粒细胞（NEUT%）</label>
                                                <div class="col-xs-3">
                                                    <div class="input-group">
                                                        <input type="text" id="form-field-neut1" placeholder="中性粒细胞" class="no-padding"/>
                                                    </div>
                                                </div>

                                                <div class="col-xs-5">
                                                    <div class="input-group">
                                                        <input class=" date-picker no-padding" style="width: 100px" id="neut1_time" type="text" data-date-format="yyyy-mm-dd"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-inline no-padding">
                                                <label class="col-xs-4 control-label" for="form-field-alt1" style="text-overflow:ellipsis; white-space:nowrap;">
                                                    谷丙转氨酶（ALT）</label>
                                                <div class="col-xs-3">
                                                    <div class="input-group">
                                                        <input type="text" id="form-field-alt1" placeholder="谷丙转氨酶" class="no-padding"/>
                                                    </div>
                                                </div>

                                                <div class="col-xs-5">
                                                    <div class="input-group">
                                                        <input class=" date-picker no-padding" style="width: 100px" id="alt1_time" type="text" data-date-format="yyyy-mm-dd"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-inline no-padding">
                                                <label class="col-xs-4 control-label" for="form-field-cr1" style="text-overflow:ellipsis; white-space:nowrap;">
                                                    肌酐（Cr）</label>
                                                <div class="col-xs-3">
                                                    <div class="input-group">
                                                        <input type="text" id="form-field-cr1" placeholder="肌酐" class="no-padding"/>
                                                    </div>
                                                </div>

                                                <div class="col-xs-5">
                                                    <div class="input-group">
                                                        <input class=" date-picker no-padding" style="width: 100px" id="cr1_time" type="text" data-date-format="yyyy-mm-dd"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="well well-sm" style="height: 160px">
                                            <h6 class="green lighter">用药后</h6>
                                            <div class=" form-inline no-padding">
                                                <label class="control-label col-xs-4" for="form-field-temperature2" style="text-overflow:ellipsis; white-space:nowrap;">体温</label>
                                                <div class="col-xs-3">
                                                    <div class="input-group col-xs-2">
                                                        <input type="text" id="form-field-temperature2" width="30" placeholder="℃" class="no-padding"/>
                                                        <%--<span class="input-group-addon no-padding">℃</span>--%>
                                                    </div>
                                                </div>
                                                <%--<div class="space-1"></div>--%>
                                                <div class="col-xs-5">
                                                    <div class="input-group col-xs-4">
                                                        <input class="date-picker <%--form-control --%> no-padding" style="width: 100px" id="temperature2_time" type="text" data-date-format="YYYY-MM-DD"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class=" form-inline no-padding">
                                                <label class="col-xs-4 control-label" for="form-field-wbc2" style="text-overflow:ellipsis; white-space:nowrap;">
                                                    白细胞计数（WBC）</label>
                                                <div class="col-xs-3">
                                                    <div class="input-group">
                                                        <input type="text" id="form-field-wbc2" placeholder="白细胞" class="no-padding"/>
                                                    </div>
                                                </div>

                                                <div class="col-xs-5">
                                                    <div class="input-group">
                                                        <input class="date-picker no-padding" style="width: 100px" id="wbc2_time" type="text" data-date-format="yyyy-mm-dd"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                </div>
                                            </div><!--row-->
                                            <div class="form-inline no-padding">
                                                <label class="col-xs-4 control-label" for="form-field-neut2" style="text-overflow:ellipsis; white-space:nowrap;">
                                                    中性粒细胞（NEUT%）</label>
                                                <div class="col-xs-3">
                                                    <input type="text" id="form-field-neut2" placeholder="中性粒细胞" class="no-padding"/>
                                                </div>

                                                <div class="col-xs-5">
                                                    <div class="input-group">
                                                        <input class=" date-picker no-padding" style="width: 100px" id="neut2_time" type="text" data-date-format="yyyy-mm-dd"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-inline no-padding">
                                                <label class="col-xs-4 control-label" for="form-field-alt2" style="text-overflow:ellipsis; white-space:nowrap;">
                                                    谷丙转氨酶（ALT）</label>
                                                <div class="col-xs-3">
                                                    <input type="text" id="form-field-alt2" placeholder="谷丙转氨酶" class="no-padding"/>
                                                </div>

                                                <div class="col-xs-5">
                                                    <div class="input-group">
                                                        <input class=" date-picker no-padding" style="width: 100px" id="alt2_time" type="text" data-date-format="yyyy-mm-dd"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-inline no-padding col-xs-12" style="margin-top: 5px;">
                                                <label class="col-xs-4 control-label" for="form-field-cr2" style="text-overflow:ellipsis; white-space:nowrap;">
                                                    肌酐（Cr）</label>
                                                <div class="col-xs-3">
                                                    <input type="text" id="form-field-cr2" placeholder="肌酐" class="no-padding"/>
                                                </div>

                                                <div class="col-xs-5">
                                                    <div class="input-group">
                                                        <input class=" date-picker no-padding" style="width: 100px" id="cr2_time" type="text" data-date-format="yyyy-mm-dd"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="well well-sm" style="height: 180px">
                                            <h6 class="green lighter">临床微生物检查</h6>
                                            <div class="form-inline no-padding">
                                                <label class="col-xs-3 control-label" style="text-overflow:ellipsis; white-space:nowrap;">病原学检测</label>
                                                <div class="control-group col-xs-4 no-padding">
                                                    <label>
                                                        <input name="form-field-micro" type="radio" class="ace" value="未做"/>
                                                        <span class="lbl">未做</span>
                                                    </label>

                                                    <label>
                                                        <input name="form-field-micro" type="radio" class="ace" value="做"/>
                                                        <span class="lbl">做</span>
                                                    </label>
                                                </div>

                                                <div class="col-xs-5 no-padding">
                                                    <div class="input-group">
                                                        <input class=" date-picker no-padding" style="width: 100px" id="micro_time" type="text" data-date-format="yyyy-mm-dd"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-inline no-padding col-xs-12" style="margin-top: 5px;">
                                                <label class="col-xs-1 control-label" for="form-field-sample" style="text-overflow:ellipsis; white-space:nowrap;">标本</label>
                                                <div class="col-xs-3">
                                                    <input type="text" id="form-field-sample" style="width: 90px" placeholder="标本" class="no-padding"/>
                                                </div>
                                                <div class="control-group col-xs-8">
                                                    <label>
                                                        <input name="form-field-checkout" type="radio" class="ace" value="未检出"/>
                                                        <span class="lbl">未检出</span>
                                                    </label>

                                                    <label>
                                                        <input name="form-field-checkout" type="radio" class="ace" value="检出"/>
                                                        <span class="lbl">检出</span>
                                                    </label>
                                                    <input type="text" id="form-field-germName" style="width: 90px" placeholder="检出菌名" class="no-padding"/>
                                                </div>
                                            </div>

                                            <div class="form-inline no-padding col-xs-12" style="margin-top: 5px;">
                                                <label class="col-xs-3 control-label" style="text-overflow:ellipsis; white-space:nowrap;">药敏试验</label>
                                                <div class="control-group col-xs-4 no-padding">
                                                    <label>
                                                        <input name="form-field-sensitive" type="radio" class="ace" value="未做"/>
                                                        <span class="lbl">未做</span>
                                                    </label>

                                                    <label>
                                                        <input name="form-field-sensitive" type="radio" class="ace" value="做"/>
                                                        <span class="lbl">做</span>
                                                    </label>
                                                </div>

                                                <div class="col-xs-5 no-padding">
                                                    <div class="input-group">
                                                        <input class=" date-picker no-padding" style="width: 100px" id="sensitive_time" type="text" data-date-format="yyyy-mm-dd"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                    <div class="control-group form-line">
                                                        <label>
                                                            <input name="form-field-match" type="radio" class="ace" value="相符"/>
                                                            <span class="lbl">相符</span>
                                                        </label>

                                                        <label>
                                                            <input name="form-field-match" type="radio" class="ace" value="不相符"/>
                                                            <span class="lbl">不相符</span>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <c:if test="${batch.surgery==0}">
                                        <div id="dropdown14" class="tab-pane">
                                            <div class="well well-sm" style="height: 120px">
                                                <div class="form-inline no-padding col-xs-12">
                                                    <div class="control-group col-xs-12 no-padding">
                                                        <div class="col-xs-3">
                                                            <input name="form-field-imaging" type="checkbox" class="ace" value="1"/>
                                                            <span class="lbl">X线</span>
                                                        </div>

                                                        <div class="col-xs-3">
                                                            <input name="form-field-imaging" type="checkbox" class="ace" value="2"/>
                                                            <span class="lbl">CT</span>
                                                        </div>

                                                        <div class="col-xs-3">
                                                            <input name="form-field-imaging" type="checkbox" class="ace" value="4"/>
                                                            <span class="lbl">磁共振</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-inline input-group col-xs-12" style="margin-top: 10px">
                                                    <label class="control-label col-xs-2" for="form-field-part" style="text-overflow:ellipsis; white-space:nowrap;">部位</label>
                                                    <input type="text" id="form-field-part" placeholder="部位" class="no-padding col-xs-10"/>
                                                </div>
                                                <div class="form-inline input-group col-xs-12" style="margin-top: 10px">
                                                    <label class="control-label col-xs-2" for="form-field-conclusion" style="text-overflow:ellipsis; white-space:nowrap;">结论</label>
                                                    <input type="text" id="form-field-conclusion" placeholder="结论" class="no-padding col-xs-10"/>
                                                </div>
                                            </div>
                                            <h6 class="light-grey">只填写与感染有关的影像学诊断</h6>
                                        </div>
                                        <div id="dropdown15" class="tab-pane">
                                            <div class="well well-sm" style="height: 180px;">
                                                <label for="form-field-symptom">与感染有关的主要症状</label>
                                                <textarea class="autosize-transition form-control" rows="6" id="form-field-symptom" placeholder="与感染有关的主要症状"></textarea>
                                            </div>
                                            <h6 class="light-grey">只填写与感染有关的主要临床症状</h6>
                                        </div>
                                    </c:if>
                                    <c:if test="${batch.surgery==1}">
                                        <div id="dropdown88" class="tab-pane in active">
                                            <div class="well well-sm" style="height: 400px" id="kkk">
                                                <div class="form-inline no-padding col-xs-12" style="margin-top: 5px;">
                                                    <label class="col-xs-2 control-label" for="form-field-sample" style="text-overflow:ellipsis; white-space:nowrap;">手术名称</label>
                                                    <div class="col-xs-3">
                                                        <input type="text" id="form-field-surgeryName" style="width: 120px" placeholder="手术名称" class="no-padding"/>
                                                    </div>
                                                    <div class="control-group col-xs-7">
                                                        <label class="col-xs-1 control-label" style="text-overflow:ellipsis; white-space:nowrap;width: 80px">切口类型</label>
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
                                                <div class="form-inline col-xs-12" style="margin-top: 10px;">
                                                    <label class="control-label no-padding" for="id-surgeryTime1" style="text-overflow:ellipsis; white-space:nowrap;;width:100px;">手术开始时间</label>
                                                    <div class="input-group">
                                                        <input class="no-padding" style="width: 110px" id="id-surgeryTime1" type="text" data-date-format="MM月DD日 HH:mm"
                                                               value="<fmt:formatDate value='${inDate}' pattern='MM月dd日 HH:mm'/>"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                </div>
                                                <div class="form-inline col-xs-12" style="margin-top: 10px;">
                                                    <label class="control-label no-padding" for="id-surgeryTime2" style="text-overflow:ellipsis; white-space:nowrap;width:100px;">手术结束时间</label>
                                                    <div class="input-group">
                                                        <input class="no-padding" style="width: 110px" id="id-surgeryTime2" type="text" data-date-format="MM月DD日 HH:mm"
                                                               value="<fmt:formatDate value='${outDate}' pattern='MM月dd日 HH:mm'/>"/>
                                                        <span class="input-group-addon no-padding"><i class="fa fa-calendar bigger-110"></i></span>
                                                    </div>
                                                </div>
                                                <div class="control-group col-xs-12 no-padding" style="margin-top: 10px">
                                                    <span class="lbl">术前初次预防用药时间：</span>
                                                    <input name="form-field-drugItem" type="checkbox" class="ace" value="1"/>
                                                    <span class="lbl">1.＞1h</span>
                                                    <input name="form-field-drugItem" type="checkbox" class="ace" value="2"/>
                                                    <span class="lbl">2.切皮前0.5-1h</span>
                                                    <input name="form-field-drugItem" type="checkbox" class="ace" value="4"/>
                                                    <span class="lbl">3.＜0.5hr</span>
                                                    <input name="form-field-drugItem" type="checkbox" class="ace" value="8"/>
                                                    <span class="lbl">4.术前未用术后用</span>
                                                    <input name="form-field-drugItem" type="checkbox" class="ace" value="16"/>
                                                    <span class="lbl">5.未夹脐带后用药</span>
                                                    <input name="form-field-drugItem" type="checkbox" class="ace" value="32"/>
                                                    <span class="lbl">6.夹住脐带后用药</span>
                                                    <input name="form-field-drugItem" type="checkbox" class="ace" value="64"/>
                                                    <span class="lbl">7.眼科滴眼＜24hr</span>
                                                    <input name="form-field-drugItem" type="checkbox" class="ace" value="128"/>
                                                    <span class="lbl">8. 眼科滴眼＞24hr</span>
                                                </div>
                                                <div class="control-group col-xs-12 no-padding" style="margin-top: 10px">
                                                    <span class="lbl">术中给药情况：</span>
                                                    <input name="form-field-surgeryDrug" type="radio" class="ace" value="已追加"/>
                                                    <span class="lbl">已追加</span>
                                                    <input name="form-field-surgeryDrug" type="radio" class="ace" value="未追加"/>
                                                    <span class="lbl">未追加</span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                    <div id="dropdown16" class="tab-pane">
                                        <div class="well well-sm" style="height: 120px">
                                            <div class="control-group">
                                                <div class="col-xs-12" style="margin-top: 10px">
                                                    <input name="form-field-purpose" type="radio" class="ace" value="未用药" checked/>
                                                    <span class="lbl">未用药</span>
                                                </div>

                                                <div class="col-xs-12" style="margin-top: 10px">
                                                    <input name="form-field-purpose" type="radio" class="ace" value="预防"/>
                                                    <span class="lbl">预防（△）</span>
                                                </div>

                                                <div class="col-xs-12 no-padding" style="margin-top: 10px">
                                                    <input name="form-field-purpose" type="radio" class="ace col-xs-1" value="治疗"/>
                                                    <span class="lbl col-xs-4">治疗（□）</span>
                                                    <div class="col-xs-7">
                                                        <label class="control-label col-xs-6" for="form-field-infection" style="text-overflow:ellipsis; white-space:nowrap;">感染诊断</label>
                                                        <input type="text" id="form-field-infection" placeholder="感染诊断" class="no-padding col-xs-6"/>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="dropdown17" class="tab-pane">
                                        <div class="well well-sm" style="height: 600px">
                                            <table id="drugTable" class="table table-striped table-bordered table-hover">
                                                <thead class="thin-border-bottom">
                                                <tr>
                                                    <th>预防/治疗</th>
                                                    <th>药品通用名</th>
                                                    <th>单次剂量</th>
                                                    <th>给药频次</th>
                                                    <th>途径</th>
                                                    <th>总用量</th>
                                                    <th>起止时间（月日 时分）</th>
                                                </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <div class="input-group col-xs-12" style="margin-top: 10px">
                                                <label class="control-label" for="form-field-antiNum" style="text-overflow:ellipsis; white-space:nowrap; width:110px;">累计使用抗菌药</label>
                                                <input type="text" id="form-field-antiNum" placeholder="元" class="no-padding" style="width: 50px;text-align: center"/>
                                                <label class="control-label" for="form-field-antiNum" style="text-overflow:ellipsis; white-space:nowrap;">种</label>
                                                <input type="text" id="form-field-antiDays" placeholder="元" class="no-padding" style="width: 50px;text-align: center"/>
                                                <label class="control-label" for="form-field-antiDays" style="text-overflow:ellipsis; white-space:nowrap;">天</label>
                                            </div>
                                            <label style="margin-top: 10px">（注射用药请同时写清溶剂名称及用量） （治疗在□上划√预防在△上划√）</label>
                                        </div>
                                    </div>

                                    <div id="dropdown18" class="tab-pane">
                                        <div class="well well-sm" style="height: 150px">
                                            <div class="input-group col-xs-12">
                                                <label class="control-label" for="form-field-money" style="text-overflow:ellipsis; white-space:nowrap; width:130px;">住院总费用</label>
                                                <input type="text" id="form-field-money" placeholder="元" class="no-padding" value="${recipe.money}"/>
                                                <label class="control-label" for="form-field-money" style="text-overflow:ellipsis; white-space:nowrap;">元</label>
                                            </div>
                                            <div class="input-group col-xs-12" style="margin-top: 10px">
                                                <label class="control-label" for="form-field-medicineMoney" style="text-overflow:ellipsis; white-space:nowrap; width:130px;">住院药品总费用</label>
                                                <input type="text" id="form-field-medicineMoney" placeholder="元" class="no-padding" value="${recipe.medicineMoney}"/>
                                                <label class="control-label" for="form-field-medicineMoney" style="text-overflow:ellipsis; white-space:nowrap;">元</label>
                                            </div>
                                            <div class="input-group col-xs-12" style="margin-top: 10px">
                                                <label class="control-label" for="form-field-antiMoney" style="text-overflow:ellipsis; white-space:nowrap; width:130px;">住院抗菌药物总费用</label>
                                                <input type="text" id="form-field-antiMoney" placeholder="元" value="0" class="no-padding"/>
                                                <label class="control-label" for="form-field-antiMoney" style="text-overflow:ellipsis; white-space:nowrap;">元</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="dropdown19" class="tab-pane">
                                        <div class="well well-sm" style="height: 150px">
                                            <div class="control-group form-inline col-xs-12">
                                                <input name="form-field-result" type="radio" class="ace" value="治愈"/>
                                                <span class="lbl">治愈</span>
                                                <input name="form-field-result" type="radio" class="ace" value="好转"/>
                                                <span class="lbl">好转</span>
                                                <input name="form-field-result" type="radio" class="ace" value="无效"/>
                                                <span class="lbl">无效</span>
                                            </div>
                                            <div class="control-group form-inline col-xs-12" style="margin-top: 20px">
                                                <input name="form-field-secondary" type="radio" class="ace" value="有"/>
                                                <span class="lbl">有</span>
                                                <input name="form-field-secondary" type="radio" class="ace" value="无"/>
                                                <span class="lbl">无</span>
                                                <span class="lbl">&nbsp;&nbsp;&nbsp;继发（医院）感染</span>
                                            </div>
                                            <div class="control-group form-inline col-xs-12" style="margin-top: 20px">
                                                <input name="form-field-antimycotic" type="radio" class="ace" value="有"/>
                                                <span class="lbl">有</span>
                                                <input name="form-field-antimycotic" type="radio" class="ace" value="无"/>
                                                <span class="lbl">无</span>
                                                <span class="lbl">&nbsp;&nbsp;&nbsp;使用抗真菌药</span>
                                            </div>
                                        </div>
                                        <label class="light-grey">继发感染的诊断及发病时间请在备注中说明</label>
                                    </div>
                                    <div id="dropdown20" class="tab-pane">
                                        <div class="well well-sm" style="height: 150px">
                                            <h6 class="green lighter">本院</h6>
                                            <div class="control-group col-xs-12 no-padding">
                                                <input name="form-field-me" type="checkbox" class="ace" value="1"/>
                                                <span class="lbl">适应证（如无适应证，不再评价余下各项）</span>
                                                <input name="form-field-me" type="checkbox" class="ace" value="2"/>
                                                <span class="lbl">药物选择</span>
                                                <input name="form-field-me" type="checkbox" class="ace" value="4"/>
                                                <span class="lbl">单次剂量</span>
                                                <input name="form-field-me" type="checkbox" class="ace" value="8"/>
                                                <span class="lbl">每日给药次数</span>
                                                <input name="form-field-me" type="checkbox" class="ace" value="16"/>
                                                <span class="lbl">溶　剂</span>
                                                <input name="form-field-me" type="checkbox" class="ace" value="32"/>
                                                <span class="lbl">用药途径</span>
                                                <input name="form-field-me" type="checkbox" class="ace" value="64"/>
                                                <span class="lbl">用药疗程</span>
                                                <input name="form-field-me" type="checkbox" class="ace" value="128"/>
                                                <span class="lbl">更换药品</span>
                                                <input name="form-field-me" type="checkbox" class="ace" value="256"/>
                                                <span class="lbl">联合用药</span>
                                            </div>
                                            <c:if test="${batch.surgery==1}">
                                                <div class="control-group col-xs-12 no-padding" style="margin-top: 10px">
                                                    <span class="lbl">围手术期用药时间：</span>
                                                    <input name="form-field-me" type="checkbox" class="ace" value="512"/>
                                                    <span class="lbl">术前</span>
                                                    <input name="form-field-me" type="checkbox" class="ace" value="1024"/>
                                                    <span class="lbl">术中</span>
                                                    <input name="form-field-me" type="checkbox" class="ace" value="2048"/>
                                                    <span class="lbl">术后</span>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="well well-sm" style="height: 150px">
                                            <h6 class="green lighter">中心或分网</h6>
                                            <div class="control-group col-xs-12 no-padding">
                                                <input name="form-field-central" type="checkbox" class="ace" value="1"/>
                                                <span class="lbl">适应证（如无适应证，不再评价余下各项）</span>
                                                <input name="form-field-central" type="checkbox" class="ace" value="2"/>
                                                <span class="lbl">药物选择</span>
                                                <input name="form-field-central" type="checkbox" class="ace" value="4"/>
                                                <span class="lbl">单次剂量</span>
                                                <input name="form-field-central" type="checkbox" class="ace" value="8"/>
                                                <span class="lbl">每日给药次数</span>
                                                <input name="form-field-central" type="checkbox" class="ace" value="16"/>
                                                <span class="lbl">溶　剂</span>
                                                <input name="form-field-central" type="checkbox" class="ace" value="32"/>
                                                <span class="lbl">用药途径</span>
                                                <input name="form-field-central" type="checkbox" class="ace" value="64"/>
                                                <span class="lbl">用药疗程</span>
                                                <input name="form-field-central" type="checkbox" class="ace" value="128"/>
                                                <span class="lbl">更换药品</span>
                                                <input name="form-field-central" type="checkbox" class="ace" value="256"/>
                                                <span class="lbl">联合用药</span>
                                            </div>
                                            <c:if test="${batch.surgery==1}">
                                                <div class="control-group col-xs-12 no-padding" style="margin-top: 10px">
                                                    <span class="lbl">围手术期用药时间：</span>
                                                    <input name="form-field-central" type="checkbox" class="ace" value="512"/>
                                                    <span class="lbl">术前</span>
                                                    <input name="form-field-central" type="checkbox" class="ace" value="1024"/>
                                                    <span class="lbl">术中</span>
                                                    <input name="form-field-central" type="checkbox" class="ace" value="2048"/>
                                                    <span class="lbl">术后</span>
                                                </div>
                                            </c:if>
                                        </div>
                                        <h6 class="light-grey">“用药合理性评价项”只在3、7月份做，其它月份不做；<br/>合理划√，不合理不选。</h6>
                                    </div>
                                    <div id="dropdown21" class="tab-pane">
                                        <div class="well well-sm" style="height: 160px">
                                            <textarea class="autosize-transition form-control" rows="6" id="form-field-memo" placeholder="备注"></textarea>
                                        </div>
                                    </div>
                                    <div id="dropdown22" class="tab-pane">
                                        <div class="well well-sm" style="height: 190px">
                                            <p>具体细项请以“序号”形式填写在表3-3⑴的相应项目中。</p>
                                        </div>
                                    </div>

                                </div>
                            </div>

                        </form>
                        <!-- /section:elements.tab.position -->
                    </div><!-- /.col -->
                    <div class="col-sm-6 widget-container-col" id="widget-container-col-13">
                        <div class="widget-box transparent" id="widget-box-13">
                            <div class="widget-header">
                                <h4 class="widget-title lighter">住院号：${recipe.patientNo}，姓名：${recipe.patientName}</h4>

                                <div class="widget-toolbar no-border" id="tabDiv">
                                    <ul class="nav nav-tabs" id="myTab2">
                                        <li class="active"><a data-toggle="tab" href="#home1">病人</a></li>
                                        <li><a data-toggle="tab" href="#home2">诊断</a></li>
                                        <li><a data-toggle="tab" href="#longTab">长嘱</a></li>
                                        <li><a data-toggle="tab" href="#shortTab">临嘱</a></li>
                                        <li><a data-toggle="tab" href="#surgeryTab">手术</a></li>
                                        <li><a data-toggle="tab" href="#courseTab" id="courseTabIndex">病程记录</a></li>
                                        <li><a data-toggle="tab" href="#historyTab" id="historyTabIndex">住院病历</a></li>
                                    </ul>
                                </div>
                            </div>

                            <div class="widget-body">
                                <div class="widget-main padding-12 no-padding-left no-padding-right">
                                    <div class="tab-content padding-4">
                                        <div id="home1" class="tab-pane">

                                            <table border="0" cellspacing="1" cellpadding="0" class="col-sm-5 table table-striped table-bordered table-hover">
                                                <tbody>
                                                <tr>
                                                    <td class="col-sm-2">住院号</td>
                                                    <td class="col-sm-4">${recipe.patientNo}</td>

                                                    <td class="col-sm-2">姓名</td>

                                                    <td class="col-sm-4">${recipe.patientName}</td>
                                                </tr>
                                                <tr>
                                                    <td class="col-sm-2">入院日期</td>
                                                    <td class="col-sm-4"><fmt:formatDate value='${inDate}' pattern='yyyy-MM-dd HH:mm'/></td>

                                                    <td class="col-sm-2">出院日期</td>
                                                    <td class="col-sm-4"><fmt:formatDate value='${outDate}' pattern='yyyy-MM-dd HH:mm'/></td>
                                                </tr>
                                                <tr>
                                                    <td class="col-sm-2">住院天数</td>
                                                    <td class="col-sm-4">${recipe.inHospitalDay}</td>

                                                    <td class="col-sm-2">年龄</td>
                                                    <td class="col-sm-4">${recipe.age}</td>
                                                </tr>
                                                <tr>
                                                    <td class="col-sm-2">性别</td>
                                                    <td class="col-sm-4">
                                                        <c:if test="${recipe.sex}">男</c:if>
                                                        <c:if test="${!recipe.sex}">女</c:if>
                                                    </td>

                                                    <td class="col-sm-2">就诊科室</td>
                                                    <td class="col-sm-4">${recipe.department}</td>
                                                </tr>
                                                <tr>
                                                    <td class="col-sm-2">主管医生</td>
                                                    <td class="col-sm-4">${recipe.masterDoctorName}</td>

                                                    <td class="col-sm-2">药品组数</td>
                                                    <td class="col-sm-4">${recipe.drugNum}</td>
                                                </tr>
                                                <tr>
                                                    <td class="col-sm-2">总金额</td>
                                                    <td class="col-sm-4">${recipe.money}</td>

                                                    <td class="col-sm-2">药品金额</td>
                                                    <td class="col-sm-4">${recipe.medicineMoney}</td>
                                                </tr>
                                                <tr>
                                                    <td class="col-sm-2">抗菌药品种数</td>
                                                    <td class="col-sm-4">${recipe.antiNum}</td>

                                                    <td class="col-sm-3">抗菌药联用数</td>
                                                    <td class="col-sm-4">${recipe.concurAntiNum}</td>
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
                                        <div id="courseTab" class="tab-pane">
                                            <div class="scrollable" data-size="600">
                                                <div id="courseContent" class="content">
                                                    <div class="col-xs-12 bigger-130">主题：{{title}}</div>
                                                    <div class="col-xs-12">
                                                        <div class="col-xs-3 purple">{{writeTime}}</div>
                                                        <div class="col-xs-9 brown">{{doctorName}}</div>
                                                    </div>
                                                    <p class="col-xs-12 profile-info-value">{{{content}}}</p>

                                                </div>
                                            </div>
                                        </div>
                                        <div id="historyTab" class="tab-pane">
                                            <div class="scrollable" data-size="600">
                                                <div id="historyContent">
                                                    <div class="col-xs-12">
                                                        <div class="col-xs-3 purple">{{writeTime}}</div>
                                                        <div class="col-xs-9 brown">{{doctorName1}}</div>
                                                    </div>
                                                    <div class="col-xs-12 profile-info-value">{{{content}}}</div>
                                                </div>
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
</body>
</html>