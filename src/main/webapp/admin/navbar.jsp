<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="navbar navbar-default" id="navbar">
    <script type="text/javascript">
        try {
            ace.settings.check('navbar', 'fixed')
        } catch (e) {
        }
        jQuery(function ($) {
            var navbarUserForm = $('#navbarUserForm');
            navbarUserForm.validate({
                errorElement: 'div',
                errorClass: 'help-block',
                focusInvalid: false,
                ignore: "",
                rules: {
                    //loginName: {required: true},
                    name: {required: true},
                    password: {required: false, minlength: 6},
                    pwdretry: {required: false, equalTo: "input[name='password']"},
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
                    $.ajax({
                        type: "POST",
                        url: "/rbac/saveUser.jspa",
                        data: navbarUserForm.serialize(),//+ "&productImage=" + av atar_ele.get(0).src,
                        contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                        cache: false,
                        success: function (response, textStatus) {
                            var result = JSON.parse(response);
                            //if (!result.succeed) {
                            if (result.succeed)
                                $("#errorText").text("保存成功，请重新登录。");
                            $("#dialog-error").removeClass('hide').dialog({
                                modal: true,
                                width: 300,
                                title: result.title,
                                buttons: [{
                                    text: "确定", "class": "btn btn-primary btn-xs", click: function () {
                                        $(this).dialog("close");
                                        if (result.succeed)
                                            $("#dialog-k12900123").dialog("close");
                                    }
                                }]
                            });
                            /* } else {
                                 $("#dialog-k12900123").dialog("close");
                             }*/
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
                        }
                    });
                },
                invalidHandler: function (form) {
                    console.log("invalidHandler");
                }
            });

            function showUserDialog() {
                $("#dialog-k12900123").removeClass('hide').dialog({
                    resizable: false,
                    width: 450,
                    modal: true,
                    title: "个人资料",
                    title_html: true,
                    buttons: [
                        {
                            html: "<i class='ace-icon fa  fa-pencil-square-o bigger-110'></i>&nbsp;保存",
                            "class": "btn btn-danger btn-minier",
                            click: function () {
                                //todo 直接从#form-closingTime获取时间的毫秒值!
                                if (navbarUserForm.valid())
                                    navbarUserForm.submit();
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

            $('.user-menu li:lt(2)').on("click", function () {
                showUserDialog();
            });
        })
    </script>

    <div class="navbar-container" id="navbar-container">
        <div class="navbar-header pull-left">
            <a href="/index.jspa" class="navbar-brand">
                <small>
                    <i class="icon-leaf"></i>
                    处方点评管理系统
                </small>
            </a><!-- /.brand -->
        </div><!-- /.navbar-header -->

        <div class="navbar-header pull-right" role="navigation">
            <ul class="nav ace-nav">

                <li class="light-blue">
                    <a data-toggle="dropdown" href="#" class="dropdown-toggle">
                        <img class="nav-user-photo" src="/assets/avatars/user.jpg" alt="用户相片"/>
                        <span class="user-info">
									<small>欢迎光临,</small>
									${user.name}
								</span>

                        <i class="icon-caret-down"></i>
                    </a>

                    <ul class="user-menu pull-right dropdown-menu dropdown-yellow dropdown-caret dropdown-close">
                        <li>
                            <a href="#">
                                <i class="ace-icon fa fa-cog"></i>
                                设置
                            </a>
                        </li>

                        <li>
                            <a href="#">
                                <i class="ace-icon fa fa-user blue"></i>
                                个人资料
                            </a>
                        </li>

                        <li class="divider"></li>

                        <li>
                            <a href="/logout.jspa">
                                <i class="ace-icon fa  fa-sign-out red"></i>
                                退出
                            </a>
                        </li>
                    </ul>
                </li>
            </ul><!-- /.ace-nav -->
        </div><!-- /.navbar-header -->
    </div><!-- /.container -->
    <div id="dialog-k12900123" class="hide">
        <form class="form-horizontal" role="form" id="navbarUserForm">
            <div id="container">
                <div class="col-xs-11">
                    <input type="hidden" name="userID" value="${user.userID}"/>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right">登录名 </label>

                        <div class="col-sm-9">
                            <div class="input-group">
                                <input type="text" name="loginName" value="${user.loginName}" readonly placeholder="登录名" class="col-xs-10 col-sm-12"/>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right">用户姓名</label>
                        <div class="col-sm-7">
                            <!-- #section:plugins/date-time.datepicker -->
                            <div class="input-group">
                                <input type="text" class="form-control col-xs-10 col-sm-12" name="name" value="${user.name}"/>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right">登录密码 </label>

                        <div class="col-sm-9">
                            <div class="input-group">
                                <input type="password" placeholder="输入密码" autocomplete="false" name="password" class="col-xs-10 col-sm-12"/>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right">密码确认 </label>

                        <div class="col-sm-9">
                            <div class="input-group">
                                <input type="password" placeholder="再次确认" autocomplete="false" name="pwdretry" class="col-xs-10 col-sm-12"/>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </form>
    </div>
    <div id="dialog-error" class="hide alert" title="提示">
        <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
    </div>
</div>