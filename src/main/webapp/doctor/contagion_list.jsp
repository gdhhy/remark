<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="../components/datatables/jquery.dataTables.min.js"></script>
<script src="../components/datatables/jquery.dataTables.bootstrap.min.js"></script>
<script src="../components/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="../components/datatables/dataTables.select.min.js"></script>
<%--<script src="../assets/js/ace.js"></script>--%>
<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>
<script src="../js/resize.js"></script>
<script src="../js/jquery.cookie.min.js"></script>
<script src="../assets/js/jquery.validate.min.js"></script>
<script src="../components/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script src="../components/bootstrap-timepicker/js/bootstrap-timepicker.js"></script>
<script src="../components/moment/moment.min.js"></script>
<script src="../components/bootstrap-daterangepicker/daterangepicker.js"></script>
<script src="../components/bootstrap-daterangepicker/daterangepicker.zh-CN.js"></script>
<script src="../components/datatables/dataTables.select.min.js"></script>
<!-- page specific plugin scripts --><%--
<script src="../components/jquery-ui/jquery-ui.js"></script>
<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>--%>

<link rel="stylesheet" href="../components/bootstrap-datepicker/css/bootstrap-datepicker3.css"/>
<link rel="stylesheet" href="../components/bootstrap-timepicker/css/bootstrap-timepicker.css"/>
<link rel="stylesheet" href="../components/bootstrap-daterangepicker/daterangepicker.css"/>
<link rel="stylesheet" href="../components/datatables/select.dataTables.css"/>
<%--<link rel="stylesheet" href="../components/jquery-ui/jquery-ui.css" />--%>
<link rel="stylesheet" href="../components/font-awesome-4.7.0/css/font-awesome.min.css"/>

<script type="text/javascript">
  jQuery(function ($) {
    var startDate = moment().month(moment().month() - 5).startOf('month');
    var endDate = moment();

    var arr = ['编辑', '提交', '退回', '接受', '作废'];


    var timeFrom = '', timeTo = '';

    var url = "/doctor/getContagionList.jspa?fromDate={0}&toDate={1}&workflowState={2}&queryItem={3}&queryField={4}";
    //var editor = new $.fn.dataTable.Editor({});
    //initiate dataTables plugin
    var dynamicTable = $('#dynamic-table');
    var myTable = dynamicTable
      //.wrap("<div class='dataTables_borderWrap' />") //if you are applying horizontal scrolling (sScrollX)
      .DataTable({
        bAutoWidth: false,
        //paging: false,
        "columns": [
          {"data": 'contagionID'},
          {"data": 'reportType', "sClass": "center"},
          {"data": 'patientName', "sClass": "center"},
          {"data": 'serialNo', "sClass": "center"},
          {"data": 'birthday', "sClass": "center"},//4
          {"data": 'occupation', "sClass": "center"},
          {"data": 'contagionName', "sClass": "center"},
          {"data": 'fillTime', "sClass": "center"},
          {"data": 'reportDoctor', "sClass": "center"},
          {"data": 'workflowChn', "sClass": "center"},//9
          {"data": 'workflowNote', "sClass": "center"},
          {"data": 'contagionID', "sClass": "center"} 
        ],

        'columnDefs': [
          {
            "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
              return meta.row + 1 + meta.settings._iDisplayStart;
            }
          },
          {
            "orderable": false, "targets": 1, title: '报告类型', width: 70, render: function (data, type, row, meta) {
              if (data === 1) return "初次报告";
              return "订正报告";
            }
          },
          {"orderable": false, "targets": 2, title: '患者姓名', width: 70},
          {"orderable": false, "targets": 3, title: '住院/门诊号', width: 90, defaultContent: ''},
          {"orderable": false, "targets": 4, title: '出生日期', width: 90},
          {"orderable": false, "targets": 5, title: '职业'},
          {"orderable": false, "targets": 6, title: '感染病名'},
          {"orderable": false, "targets": 7, title: '报告日期', width: 160},
          {"orderable": false, "targets": 8, title: '报告人'},
          {"orderable": false, "targets": 9, title: '状态'},
          {"orderable": false, "targets": 10, title: '退回消息', defaultContent: ''},
          {
            "orderable": false, "targets": 11, title: '操作',/*className:'center',*/ width: 120, render: function (data, type, row, meta) {
              return '<div class="hidden-sm hidden-xs action-buttons">' +
                <c:choose>
                <c:when test="${INFECTIOUS_ROLE==false}">
                '<a class="hasDetail" href="#" data-Url="/index.jspa?content=/doctor/getContagion.jspa?contagionID={0}&menuID=51">'.format(data) +
                '<i class="ace-icon fa {0} bigger-130" disabled="disabled" title="编辑报告"></i></a>&nbsp;'
                  .format(row["workflowChn"] === "编辑" || row["workflowChn"] === "退回" ? 'fa-pencil-square-o' : 'fa-credit-card') +
                (row["workflowChn"] === "编辑" || row["workflowChn"] === "退回" ?
                  '<a class="black" href="#" data-Url="javascript:deleteContagion({0},\'{1}\')">'.format(data, row["patientName"]) +
                  '<i class="ace-icon fa fa-trash-o red bigger-130" title="删除报告"></i></a>&nbsp;' : '') +
                (row["workflowChn"] === "编辑" ?
                  '<a class="submit" href="#" data-Url="javascript:submitContagion({0},\'{1}\')">'.format(data, row["patientName"]) +
                  '<i class="ace-icon fa fa-arrow-up orange bigger-130" title="提交"></i></a>&nbsp;' : '') +
                (row["workflowChn"] === "接受" ?
                  '<a class="export" href="#" data-Url="/doctor/getContagionPDF.jspa?contagionID={0}">'.format(data) +
                  '<i class="ace-icon fa fa-file-pdf-o bigger-130" title="导出PDF"></i></a>' : '') +
                </c:when>
                <c:otherwise>
                '<a class="hasDetail" href="#" data-Url="/index.jspa?content=/doctor/getContagion.jspa?contagionID={0}&menuID=51">'.format(data) +
                '<i class="ace-icon fa fa-credit-card bigger-130" title="查看报告"></i></a>&nbsp;' +
                (row["workflowChn"] === "提交" ?
                  '<a class="accept" href="#" data-Url="javascript:acceptContagion({0},\'{1}\')">'.format(data, row["patientName"]) +
                  '<i class="ace-icon fa fa-lock blue bigger-130" title="接受"></i></a>&nbsp;' : '') +
                (row["workflowChn"] === "提交" ?
                  '<a class="reject" href="#" data-Url="javascript:rejectContagion({0},\'{1}\')">'.format(data, row["patientName"]) +
                  '<i class="ace-icon fa fa-arrow-left red bigger-110" title="退回"></i></a>&nbsp;' : '') +
                (row["workflowChn"] === "接受" ?
                        '<a class="export" href="#" data-Url="/doctor/getContagionPDF.jspa?contagionID={0}">'.format(data) +
                  '<i class="ace-icon fa fa-file-pdf-o bigger-130" title="导出PDF" ></i></a>' : ' ') +
                </c:otherwise>
                </c:choose>
                '</div>';
            }
          }
        ],
        "aaSorting": [],
        language: {
          url: '../components/datatables/datatables.chinese.json'
        },
        "ajax": {
          url: url.format(startDate.format('YYYY-MM-DD'), endDate.format('YYYY-MM-DD'), -1, '', ''),
          "data": function (d) {//删除多余请求参数
            for (var key in d)
              if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                delete d[key];
          }
        },
        //scrollY: '60vh',
        //"serverSide": true,
        select: {
          style: 'single'
        }
      });
    myTable.on('draw', function () {
      $('#dynamic-table tr a').click(function () {
        //console.log("url:" + $(this).attr("data-Url"));
        if ($(this).attr("data-Url").indexOf('javascript:') >= 0) {
          eval($(this).attr("data-Url"));
        } else
          window.open($(this).attr("data-Url"), "_blank");
      });
     /* $('#dynamic-table a.black').on('click', function (e) {
        e.preventDefault();
        deleteContagion($(this).attr("data-contagionID"), $(this).attr("data-patientName"));
      });
      $('#dynamic-table a.submit').on('click', function (e) {
        e.preventDefault();
        submitContagion($(this).attr("data-contagionID"), $(this).attr("data-patientName"));
      });
      $('#dynamic-table a.accept').on('click', function (e) {
        e.preventDefault();
        acceptContagion($(this).attr("data-contagionID"), $(this).attr("data-patientName"));
      });
      $('#dynamic-table a.reject').on('click', function (e) {
        e.preventDefault();
        rejectContagion($(this).attr("data-contagionID"), $(this).attr("data-patientName"));
      });*/
    });
    $('#queryContagion').click(function () {
      myTable.ajax.url(url.format(startDate.format('YYYY-MM-DD'), endDate.format('YYYY-MM-DD'), $("input[name='stat']:checked").val(),
        $('#queryItem').val(), $('#queryField').val())).load();
    });
    $("#dt").resize(function () {
      myTable.columns.adjust();
    });

    function deleteContagion(contagionID, patientName) {
      if (contagionID === undefined) return;
      $('#name').text(patientName);
      $("#dialog-delete").removeClass('hide').dialog({
        resizable: false,
        modal: true,
        title: "删除感染病报告",
        buttons: [
          {
            html: "<i class='ace-icon fa fa-trash bigger-110'></i>&nbsp;确定",
            "class": "btn btn-danger btn-minier",
            click: function () {
              $.ajax({
                type: "POST",
                url: "/doctor/deleteContagion.jspa?contagionID=" + contagionID,
                //contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                cache: false,
                success: function (response, textStatus) {
                  var result = JSON.parse(response);
                  if (result.success)
                    myTable.ajax.reload();
                  else
                    showDialog("请求结果：" + result.success, response);
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

    function submitContagion(contagionID, patientName) {
      if (contagionID === undefined) return;
      $('#name2').text(patientName);
      var submitUrl = "/doctor/setWorkflow.jspa?objectID={0}&objectType=contagion&workflow=1&flowNote= ".format(contagionID);
      console.log("url:" + submitUrl);
      $("#dialog-submit").removeClass('hide').dialog({
        resizable: false,
        modal: true,
        title: "提交感染病报告",
        buttons: [
          {
            html: "<i class='ace-icon fa fa-save bigger-110'></i>&nbsp;确定",
            "class": "btn btn-success btn-minier",
            click: function () {
              $.ajax({
                type: "POST",
                url: submitUrl,
                //contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                cache: false,
                success: function (response, textStatus) {
                  var result = JSON.parse(response);
                  if (result.success)
                    myTable.ajax.reload();
                  else
                    showDialog("请求结果：" + result.success, response);
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

    function acceptContagion(contagionID, patientName) {
      if (contagionID === undefined) return;
      $('#name3').text(patientName);
      var submitUrl = "/doctor/setWorkflow.jspa?objectID={0}&objectType=contagion&workflow=3&flowNote= ".format(contagionID);
      console.log("url:" + submitUrl);
      $("#dialog-accept").removeClass('hide').dialog({
        resizable: false,
        modal: true,
        title: "接受感染病报告",
        buttons: [
          {
            html: "<i class='ace-icon fa fa-lock bigger-110'></i>&nbsp;确定",
            "class": "btn btn-success btn-minier",
            click: function () {
              $.ajax({
                type: "POST",
                url: submitUrl,
                //contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                cache: false,
                success: function (response, textStatus) {
                  var result = JSON.parse(response);
                  if (result.success)
                    myTable.ajax.reload();
                  else
                    showDialog("请求结果：" + result.success, response);
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

    function rejectContagion(contagionID, patientName) {
      if (contagionID === undefined) return;
      $('#name4').text(patientName);
      var submitUrl = "/doctor/setWorkflow.jspa?objectID={0}&objectType=contagion&workflow=2&flowNote={1}";
      //console.log("url:" + submitUrl);
      $("#dialog-reject").removeClass('hide').dialog({
        resizable: false,
        modal: true,
        title: "退回感染病报告",
        buttons: [
          {
            html: "<i class='ace-icon fa fa-lock bigger-110'></i>&nbsp;确定",
            "class": "btn btn-success btn-minier",
            click: function () {
              $.ajax({
                type: "POST",
                url: submitUrl.format(contagionID, $('#form-field-9').val()),
                //contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                cache: false,
                success: function (response, textStatus) {
                  var result = JSON.parse(response);
                  if (result.success)
                    myTable.ajax.reload();
                  else
                    showDialog("请求结果：" + result.success, response);
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

    $('#form-dateRange').daterangepicker({
      'applyClass': 'btn-sm btn-success',
      'cancelClass': 'btn-sm btn-default',
      startDate: startDate,
      endDate: endDate,
      ranges: {
        '本月': [moment().startOf('month')],
        '上月': [moment().month(moment().month() - 1).startOf('month'), moment().month(moment().month() - 1).endOf('month')],
        '本季': [moment().startOf('quarter')],
        '上季': [moment().quarter(moment().quarter() - 1).startOf('month'), moment().quarter(moment().quarter() - 1).endOf('quarter')],
        '今年': [moment().startOf('year')],
        '去年': [moment().year(moment().year() - 1).startOf('year'), moment().year(moment().year() - 1).endOf('year')]
      },
      locale: locale
    }, function (start, end, label) {
      startDate = start;
      endDate = end;
    }).css("min-width", "190px").next("i").click(function () {
      // 对日期的i标签增加click事件，使其在鼠标点击时可以拉出日期选择
      $(this).parent().find('input').click();
    }).next().on(ace.click_event, function () {
      $(this).prev().focus();
    });

    $('#dateRange').daterangepicker({
      'applyClass': 'btn-sm btn-success',
      'cancelClass': 'btn-sm btn-default',
      ranges: {
        '本月': [moment().startOf('month')],
        '上月': [moment().month(moment().month() - 1).startOf('month'), moment().month(moment().month() - 1).endOf('month')],
        '本季': [moment().startOf('quarter')],
        '上季': [moment().quarter(moment().quarter() - 1).startOf('month'), moment().quarter(moment().quarter() - 1).endOf('quarter')],
        '今年': [moment().startOf('year')],
        '去年': [moment().year(moment().year() - 1).startOf('year'), moment().year(moment().year() - 1).endOf('year')]
      },
      autoUpdateInput: false, //关闭自动赋值，使初始值为空
      locale: locale
    }, function (start, end, label) {
      timeFrom = moment(start).format('YYYY-MM-DD');
      timeTo = moment(end).format('YYYY-MM-DD');
      this.autoUpdateInput = true;//选完日期后打开自动赋值
    }).css("min-width", "170px").next("i").click(function () {
      // 对日期的i标签增加click事件，使其在鼠标点击时可以拉出日期选择
      $(this).parent().find('input').click();
    }).next().on(ace.click_event, function () {
      $(this).prev().focus();
    });
    $('#queryItem').on('change', function (e) {//console.log("value:" + this.options[this.selectedIndex].innerHTML );
      $('#queryField').attr("placeholder", this.options[this.selectedIndex].innerHTML);
    });

    //$.fn.dataTable.Buttons.swfPath = "components/datatables.net-buttons-swf/index.swf"; //in Ace demo ../components will be replaced by correct assets path
    $.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';

    new $.fn.dataTable.Buttons(myTable, {
      buttons: [
        {
          "text": "<i class='fa fa-plus-square-o bigger-110 red'></i>报告感染病",
          "className": "btn btn-xs btn-white btn-primary"
        }, {
          "text": "<i class='fa fa-arrow-up bigger-110 red'></i>提交",
          "className": "btn btn-xs btn-white btn-primary"
        }
      ]
    });
    myTable.buttons().container().appendTo($('.tableTools-container'));
    myTable.button(0).action(function (e, dt, button, config) {
      showChoosePatient();
    });

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

    var patientTable;
    var choosePatient;

//新
    function showChoosePatient() {
      $('#dt2').addClass("hide");
      $('#dt3').addClass("hide");
      $("#dialog-edit").removeClass('hide').dialog({
        resizable: false,
        //margin: 0,
        width: 950,
        height: 650,
        modal: true,
        title: "选择病人填写感染病报告",
        buttons: [
          {
            html: "<i class='ace-icon fa fa-check bigger-110'></i>&nbsp;选择",
            "class": "btn disabled btn-primary btn-minier ",
            click: function () {
              console.log("choosePatient:" + choosePatient["PatID"]);
              var newContagionUrl = "index.jspa?content=/doctor/newContagion.jspa&menuID=51&patientID={0}&serialNo={1}&diagnosisDate={2}";
              if ($('#form-type').val() === '2')
                newContagionUrl = newContagionUrl.format(choosePatient["PatID"], choosePatient["住院号"], choosePatient["入院时间"]);
              else
                newContagionUrl = newContagionUrl.format(choosePatient["PatID"], choosePatient["cardNo"], choosePatient["挂号时间"]);
              window.open(newContagionUrl);
              /*window.open("index.jspa?content=/doctor/newContagion.jspa&menuID=51&patientID=" + choosePatient["PatID"] +
               "&diagnosisDate=" + ($('#form-type').val() === '2' ? choosePatient["入院时间"] : choosePatient["挂号时间"]));*/
              $(this).dialog("close");
            }
          }, {
            html: "<i class='ace-icon fa fa-square bigger-110'></i>&nbsp;空白填写",
            "class": "btn btn-info btn-minier",
            click: function () {
              window.open("index.jspa?content=/doctor/newContagion.jspa&menuID=51");
              $(this).dialog("close");
            }
          }, {
            html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 取消",
            "class": "btn btn-minier",
            click: function () {
              $(this).dialog("close");
            }
          }
        ]
      });//.siblings('div.ui-dialog-titlebar').remove();
    }

    $('#queryPatient').click(function () {
      if ($('#form-type').val() === '2') {
        $('#dt3').addClass("hide");
        $('#dt2').removeClass("hide");
        patientTable = $('#dynamic-table2').DataTable({
          bAutoWidth: false,
          paging: true,
          searching: false,

          ordering: false,
          "destroy": true,
          "columns": [
            {"data": "PatID"},
            /*{"data": "ID"},*/
            {"data": "住院号", "sClass": "center"},
            {"data": "入院时间", "sClass": "center"},
            {"data": "出院时间", "sClass": "center"},
            {"data": "姓名", "sClass": "center"},
            {"data": "性别", "sClass": "center"},
            {"data": "年龄", "sClass": "center"},
            {"data": "诊断", "sClass": "center"},
            {"data": "当前科室", "sClass": "center"},
            {"data": "医生姓名", "sClass": "center"}
          ],

          'columnDefs': [
            {
              targets: 0, data: null, defaultContent: '', orderable: false, className: 'select-checkbox', render: function () {
                return "";
              }
            },
            {"orderable": false, "targets": 1, title: '住院号', width: 70},
            {"orderable": false, "targets": 2, title: '入院日期', width: 120},
            {"orderable": false, "targets": 3, title: '出院日期', width: 120, defaultContent: ''},
            {"orderable": false, "targets": 4, title: '姓名', width: 80},
            {"orderable": false, "targets": 5, title: '性别', width: 45},
            {"orderable": false, "targets": 6, title: '年龄', width: 60},
            {"orderable": false, "targets": 7, title: '诊断', width: 150},
            {"orderable": false, "targets": 8, title: '当前科室', defaultContent: '', width: 120},
            {"orderable": false, "targets": 9, title: '主管医生', defaultContent: '', width: 80}],
          select: {
            style: 'os',
            selector: 'td:first-child'
          },
          "aaSorting": [],
          language: {
            url: '../components/datatables/datatables.chinese.json'
          },
          "ajax": {
            url: "/doctor/getHospitalPatient.jspa?queryItem=patientName&queryField=" + $('#patientName').val() +
              "&timeFrom=" + timeFrom + "&timeTo=" + timeTo,
            "data": function (d) {//删除多余请求参数
              for (var key in d)
                if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                  delete d[key];
            }
          }
        });
      } else {
        $('#dt2').addClass("hide");
        $('#dt3').removeClass("hide");

        patientTable = $('#dynamic-table3').DataTable({
          bAutoWidth: false,
          paging: true,
          searching: false,

          ordering: false,
          "destroy": true,
          "columns": [
            {"data": "PatID"},
            /*{"data": "ID"},*/
            {"data": "cardNo"},
            {"data": "挂号时间", "sClass": "center"},
            {"data": "姓名", "sClass": "center"},
            {"data": "性别", "sClass": "center"},
            {"data": "年龄", "sClass": "center"},
            {"data": "诊断", "sClass": "center"},
            {"data": "接诊科室", "sClass": "center"},
            {"data": "医生姓名", "sClass": "center"}
          ],

          'columnDefs': [
            {
              targets: 0, data: null, defaultContent: '', orderable: false, className: 'select-checkbox', render: function () {
                return "";
              }
            },
            /* {
             "orderable": false, "targets": 1, width: 15, render: function (data, type, row, meta) {
              return meta.row + 1 + meta.settings._iDisplayStart;
             }
             },*/
            {"orderable": false, "targets": 1, title: '门诊卡号', width: 80},
            {"orderable": false, "targets": 2, title: '挂号时间', width: 120},
            {"orderable": false, "targets": 3, title: '姓名'},
            {"orderable": false, "targets": 4, title: '性别', width: 45},
            {"orderable": false, "targets": 5, title: '年龄', width: 60},
            {"orderable": false, "targets": 6, title: '诊断', width: 150},
            {"orderable": false, "targets": 7, title: '接诊科室'},
            {"orderable": false, "targets": 8, title: '医生姓名', width: 80}
          ], select: {
            style: 'os',
            selector: 'td:first-child'
          },
          "aaSorting": [],
          language: {
            url: '../components/datatables/datatables.chinese.json'
          },
          "ajax": {
            url: "/doctor/getClinicPatient.jspa?queryItem=patientName&queryField=" + $('#patientName').val() +
              "&timeFrom=" + timeFrom + "&timeTo=" + timeTo,
            "data": function (d) {//删除多余请求参数
              for (var key in d)
                if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0) //以columns开头的参数删除
                  delete d[key];
            }
          }
        });
      }


      patientTable.on('select', function (e, dt, type, indexes) {
        $('.ui-dialog-buttonpane').find('button:contains("选择")').removeAttr("disabled");
        $('.ui-dialog-buttonpane').find('button:contains("空白")').attr("disabled", "disabled");
        choosePatient = patientTable.rows({selected: true}).data()[0];
        //console.log("choose:"+JSON.stringify(choosePatient));
      }).on('deselect', function (e, dt, type, indexes) {
        $('.ui-dialog-buttonpane').find('button:contains("选择")').attr("disabled", "disabled");
        $('.ui-dialog-buttonpane').find('button:contains("空白")').removeAttr("disabled");
        choosePatient = null;
      });
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
    <li class="active">感染病报告</li>
  </ul><!-- /.breadcrumb -->

  <!-- #section:basics/content.searchbox -->
  <div class="nav-search" id="nav-search">
    <form class="form-search">
  <span class="input-icon">
  <input type="text" placeholder="Search ..." class="nav-search-input" id="nav-search-input" autocomplete="off"/>
  <i class="ace-icon fa fa-search nav-search-icon"></i>
  </span>
    </form>
  </div><!-- /.nav-search -->

  <!-- /section:basics/content.searchbox -->
</div>

<!-- /section:basics/content.breadcrumbs -->
<div class="page-content">
  <div class="page-header">

    <form class="form-search form-inline">

      <label class=" control-label no-padding-right">状态： </label>
      <div class="radio">
        <label>
          <input type="radio" name="stat" value="-1" checked>
          <span class="lbl">全部</span>
        </label>
      </div>
      <div class="radio">
        <label>
          <input type="radio" name="stat" value="3">
          <span class="lbl">接受</span>
        </label>
      </div>
      <div class="radio">
        <label>
          <input type="radio" name="stat" value="0">
          <span class="lbl">未接受</span>
        </label>
      </div>&nbsp;&nbsp;&nbsp;


      <div class="input-group">
        <select class="nav-search-input ace" id="queryItem" name="queryItem" style="color: black">
          <option value="0">感染病名</option>
          <option value="1">患者姓名</option>
        </select>&nbsp;
        <input class="nav-search-input ace " type="text" id="queryField" name="queryField"
            style="width: 120px;color: black"
            placeholder="感染病名"/>
      </div>

      <label>日期：</label>
      <!-- #section:plugins/date-time.datepicker -->
      <div class="input-group">
        <input class="form-control nav-search-input" name="dateRangeString" id="form-dateRange"
            style="color: black "
            data-date-format="YYYY-MM-DD"/>
        <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
      </div>&nbsp;&nbsp;&nbsp;

      <button type="button" class="btn btn-sm btn-success" id="queryContagion">
        查询
        <i class="ace-icon glyphicon glyphicon-search icon-on-right bigger-100"></i>
      </button>
      <button type="button" class="btn btn-sm btn-info">
        导出
        <i class="ace-icon fa fa-file-excel-o icon-on-right bigger-100"></i>
      </button>
    </form>
  </div><!-- /.page-header -->


  <div class="row">
    <div class="col-xs-12">

      <div class="row">

        <div class="col-xs-12">
          <div class="table-header">
            感染病"列表"
            <div class="pull-right tableTools-container"></div>
          </div>

          <!-- div.table-responsive -->

          <!-- div.dataTables_borderWrap -->
          <div id="dt">
            <table id="dynamic-table" class="table table-striped table-bordered table-hover">
            </table>
          </div>
        </div>
      </div>

      <!-- PAGE CONTENT ENDS -->
    </div><!-- /.col -->
  </div><!-- /.row -->
</div>
<!-- /.page-content -->
<div id="dialog-edit" class="hide no-padding ">
  <!-- /section:basics/content.breadcrumbs -->
  <div class="page-content ">
    <div class="page-header">
      <form class="form-search form-inline">
        <div class="input-group">
          <label class=" control-label no-padding-right" for="form-type">门诊住院：</label>

          <select id="form-type" class="chosen-select" data-placeholder="门诊住院">
            <option value="1" selected>门诊</option>
            <option value="2">住院</option>
          </select>
        </div>

        <div class="input-group">
          <label>&nbsp;&nbsp;&nbsp;患者姓名：</label>
          <input class="nav-search-input ace " type="text" id="patientName"
              style="width: 100px;color: black"
              placeholder="患者姓名"/>
        </div>

        <label>&nbsp;&nbsp;门诊日期：</label>
        <!-- #section:plugins/date-time.datepicker -->
        <div class="input-group">
          <input class="form-control nav-search-input" id="dateRange"
              style="color: black "
              data-date-format="YYYY-MM-DD"/>
          <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
        </div>&nbsp;&nbsp;&nbsp;

        <button type="button" class="btn btn-sm btn-success" id="queryPatient">
          查询
          <i class="ace-icon glyphicon glyphicon-search icon-on-right bigger-100"></i>
        </button>
      </form>
    </div>

    <div class="row ">
      <div class="col-xs-12">

        <div class="row">

          <div class="col-xs-12">
            <div class="table-header">
              病人列表
            </div>

            <!-- div.table-responsive -->

            <!-- div.dataTables_borderWrap -->
            <div id="dt2">
              <table id="dynamic-table2" class="table table-striped table-bordered table-hover">
              </table>
            </div>
            <div id="dt3">
              <table id="dynamic-table3" class="table table-striped table-bordered table-hover">
              </table>
            </div>
          </div>
        </div>

        <!-- PAGE CONTENT ENDS -->
      </div><!-- /.col -->
    </div><!-- /.row -->
  </div>
</div>
<div class="widget-box widget-color-orange hide" style=" padding: 0;margin: 0;" id="boxDialog">
  <div class="widget-header widget-header-small">
    <h6 class="widget-title">
      <i class="ace-icon fa fa-sort"></i>
      Small Header & Collapsed
    </h6>

    <div class="widget-toolbar">
      <a href="#" data-action="settings">
        <i class="ace-icon fa fa-cog"></i>
      </a>

      <a href="#" data-action="reload">
        <i class="ace-icon fa fa-refresh"></i>
      </a>

      <a href="#" data-action="collapse">
        <i class="ace-icon fa fa-plus" data-icon-show="fa-plus" data-icon-hide="fa-minus"></i>
      </a>

      <a href="#" data-action="close">
        <i class="ace-icon fa fa-times"></i>
      </a>
    </div>
  </div>
  <div class="widget-body ">
    <div class="widget-main">

    </div>
  </div>
</div>
<div id="dialog-error" class="hide alert" title="提示">
  <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
</div>
<div id="dialog-delete" class="hide">
  <div class="alert alert-info bigger-110">
    永久删除 <span id="name" class="red"></span> 感染病报告，不可恢复！
  </div>

  <div class="space-6"></div>

  <p class="bigger-110 bolder center grey">
    <i class="icon-hand-right blue bigger-120"></i>
    确认吗？
  </p>
</div>
<div id="dialog-submit" class="hide">
  <div class="alert alert-info bigger-110">
    提交 <span id="name2" class="red"></span> 感染病报告给下一级审核。
  </div>

  <div class="space-6"></div>

  <p class="bigger-110 bolder center grey">
    <i class="icon-hand-right blue bigger-120"></i>
    确认吗？
  </p>
</div>
<div id="dialog-accept" class="hide">
  <div class="alert alert-info bigger-110">
    接受 <span id="name3" class="red"></span> 感染病报告。
  </div>

  <div class="space-6"></div>

  <p class="bigger-110 bolder center grey">
    <i class="icon-hand-right blue bigger-120"></i>
    确认吗？
  </p>
</div>
<div id="dialog-reject" class="hide">
  <div class="alert alert-info bigger-110">
    拒绝 <span id="name4" class="red"></span> 感染病报告。<br/>
    拒绝后将会退回给填写人。
  </div>
  <div>
    <label for="form-field-9">拒绝原因：</label>

    <textarea class="form-control limited" id="form-field-9" maxlength="255"></textarea>
  </div>
  <%--<div class="space-6"></div>
  <p class="bigger-110 bolder center grey">
   <i class="icon-hand-right blue bigger-120"></i>
   确认吗？
  </p>--%>
</div>