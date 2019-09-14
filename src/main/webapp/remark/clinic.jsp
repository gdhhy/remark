<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>处方点评工作表</title>
    <!-- basic styles -->
    <link href="../components/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet"/>

    <link rel="stylesheet" href="../components/jquery-ui/jquery-ui.min.css"/>
    <link rel="stylesheet" href="../components/jquery-ui.custom/jquery-ui.custom.css"/>
    <link rel="stylesheet" href="../assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/> <!--重要-->

    <!-- basic scripts -->
    <script src="../js/jquery-1.12.4.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <script src="../components/jquery-ui/jquery-ui.min.js"></script>

    <script src="../js/string_func.js"></script>
    <style type="text/css">
        a {
            TEXT-DECORATION: none
        }

        html, body {
            height: 100%;
            overflow: hidden;
        }

        body {
            overflow: auto;
        }

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

        .modal-header .close {
            margin-right: 15px;
        }

        .modal-footer {
            position: absolute;
            width: 100%;
            bottom: 0;
        }
    </style>

    <script type="text/javascript">
        function showPic(text) {
            var x, y;
            x = event.clientX;
            y = event.clientY;
            document.getElementById("Layer1").style.left = x;
            document.getElementById("Layer1").style.top = y;
            document.getElementById("Layer1").innerHTML = text;
            document.getElementById("Layer1").style.display = "block";
        }

        function hiddenPic() {
            document.getElementById("Layer1").innerHTML = "";
            document.getElementById("Layer1").style.display = "none";
        }


        /*弹出问题对话框开始*/

        $('#saveQuestionBtn').click(function() {
            console.log("click button");
            var selectItem = '';
            $("input:checkbox[name='dictNo']:checked").each(function () {
                selectItem += $(this).val() + ', ';
            });
            if (selectItem.endWith(', '))
                selectItem = selectItem.substring(0, selectItem.length - 2);
            console.log("select:" + selectItem);

            $('#clinic.disItem').val(selectItem);
            $('#question-choose').modal('hide');
        });
        var kk = 0;//正在加载标记
        var questionTable = $("#questionTable");

        function showQuestionDialog(selected) {
            //console.log("aa=" + $(selected).parent().html());
            if (questionTable.find("tbody tr").length === 0 && kk === 0) {
                kk = 1;

                $.ajax({
                    type: "GET",
                    url: "/common/dict/listDict.jspa",
                    data: "parentID=118",
                    contentType: "application/x-www-form-urlencoded",
                    cache: false,
                    success: function (response, textStatus) {
                        var respObject = JSON.parse(response);
                        if (respObject.data.length > 0)
                            $.each(respObject.data, function () {
                                var $tr = '<tr><td><input name="dictNo" type="checkbox" value="{0}" /></td><td align="center">{1}</td><td align="left">{2}</td></tr>'.format(this.dictNo, this.dictNo, this.value);
                                // console.log($tr);
                                $("#questionTable tbody").append($tr);
                            });

                        setCheckQuestion($('#clinic.disItem').text());
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        $("#errorText").text(response.responseText.substr(0, 1000));
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
                setCheckQuestion($('#clinic.disItem').text());
            }
            $('#question-choose').modal();
        }

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
    </script>
</head>
<body>
<div id="Layer1" style="display:none;position:absolute;z-index:1;background-color: #f5ffd7"></div>
<form action="saveClinic" id="rxForm">
    <table border="0">
        <tr>
            <td colspan="2" height="5"></td>
        </tr>
        <tr>
            <td width="5"></td>
            <td>
                <table border="1" cellspacing="0" bordercolor="#368E9D" style="border-collapse:collapse">
                    <tr>
                        <td colspan="8" height="40" align="center"><span style="font-size: 20px; font-family:'黑体';">翁源县人民医院</span>
                            <br/>
                            <span style="font-size: 20px; font-family:'黑体';">${clinic.clinicType}</span>
                        </td>
                    </tr>
                    <tr>
                        <td width="79" align="right" style="color: #368E9D;" bgColor="#ffffff" height="25">
                            门诊号
                        </td>
                        <td width="92" align="center">${clinic.serialNo}</td>
                        <td width="81" align="right" style="color: #368E9D;" bgColor="#ffffff">处方张数</td>
                        <td width="78" align="center">${clinic.rxCount}</td>
                        <td width="81" align="right" style="color: #368E9D;" bgColor="#ffffff">时间</td>
                        <td width="119" align="center"><fmt:formatDate value='${clinic.clinicDate}' pattern="yyyy-MM-dd HH:mm"/></td>
                        <td width="81" align="right" style="color: #368E9D;" bgColor="#ffffff">药品组数</td>
                        <td width="119" align="center">${clinic.drugNum}</td>
                    </tr>
                    <tr>
                        <td width="79" align="right" style="color: #368E9D;" bgColor="#ffffff" height="25"> 姓名</td>
                        <td width="92" align="center">${clinic.patientName}</td>
                        <td width="81" align="right" style="color: #368E9D;" bgColor="#ffffff"> 年龄</td>
                        <td width="92" align="center">${clinic.age}</td>

                        <td width="81" align="right" style="color: #368E9D;" bgColor="#ffffff">性别</td>
                        <td width="78" align="center"><c:if test='${clinic.sex}'>男</c:if>
                            <c:if test="${!clinic.sex}">女</c:if></td>
                        <td width="81" align="right" style="color: #368E9D;" bgColor="#ffffff"> 药品金额</td>
                        <td width="92" align="center">￥<fmt:formatNumber pattern="0.00" value="${clinic.money}"/></td>
                    </tr>
                    <tr>
                        <td width="79" align="right" style="color: #368E9D;" bgColor="#ffffff" height="25">医生</td>
                        <td width="92" align="center">${clinic.doctorName}</td>
                        <td width="81" align="right" style="color: #368E9D;" bgColor="#ffffff">配药药师</td>
                        <td width="80" align="center">${clinic.apothecaryName}</td>
                        <td width="81" align="right" style="color: #368E9D;" bgColor="#ffffff">核对药师</td>
                        <td width="80" align="center">${clinic.confirmName}</td>
                        <td width="81" align="right" style="color: #368E9D;" bgColor="#ffffff"> 就诊科室</td>
                        <td width="119" align="center">${clinic.department}</td>
                    </tr>
                    <tr>

                        <td width="81" align="right" style="color: #368E9D;" bgColor="#ffffff" height="25">诊断</td>
                        <td align="center" colspan="3">${clinic.diagnosis}</td>
                        <td width="81" align="right" style="color: #368E9D;" bgColor="#ffffff" height="25">住址</td>
                        <td align="center" colspan="3">${clinic.address}</td>
                    </tr>
                    <tr>
                        <td colspan="8" align="left">
                            <span style="font-size: 20px;font-weight: bold;">Rx:</span><br/>
                            <table width="100%" border="0">
                                <c:forEach items="${clinic.details}" var="detail" varStatus="st">
                                    <tr style="font-size:14px;">
                                        <td width="20" height="25"></td>
                                        <td width="20">${detail.num1}</td>
                                        <td width="20">${detail.num2}</td>
                                        <c:if test='${detail.medicineNo!="+"}'>
                                            <td nowrap="true" width="300">
                                                <c:if test='${detail.instructionID>0}'>    <%--有说明书--%>
                                                    <a href="#" onclick="displayInstruction(${detail.instructionID},'${detail.medicineName}',300,10)">
                                                        <c:if test="${detail.antiClass>0}">    <%--抗生素颜色特殊--%>
                                                            <span style="color: #e66e00;"> ${fn:trim(detail.dosage)} </span>
                                                        </c:if>
                                                        <c:if test="${detail.antiClass<=0}">${fn:trim(detail.dosage)}</c:if>
                                                    </a>
                                                </c:if>
                                                <c:if test='${detail.instructionID<=0}'>
                                                    <c:if test="${detail.antiClass>0}">    <%--抗生素颜色特殊--%>
                                                        <span style="color: #e66e00;"> ${fn:trim(detail.dosage)} </span>
                                                    </c:if>
                                                    <c:if test="${detail.antiClass<=0}"> ${fn:trim(detail.dosage)} </c:if>
                                                </c:if>
                                            </td>
                                            <c:if test="${detail.incompatibility==1}">
                                                <td onmouseout="hiddenPic();" onmousemove="showPic('${detail.taboo}');">
                                                    <span style="color:#ee0000;">${detail.quantity}${detail.unit} &nbsp;
                                                        (${detail.eachQuantity} ${detail.unit}／次)
                                                          　${detail.frequency}
                                                    </span>
                                                </td>
                                            </c:if>
                                            <c:if test="${detail.incompatibility!=1}">
                                                <td>${detail.quantity} ${detail.unit} &nbsp;
                                                    (${detail.eachQuantity} ${detail.unit}／次)
                                                    　${detail.frequency}
                                                </td>
                                            </c:if>
                                            <td>${detail.audit}</td>
                                        </c:if>
                                        <c:if test='${detail.medicineNo=="+"}'>
                                            <td colspan="3">${fn:trim(detail.dosage)} ${detail.adviceType} &nbsp;&nbsp;
                                                <c:choose>
                                                    <c:when test='${detail.num==1}'>Q.d.</c:when>
                                                    <c:when test='${detail.num==2}'>B.i.d.</c:when>
                                                    <c:when test='${detail.num==3}'>T.i.d.</c:when>
                                                    <c:otherwise>每天${detail.num}次</c:otherwise>
                                                </c:choose>
                                                <c:if test="${detail.dayNum >0}">×&nbsp;${detail.dayNum}天 </c:if>
                                            </td>
                                        </c:if>
                                    </tr>
                                </c:forEach>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td width="85" align="right" style="font-size: 14px;font-weight:bold;" bgColor="#ffffff" height="35">不合理项</td>
                        <td colspan="7" align="center"><input style='border-bottom:0px;border-top:0px;border-left:0px;border-right:0px;'
                                                              name="clinic.disItem" id="clinic.disItem" type="text" onclick="showQuestionDialog(this);"
                                                              value="${clinic.disItem}" size="100" maxlength="200"/></td>
                    </tr>
                    <tr>
                        <td width="85" align="right" style=" font-size: 14px;font-weight:bold;" bgColor="#ffffff">
                            点评
                        </td>
                        <td colspan="5" nowrap="true"><textarea name="clinic.result" cols="60" rows="3" id="clinic.result">${clinic.result}</textarea></td>
                        <td align="right" style="font-size: 14px;font-weight:bold;" bgColor="#ffffff">结果</td>
                        <td>
                            <input type="radio" value="1"
                                   <c:if test='${clinic.rational==1}'>checked</c:if> name="clinic.rational">合理<br/>
                            <input type="radio" value="0"
                                   <c:if test='${clinic.rational==0}'>checked</c:if> name="clinic.rational">不合理
                        </td>
                    </tr>

                    <c:if test='${clinic.appealState>0}'>
                        <tr>
                            <td width="100" align="right" style=" font-size: 14px;font-weight:bold;" bgColor="#ffffff" height="35">
                                申诉内容
                            </td>
                            <td width="150" colspan="7" nowrap="true">${appeal.appealContent}</td>
                        </tr>
                        <tr>
                            <td width="85" align="right" style=" font-size: 14px;font-weight:bold;" bgColor="#ffffff">
                                申诉回复
                            </td>
                            <td colspan="6" nowrap="true"><textarea cols="70" rows="2" id="replyContent">${appeal.replyContent}</textarea></td>
                            <td align="center" valign="middle">
                                <input type="button" id="replyBtn" value="回复"
                                <c:if test="${clinic.appealState==2}"> disabled</c:if> onclick="javascript:replyAppeal()">
                            </td>
                        </tr>
                    </c:if>
                </table>
            </td>
        </tr>
    </table>
    <input type="hidden" id="clinic.clinicID" name="clinic.clinicID" value="${clinic.clinicID}"/>
</form>
<div id="dialog-error" class="hide alert" title="提示">
    <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
</div>
<div id="question-choose" class="modal fade" tabindex="-1">
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
</body>
</html>