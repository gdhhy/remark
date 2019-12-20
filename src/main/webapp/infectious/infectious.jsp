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
<script src="../assets/js/jquery.validate.messages_cn.js"></script>
<script src="../components/moment/moment.min.js"></script>
<script src="../components/bootstrap-daterangepicker/daterangepicker.js"></script>
<script src="../components/bootstrap-daterangepicker/daterangepicker.zh-CN.js"></script>
<script src="../components/chosen/chosen.jquery.js"></script>

<link rel="stylesheet" href="../components/bootstrap-daterangepicker/daterangepicker.css"/>
<link rel="stylesheet" href="../components/chosen/chosen.min.css"/>
<!-- ace styles -->
<link rel="stylesheet" href="../assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/>

<script type="text/javascript">
    jQuery(function ($) {
        var startDate = moment().month(moment().month() - 1).startOf('month');
        // var endDate = moment().month(moment().month() - 1).endOf('month');

        var url = "/infectious/getInfectiousList.jspa";
        //var editor = new $.fn.dataTable.Editor({});
        //initiate dataTables plugin


        $('.chooseDate').daterangepicker({
            'applyClass': 'btn-sm btn-success',
            'cancelClass': 'btn-sm btn-default',
            singleDatePicker: true, showDropdowns: true,
            autoUpdateInput: false, //关闭自动赋值，使初始值为空
            locale: locale
        }, function (start, end, label) {
            startDate = start;
            this.autoUpdateInput = true;//选完日期后打开自动赋值
        }).css("min-width", "100px").next("i").click(function () {
            // 对日期的i标签增加click事件，使其在鼠标点击时可以拉出日期选择
            $(this).parent().find('input').click();
        }).next().on(ace.click_event, function () {
            $(this).prev().focus();
        });
        $('#queryItem').on('change', function (e) {
            //console.log("value:" + this.options[this.selectedIndex].innerHTML );
            $('#queryField').attr("placeholder", this.options[this.selectedIndex].innerHTML);
        });

        $('.chooseDateTime').daterangepicker({
            'applyClass': 'btn-sm btn-success',
            'cancelClass': 'btn-sm btn-default',
            singleDatePicker: true, showDropdowns: true,
            "timePicker": true, "timePicker24Hour": true,
            autoUpdateInput: false, //关闭自动赋值，使初始值为空
            locale: localeWithTime
        }, function (start, end, label) {
            startDate = start;
            this.autoUpdateInput = true;//选完日期后打开自动赋值
        }).css("min-width", "130px").next("i").click(function () {
            // 对日期的i标签增加click事件，使其在鼠标点击时可以拉出日期选择
            $(this).parent().find('input').click();
        }).next().on(ace.click_event, function () {
            $(this).prev().focus();
        });
        $('#queryItem').on('change', function (e) {
            //console.log("value:" + this.options[this.selectedIndex].innerHTML );
            $('#queryField').attr("placeholder", this.options[this.selectedIndex].innerHTML);
        });

        $('.multiple-chosen').chosen({allow_single_deselect: true, no_results_text: "未找到此选项!"});
        //$('.chosen-select').chosen({allow_single_deselect: true});
        //$('.multiple-chosen').addClass('tag-input-style');
        var infectious0 = ['鼠疫', '霍乱'];
        var infectious1 = ['传染性非典型肺炎', '艾滋病', 'HIV', '脊髓灰质炎', '流行性出血热', '新生儿破伤风', '麻疹', '流行性脑脊髓膜炎', '登革热', '布鲁氏菌病', '钩端螺旋体病', '流行性乙型脑炎',
            '白喉', '猩红热', '人感染H7N9禽流感', '百日咳', '血吸虫病', '淋病', '人感染高致病性禽流感', '狂犬病', '病毒性肝炎-甲型', '病毒性肝炎-乙型', '病毒性肝炎-丙型', '病毒性肝炎-戊型',
            '病毒性肝炎-未分型', '疟疾-间日疟', '疟疾-恶性疟', '疟疾-未分型', '炭疽-肺炭疽', '炭疽-皮肤炭疽', '炭疽-未分型', '痢疾-细菌性', '痢疾-阿米巴性', '伤寒-伤寒', '伤寒-副伤寒',
            '肺结核-涂阳', '肺结核-仅培阳', '肺结核-菌阴', '肺结核-未痰检', '梅毒-Ⅰ期', '梅毒-Ⅱ期', '梅毒-Ⅲ期', '梅毒-胎传', '梅毒-隐性'];
        var infectious2 = ['流行性感冒', '流行性腮腺炎', '风疹', '急性出血结膜炎', '麻风病', '流行性和地方性斑疹伤寒', '黑热病', '包虫病', '丝虫病',
            '除霍乱、细菌性和阿米巴性痢疾、伤寒和副伤寒以外的感染性腹泻病', '手足口病'];
        var infectious3 = ['水痘', '不明原因肺炎', '人感染猪链球菌病', '结核性胸膜炎', '发热伴血小板减少综合症', '人粒细胞无形体病', '肝吸虫病', '生殖器疱疹', '不明原因肺炎', 'AFP', '生殖道沙眼衣原体感染',
            '恙虫病', '中东呼吸综合症', '埃博拉出血热', '寨卡病毒病', '不明原因', '其它'];

        var infectiousVar = [infectious0, infectious1, infectious2, infectious3];
        $('#infectiousClass').on('change', function () {
            if ($('#infectiousName option').length > 0)
                $('#infectiousName').empty();
            var kk = infectiousVar[$(this).val()];

            $.each(kk, function (index, value) {
                $("#infectiousName").append("<option value='{0}'>{1}</option>".format(value, value));
            });
            $('#vdBox').collapse('hide');
        });
        $.each(infectious${infectious.infectiousClass}, function (index, value) {
            $("#infectiousName").append("<option value='{0}' {1}>{2}</option>".format(value, '${infectious.infectiousName}' === value ? 'selected' : '', value));
        });

        //性病打开vdBox
        var venerism = ['梅毒', '淋病', '生殖道沙眼衣原体感染', '生殖器疱疹', '艾滋病', '尖锐湿疣'];
        $('#infectiousName').on('change', function () {
            var changeValue = $(this).val();
            $.each(venerism, function (index, value) {
                if (value === changeValue || changeValue.startsWith(value)) {
                    $('#vdBox').collapse('show');
                    return false;
                }
            });

            $('#vdBox').collapse('hide');
        });

        $('#vdBox').addClass("collapse");//默认关闭
        for (var k = 0; k < venerism.length; k++) {
            if ('${infectious.infectiousName}' !== '' && (venerism[k] === '${infectious.infectiousName}' || '${infectious.infectiousName}'.startsWith(venerism[k])))
                $('#vdBox').collapse('show');
        }

        //性病打开vdBox -- 结束

        //接触史 多选项，按位于
        $("#touchHis option").each(function () {
            if (($(this).val() & ${infectious.touchHis}) === parseInt($(this).val()))
                $(this).attr("selected", "selected");
        });
        $("#touchHis").trigger("chosen:updated");
        //多选项 结束

        //民族其他选项
        $("input[name=nation]").click(function () {
            if ($(this).val() === "2")
                $('#nationElse').removeClass("hidden");
            else
                $('#nationElse').addClass("hidden");
        });
        //职业其他选项
        $('#occupation').on('change', function (e) {
            if ($(this).val() === "18")
                $('#occupationElse').removeClass("hidden");
            else
                $('#occupationElse').addClass("hidden");
        });
        //新建传入0，而具体职业occupationElse从his读入
        if ('${infectious.occupation}' === '0' && '${infectious.occupationElse}' !== '') {
            var elseOccu = true;
            $('#occupation option').each(function () {
                //console.log("$(this).val() :" + $(this).text());
                if ($(this).text() === '${infectious.occupationElse}') {
                    $(this).attr("selected", "selected");
                    $('#occupationElse').val('');
                    return false;
                }
            });
            if (elseOccu) {
                $('#occupation option[value=18]').attr("selected", "selected");
                $('#occupationElse').removeClass("hidden");
            }
        }

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

        var infectiousForm = $('#infectiousForm');
        infectiousForm.validate({
            errorElement: 'div',
            errorClass: 'help-block',
            focusInvalid: false,
            ignore: "",
            rules: {
                patientName: {required: true},
                address: {required: true},
                caseClass1: {required: true},
                caseClass2: {required: true}
            },

            highlight: function (e) {
                $(e).closest('.control-label').removeClass('has-info').addClass('has-error');
            },

            success: function (e) {
                $(e).closest('.control-label').removeClass('has-error');//.addClass('has-info');
                $(e).remove();
            },

            errorPlacement: function (error, element) {
               /* if (element.is(":radio"))
                    error.appendTo(element.parent().next().next());
                else if (element.is(":checkbox"))
                    error.appendTo(element.next());
                else*/
                    error.insertAfter(element.parent());
            },

            submitHandler: function (form) {
                $('#caseClass').val(parseInt($('input:radio[name="caseClass1"]:checked').val()) + 10 * parseInt($('input:radio[name="caseClass2"]:checked').val()));
                /*                var touchVar = $("#touchHis").val();
                                console.log("touchVar:" + touchVar);*/
                var touchVar = 0;
                $("#touchHis option:selected").each(function () {
                    touchVar += parseInt($(this).val());
                });
                //console.log("touchVar:" + touchVar);
                $("input[name='touchHis']").val(touchVar);

                var submitData = {};
                $.each(infectiousForm.serializeArray(), function (index, object) {
                    if (object.name !== 'caseClass1' && object.name !== 'caseClass2')
                        submitData[object.name] = object.value;
                });
                console.log("json:" + JSON.stringify(submitData));
                $.ajax({
                    type: "POST",
                    url: "/infectious/saveInfectious.jspa",
                    data: JSON.stringify(submitData),//+ "&productImage=" + av atar_ele.get(0).src,
                    contentType: "application/json; charset=utf-8",
                    cache: false,
                    success: function (response, textStatus) {
                        var result = JSON.parse(response);
                        $("#errorText").html(result.message);

                        $("#dialog-error").removeClass('hide').dialog({
                            modal: true,
                            width: 600,
                            title: "保存传染病报告卡",
                            buttons: [{
                                text: "确定", "class": "btn btn-primary btn-xs", click: function () {
                                    $(this).dialog("close");
                                    //myTable.ajax.reload();
                                }
                            }]
                        });
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
        });
    })
</script>
<style>
    .row {
        margin-top: 4px;
        margin-bottom: 4px;
    }
</style>
<!-- #section:basics/content.breadcrumbs -->
<div class="breadcrumbs ace-save-state" id="breadcrumbs">
    <ul class="breadcrumb">
        <li>
            <i class="ace-icon fa fa-home home-icon"></i>
            <a href="/index.jspa">首页</a>
        </li>
        <li class="active">传染病报告卡</li>
    </ul><!-- /.breadcrumb -->


    <!-- /section:basics/content.searchbox -->
</div>

<!-- /section:basics/content.breadcrumbs -->
<div class="page-content" style="width: 880px">
    <div class="page-header">
        <h1>传染病报告卡 </h1>
    </div><!-- /.page-header -->

    <div class="row">
        <div class="col-xs-12">
            <!-- PAGE CONTENT BEGINS -->
            <form class="form-horizontal form-inline" id="infectiousForm" name="infectiousForm">
                <div class="row">
                    <label class="col-sm-1 control-label no-padding-right" for="reportNo"> 卡片编号 </label>
                    <div class="col-sm-4">
                        <input type="text" id="reportNo" name="reportNo" class="col-xs-10 col-sm-5" value="${infectious.reportNo}"/>
                    </div>

                    <label class="col-sm-2 control-label no-padding-right red2 "> 报告卡类别 </label>
                    <div class="col-sm-5">
                        <div class="radio col-sm-6 ">
                            <label style="white-space: nowrap">
                                <input name="reportType" type="radio" class="ace" value="1"<c:if test='${infectious.reportType==1}'> checked</c:if>/>
                                <span class="lbl">初次报告</span>
                            </label>
                        </div>
                        <div class="radio col-sm-6">
                            <label style="white-space: nowrap">
                                <input name="reportType" type="radio" class="ace" value="2"<c:if test='${infectious.reportType==2}'> checked</c:if> />
                                <span class="lbl">订正报告</span>
                            </label>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="widget-box  " style="width: 870px;padding: 0;margin: 0;">
                        <div class="widget-body ">
                            <div class="widget-main" style="padding-top: 0;padding-bottom:0">
                                <div class="row">
                                    <div class="col-sm-6 form-group">
                                        <label class="col-sm-2  control-label no-padding-right no-padding-left red2" for="patientName">&nbsp;&nbsp;&nbsp;患者姓名 </label>

                                        <div class="col-sm-8">
                                            <input type="text" id="patientName" name="patientName" value="${infectious.patientName}"/>
                                        </div>
                                    </div>
                                    <label class=" col-sm-2 control-label no-padding-right" for="patientParent"> 患儿家长姓名 </label>

                                    <div class="col-sm-2 col-lg-1">
                                        <input type="text" id="patientParent" name="patientParent" value="${infectious.patientParent}"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class=" col-sm-1  control-label no-padding-right" for="idCardNo"> 身份证号 </label>

                                    <div class="col-sm-5">
                                        <input type="text" id="idCardNo" name="idCardNo" style="width: 100%" value="${infectious.idCardNo}"/>
                                    </div>

                                    <label class=" col-sm-1 control-label no-padding-right"> 性别 </label>

                                    <div class="col-sm-2">
                                        <div class="radio col-sm-6">
                                            <label style="white-space: nowrap">
                                                <input name="boy" type="radio" class="ace" value="1"<c:if test='${infectious.boy==1}'> checked</c:if>/>
                                                <span class="lbl">男</span>
                                            </label>
                                        </div>

                                        <div class="radio col-sm-6">
                                            <label style="white-space: nowrap">
                                                <input name="boy" type="radio" class="ace" value="0" <c:if test='${infectious.boy==0}'> checked</c:if>/>
                                                <span class="lbl">女</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class=" col-sm-1  control-label no-padding-right" for="birthday"> 出生日期 </label>


                                    <div class="col-sm-3 ">
                                        <div class=" input-group">
                                            <input class="form-control nav-search-input chooseDate" name="birthday" id="birthday" style="color: black"
                                                   value="${infectious.birthday}"/>
                                            <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
                                        </div>
                                    </div>
                                    <label class="col-sm-3 control-label no-padding-right" for="age">（如出生日期不详，实足年龄： </label>
                                    <div class="col-sm-1 ">
                                        <input type="text" id="age" name="age" style="width: 100%" value="${infectious.age}"/>
                                    </div>

                                    <label class=" col-sm-1 control-label no-padding-right">年龄单位 </label>
                                    <div class="col-sm-2">
                                        <div class="radio col-sm-4">
                                            <label style="white-space: nowrap">
                                                <input name="ageUnit" type="radio" class="ace" value="1"<c:if test='${infectious.ageUnit==1}'> checked</c:if>/>
                                                <span class="lbl">岁</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-4">

                                            <label style="white-space: nowrap">
                                                <input name="ageUnit" type="radio" class="ace" value="2"<c:if test='${infectious.ageUnit==2}'> checked</c:if>/>
                                                <span class="lbl">月</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-4">
                                            <label style="white-space: nowrap">
                                                <input name="ageUnit" type="radio" class="ace" value="4"<c:if test='${infectious.ageUnit==4}'> checked</c:if>/>
                                                <span class="lbl">天）</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1  control-label no-padding-right" for="workplace"> 工作单位 </label>

                                    <div class="col-sm-7">
                                        <input type="text" id="workplace" name="workplace" style="width: 100%" value="${infectious.workplace}"/>
                                    </div>
                                    <label class=" col-sm-1 control-label no-padding-right" for="linkPhone"> 联系电话 </label>

                                    <div class="col-sm-3">
                                        <input type="text" id="linkPhone" name="linkPhone" value="${infectious.linkPhone}"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1 control-label no-padding-right "> 病人属于 </label>
                                    <div class="col-sm-11">
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="本县区"<c:if test='${infectious.belongTo eq "本县区"}'> checked</c:if>/>
                                                <span class="lbl">本县区</span>
                                            </label>
                                        </div>

                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="本市其他县区"<c:if test='${infectious.belongTo eq "本市其他县区"}'> checked</c:if>/>
                                                <span class="lbl">本市其他县区</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="本省其它地市"<c:if test='${infectious.belongTo eq "本省其它地市"}'> checked</c:if>/>
                                                <span class="lbl">本省其它地市</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="外省"<c:if test='${infectious.belongTo eq "外省"}'> checked</c:if>/>
                                                <span class="lbl">外省</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="港澳台"<c:if test='${infectious.belongTo eq "港澳台"}'> checked</c:if>/>
                                                <span class="lbl">港澳台</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="外籍"<c:if test='${infectious.belongTo eq "外籍"}'> checked</c:if>/>
                                                <span class="lbl">外籍</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1  control-label no-padding-right light-red" for="address"> 现住址 </label>

                                    <div class="col-sm-10">
                                        <input type="text" id="address" name="address" style="width: 100%" value="${infectious.address}"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1 control-label no-padding-right  light-red"> 患者职业 </label>
                                    <div class="col-sm-2">
                                        <select class="chosen-select form-control" id="occupation" name="occupation">
                                            <option value="1"<c:if test='${infectious.occupation==1}'> selected</c:if>>幼托儿童</option>
                                            <option value="2"<c:if test='${infectious.occupation==2}'> selected</c:if>>散居儿童</option>
                                            <option value="3"<c:if test='${infectious.occupation==3}'> selected</c:if>>学生（大中小学）</option>
                                            <option value="4"<c:if test='${infectious.occupation==4}'> selected</c:if>>教师</option>
                                            <option value="5"<c:if test='${infectious.occupation==5}'> selected</c:if>>保育员及保姆</option>
                                            <option value="6"<c:if test='${infectious.occupation==6}'> selected</c:if>>餐饮食品业</option>
                                            <option value="7"<c:if test='${infectious.occupation==7}'> selected</c:if>>商业服务</option>
                                            <option value="8"<c:if test='${infectious.occupation==8}'> selected</c:if>>医务人员</option>
                                            <option value="9"<c:if test='${infectious.occupation==9}'> selected</c:if>>工人</option>
                                            <option value="10"<c:if test='${infectious.occupation==10}'> selected</c:if>>民工</option>
                                            <option value="11"<c:if test='${infectious.occupation==11}'> selected</c:if>>农民</option>
                                            <option value="12"<c:if test='${infectious.occupation==12}'> selected</c:if>>牧民</option>
                                            <option value="13"<c:if test='${infectious.occupation==13}'> selected</c:if>>渔(船)民</option>
                                            <option value="14"<c:if test='${infectious.occupation==14}'> selected</c:if>>干部职员</option>
                                            <option value="15"<c:if test='${infectious.occupation==15}'> selected</c:if>>离退人员</option>
                                            <option value="16"<c:if test='${infectious.occupation==16}'> selected</c:if>>家务或待业</option>
                                            <option value="17"<c:if test='${infectious.occupation==17}'> selected</c:if>>不详</option>
                                            <option value="18"<c:if test='${infectious.occupation==18}'> selected</c:if>>其他</option>
                                        </select>
                                    </div>
                                    <div class="col-sm-3">
                                        <input type="text" id="occupationElse"<c:if test='${infectious.occupation!=18}'> class="hidden"</c:if> name="occupationElse"
                                               placeholder="其他职业" style="width: 100%" value="${infectious.occupationElse}"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1 control-label no-padding-right red2"> 病例分类 </label>
                                    <div class="col-sm-11">
                                        <div class="row">
                                            <label class="col-sm-1 control-label no-padding-right"> (1) </label>
                                            <div class="radio col-sm-2">
                                                <label style="white-space: nowrap">
                                                    <input name="caseClass1" type="radio" class="ace" value="1" <c:if test='${(infectious.caseClass mod 10 )==1}'> checked</c:if>/>
                                                    <span class="lbl">疑似病例</span>
                                                </label>
                                            </div>

                                            <div class="radio col-sm-2">
                                                <label style="white-space: nowrap">
                                                    <input name="caseClass1" type="radio" class="ace" value="2"<c:if test='${(infectious.caseClass mod 10)==2}'> checked</c:if>/>
                                                    <span class="lbl">临床诊断病例</span>
                                                </label>
                                            </div>
                                            <div class="radio col-sm-2">
                                                <label style="white-space: nowrap">
                                                    <input name="caseClass1" type="radio" class="ace" value="4"<c:if test='${(infectious.caseClass mod 10)==4}'> checked</c:if>/>
                                                    <span class="lbl">实验室确诊病例、病原携带者</span>
                                                </label>
                                            </div>
                                        </div>

                                        <div class="row"><label class="col-sm-1 control-label no-padding-right"> (2) </label>
                                            <div class="radio col-sm-2">
                                                <label style="white-space: nowrap">
                                                    <input name="caseClass2" type="radio" class="ace" value="1"<c:if test='${(infectious.caseClass mod 10)==1}'> checked</c:if>/>
                                                    <span class="lbl">急性</span>
                                                </label>
                                            </div>
                                            <div class="radio col-sm-2">
                                                <label style="white-space: nowrap">
                                                    <input name="caseClass2" type="radio" class="ace" value="2"<c:if test='${(infectious.caseClass mod 10)==2}'> checked</c:if>/>
                                                    <span class="lbl">慢性（乙型肝炎、血吸虫填、丙型肝炎写）</span>
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                    <input name="caseClass" id="caseClass" type="hidden"/>
                                </div>
                                <div class="row">
                                    <label class=" col-sm-1  control-label no-padding-right" for="accidentDate"> 发病日期 </label>
                                    <div class="col-sm-3 ">
                                        <div class=" input-group">
                                            <input class="form-control nav-search-input chooseDate" name="accidentDate" id="accidentDate" style="color: black"
                                                   value="${infectious.accidentDate}"/>
                                            <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
                                        </div>
                                    </div>
                                    <label class="col-sm-pull-4 control-label no-padding-right small" for="accidentDate">(病原携带者填初诊日期或就诊时间) </label>
                                </div>
                                <div class="row">
                                    <label class=" col-sm-1  control-label no-padding-right" for="diagnosisDate"> 诊断日期 </label>


                                    <div class="col-sm-3 ">
                                        <div class=" input-group">
                                            <input class="form-control nav-search-input chooseDateTime" name="diagnosisDate" id="diagnosisDate" style="color: black"
                                                   value="${infectious.diagnosisDate}"/>
                                            <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
                                        </div>
                                    </div>

                                    <label class=" col-sm-1  control-label no-padding-right" for="deathDate"> 死亡日期 </label>

                                    <div class="col-sm-3">
                                        <div class=" input-group">
                                            <input class="form-control nav-search-input chooseDate" name="deathDate" id="deathDate" style="color: black"
                                                   value="${infectious.deathDate}"/>
                                            <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="widget-box" style="width: 870px;padding: 0;margin: 0;">
                        <div class="widget-body">
                            <div class="widget-main" style="padding-top: 0;padding-bottom:0">
                                <div class="row">
                                    <label class="col-lg-1 control-label no-padding-right light-red" for="infectiousClass"> 类别 </label>
                                    <div class="col-lg-5">
                                        <select class="chosen-select2 form-control" id="infectiousClass" name="infectiousClass">
                                            <option value="0"<c:if test='${infectious.infectiousClass==0}'> selected</c:if>>甲类传染病</option>
                                            <option value="1"<c:if test='${infectious.infectiousClass==1}'> selected</c:if>>乙类传染病</option>
                                            <option value="2"<c:if test='${infectious.infectiousClass==2}'> selected</c:if>>丙类传染病</option>
                                            <option value="3"<c:if test='${infectious.infectiousClass==3}'> selected</c:if>>其他法定管理以及重点监测传染病</option>
                                        </select>
                                    </div>
                                    <label class="col-lg-1 control-label no-padding-right light-red" for="infectiousName"> 名称 </label>
                                    <div class="col-lg-5">
                                        <select class="chosen-select2 form-control" id="infectiousName" name="infectiousName">
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="widget-box" id="vdBox" style="width: 870px; padding: 0;margin: 0;">
                        <div class="widget-header  widget-header-small">
                            <h6 class="widget-title">性病报告附卡（报告性病时须加填本栏目）（全部必填）</h6>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-down"></i>
                                </a>
                            </div>
                        </div>
                        <div class="widget-body">
                            <div class="widget-main" style="padding-top: 0;padding-bottom:0">

                                <div class="row">
                                    <label class="col-sm-1 control-label no-padding-right "> 婚姻状况 </label>
                                    <div class="col-sm-6">
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="marital" type="radio" class="ace" value="1" <c:if test='${infectious.marital==1}'> checked</c:if>/>
                                                <span class="lbl">未婚</span>
                                            </label>
                                        </div>

                                        <div class="radio col-sm-3">
                                            <label style="white-space: nowrap">
                                                <input name="marital" type="radio" class="ace" value="2"<c:if test='${infectious.marital==2}'> checked</c:if>/>
                                                <span class="lbl">已婚有配偶</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-3">
                                            <label style="white-space: nowrap">
                                                <input name="marital" type="radio" class="ace" value="3"<c:if test='${infectious.marital==3}'> checked</c:if>/>
                                                <span class="lbl">离异或丧偶</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="marital" type="radio" class="ace" value="4"<c:if test='${infectious.marital==4}'> checked</c:if>/>
                                                <span class="lbl">不详</span>
                                            </label>
                                        </div>
                                    </div>

                                    <div class="col-sm-5">
                                        <label class="col-sm-2 control-label no-padding-right "> 民族 </label>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="nation" type="radio" class="ace" value="1" <c:if test='${infectious.nation==1}'> checked</c:if>/>
                                                <span class="lbl">汉族</span>
                                            </label>
                                        </div>

                                        <div class="radio col-sm-3">
                                            <label style="white-space: nowrap">
                                                <input name="nation" type="radio" class="ace" value="2"<c:if test='${infectious.nation==2}'> checked</c:if>/>
                                                <span class="lbl">其他</span>
                                            </label>
                                        </div>
                                        <div class=" col-sm-5">
                                            <input type="text" id="nationElse"<c:if test='${infectious.nation!=2}'> class="hidden"</c:if> name="nationElse" placeholder="其他民族"
                                                   style="width: 100%" value="${infectious.nationElse}"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1 control-label no-padding-right" for="education"> 文化程度 </label>
                                    <div class="col-sm-4">
                                        <select class="chosen-select form-control" id="education" name="education">
                                            <option value="1"<c:if test='${infectious.education==1}'> selected</c:if>>文盲</option>
                                            <option value="2"<c:if test='${infectious.education==2}'> selected</c:if>>小学</option>
                                            <option value="3"<c:if test='${infectious.education==3}'> selected</c:if>>初中</option>
                                            <option value="4"<c:if test='${infectious.education==4}'> selected</c:if>>高中或中专</option>
                                            <option value="5"<c:if test='${infectious.education==5}'> selected</c:if>>大专及以上</option>
                                        </select>
                                    </div>

                                    <label class="col-sm-1 control-label no-padding-right "> 性病史 </label>
                                    <div class="col-sm-4">
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="venerismHis" type="radio" class="ace" value="1"<c:if test='${infectious.venerismHis==1}'> checked</c:if>/>
                                                <span class="lbl">有</span>
                                            </label>
                                        </div>

                                        <div class="radio col-sm-3">
                                            <label style="white-space: nowrap">
                                                <input name="venerismHis" type="radio" class="ace" value="2"<c:if test='${infectious.venerismHis==2}'> checked</c:if>/>
                                                <span class="lbl">无</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-3">
                                            <label style="white-space: nowrap">
                                                <input name="venerismHis" type="radio" class="ace" value="3"<c:if test='${infectious.venerismHis==3}'> checked</c:if>/>
                                                <span class="lbl">不详</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1  control-label no-padding-right" for="registerAddr"> 户籍地址 </label>

                                    <div class="col-sm-11">
                                        <input type="text" id="registerAddr" name="registerAddr" style="width: 100%" value="${infectious.registerAddr}"/>
                                    </div>
                                </div>
                                <div class="row" <%--style="height: 35px"--%>>
                                    <label class="col-sm-2  control-label no-padding-left " for="touchHis">接触史（可多选）</label>
                                    <div class="col-sm-10">
                                        <select multiple class="chosen-select form-control multiple-chosen" id="touchHis" data-placeholder="接触史"
                                                style="width: 100%;">
                                            <option value="1">注射毒品史</option>
                                            <option value="2">非婚异性性接触史（非商业）</option>
                                            <option value="4">非婚异性性接触史（商业）</option>
                                            <option value="8"<c:if test='${(infectious.touchHis)==8}'> selected</c:if>>配偶/固定性伴阳性</option>
                                        </select>
                                        <input type="hidden" name="touchHis">
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-2 control-label no-padding-left" for="infectRoute"> 最有可能感染路径 </label>

                                    <div class="col-sm-5">
                                        <select class="chosen-select form-control" id="infectRoute" name="infectRoute">
                                            <option value="1"<c:if test='${infectious.infectRoute==1}'> selected</c:if>>注射毒品</option>
                                            <option value="2"<c:if test='${infectious.infectRoute==2}'> selected</c:if>>异性传播</option>
                                            <option value="3"<c:if test='${infectious.infectRoute==3}'> selected</c:if>>同性传播</option>
                                            <option value="4"<c:if test='${infectious.infectRoute==4}'> selected</c:if>>性接触+注射毒品</option>
                                            <option value="5"<c:if test='${infectious.infectRoute==5}'> selected</c:if>>采血（浆）</option>
                                            <option value="6"<c:if test='${infectious.infectRoute==6}'> selected</c:if>>输血/血制品史</option>
                                            <option value="7"<c:if test='${infectious.infectRoute==7}'> selected</c:if>>母婴传播</option>
                                            <option value="8"<c:if test='${infectious.infectRoute==8}'> selected</c:if>>职业暴露</option>
                                            <option value="9"<c:if test='${infectious.infectRoute==9}'> selected</c:if>>其他</option>
                                            <option value="10"<c:if test='${infectious.infectRoute==10}'> selected</c:if>>不详</option>
                                        </select>
                                    </div>
                                    <label class="col-sm-1  control-label no-padding-right" for="sampleSource"> 样本来源 </label>

                                    <div class="col-sm-4">
                                        <select class="chosen-select form-control" id="sampleSource" name="sampleSource">
                                            <option value="1"<c:if test='${infectious.sampleSource==1}'> selected</c:if>>术前检测</option>
                                            <option value="2"<c:if test='${infectious.sampleSource==2}'> selected</c:if>>受血（制品）前检测</option>
                                            <option value="3"<c:if test='${infectious.sampleSource==3}'> selected</c:if>>性病门诊</option>
                                            <option value="4"<c:if test='${infectious.sampleSource==4}'> selected</c:if>>其他就诊者检测</option>
                                            <option value="5"<c:if test='${infectious.sampleSource==5}'> selected</c:if>>婚前检查（含涉外婚姻）</option>
                                            <option value="6"<c:if test='${infectious.sampleSource==6}'> selected</c:if>>孕产期检查</option>
                                            <option value="7"<c:if test='${infectious.sampleSource==7}'> selected</c:if>>检测咨询</option>
                                            <option value="8"<c:if test='${infectious.sampleSource==8}'> selected</c:if>>阳性者配偶或性伴检测</option>
                                            <option value="9"<c:if test='${infectious.sampleSource==9}'> selected</c:if>>女性阳性者子女检测</option>
                                            <option value="10"<c:if test='${infectious.sampleSource==10}'> selected</c:if>>出入境人员体检</option>
                                            <option value="11"<c:if test='${infectious.sampleSource==11}'> selected</c:if>>新兵体检</option>
                                            <option value="12"<c:if test='${infectious.sampleSource==12}'> selected</c:if>>强制/劳教戒毒人员检测</option>
                                            <option value="13"<c:if test='${infectious.sampleSource==13}'> selected</c:if>>妇教所/女劳收教人员检测</option>
                                            <option value="14"<c:if test='${infectious.sampleSource==14}'> selected</c:if>>其他羁押人员体检</option>
                                            <option value="15"<c:if test='${infectious.sampleSource==15}'> selected</c:if>>专题调查</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-2 control-label no-padding-left "> 实验室检测结论 </label>
                                    <div class="col-sm-pull-0">
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="conclusion" type="radio" class="ace" value="1"<c:if test='${infectious.conclusion==1}'> checked</c:if>/>
                                                <span class="lbl">确认结果阳性</span>
                                            </label>
                                        </div>

                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="conclusion" type="radio" class="ace" value="2"<c:if test='${infectious.conclusion==2}'> checked</c:if>/>
                                                <span class="lbl">替代策略检测阳性</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="conclusion" type="radio" class="ace" value="3"<c:if test='${infectious.conclusion==3}'> checked</c:if>/>
                                                <span class="lbl">核酸检测阳性</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-5">
                                        <label class=" col-sm-9  control-label no-padding-left" for="checkConfirmDate"> 确认（替代策略核算）检测阳性日期 </label>
                                        <div class="col-sm-3">
                                            <div class=" input-group">
                                                <input class="form-control nav-search-input chooseDate" name="checkConfirmDate" id="checkConfirmDate"
                                                       style="color: black" value="${infectious.checkConfirmDate}"/>
                                                <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-7">
                                        <label class=" col-sm-4  control-label no-padding-right" for="hivConfirmDate"> 艾滋病确诊日期 </label>

                                        <div class="col-sm-3">
                                            <div class=" input-group">
                                                <input class="form-control nav-search-input chooseDate" name="hivConfirmDate" id="hivConfirmDate" style="color: black"
                                                       value="${infectious.hivConfirmDate}"/>
                                                <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
                                            </div>
                                        </div>

                                        <label class="col-sm-5 control-label no-padding-right small"> （确诊为艾滋病是必须填写）</label></div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-3  control-label no-padding-right" for="checkUnit"> 确认（替代策略核算）检测单位 </label>

                                    <div class="col-sm-9">
                                        <input type="text" id="checkUnit" name="checkUnit" style="width: 100%" value="${infectious.checkUnit}"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="widget-box" style="width: 870px;padding: 0;margin: 0;">
                        <div class="widget-body ">
                            <div class="widget-main" style="padding-top: 0;padding-bottom:0">
                                <div class="row">
                                    <label class="col-sm-1 control-label no-padding-right" for="correctName"> 订正病名 </label>
                                    <div class="col-sm-3">
                                        <input type="text" id="correctName" name="correctName" style="width: 100%" value="${infectious.correctName}"/>
                                    </div>
                                    <label class="col-sm-1 control-label no-padding-right" for="cancelCause"> 退卡原因 </label>
                                    <div class="col-sm-3">
                                        <input type="text" id="cancelCause" name="cancelCause" style="width: 100%" value="${infectious.cancelCause}"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1 control-label no-padding-right" for="reportUnit"> 报告单位 </label>
                                    <div class="col-sm-3">
                                        <input type="text" id="reportUnit" name="reportUnit" placeholder="报告单位" style="width: 100%" value="${infectious.reportUnit}"/>
                                    </div>
                                    <label class="col-sm-1 control-label no-padding-right" for="doctorPhone"> 联系电话 </label>
                                    <div class="col-sm-3">
                                        <input type="text" id="doctorPhone" name="doctorPhone" style="width: 100%" value="${infectious.doctorPhone}"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1 control-label no-padding-right light-red" for="reportDoctor"> 报告医生 </label>
                                    <div class="col-sm-3">
                                        <input type="text" id="reportDoctor" name="reportDoctor" placeholder="报告医生" style="width: 100%" value="${infectious.reportDoctor}"/>
                                    </div>
                                    <label class="col-sm-1 control-label no-padding-right light-red" for="fillTime"> 填卡日期 </label>
                                    <div class="col-sm-3">
                                        <input type="text" id="fillTime" name="fillTime" readonly placeholder="填卡日期" style="width: 100%" value="${infectious.fillTime}"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="widget-box" style="width: 870px;padding: 0;margin: 0;">
                        <div class="widget-body ">
                            <div class="widget-main" style="padding-top: 0;padding-bottom:0">
                                <div class="row">
                                    <label class="col-sm-1 control-label no-padding-right" for="memo"> 备注 </label>
                                    <div class="col-sm-11">
                                        <textarea id="memo" name="memo" style="width: 100%">${infectious.memo}</textarea>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row align-center">
                    <input type="hidden" name="infectiousID" value="${infectious.infectiousID}"/>
                    <input type="hidden" name="objectType" value="${infectious.objectType}"/>
                    <input type="hidden" name="patientID" value="${infectious.patientID}"/>
                    <input type="hidden" name="serialNo" value="${infectious.serialNo}"/>
                    <input type="hidden" name="doctorUserID" value="${infectious.doctorUserID}"/>
                    <button class="btn btn-white btn-save btn-bold">
                        <i class="ace-icon fa fa-floppy-o bigger-120 blue"></i>
                        保存
                    </button>
                </div>
            </form>
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div>
    <!-- /.row -->
</div>
<!-- /.page-content -->