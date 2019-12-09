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
            locale: locale
        }, function (start, end, label) {
            startDate = start;
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
            locale: localeWithTime
        }, function (start, end, label) {
            startDate = start;
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
        // $('.chosen-select').chosen({allow_single_deselect: true});
        //$('.multiple-chosen').addClass('tag-input-style');
        var infectious1 = ['鼠疫', '霍乱'];
        var infectious2 = ['传染性非典型肺炎', '艾滋病', 'HIV', '脊髓灰质炎', '流行性出血热', '新生儿破伤风', '麻疹', '流行性脑脊髓膜炎', '登革热', '布鲁氏菌病', '钩端螺旋体病', '流行性乙型脑炎',
            '白喉', '猩红热', '人感染H7N9禽流感', '百日咳', '血吸虫病', '淋病', '人感染高致病性禽流感', '狂犬病', '病毒性肝炎-甲型', '病毒性肝炎-乙型', '病毒性肝炎-丙型', '病毒性肝炎-戊型',
            '病毒性肝炎-未分型', '疟疾-间日疟', '疟疾-恶性疟', '疟疾-未分型', '炭疽-肺炭疽', '炭疽-皮肤炭疽', '炭疽-未分型', '痢疾-细菌性', '痢疾-阿米巴性', '伤寒-伤寒', '伤寒-副伤寒',
            '肺结核-涂阳', '肺结核-仅培阳', '肺结核-菌阴', '肺结核-未痰检', '梅毒-Ⅰ期', '梅毒-Ⅱ期', '梅毒-Ⅲ期', '梅毒-胎传', '梅毒-隐性'];
        var infectious3 = ['流行性感冒', '流行性腮腺炎', '风疹', '急性出血结膜炎', '麻风病', '流行性和地方性斑疹伤寒', '黑热病', '包虫病;', '丝虫病', '除霍乱、细菌性和阿米巴性痢疾、伤寒和副伤寒以外的感染性腹泻病', '手足口病'];
        var infectious4 = ['水痘', '不明原因肺炎', '人感染猪链球菌病', '结核性胸膜炎', '发热伴血小板减少综合症', '人粒细胞无形体病', '肝吸虫病', '生殖器疱疹', '不明原因肺炎', 'AFP', '生殖道沙眼衣原体感染',
            '恙虫病', '中东呼吸综合症', '埃博拉出血热', '寨卡病毒病', '不明原因', '其它'];
        var infectiousVar = [infectious1, infectious2, infectious3, infectious4];
        $('#infectiousClass').on('change', function (e) {
            if ($('#infectiousName option').length > 0)
                $('#infectiousName').empty();
            var kk = infectiousVar[$(this).val()];

            $.each(kk, function (index, value) {
                $("#infectiousName").append("<option value='{0}'>{1}</option>".format(value, value));
            });

        });
        $('#vdBox').collapse({toggle: true});

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

        $('.btn-save').click(function () {
            var json = {};
            json.infectiousID = $('#infectiousID').val();
            json.objectType = $('#objectType').val();
            json.serialNo = $('#serialNo').val();
            json.reportNo = $('#reportNo').val();
            json.boy = $('input:radio[name="boy"]:checked').val();
            json.birthday = $('#birthday').val();
            json.age = $('#age').val();
            json.ageUnit = $('input:radio[name="ageUnit"]:checked').val();
            json.workplace = $('#workplace').val();
            json.linkPhone = $('#linkPhone').val();
            json.belongTo = $('input:radio[name="belongTo"]:checked').val();
            json.address = $('#address').val();
            json.occupation = $('#occupation').val();
            json.occupationElse = $('#occupationElse').val();
            json.caseClass = $('input:radio[name="caseClass"]:checked').val() + $('input:radio[name="caseClass2"]:checked').val();
            json.accidentDate = $('#accidentDate').val();
            json.diagnosisDate = $('#diagnosisDate').val();
            json.deathDate = $('#deathDate').val();
            json.infectiousClass = $('#infectiousClass').val();
            json.infectiousName = $('#infectiousName').val();
            json.correctName = $('#correctName').val();
            json.cancelCause = $('#cancelCause').val();
            json.reportUnit = '${infectious.reportUnit}';

            $.ajax({
                type: "POST",
                url: 'saveInfectious.jspa',
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
                    showDialog("请求状态码：" + response.status, response.responseText);
                },
            });
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
            <form class="form-horizontal">
                <div class="row">
                    <label class="col-sm-1 control-label no-padding-right" for="reportNo"> 卡片编号 </label>
                    <div class="col-sm-4">
                        <input type="text" id="reportNo" placeholder="卡片编号" class="col-xs-10 col-sm-5"/>
                    </div>

                    <label class="col-sm-2 control-label no-padding-right red2 "> 报告卡类别 </label>
                    <div class="col-sm-5">
                        <div class="radio col-sm-6 ">
                            <label style="white-space: nowrap">
                                <input name="isStat" type="radio" class="ace" checked value="1"/>
                                <span class="lbl">初次报告</span>
                            </label>
                        </div>
                        <div class="radio col-sm-6">
                            <label style="white-space: nowrap">
                                <input name="isStat" type="radio" class="ace" value="0"/>
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
                                    <label class=" col-sm-1  control-label no-padding-right red2" for="patientName"> 患者姓名 </label>

                                    <div class="col-sm-4">
                                        <input type="text" id="patientName" placeholder="患者姓名"/>
                                    </div>
                                    <label class=" col-sm-2 control-label no-padding-right" for="patientParent"> 患儿家长姓名 </label>

                                    <div class="col-sm-5">
                                        <input type="text" id="patientParent" placeholder="患儿家长姓名"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class=" col-sm-1  control-label no-padding-right" for="idCardNo"> 身份证号 </label>

                                    <div class="col-sm-5">
                                        <input type="text" id="idCardNo" placeholder="身份证号" style="width: 100%"/>
                                    </div>

                                    <label class=" col-sm-1 control-label no-padding-right"> 性别 </label>

                                    <div class="col-sm-2">
                                        <div class="radio col-sm-6">
                                            <label style="white-space: nowrap">
                                                <input name="boy" type="radio" class="ace" checked value="1"/>
                                                <span class="lbl">男</span>
                                            </label>
                                        </div>

                                        <div class="radio col-sm-6">
                                            <label style="white-space: nowrap">
                                                <input name="boy" type="radio" class="ace" value="0"/>
                                                <span class="lbl">女</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class=" col-sm-1  control-label no-padding-right" for="birthday"> 出生日期 </label>


                                    <div class="col-sm-3 ">
                                        <div class=" input-group">
                                            <input class="form-control nav-search-input chooseDate" name="birthdayString" id="birthday" style="color: black"/>
                                            <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
                                        </div>
                                    </div>
                                    <label class="col-sm-3 control-label no-padding-right" for="age">（如出生日期不详，实足年龄： </label>
                                    <div class="col-sm-1 ">
                                        <input type="text" id="age" placeholder="年龄" style="width: 100%"/>
                                    </div>

                                    <label class=" col-sm-1 control-label no-padding-right">年龄单位 </label>
                                    <div class="col-sm-2">
                                        <div class="radio col-sm-4">
                                            <label style="white-space: nowrap">
                                                <input name="ageUnit" type="radio" class="ace" checked value="1"/>
                                                <span class="lbl">岁</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-4">
                                            <label style="white-space: nowrap">
                                                <input name="ageUnit" type="radio" class="ace" value="2"/>
                                                <span class="lbl">月</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-4">
                                            <label style="white-space: nowrap">
                                                <input name="ageUnit" type="radio" class="ace" value="4"/>
                                                <span class="lbl">天）</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1  control-label no-padding-right" for="workplace"> 工作单位 </label>

                                    <div class="col-sm-7">
                                        <input type="text" id="workplace" placeholder="工作单位" style="width: 100%"/>
                                    </div>
                                    <label class=" col-sm-1 control-label no-padding-right" for="linkPhone"> 联系电话 </label>

                                    <div class="col-sm-3">
                                        <input type="text" id="linkPhone" placeholder="联系电话"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1 control-label no-padding-right "> 病人属于 </label>
                                    <div class="col-sm-11">
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" checked value="本县区"/>
                                                <span class="lbl">本县区</span>
                                            </label>
                                        </div>

                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="本市其他县区"/>
                                                <span class="lbl">本市其他县区</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="本省其它地市"/>
                                                <span class="lbl">本省其它地市</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="外省"/>
                                                <span class="lbl">外省</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="港澳台"/>
                                                <span class="lbl">港澳台</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="外籍"/>
                                                <span class="lbl">外籍</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1  control-label no-padding-right light-red" for="address"> 现住址 </label>

                                    <div class="col-sm-11">
                                        <input type="text" id="address" placeholder="现住址" style="width: 100%"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1 control-label no-padding-right  light-red"> 患者职业 </label>

                                    <div class="col-sm-5">
                                        <select class="chosen-select form-control" id="occupation" data-placeholder="选择职业">
                                            <option value="幼托儿童">幼托儿童</option>
                                            <option value="散居儿童">散居儿童</option>
                                            <option value="学生（大中小学）">学生（大中小学）</option>
                                            <option value="教师">教师</option>
                                            <option value="保育员及保姆">保育员及保姆</option>
                                            <option value="餐饮食品业">餐饮食品业</option>
                                            <option value="商业服务">商业服务</option>
                                            <option value="医务人员">医务人员</option>
                                            <option value="工人">工人</option>
                                            <option value="民工">民工</option>
                                            <option value="农民">农民</option>
                                            <option value="牧民">牧民</option>
                                            <option value="渔(船)民">渔(船)民</option>
                                            <option value="干部职员">干部职员</option>
                                            <option value="离退人员">离退人员</option>
                                            <option value="家务或待业">家务或待业</option>
                                            <option value="不详">不详</option>
                                            <option value="其他">其他</option>
                                        </select>
                                    </div>
                                    <%--<label class="col-sm-1  control-label no-padding-right" for="occupationElse"> 其他 </label>--%>

                                    <div class="col-sm-5">
                                        <input type="text" id="occupationElse" placeholder="其他职业" style="width: 100%"/>
                                    </div>
                                    <%--<div class="col-sm-11">
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" checked value="1"/>
                                                <span class="lbl">幼托儿童</span>
                                            </label>
                                        </div>

                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="2"/>
                                                <span class="lbl">散居儿童</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="4"/>
                                                <span class="lbl">学生（大中小学）</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="8"/>
                                                <span class="lbl">教师</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="16"/>
                                                <span class="lbl">保育员及保姆</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="32"/>
                                                <span class="lbl">餐饮食品业</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="32"/>
                                                <span class="lbl">商业服务</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="belongTo" type="radio" class="ace" value="32"/>
                                                <span class="lbl">医务人员</span>
                                            </label>
                                        </div>
                                    </div>--%>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1 control-label no-padding-right red2"> 病例分类 </label>
                                    <div class="col-sm-11">
                                        <div class="row">
                                            <label class="col-sm-1 control-label no-padding-right"> (1) </label>
                                            <div class="radio col-sm-2">
                                                <label style="white-space: nowrap">
                                                    <input name="caseClass" type="radio" class="ace" checked value="1"/>
                                                    <span class="lbl">疑似病例</span>
                                                </label>
                                            </div>

                                            <div class="radio col-sm-2">
                                                <label style="white-space: nowrap">
                                                    <input name="caseClass" type="radio" class="ace" value="2"/>
                                                    <span class="lbl">临床诊断病例</span>
                                                </label>
                                            </div>
                                            <div class="radio col-sm-2">
                                                <label style="white-space: nowrap">
                                                    <input name="caseClass" type="radio" class="ace" value="4"/>
                                                    <span class="lbl">实验室确诊病例、病原携带者</span>
                                                </label>
                                            </div>
                                        </div>

                                        <div class="row"><label class="col-sm-1 control-label no-padding-right"> (2) </label>
                                            <div class="radio col-sm-2">
                                                <label style="white-space: nowrap">
                                                    <input name="caseClass2" type="radio" class="ace" value="8"/>
                                                    <span class="lbl">急性</span>
                                                </label>
                                            </div>
                                            <div class="radio col-sm-2">
                                                <label style="white-space: nowrap">
                                                    <input name="caseClass2" type="radio" class="ace" value="16"/>
                                                    <span class="lbl">慢性（乙型肝炎、血吸虫填、丙型肝炎写）</span>
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class=" col-sm-1  control-label no-padding-right" for="accidentDate"> 发病日期 </label>
                                    <div class="col-sm-3 ">
                                        <div class=" input-group">
                                            <input class="form-control nav-search-input chooseDate" name="accidentDateString" id="accidentDate" style="color: black"/>
                                            <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
                                        </div>
                                    </div>
                                    <label class="col-sm-pull-4 control-label no-padding-right small" for="accidentDate">(病原携带者填初诊日期或就诊时间) </label>
                                </div>
                                <div class="row">
                                    <label class=" col-sm-1  control-label no-padding-right" for="diagnosisDate"> 诊断日期 </label>


                                    <div class="col-sm-3 ">
                                        <div class=" input-group">
                                            <input class="form-control nav-search-input chooseDateTime" name="accidentDateString" id="diagnosisDate" style="color: black"/>
                                            <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
                                        </div>
                                    </div>

                                    <label class=" col-sm-1  control-label no-padding-right" for="deathDate"> 死亡日期 </label>

                                    <div class="col-sm-3">
                                        <div class=" input-group">
                                            <input class="form-control nav-search-input chooseDate" name="deathDateString" id="deathDate" style="color: black"/>
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
                                        <select class="chosen-select2 form-control" id="infectiousClass" data-placeholder="传染病类别">
                                            <option value="0">甲类传染病</option>
                                            <option value="1">乙类传染病</option>
                                            <option value="2">丙类传染病</option>
                                            <option value="3">其他法定管理以及重点监测传染病</option>
                                        </select>
                                    </div>
                                    <label class="col-lg-1 control-label no-padding-right light-red" for="infectiousName"> 名称 </label>
                                    <div class="col-lg-5">
                                        <select class="chosen-select2 form-control" id="infectiousName" data-placeholder="名称">
                                            <option value="甲类传染病">甲类传染病</option>
                                            <option value="乙类传染病">乙类传染病</option>
                                            <option value="丙类传染病">丙类传染病</option>
                                            <option value="其他法定管理以及重点监测传染病">其他法定管理以及重点监测传染病</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="widget-box collapsed" id="vdBox" style="width: 870px; padding: 0;margin: 0;">
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
                                                <input name="marital" type="radio" class="ace" checked value="1"/>
                                                <span class="lbl">未婚</span>
                                            </label>
                                        </div>

                                        <div class="radio col-sm-3">
                                            <label style="white-space: nowrap">
                                                <input name="marital" type="radio" class="ace" value="2"/>
                                                <span class="lbl">已婚有配偶</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-3">
                                            <label style="white-space: nowrap">
                                                <input name="marital" type="radio" class="ace" value="4"/>
                                                <span class="lbl">离异或丧偶</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="marital" type="radio" class="ace" value="8"/>
                                                <span class="lbl">不详</span>
                                            </label>
                                        </div>
                                    </div>

                                    <div class="col-sm-5">
                                        <label class="col-sm-2 control-label no-padding-right "> 民族 </label>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="nation" type="radio" class="ace" checked value="1"/>
                                                <span class="lbl">汉族</span>
                                            </label>
                                        </div>

                                        <div class="radio col-sm-3">
                                            <label style="white-space: nowrap">
                                                <input name="nation" type="radio" class="ace" value="2"/>
                                                <span class="lbl">其他</span>
                                            </label>
                                        </div>
                                        <div class=" col-sm-5">
                                            <input type="text" id="nationElse" placeholder="其他民族" style="width: 100%"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1 control-label no-padding-right" for="education"> 文化程度 </label>
                                    <div class="col-sm-4">
                                        <select class="chosen-select form-control" id="education" data-placeholder="传染病类别">
                                            <option value="1">文盲</option>
                                            <option value="2">小学</option>
                                            <option value="3">初中</option>
                                            <option value="4">高中或中专</option>
                                            <option value="4">大专及以上</option>
                                        </select>
                                    </div>

                                    <label class="col-sm-1 control-label no-padding-right "> 性病史 </label>
                                    <div class="col-sm-4">
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="venerismHis" type="radio" class="ace" checked value="1"/>
                                                <span class="lbl">有</span>
                                            </label>
                                        </div>

                                        <div class="radio col-sm-3">
                                            <label style="white-space: nowrap">
                                                <input name="venerismHis" type="radio" class="ace" value="2"/>
                                                <span class="lbl">无</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-3">
                                            <label style="white-space: nowrap">
                                                <input name="venerismHis" type="radio" class="ace" value="4"/>
                                                <span class="lbl">不详</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1  control-label no-padding-right" for="registerAddr"> 户籍地址 </label>

                                    <div class="col-sm-11">
                                        <input type="text" id="registerAddr" placeholder="户籍地址" style="width: 100%"/>
                                    </div>
                                </div>
                                <div class="row" <%--style="height: 35px"--%>>
                                    <label class="col-sm-2  control-label no-padding-left " for="touchHis">接触史（可多选）</label>
                                    <div class="col-sm-10">
                                        <select multiple class="chosen-select form-control multiple-chosen" id="touchHis" data-placeholder="接触史" style="width: 100%;">
                                            <option value="注射毒品史">注射毒品史</option>
                                            <option value="非婚异性性接触史（非商业）">非婚异性性接触史（非商业）</option>
                                            <option value="非婚异性性接触史（商业）">非婚异性性接触史（商业）</option>
                                            <option value="配偶/固定性伴阳性">配偶/固定性伴阳性</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-2 control-label no-padding-left" for="infectRoute"> 最有可能感染路径 </label>

                                    <div class="col-sm-5">
                                        <select class="chosen-select form-control" id="infectRoute" data-placeholder="最有可能感染路径">
                                            <option value="1">注射毒品</option>
                                            <option value="2">异性传播</option>
                                            <option value="3">同性传播</option>
                                            <option value="4">性接触+注射毒品</option>
                                            <option value="5">采血（浆）</option>
                                            <option value="6">输血/血制品史</option>
                                            <option value="7">母婴传播</option>
                                            <option value="8">职业暴露</option>
                                            <option value="9">其他</option>
                                            <option value="10">不详</option>
                                        </select>
                                    </div>
                                    <label class="col-sm-1  control-label no-padding-right" for="sampleSource"> 样本来源 </label>

                                    <div class="col-sm-4">
                                        <select class="chosen-select form-control" id="sampleSource" data-placeholder="样本来源">
                                            <option value="1">术前检测</option>
                                            <option value="2">受血（制品）前检测</option>
                                            <option value="3">性病门诊</option>
                                            <option value="4">其他就诊者检测</option>
                                            <option value="5">婚前检查（含涉外婚姻）</option>
                                            <option value="6">孕产期检查</option>
                                            <option value="7">检测咨询</option>
                                            <option value="8">阳性者配偶或性伴检测</option>
                                            <option value="9">女性阳性者子女检测</option>
                                            <option value="10">出入境人员体检</option>
                                            <option value="11">新兵体检</option>
                                            <option value="12">强制/劳教戒毒人员检测</option>
                                            <option value="13">妇教所/女劳收教人员检测</option>
                                            <option value="14">其他羁押人员体检</option>
                                            <option value="15">专题调查</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-2 control-label no-padding-left "> 实验室检测结论 </label>
                                    <div class="col-sm-pull-0">
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="conclusion" type="radio" class="ace" checked value="1"/>
                                                <span class="lbl">确认结果阳性</span>
                                            </label>
                                        </div>

                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="conclusion" type="radio" class="ace" value="2"/>
                                                <span class="lbl">替代策略检测阳性</span>
                                            </label>
                                        </div>
                                        <div class="radio col-sm-2">
                                            <label style="white-space: nowrap">
                                                <input name="conclusion" type="radio" class="ace" value="4"/>
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
                                                <input class="form-control nav-search-input chooseDate" name="checkConfirmDateString" id="checkConfirmDate"
                                                       style="color: black"/>
                                                <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-7">
                                        <label class=" col-sm-4  control-label no-padding-right" for="hivConfirmDate"> 艾滋病确诊日期 </label>

                                        <div class="col-sm-3">
                                            <div class=" input-group">
                                                <input class="form-control nav-search-input chooseDate" name="hivConfirmDateString" id="hivConfirmDate" style="color: black"/>
                                                <span class="input-group-addon"><i class="fa fa-calendar bigger-100"></i></span>
                                            </div>
                                        </div>

                                        <label class="col-sm-5 control-label no-padding-right small"> （确诊为艾滋病是必须填写）</label></div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-3  control-label no-padding-right" for="checkUnit"> 确认（替代策略核算）检测单位 </label>

                                    <div class="col-sm-9">
                                        <input type="text" id="checkUnit" placeholder="户籍地址" style="width: 100%"/>
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
                                        <input type="text" id="correctName" placeholder="订正病名" style="width: 100%"/>
                                    </div>
                                    <label class="col-sm-1 control-label no-padding-right" for="cancelCause"> 退卡原因 </label>
                                    <div class="col-sm-3">
                                        <input type="text" id="cancelCause" placeholder="退卡原因" style="width: 100%"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1 control-label no-padding-right" for="reportUnit"> 报告单位 </label>
                                    <div class="col-sm-3">
                                        <input type="text" id="reportUnit" placeholder="报告单位" style="width: 100%" value="${infectious.reportUnit}"/>
                                    </div>
                                    <label class="col-sm-1 control-label no-padding-right" for="doctorPhone"> 联系电话 </label>
                                    <div class="col-sm-3">
                                        <input type="text" id="doctorPhone" placeholder="联系电话" style="width: 100%" value="${infectious.doctorPhone}"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1 control-label no-padding-right light-red" for="reportDoctor"> 报告医生 </label>
                                    <div class="col-sm-3">
                                        <input type="text" id="reportDoctor" placeholder="报告医生" style="width: 100%" value="${infectious.reportDoctor}"/>
                                    </div>
                                    <label class="col-sm-1 control-label no-padding-right light-red" for="fillTime"> 填卡日期 </label>
                                    <div class="col-sm-3">
                                        <input type="text" id="fillTime" readonly placeholder="填卡日期" style="width: 100%" value="${infectious.fillTime}"/>
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
                                        <textarea id="memo" placeholder="备注" style="width: 100%"></textarea>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row align-center">
                    <input type="hidden" id="infectiousID" name="infectiousID" value="${infectious.infectiousID}"/>
                    <input type="hidden" id="objectType" name="objectType" value="${infectious.objectType}"/>
                    <input type="hidden" id="serialNo" name="serialNo" value="${infectious.serialNo}"/>
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