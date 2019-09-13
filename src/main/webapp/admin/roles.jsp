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
                    {"data": "roleID"},
                    {"data": "name", "sClass": "center", "defaultContent": ""},
                    {"data": "roleNo", "sClass": "center", "defaultContent": ""},
                    {"data": "layer", "sClass": "center"},
                    /*{"data": "parentID", "sClass": "center", "defaultContent": ""},*/
                    {"data": "note", "sClass": "center", "defaultContent": ""}
                ],

                'columnDefs': [
                    {
                        "searchable": false, "orderable": false, className: 'text-center', "targets": 0, width: 20, render: function (data, type, row, meta) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        }
                    },
                    {"searchable": true, "orderable": false, title: '角色名称', className: 'text-center', "targets": 1},
                    {"searchable": false, "orderable": false, title: '角色标识', className: 'text-center', "targets": 2},
                    {"searchable": true, "orderable": false, title: '层级', className: 'text-center', "targets": 3},
                    /*{"searchable": false, "orderable": false, title: '上级角色', className: 'text-center', "targets": 4},*/
                    {"searchable": true, "orderable": false, title: '备注', className: 'text-center', "targets": 4},
                    {
                        'targets': 5, 'searchable': false, 'orderable': false, width: 60, data: 'roleID',
                        render: function (data, type, row, meta) {
                            return '<div class="hidden-sm hidden-xs action-buttons">' +
                                '<a class="green" href="#" data-roleID="{0}">'.format(data) +
                                '<i class="ace-icon fa fa-pencil bigger-130"></i>' +
                                '</a>' +
                                '<a class="black" href="#" data-roleID="{0}" data-goodsName="{1}">'.format(data, row["name"]) +
                                '<i class="ace-icon fa fa-trash-o bigger-130"></i>' +
                                '</a>' +
                                '</div>';
                        }
                    }],
                "aaSorting": [],
                language: {
                    url: '/components/datatables/datatables.chinese.json'
                },
                "ajax": "/rbac/listRole.jspa",

                select: {
                    style: 'single'
                }
            });
        myTable.on('order.dt search.dt', function () {
            myTable.column(0, {search: 'applied', order: 'applied'}).nodes().each(function (cell, i) {
                cell.innerHTML = i + 1;
            });
        }).draw();
        myTable.on('draw', function () {
            $('a.green').on('click', function (e) {
                e.preventDefault();
                showRoleDialog($(this).attr("data-roleID"));
            });
            $('a.black').on('click', function (e) {
                e.preventDefault();
                deleteRole($(this).attr("data-roleID"), $(this).attr("data-goodsName"))
            });
        });

        var roleForm = $('#roleForm');
        roleForm.validate({
            errorElement: 'div',
            errorClass: 'help-block',
            focusInvalid: false,
            ignore: "",
            rules: {
                name: {required: true},
                allowCount: {required: true, digits: true}
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
                //console.log(roleForm.serialize());// + "&productImage=" + av atar_ele.get(0).src);
                //console.log("form:" + form);
                $.ajax({
                    type: "POST",
                    url: "/rbac/saveRole.jspa",
                    data: roleForm.serialize(),//+ "&productImage=" + av atar_ele.get(0).src,
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
                                    }
                                }]
                            });
                        } else {
                            myTable.ajax.reload();
                            $("#dialog-edit").dialog("close");
                        }
                    },
                    error: function (response, textStatus) {/*能够接收404,500等错误*/
                        $("#errorText").text(response.responseText.substr(0, 2000));
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
                    "text": "<i class='glyphicon glyphicon-plus  bigger-110 red'></i>新增 ",
                    "className": "btn btn-white btn-primary btn-bold"
                }
            ]
        });
        myTable.buttons().container().appendTo($('.tableTools-container'));

        function deleteRole(roleID, goodsName) {
            if (roleID === undefined) return;
            $('#name').text(goodsName);
            $("#dialog-delete").removeClass('hide').dialog({
                resizable: false,
                modal: true,
                title: "确认删除角色",
                title_html: true,
                buttons: [
                    {
                        html: "<i class='ace-icon fa  fa-trash bigger-110'></i>&nbsp;确定",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            $.ajax({
                                type: "POST",
                                url: "/rbac/deleteRole.jspa?roleID=" + roleID,
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


        function showRoleDialog(roleID) {
            //roleForm[0].reset();
            if (roleID != null) {
                $.getJSON("/rbac/showRole.jspa?roleID=" + roleID, function (result) { //https://www.cnblogs.com/liuling/archive/2013/02/07/sdafsd.html
                    $("#form-name").val(result["name"]);
                    $("#form-roleNo").val(result["roleNo"]);
                    $("#form-allowCount").val(result["allowCount"]);
                    $("#form-layer").val(result["layer"]);
                });
                $("#form-roleID").val(roleID);
            } else {  //用了reset(),就不用执行
                $("input[id^='form-'],#productImage").val("");
            }

            $("#dialog-edit").removeClass('hide').dialog({
                resizable: false,
                width: 450,
                height: 430,
                modal: true,
                title: roleID == null ? "增加角色" : "设置角色",
                title_html: true,
                buttons: [
                    {
                        html: "<i class='ace-icon fa  fa-pencil-square-o bigger-110'></i>&nbsp;保存",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            //todo 直接从#form-closingTime获取时间的毫秒值!
                            if (roleForm.valid())
                                roleForm.submit();
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


        myTable.button(0).action(function (e, dt, button, config) {
            e.preventDefault();
            showRoleDialog(null);
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
        <li class="active">角色管理</li>
    </ul><!-- /.breadcrumb -->
</div>

<!-- /section:basics/content.breadcrumbs -->
<div class="page-content">

    <div class="page-header">
        <h1>角色管理 </h1>
    </div><!-- /.page-header -->

    <div class="row">
        <div class="col-xs-12">

            <div class="row">

                <div class="col-xs-12">
                    <div class="table-header">
                        角色列表
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
        <form class="form-horizontal" role="form" id="roleForm">
            <div class="col-xs-11">
                <input type="hidden" id="form-roleID" name="roleID"/>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="form-name">角色名 </label>

                    <div class="col-sm-9">
                        <div class="input-group">
                            <input type="text" id="form-name" name="name" placeholder="角色名" class="col-xs-10 col-sm-12"/>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="form-roleNo">角色标识 </label>

                    <div class="col-sm-9">
                        <div class="input-group">
                            <input type="text" id="form-roleNo" name="roleNo" placeholder="角色标识" class="col-xs-10 col-sm-12"/>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="form-allowCount">允许用户数</label>

                    <div class="col-sm-9">
                        <div class="input-group">
                            <input type="text" id="form-allowCount" name="allowCount" placeholder="最大用户数" class="col-xs-10 col-sm-12"/>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="form-layer">层级</label>

                    <div class="col-sm-9">
                        <div class="input-group">
                            <input type="text" id="form-layer" name="layer" placeholder="层级" class="col-xs-10 col-sm-12"/>
                        </div>
                    </div>
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