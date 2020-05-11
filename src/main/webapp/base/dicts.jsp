<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script src="../components/datatables/jquery.dataTables.min.js"></script>
<script src="../components/datatables/jquery.dataTables.bootstrap.min.js"></script>
<script src="../components/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="../components/datatables/dataTables.select.min.js"></script>
<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>
<script src="../js/render_func.js"></script>
<script src="../js/jquery.cookie.min.js"></script>
<script src="../assets/js/jquery.validate.min.js"></script>
<script src="../assets/js/jquery.validate.messages_cn.js"></script>
<script src="../components/chosen/chosen.jquery.js"></script>
<script type="text/javascript" src="../components/zTree_v3/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="../components/zTree_v3/js/jquery.ztree.excheck.js"></script>
<script type="text/javascript" src="../components/zTree_v3/js/jquery.ztree.exedit.js"></script>

<!-- bootstrap & fontawesome -->

<link rel="stylesheet" href="../components/font-awesome/css/font-awesome.css"/>
<link rel="stylesheet" href="../components/chosen/chosen.min.css"/>
<link rel="stylesheet" href="../components/zTree_v3/css/zTreeStyle/zTreeStyle.css" type="text/css">
<style>
    .form-group {
        margin-bottom: 3px;
        margin-top: 3px;
    }
</style>
<script type="text/javascript">
    jQuery(function ($) {
        var url = "/common/dict/listDict.jspa?parentID=1";
        var dynamicTable = $('#dynamic-table');
        var myTable = dynamicTable.DataTable({
            bAutoWidth: false,
            /*"aLengthMenu": [[10, 20, 50, -1], [10, 20, 50, "所有"]],//设置每页显示数据条数的下拉选项
            'iDisplayLength': 10, //每页初始显示5条记录*/
            "searching": true, dom: 'tp', paging: false,
            "columns": [
                {"data": "dictID", "sClass": "center", "orderable": false, width: 45},
                {"data": "dictNo", "sClass": "center", "orderable": false, className: 'middle'},
                {"data": "name", "sClass": "center", "orderable": false, className: 'middle', defaultContent: ''},
                {"data": "value", "sClass": "center", "orderable": false, className: 'middle', defaultContent: ''},
                {"data": "orderNum", "sClass": "center", "orderable": false, className: 'middle', defaultContent: ''},
                {"data": "dictID", "sClass": "center", "orderable": false, width: 85}
            ],
            'columnDefs': [
                {
                    "orderable": false, "targets": 0, width: 20, render: function (data, type, row, meta) {
                        return meta.row + 1 + meta.settings._iDisplayStart;
                    }
                },
                {
                    'targets': 5, 'searchable': false, 'orderable': false,
                    render: function (data, type, row, meta) {
                        return '<div class="hidden-sm hidden-xs action-buttons">' +
                            '<a class="hasDetail" href="#" data-Url="javascript:editDict({0});">'.format(data) +
                            '<i class="ace-icon fa  fa-pencil-square-o green bigger-130"></i>' +
                            '</a>&nbsp;&nbsp;&nbsp;' +
                            '<a class="hasDetail" href="#" data-Url="javascript:deleteDialog({0},\'{1}\');">'.format(data, row['name']) +
                            '<i class="ace-icon fa  fa-remove red bigger-130"></i>' +
                            '</a>' +
                            '</div>';
                    }
                }
            ],
            "aaSorting": [],
            language: {
                url: '../components/datatables/datatables.chinese.json'
            },
            "ajax": {
                url: url,
                "data": function (d) {//删除多余请求参数
                    for (var key in d)
                        if (key.indexOf("columns") === 0 || key.indexOf("order") === 0) //以columns开头的参数删除 ,保留|| key.indexOf("search") === 0
                            delete d[key];
                }
            },
            "processing": true,
            "serverSide": true,
            select: {style: 'single'}
        });
        myTable.on('draw', function () {
            $('#dynamic-table tr').find('.hasDetail').click(function () {
                if ($(this).attr("data-Url").indexOf('javascript:') >= 0) {
                    eval($(this).attr("data-Url"));
                } else
                    window.open($(this).attr("data-Url"), "_blank");
            });
        });
        //$.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap padding-4';
        new $.fn.dataTable.Buttons(myTable, {
            buttons: [
                {
                    "text": "<i class='fa fa-plus-square bigger-130'></i>&nbsp;&nbsp;新增",
                    "className": "btn btn-xs btn-white btn-primary "
                }
            ]
        });
        myTable.buttons().container().appendTo($('.tableTools-container'));
        myTable.button(0).action(function (e, dt, button, config) {
            e.preventDefault();
            showDictDialog({dictID: 0, parentID: $('#parentID').val()});
        });

        function editDict(dictID) {
            $.getJSON("/common/dict/listDict.jspa?dictID=" + dictID, function (ret) {
                showDictDialog(ret.data[0]);
            });
        }

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

        var setting = {
            async: {
                enable: true,
                url: "/common/dict/zTree.jspa",
                autoParam: ["id=parentID"],//, "name=n", "level=lv"
                type: "get"
            },
            callback: {
                onClick: zTreeOnClick,
                beforeAsync: beforeAsync,
                onAsyncSuccess: onAsyncSuccess
            }
        };

        function beforeAsync() {
            curAsyncCount++;
        }

        function onAsyncSuccess(event, treeId, treeNode, msg) {
            curAsyncCount--;
            if (curStatus === "expand") {
                expandNodes(treeNode.children);
            } else if (curStatus === "async") {
                asyncNodes(treeNode.children);
            }

            if (curAsyncCount <= 0) {
                curStatus = "";
            }
        }

        var curStatus = "init", curAsyncCount = 0, goAsync = false;

        function expandNodes(nodes) {
            if (!nodes) return;
            curStatus = "expand";
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            for (var i = 0, l = nodes.length; i < l; i++) {
                zTree.expandNode(nodes[i], true, false, false);//展开节点就会调用后台查询子节点
                if (nodes[i].isParent && nodes[i].zAsync) {
                    expandNodes(nodes[i].children);//递归
                } else {
                    goAsync = true;
                }
            }
        }

        $.fn.zTree.init($("#treeDemo"), setting, {id: '1', name: '数据字典', isParent: true});

        var zTree = $.fn.zTree.getZTreeObj("treeDemo");
        zTree.expandNode(zTree.getNodes()[0], true, false, false);//展开节点就会调用后台查询子节点
        showChildren(1);
        var selectNode;

        function zTreeOnClick(event, treeId, treeNode) {
            //alert(treeNode.id + ", " + treeNode.name);
            selectNode = treeNode;
            showChildren(treeNode.id);
            $('#parentID').val(treeNode.id);
        }

        function showChildren(parentID) {
            myTable.ajax.url("/common/dict/listDict.jspa?parentID={0}".format(parentID)).load();
        }

        //var editingDict;

        function showDictDialog(dict) {
            //editingDict = dict;
            /*  var nodes = zTree.getSelectedNodes();

              if (nodes.length > 0)
                  $('#parentName').val(nodes[0].name);*/
            if (dict.dictID === 0) {
                $.getJSON("/common/dict/listDict.jspa?dictID=" + dict.parentID, function (ret) {
                    $('#parentName').val(ret.data[0].name);
                    $('#layer').val(ret.data[0].layer + 1);
                });
            }
            $('#dictID').val(dict.dictID);
            $('#name').val(dict.name);
            $('#layer').val(dict.layer);
            $('#hasChild').val(dict.hasChild);
            $('#value').val(dict.value);
            $('#orderNum').val(dict.orderNum);
            $('#dictNo').val(dict.dictNo);
            $('#note').val(dict.note);

            $("#dialog-edit").removeClass('hide').dialog({
                resizable: false, width: 470, height: 350, modal: true, title: "编辑数据字典", title_html: true,
                buttons: [
                    {
                        html: "<i class='ace-icon fa fa-floppy-o bigger-110'></i>&nbsp;保存",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            if (dictForm.valid()) {
                                dictForm.submit();
                            }
                        }
                    }, {
                        html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 关闭",
                        "class": "btn btn-minier",
                        click: function () {
                            $('#dialog-edit').dialog('close');
                        }
                    }]
            });
        }

        var dictForm = $('#dictForm');
        dictForm.validate({
            errorElement: 'div',
            errorClass: 'help-block',
            focusInvalid: false,
            ignore: "",
            rules: {
                orderNum: {required: true, number: true}
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
                    url: "/common/dict/saveDict.jspa",
                    data: dictForm.serialize(),//+ "&productImage=" + av atar_ele.get(0).src,
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                    cache: false,
                    success: function (response, textStatus) {
                        var result = JSON.parse(response);
                        if (!result.succeed) {
                            $("#errorText").html(result.errmsg);
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
                            zTree.reAsyncChildNodes(selectNode, "refresh");
                            $("#dialog-edit").dialog("close");
                        }
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
                    complete: function (data) {
                        console.log("complete");
                    }
                });
            },
        });

        function deleteDialog(dictID, chnName) {
            if (dictID === undefined) return;
            $('#chnName').text(chnName);
            //resizable: false, width: 470, height: 350, modal: true, title: "编辑数据字典", title_html: true,
            $("#dialog-delete").removeClass('hide').dialog({
                resizable: false,
                modal: true,
                title: "确认数据字典",
                //title_html: true,
                buttons: [
                    {
                        html: "<i class='ace-icon fa fa-trash bigger-110'></i>&nbsp;确定",
                        "class": "btn btn-danger btn-minier",
                        click: function () {
                            $.ajax({
                                type: "POST",
                                url: "/common/dict/deleteDict.jspa?dictID=" + dictID,
                                //contentType: "application/x-www-form-urlencoded; charset=UTF-8",//http://www.cnblogs.com/yoyotl/p/5853206.html
                                cache: false,
                                success: function (response, textStatus) {
                                    var result = JSON.parse(response);
                                    if (result.succeed) {
                                        myTable.ajax.reload();
                                        zTree.reAsyncChildNodes(selectNode, "refresh");
                                    } else
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
    });
</script>

<!-- #section:basics/content.breadcrumbs -->
<div class="breadcrumbs ace-save-state" id="breadcrumbs">
    <ul class="breadcrumb">
        <li>
            <i class="ace-icon fa fa-home home-icon"></i>
            <a href="/index.jspa?content=/admin/hello.html">首页</a>
        </li>
        <li class="active">数据字典维护</li>

    </ul><!-- /.breadcrumb -->

    <!-- #section:basics/content.searchbox -->
    <div class="nav-search" id="nav-search">

    </div><!-- /.nav-search -->

    <!-- /section:basics/content.searchbox -->
</div>

<!-- /section:basics/content.breadcrumbs -->
<div class="page-content">
    <div class="page-header">

    </div><!-- /.page-header -->

    <div class="row">
        <div class="col-xs-12">

            <div class="row">

                <div class="col-xs-12">
                    <div class="table-header">
                        数据字典
                        <div class="pull-right tableTools-container"></div>
                    </div>

                    <!-- div.table-responsive -->

                    <!-- div.dataTables_borderWrap -->
                    <div class="row">
                        <div class="col-xs-4" style="height: auto">
                            <div class="widget-box widget-color-blue2">
                                <div class="widget-body">
                                    <div class="widget-main padding-8">
                                        <div class="zTreeDemoBackground left">
                                            <ul id="treeDemo" class="ztree"></ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-8">
                            <table id="dynamic-table" class="table table-striped table-bordered table-hover ">
                                <thead>
                                <tr>
                                    <th style="text-align: center"></th>
                                    <th style="text-align: center">代码</th>
                                    <th style="text-align: center">名称</th>
                                    <th style="text-align: center">值</th>
                                    <th style="text-align: center">排序号</th>
                                    <th style="text-align: center">操作</th>
                                </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                </div>
            </div>


            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->
</div>
<div id="dialog-edit" class="hide">
    <form class="form-horizontal" role="form" id="dictForm">
        <input type="hidden" id="dictID" name="dictID">
        <input type="hidden" id="parentID" name="parentID" value="1">
        <input type="hidden" id="layer" name="layer" value="1">
        <input type="hidden" id="hasChild" name="hasChild" value="1">
        <!-- PAGE CONTENT BEGINS -->
        <div class="container-fluid">
            <div class="col-xs-12 col-sm-12 no-padding no-margin">
                <div class="form-group" style="margin-bottom: 3px;margin-top: 5px;">
                    <label class="col-sm-3 control-label no-padding-right " for="name"> 上级分类 </label>
                    <div class="col-sm-9">
                        <input type="text" id="parentName" placeholder="根" style="font-size: 9px;color: black ;" class="col-xs-10 col-sm-10" readonly/>
                    </div>
                </div>
                <div class="form-group" style="margin-bottom: 3px;margin-top: 5px;">
                    <label class="col-sm-3 control-label no-padding-right " for="dictNo"> 代码 </label>
                    <div class="col-sm-9">
                        <input type="text" id="dictNo" name="dictNo" placeholder="代码" style="font-size: 9px;color: black ;" class="col-xs-10 col-sm-10"/>
                    </div>
                </div>
                <div class="form-group" style="margin-bottom: 3px;margin-top: 5px;">
                    <label class="col-sm-3 control-label no-padding-right " for="name"> 名称 </label>
                    <div class="col-sm-9">
                        <input type="text" id="name" name="name" placeholder="名称" style="font-size: 9px;color: black ;" class="col-xs-10 col-sm-10" required/>
                    </div>
                </div>
                <div class="form-group" style="margin-bottom: 3px;margin-top: 5px;">
                    <label class="col-sm-3 control-label no-padding-right " for="value"> 值 </label>
                    <div class="col-sm-9">
                        <input type="text" id="value" name="value" placeholder="值" style="font-size: 9px;color: black ;" class="col-xs-10 col-sm-10"/>
                    </div>
                </div>
                <div class="form-group" style="margin-bottom: 3px;margin-top: 5px;">
                    <label class="col-sm-3 control-label no-padding-right " for="orderNum"> 排序号 </label>
                    <div class="col-sm-9">
                        <input type="text" id="orderNum" name="orderNum" placeholder="排序号" style="font-size: 9px;color: black ;" class="col-xs-10 col-sm-10"/>
                    </div>
                </div>
                <div class="form-group" style="margin-bottom: 3px;margin-top: 5px;">
                    <label class="col-sm-3 control-label no-padding-right " for="note"> 备注 </label>
                    <div class="col-sm-9">
                        <input type="text" id="note" name="note" placeholder="备注" style="font-size: 9px;color: black ;" class="col-xs-10 col-sm-10"/>
                    </div>
                </div>
            </div><!-- /.col -->
        </div>
    </form>
</div>
<div id="dialog-error" class="hide alert" title="提示">
    <p id="errorText">保存失败，请稍后再试，或与系统管理员联系。</p>
</div>
<div id="dialog-delete" class="hide">
    <div class="alert alert-info bigger-110">
        永久删除 <span id="chnName" class="red"></span> ，不可恢复！
    </div>

    <div class="space-6"></div>

    <p class="bigger-110 bolder center grey">
        <i class="icon-hand-right blue bigger-120"></i>
        确认吗？
    </p>
</div>
<!-- /.page-content -->