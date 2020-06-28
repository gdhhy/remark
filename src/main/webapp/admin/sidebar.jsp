<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
            <a href="index.jspa?content=/admin/hello.html" id="0">
                <i class="menu-icon fa fa-tachometer"></i>
                <span class="menu-text"> 控制台 </span>
            </a>
        </li>
        <sec:authorize access="hasAnyAuthority('REVIEW,ADMIN')">
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
                                <%--<i class="menu-icon fa fa-caret-right"></i>--%>
                            <i class="menu-icon fa fa-random"></i>
                            <span class="menu-text">抽样点评</span>
                        </a>

                        <b class="arrow"></b>
                    </li>
                    <li class="">
                        <a href="index.jspa?content=/remark/query.jsp&menuID=16" id="16">
                                <%--<i class="menu-icon fa fa-caret-right"></i>--%>
                            <i class="menu-icon fa fa-search"></i>
                            <span class="menu-text">查询点评</span>
                        </a>

                        <b class="arrow"></b>
                    </li>
                    <li class="">
                        <a href="index.jspa?content=/remark/result.jsp&menuID=15" id="15">
                            <i class="menu-icon fa fa-history"></i>
                            <span class="menu-text"> 点评结果</span>
                        </a>

                        <b class="arrow"></b>
                    </li>
                </ul>
            </li>
            <li>
                <a href="#" class="dropdown-toggle">
                    <i class="menu-icon fa  fa-sun-o"></i>

                    <span class="menu-text"> 阳光用药 </span>

                    <b class="arrow fa fa-angle-down"></b>
                </a>

                <b class="arrow"></b>

                <ul class="submenu">
                    <li class="">
                        <a href="index.jspa?content=/sunning/summary.jsp&menuID=20" id="20">
                            <!--<i class="menu-icon fa fa-user"></i>-->
                            <i class="menu-icon fa fa-caret-right"></i>
                            <span class="menu-text">用药概况</span>
                        </a>

                        <b class="arrow"></b>
                    </li>
                    <li class="">
                        <a href="index.jspa?content=/sunning/medicine_day.jsp&menuID=21" id="21">

                            <!--<i class="menu-icon fa fa-certificate"></i>-->
                            <i class="menu-icon fa fa-caret-right"></i>
                            <span class="menu-text">药品分析（天）</span>
                        </a>

                        <b class="arrow"></b>
                    </li>
                    <li class="">
                        <a href="index.jspa?content=/sunning/department.jsp&menuID=22" id="22">

                            <!--<i class="menu-icon fa fa-certificate"></i>-->
                            <i class="menu-icon fa fa-caret-right"></i>
                            <span class="menu-text">科室用药趋势</span>
                        </a>

                        <b class="arrow"></b>
                    </li>
                    <li class="">
                        <a href="index.jspa?content=/sunning/doctor.jsp&menuID=23" id="23">

                            <!--<i class="menu-icon fa fa-certificate"></i>-->
                            <i class="menu-icon fa fa-caret-right"></i>
                            <span class="menu-text">医生用药分析</span>
                        </a>

                        <b class="arrow"></b>
                    </li>
                    <li class="">
                        <a href="index.jspa?content=/sunning/department_base.jsp&menuID=24" id="24">

                            <!--<i class="menu-icon fa fa-certificate"></i>-->
                            <i class="menu-icon fa fa-caret-right"></i>
                            <span class="menu-text">科室基药统计</span>
                        </a>

                        <b class="arrow"></b>
                    </li>
                    <li class="">
                        <a href="index.jspa?content=/sunning/doctor_base.jsp&menuID=25" id="25">

                            <!--<i class="menu-icon fa fa-certificate"></i>-->
                            <i class="menu-icon fa fa-caret-right"></i>
                            <span class="menu-text">医生基药统计</span>
                        </a>

                        <b class="arrow"></b>
                    </li>
                </ul>
            </li>

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
                        <a href="index.jspa?content=/anti/department.jsp&menuID=33" id="33">
                            <!--<i class="menu-icon fa fa-user"></i>-->
                            <i class="menu-icon fa fa-caret-right"></i>
                            <span class="menu-text"> 科室抗菌药统计</span>
                        </a>

                        <b class="arrow"></b>
                    </li>
                    <li class="">
                        <a href="index.jspa?content=/anti/doctor.jsp&menuID=34" id="34">
                            <!--<i class="menu-icon fa fa-user"></i>-->
                            <i class="menu-icon fa fa-caret-right"></i>
                            <span class="menu-text"> 医生抗菌药统计</span>
                        </a>

                        <b class="arrow"></b>
                    </li>
                        <%--  <li class="">
                              <a href="index.jspa?content=/admin/roles.jsp&menuID=31" id="31">
                                  <!--<i class="menu-icon fa fa-certificate"></i>-->
                                  <i class="menu-icon fa fa-caret-right"></i>
                                  <span class="menu-text"> 住院科室抗菌药统计</span>
                              </a>

                              <b class="arrow"></b>
                          </li>
                          <li class="">
                              <a href="index.jspa?content=/admin/roles.jsp&menuID=32" id="32">
                                  <!--<i class="menu-icon fa fa-certificate"></i>-->
                                  <i class="menu-icon fa fa-caret-right"></i>
                                  <span class="menu-text"> 门诊抗菌药统计</span>
                              </a>

                              <b class="arrow"></b>
                          </li>--%>
                </ul>
            </li>
        </sec:authorize>
        <sec:authorize access="hasAnyAuthority('ADMIN,DOCTOR,INFECTIOUS,CONTAGION')">
            <li>
                <a href="#" class="dropdown-toggle">
                    <i class="menu-icon fa  fa-upload"></i>

                    <span class="menu-text"> 上报数据 </span>

                    <b class="arrow fa fa-angle-down"></b>
                </a>

                <b class="arrow"></b>

                <ul class="submenu">
                    <sec:authorize access="hasAnyAuthority('ADMIN,DOCTOR,INFECTIOUS')">
                        <li class="">
                            <a href="index.jspa?content=/doctor/showInfectiousList.jspa&menuID=50" id="50">
                                <i class="menu-icon fa fa-bug"></i>
                                <span class="menu-text">传染病上报</span>
                            </a>

                            <b class="arrow"></b>
                        </li>
                    </sec:authorize>
                    <sec:authorize access="hasAnyAuthority('ADMIN,DOCTOR,CONTAGION')">
                        <li class="">
                            <a href="index.jspa?content=/doctor/showContagionList.jspa&menuID=51" id="51">

                                <i class="menu-icon fa fa-caret-right"></i>
                                <span class="menu-text">感染病上报</span>
                            </a>

                            <b class="arrow"></b>
                        </li>
                    </sec:authorize>
                    <sec:authorize access="hasAnyAuthority('ADMIN,DOCTOR,UNTOWARD')">
                        <li class="">
                            <a href="index.jspa?content=/doctor/showUntowardList.jspa&menuID=52" id="52">

                                <i class="menu-icon fa fa-drupal"></i>
                                <span class="menu-text">不良反应事件</span>
                            </a>

                            <b class="arrow"></b>
                        </li>
                    </sec:authorize>
                </ul>
            </li>
        </sec:authorize>
        <sec:authorize access="hasAnyAuthority('ADMIN,REVIEW')">
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
                    <li class="">
                        <a href="index.jspa?content=/base/drug.jsp&menuID=42" id="42">
                            <!--<i class="menu-icon fa fa-user"></i>-->
                            <i class="menu-icon fa fa-caret-right"></i>
                            <span class="menu-text">通用名</span>
                        </a>

                        <b class="arrow"></b>
                    </li>
                    <li class="">
                        <a href="index.jspa?content=/base/instruction.jsp&menuID=41" id="41">
                            <!--<i class="menu-icon fa fa-user"></i>-->
                            <i class="menu-icon fa fa-caret-right"></i>
                            <span class="menu-text">说明书库</span>
                        </a>

                        <b class="arrow"></b>
                    </li>
                    <li class="">
                        <a href="index.jspa?content=/base/dicts.jsp&menuID=43" id="43">
                            <!--<i class="menu-icon fa fa-user"></i>-->
                            <i class="menu-icon fa fa-caret-right"></i>
                            <span class="menu-text">数据字典</span>
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
                    <sec:authorize access="hasAuthority('ADMIN')">
                        <li class="">
                            <a href="index.jspa?content=users.jspa&menuID=4" id="4">
                                <i class="menu-icon fa fa-caret-right"></i>
                                <i class="fa fa-user"></i>
                                <span class="menu-text">用户管理</span>

                            </a>

                            <b class="arrow"></b>
                        </li>
                    </sec:authorize>
                    <li class="">
                        <a href="index.jspa?content=/monitor/data.jsp&menuID=6" id="6">
                            <!--<i class="menu-icon fa fa-certificate"></i>-->
                            <i class="menu-icon fa fa-caret-right"></i>
                            <i class="fa fa-database"></i>
                            <span class="menu-text">数据量监控</span>
                        </a>

                        <b class="arrow"></b>
                    </li>
                    <li class="">
                        <a href="index.jspa?content=/monitor/task.jsp&menuID=7" id="7">
                            <!--<i class="menu-icon fa fa-certificate"></i>-->
                            <i class="menu-icon fa fa-caret-right"></i>
                            <i class="fa fa-tasks" aria-hidden="true"></i>

                            <span class="menu-text">导入任务</span>
                        </a>

                        <b class="arrow"></b>
                    </li>
                </ul>
            </li>
        </sec:authorize>

    </ul><!-- /.nav-list -->

    <div class="sidebar-toggle sidebar-collapse" id="sidebar-collapse">
        <i id="sidebar-toggle-icon" class="ace-icon fa fa-angle-double-left ace-save-state"
           data-icon1="ace-icon fa fa-angle-double-left" data-icon2="ace-icon fa fa-angle-double-right"></i>
    </div>
</div>