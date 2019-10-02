<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<div id="sidebar" class="sidebar responsive ace-save-state">
    <script type="text/javascript">
        try {
            ace.settings.loadState('sidebar')
        } catch (e) {
        }

        $(function () {
            function setActiveNav() {
                var content = $.cookie("firstContent");
                if (!content) {
                    $.removeCookie('firstContent');
                } else {
                    var lastContent = $.getReferrerUrlParam("content");
                    var thisContent = $.getUrlParam("content");


                    if (thisContent === null && lastContent !== null) {//need redirect
                        console.log("need redirect:" + lastContent);
                        $(window.location).attr('href', 'index.jspa?content=' + lastContent);
                    }
                }

                var menuID = $.getUrlParam("menuID");
                var liItem = $(".nav-list li");
                if (!menuID) {
                    liItem.eq(0).addClass("active");
                } else {
                    for (var i = 0; i < liItem.length; i++) {
                        if (liItem.eq(i).find("a").attr("id") === menuID) {
                            liItem.eq(i).addClass("active");

                            if (liItem.eq(i).parent().hasClass("submenu")) {
                                liItem.eq(i).parent().parent().addClass("open");
                                liItem.eq(i).parent().parent().addClass("active");
                            }

                            break;
                        }
                    }
                }
            }

            setActiveNav();
        });
    </script>

    <div class="sidebar-shortcuts" id="sidebar-shortcuts">
        <div class="sidebar-shortcuts-large" id="sidebar-shortcuts-large">
            <button class="btn btn-success">
                <i class="ace-icon fa fa-signal"></i>
            </button>

            <button class="btn btn-info">
                <i class="ace-icon fa fa-pencil"></i>
            </button>

            <!-- #section:basics/sidebar.layout.shortcuts -->
            <button class="btn btn-warning">
                <i class="ace-icon fa fa-users"></i>
            </button>

            <button class="btn btn-danger">
                <i class="ace-icon fa fa-cogs"></i>
            </button>

            <!-- /section:basics/sidebar.layout.shortcuts -->
        </div>

        <div class="sidebar-shortcuts-mini" id="sidebar-shortcuts-mini">
            <span class="btn btn-success"></span>

            <span class="btn btn-info"></span>

            <span class="btn btn-warning"></span>

            <span class="btn btn-danger"></span>
        </div>
    </div><!-- /.sidebar-shortcuts -->

    <ul class="nav nav-list">
        <li>
            <a href="index.jspa" id="0">
                <i class="menu-icon fa fa-tachometer"></i>
                <span class="menu-text"> 控制台 </span>
            </a>
        </li>

        <li>
            <a href="#" class="dropdown-toggle">
                <i class="menu-icon glyphicon  glyphicon-bookmark "></i>
                <span class="menu-text"> 处方点评 </span>

                <b class="arrow fa fa-angle-down"></b>
            </a>

            <b class="arrow"></b>

            <ul class="submenu">
                <li class="">
                    <a href="index.jspa?content=/remark/sample.jsp&menuID=14" id="14">
                        <!--<i class="menu-icon fa fa-user"></i>-->
                        <i class="menu-icon fa fa-caret-right"></i>
                        <span class="menu-text">抽样点评</span>
                    </a>

                    <b class="arrow"></b>
                </li>
                <li class="">
                    <a href="index.jspa?content=/admin/roles.jsp&menuID=15" id="15">
                        <!--<i class="menu-icon fa 	fa-certificate"></i>-->
                        <i class="menu-icon fa fa-caret-right"></i>
                        <span class="menu-text"> 查询点评</span>
                    </a>

                    <b class="arrow"></b>
                </li>
            </ul>
        </li>
        <li>
            <a href="#" class="dropdown-toggle">
                <i class="menu-icon fa  fa-eye "></i>

                <span class="menu-text"> 阳光用药 </span>

                <b class="arrow fa fa-angle-down"></b>
            </a>

            <b class="arrow"></b>

            <ul class="submenu">
                <li class="">
                    <a href="index.jspa?content=/remark/sample.jsp&menuID=20" id="20">
                        <!--<i class="menu-icon fa fa-user"></i>-->
                        <i class="menu-icon fa fa-caret-right"></i>
                        <span class="menu-text">用药概况</span>
                    </a>

                    <b class="arrow"></b>
                </li>
                <li class="">
                    <a href="index.jspa?content=/sunning/medicine_day.jsp&menuID=21" id="21">

                        <!--<i class="menu-icon fa 	fa-certificate"></i>-->
                        <i class="menu-icon fa fa-caret-right"></i>
                        <span class="menu-text">药品分析（天）</span>
                    </a>

                    <b class="arrow"></b>
                </li>
                <li class="">
                    <a href="index.jspa?content=/sunning/department.jsp&menuID=22" id="22">

                        <!--<i class="menu-icon fa 	fa-certificate"></i>-->
                        <i class="menu-icon fa fa-caret-right"></i>
                        <span class="menu-text">科室用药趋势</span>
                    </a>

                    <b class="arrow"></b>
                </li>
                <li class="">
                    <a href="index.jspa?content=/sunning/doctor.jsp&menuID=23" id="23">

                        <!--<i class="menu-icon fa 	fa-certificate"></i>-->
                        <i class="menu-icon fa fa-caret-right"></i>
                        <span class="menu-text">医生用药分析</span>
                    </a>

                    <b class="arrow"></b>
                </li>
            </ul>
        </li>
        <%--<sec:authentication property="principal.username"/>--%>
        <sec:authorize access="hasRole('ADMIN2')">
            <li>
                <a href="index.jspa?content=/appeal/checkRecord.jsp&menuID=2" id="2">
                    <i class="menu-icon fa fa-picture-o"></i>
                    <span class="menu-text"> 盘查录入 </span>
                </a>
            </li>
            <li>
                <a href="index.jspa?content=/appeal/joinbuy.jspa&menuID=3" id="3">
                    <i class="menu-icon fa fa-pencil-square-o"></i>
                    <span class="menu-text"> 上访事件管理 </span>
                </a>
            </li>
        </sec:authorize>

        <li>
            <a href="#" class="dropdown-toggle">
                <i class="menu-icon fa fa-flask "></i>
                <span class="menu-text"> 抗菌药监测 </span>

                <b class="arrow fa fa-angle-down"></b>
            </a>

            <b class="arrow"></b>

            <ul class="submenu">
                <li class="">
                    <a href="index.jspa?content=/anti/drug.jsp&menuID=30" id="30">
                        <!--<i class="menu-icon fa fa-user"></i>-->
                        <i class="menu-icon fa fa-caret-right"></i>
                        <span class="menu-text"> 抗菌药品种统计</span>
                    </a>

                    <b class="arrow"></b>
                </li>
                <li class="">
                    <a href="index.jspa?content=/admin/roles.jsp&menuID=31" id="31">
                        <!--<i class="menu-icon fa 	fa-certificate"></i>-->
                        <i class="menu-icon fa fa-caret-right"></i>
                        <span class="menu-text"> 住院科室抗菌药统计</span>
                    </a>

                    <b class="arrow"></b>
                </li>
                <li class="">
                    <a href="index.jspa?content=/admin/roles.jsp&menuID=31" id="31">
                        <!--<i class="menu-icon fa 	fa-certificate"></i>-->
                        <i class="menu-icon fa fa-caret-right"></i>
                        <span class="menu-text"> 门诊抗菌药统计</span>
                    </a>

                    <b class="arrow"></b>
                </li>
            </ul>
        </li>
        <li>
            <a href="#" class="dropdown-toggle">
                <i class="menu-icon glyphicon glyphicon-adjust "></i>
                <span class="menu-text">基础数据 </span>

                <b class="arrow fa fa-angle-down"></b>
            </a>

            <b class="arrow"></b>

            <ul class="submenu">
                <li class="">
                    <a href="index.jspa?content=/base/medicine.jsp&menuID=40" id="40">
                        <!--<i class="menu-icon fa fa-user"></i>-->
                        <i class="menu-icon fa fa-caret-right"></i>
                        <span class="menu-text">本院药品</span>
                    </a>

                    <b class="arrow"></b>
                </li>
            </ul>
        </li>
        <li>
            <a href="#" class="dropdown-toggle">
                <i class="menu-icon fa fa-cog"></i>
                <span class="menu-text"> 系统管理 </span>

                <b class="arrow fa fa-angle-down"></b>
            </a>

            <b class="arrow"></b>

            <ul class="submenu">
                <li class="">
                    <a href="index.jspa?content=/admin/users.jsp&menuID=4" id="4">
                        <!--<i class="menu-icon fa fa-user"></i>-->
                        <i class="menu-icon fa fa-caret-right"></i>
                        用户管理
                    </a>

                    <b class="arrow"></b>
                </li>
                <li class="">
                    <a href="index.jspa?content=/admin/roles.jsp&menuID=5" id="5">
                        <!--<i class="menu-icon fa 	fa-certificate"></i>-->
                        <i class="menu-icon fa fa-caret-right"></i>
                        <span class="menu-text"> 角色设置</span>
                    </a>

                    <b class="arrow"></b>
                </li>
                <li class="">
                    <a href="index.jspa?content=/monitor/data.jsp&menuID=6" id="6">
                        <!--<i class="menu-icon fa 	fa-certificate"></i>-->
                        <i class="menu-icon fa fa-caret-right"></i>
                        <span class="menu-text">数据量监控</span>
                    </a>

                    <b class="arrow"></b>
                </li>
            </ul>
        </li>
        <li>

        </li>

    </ul><!-- /.nav-list -->

    <div class="sidebar-toggle sidebar-collapse" id="sidebar-collapse">
        <i id="sidebar-toggle-icon" class="ace-icon fa fa-angle-double-left ace-save-state"
           data-icon1="ace-icon fa fa-angle-double-left" data-icon2="ace-icon fa fa-angle-double-right"></i>
    </div>
</div>