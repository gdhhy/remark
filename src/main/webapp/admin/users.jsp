<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="../components/datatables/jquery.dataTables.min.js"></script>
<script src="../components/datatables/jquery.dataTables.bootstrap.min.js"></script>
<script src="../components/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="../components/datatables/dataTables.select.min.js"></script>

<script src="../components/jquery-ui/jquery-ui.min.js"></script>
<!--不能用1.11.4-->
<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>
<script src="../components/jquery.gritter/js/jquery.gritter.js"></script>
<script src="../assets/js/jquery.validate.min.js"></script>
<script src="../components/chosen/chosen.jquery.js"></script>
<link rel="stylesheet" href="../components/bootstrap-datetimepicker/bootstrap-datetimepicker.css"/>
<link rel="stylesheet" href="../components/jquery-ui/jquery-ui.min.css"/>
<link rel="stylesheet" href="../components/jquery-ui.custom/jquery-ui.custom.min.css"/>
<link rel="stylesheet" href="../components/jquery.gritter/css/jquery.gritter.min.css"/>
<link rel="stylesheet" href="../components/chosen/chosen.min.css"/>
<link rel="stylesheet" href="../css/joinbuy.css"/>

<script type="text/javascript">
    jQuery(function ($) {
        //var editor = new $.fn.dataTable.Editor({});
        //initiate dataTables plugin
        var myTable = $('#dynamic-table')
        //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
            .DataTable({
                bAutoWidth: false,
                "columns": [
                    {"data": "userID"},
                    {"data": "loginName", "sClass": "center"},
                    {"data": "name", "sClass": "center", "defaultContent": ""},
                    {"data": "roles", "sClass": "center", "defaultContent": ""},
                    {"data": "createDate", "sClass": "center"},
                    {"data": "lastLoginTime", "sClass": "center", "defaultContent": ""},
                    {"data": "failureLogin", "sClass": "center", "defaultContent": ""},
                    {"data": "succeedLogin", "sClass": "center", "defaultContent": ""}
                ],

                'columnDefs': [
                    {
                        "searchable": false, "orderable": false, className: 'text-center', "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {"searchable": true, "orderable": false, title: '登录名', className: 'text-center', "targets": 1},
                    {"searchable": true, "orderable": false, title: '用户姓名', className: 'text-center', "targets": 2},
                    {"searchable": true, "orderable": false, title: '角色', className: 'text-center', "targets": 3},
                    {"searchable": false, "orderable": false, title: '创建时间', className: 'text-center', "targets": 4},
                    {"searchable": true, "orderable": false, title: '最后登录时间', className: 'text-center', "targets": 5},
                    {"searchable": false, "orderable": false, title: '连续失败次数', className: 'text-center', "targets": 6},
                    {"searchable": true, "orderable": false, title: '累计登录次数', className: 'text-center', "targets": 7},
                    {
                        'targets': 8, 'searchable': false, 'orderable': false, width: 60, data: 'userID',
                        render: function (data, type, row, meta) {
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="green" href="#" data-userID="{0}">'.format(data) +
                                '<i class="ace-icon fa fa-pencil bigger-130"></i>' +
                                '</a>' +
                                '<a class="black" href="#" data-userID="{0}" data-goodsName="{1}">'.format(data, row["name"]) +
                                '<i class="ace-icon fa fa-trash-o bigger-130"></i>' +
                                '</a>' +
                                '</div>';
                        }
                    }],
                "aaSorting": [],
                language: {
                    url: '/components/datatables/datatables.chinese.json'
                },
                "ajax": "/rbac/listUser.jspa",

                select: {
                    style: 'single'
                }
            });
        myTable.on('draw', function () {
            $('a.green').on('click', function (e) {
                e.preventDefault();
                showUserDialog($(this).attr("data-userID"));
            });
            $('a.black').on('click', function (e) {
                e.preventDefault();
                deleteUser($(this).attr("data-userID"), $(this).attr("data-goodsName"))
            });
        });

        var userForm = $('#userForm');
        userForm.validate({
            errorElement: 'div',
            errorClass: 'help-block',
            focusInvalid: false,
            ignore: "",
            rules: {
                loginName: {required: true},
                name: {required: true},
                password: {required: false, minlength: 6},
                pwdretry: {equalTo: "#form-password"},
                groupID: {required: true}
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
                //console.log(userForm.serialize());// + "&productImage=" + av atar_ele.get(0).src);
                //console.log("form:" + form);
                $.ajax({
                    type: "POST",
                    url: "/rbac/saveUser.jspa",
                    data: userForm.serialize(),//+ "&productImage=" + av atar_ele.get(0).src,
                    contentType: "application/x-www-form-urlencoded",//http://www.cnblogs.com/yoyotl/p/5853206.html
                    cache: false,
                    success: function (response, textStatus) {
                        var result = JSON.parse(response);
                        if (!result.succeed) {
                            $("#errorText").text(result.errmsg);
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
        /*https://www.gyrocode.com/articles/jquery-datatables-checkboxes/*/

        //$.fn.dataTable.Buttons.swfPath = "components/datatables.net-buttons-swf/index.swf"; //in Ace demo ../components will be replaced by correct assets path
        $.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';

        new $.fn.dataTable.Buttons(myTable, {
            buttons: [
                {
                    "text": "<i class='fa fa-user-plus bigger-110 red'></i>新增 ",
                    "className": "btn btn-xs btn-white btn-primary"
                }
            ]
        });
        myTable.buttons().container().appendTo($('.tableTools-container'));

        function deleteUser(userID, goodsName) {
            if (userID === undefined) return;
            $('#name').text(goodsName);
            $("#dialog-delete").removeClass('hide').dialog({
                resizable: false,
                modal: true,
                title: "确认删除用户",
                title_html: true,
                buttons: [
                    {
                        html: "<i class='ace-icon fa  fa-trash bigger-110'></i>&nbsp;确定",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            $.ajax({
                                type: "POST",
                                url: "/rbac/deleteUser.jspa?userID=" + userID,
                                //contentType: "application/x-www-form-urlencoded",//http://www.cnblogs.com/yoyotl/p/5853206.html
                                cache: false,
                                success: function (response, textStatus) {
                                    var result = JSON.parse(response);
                                    if (result.succeed)
                                        myTable.ajax.reload();
                                    else
                                        showDialog("请求结果：" + result.succeed, response);
                                },
                                error: function (response, textStatus) {/*能够接收404,500等错误*/
                                    showDialog("请求状态码：" + response.status, response.responseText.substr(0, 1000));
                                    /* $("#errorText").text(response.responseText.substr(0, 1000));
                                     $("#dialog-error").removeClass('hide').dialog({
                                         modal: true,
                                         width: 600,
                                         title: "请求状态码：" + response.status,//404，500等
                                         buttons: [{
                                             text: "确定", "class": "btn btn-primary btn-xs", click: function () {
                                                 $(this).dialog("close");
                                             }
                                         }]
                                     });*/
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

        $.gritter.options.class_name = 'gritter-center';


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


        function showUserDialog(userID) {
            //userForm[0].reset();
            $("#form-roles option").each(function () {
                $(this).removeAttr("selected");
            });
            if (userID != null) {
                // var htmlobj = $.ajax({url: "rbac/showUser.jspa?userID=" + userID, async: false});
                $.getJSON("/rbac/showUser.jspa?userID=" + userID, function (result) { //https://www.cnblogs.com/liuling/archive/2013/02/07/sdafsd.html
                    $("#form-name").val(result["name"]);
                    $("#form-loginName").val(result["loginName"]);
                    //$("#form-roles").get(0).selectedIndex = result["roles"];//OK
                    var roles = result["roles"].split(",");

                    for (var i = 0; i < roles.length; i++)
                        $("#form-roles option[value='" + roles[i] + "']").attr("selected", "selected");

                    $("#form-roles").trigger("chosen:updated");
                });
                $("#form-userID").val(userID);
            }

            /*  $.getJSON("/rbac/listRole.jspa", function (result) { //https://www.cnblogs.com/liuling/archive/2013/02/07/sdafsd.html
                  if (result.iTotalRecords > 0) {
                      $.each(result.data, function (n, value) {
                          console.log("value.roleID:" + '<option value="{0}">{1}</option>'.format(value.roleNo, value.roleNo));
                          $('#form-roleID').append('<option value="{0}">{1}</option>'.format(value.roleNo, value.roleNo));
                      });
                      $('#form-roleID').val("");
                  }
              });*/
            $("#dialog-edit").removeClass('hide').dialog({
                resizable: false,
                width: 450,
                height: 530,
                modal: true,
                title: userID == null ? "增加用户" : "设置用户",
                title_html: true,
                buttons: [
                    {
                        html: "<i class='ace-icon fa  fa-pencil-square-o bigger-110'></i>&nbsp;保存",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            //todo 直接从#form-closingTime获取时间的毫秒值!
                            if (userForm.valid())
                                userForm.submit();
                            //$(this).dialog("close");
                        }
                    }, {
                        html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 取消",
                        "class": "btn btn-minier",
                        click: function () {
                            $(this).dialog("close");
                            //$('.chosen-select').destroy().init()
                        }
                    }
                ]
            });
        }


        myTable.button(0).action(function (e, dt, button, config) {
            e.preventDefault();
            showUserDialog(null);
        });

        $('.chosen-select').chosen({allow_single_deselect: true, no_results_text: "未找到此选项!"});
        //resize the chosen on window resize

        $(window)
            .off('resize.chosen')
            .on('resize.chosen', function () {
                $('.chosen-select').each(function () {
                    var $this = $(this);
                    $this.next().css({'width': 190});
                })
            }).trigger('resize.chosen');
        //resize chosen on sidebar collapse/expand
        $(document).on('settings.ace.chosen', function (e, event_name, event_val) {
            console.log("settings.ace.chosen");
            if (event_name !== 'sidebar_collapsed') return;
            $('.chosen-select').each(function () {
                var $this = $(this);
                $this.next().css({'width': 190});
            })
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
        <li class="active">用户管理</li>
    </ul><!-- /.breadcrumb -->
</div>

<!-- /section:basics/content.breadcrumbs -->
<div class="page-content">

    <div class="page-header">
        <h1>用户管理 </h1>
    </div><!-- /.page-header -->

    <div class="row">
        <div class="col-xs-12">

            <div class="row">

                <div class="col-xs-12">
                    <div class="table-header">
                        用户列表
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
    <div id="dialog-error" class="hide alert" title="提示">
        <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
    </div>

    <div id="dialog-delete" class="hide">
        <div class="alert alert-info bigger-110">
            永久删除 <span id="name" class="red"></span> ，不可恢复！
        </div>

        <div class="space-6"></div>

        <p class="bigger-110 bolder center grey">
            <i class="icon-hand-right blue bigger-120"></i>
            确认吗？
        </p>
    </div>
    <div id="dialog-edit" class="hide">
        <form class="form-horizontal" role="form" id="userForm">
            <div id="container">
                <div class="col-xs-11">
                    <input type="hidden" id="form-userID" name="userID"/>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-name">登录名 </label>

                        <div class="col-sm-9">
                            <div class="input-group">
                                <input type="text" id="form-loginName" name="loginName" placeholder="登录名" class="col-xs-10 col-sm-12"/>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-name">用户姓名</label>
                        <div class="col-sm-7">
                            <!-- #section:plugins/date-time.datepicker -->
                            <div class="input-group">
                                <input type="text" class="form-control col-xs-10 col-sm-12" name="name" id="form-name"/>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-password">登录密码 </label>

                        <div class="col-sm-9">
                            <div class="input-group">
                                <input type="password" id="form-password" placeholder="输入密码" autocomplete="false" name="password" class="col-xs-10 col-sm-12"/>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-pwdretry">密码确认 </label>

                        <div class="col-sm-9">
                            <div class="input-group">
                                <input type="password" id="form-pwdretry" placeholder="再次确认" autocomplete="false" name="pwdretry" class="col-xs-10 col-sm-12"/>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="form-roles" class="col-sm-3 control-label no-padding-right">角色</label>
                        <div class="col-sm-9">
                            <div class="input-group">
                                <select class="chosen-select" id="form-roles" data-placeholder="选择角色" name="roles" multiple>
                                    <option value=""></option>
                                    <option value="ADMIN">管理员</option>
                                    <option value="USER">普通用户</option>
                                    <option value="DEVELOP">系统开发</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <%--<div class="form-group">
                        <label for="form-groupID" class="col-sm-3 control-label no-padding-right">部门</label>

                        <div class="col-sm-9">
                            <div class="input-group">
                                <select class="chosen-select" id="form-groupID" data-placeholder="选择部门" name="groupID">
                                    <option value=""></option>
                                    <option value="1">营销部</option>
                                    <option value="2">技术部</option>
                                </select>
                            </div>
                        </div>
                    </div>--%>


                </div>
            </div>
        </form>
    </div>

    <%--<div id="dialog-alert" title="警告" class="hidden">
        <p>未选择足够的付款二维码！</p>
    </div>--%>
    <div id="dialog-null" class="hidden">
        <div id="dialog-content"></div>
    </div>
</div>
<!-- /.page-content -->