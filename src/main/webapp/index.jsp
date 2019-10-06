<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<c:import url="/admin/static.html" charEncoding="UTF8"/>
<body class="no-skin">
<c:import url="/navbar.jspa" charEncoding="UTF8"/>

<div class="main-container" id="main-container">
    <script type="text/javascript">
        try {
            ace.settings.check('main-container', 'fixed');
        } catch (e) {
        }
    </script>

    <div class="main-container-inner">
        <a class="menu-toggler" id="menu-toggler" href="#">
            <span class="menu-text"></span>
        </a>
        <c:import url="/admin/sidebar.jsp" charEncoding="UTF8"/>

        <div class="main-content">
            <c:import url="${content}" charEncoding="UTF8"/>
        </div><!-- /.main-content -->

        <c:import url="/admin/skin-setting.html" charEncoding="UTF8"/>
    </div><!-- /.main-container-inner -->
    <%--<a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
        <i class="icon-double-angle-up icon-only bigger-110"></i>
    </a>--%>
</div><!-- /.main-container -->



<!-- page specific plugin scripts -->

<!-- ace scripts -->
<script src="assets/js/src/elements.scroller.js"></script>
<script src="assets/js/src/elements.colorpicker.js"></script>
<script src="assets/js/src/elements.fileinput.js"></script>
<script src="assets/js/src/elements.typeahead.js"></script>
<script src="assets/js/src/elements.wysiwyg.js"></script>
<script src="assets/js/src/elements.spinner.js"></script>
<script src="assets/js/src/elements.treeview.js"></script>
<script src="assets/js/src/elements.wizard.js"></script>
<script src="assets/js/src/elements.aside.js"></script>
<script src="assets/js/src/ace.js"></script>
<%--<script src="http://ace.jeka.by/assets/js/ace.min.js"></script>--%>
<script src="assets/js/src/ace.basics.js"></script>
<script src="assets/js/src/ace.scrolltop.js"></script>
<script src="assets/js/src/ace.ajax-content.js"></script>
<script src="assets/js/src/ace.touch-drag.js"></script>
<script src="assets/js/src/ace.sidebar.js"></script>
<script src="assets/js/src/ace.sidebar-scroll-1.js"></script>
<script src="assets/js/src/ace.submenu-hover.js"></script>
<script src="assets/js/src/ace.widget-box.js"></script>
<script src="assets/js/src/ace.settings.js"></script>
<%--<script src="assets/js/src/ace.settings-rtl.js"></script>--%>
<script src="assets/js/src/ace.settings-skin.js"></script>
<script src="assets/js/src/ace.widget-on-reload.js"></script>
<script src="assets/js/src/ace.searchbox-autocomplete.js"></script>

</body>
</html>

