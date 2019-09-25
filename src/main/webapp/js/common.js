(function ($) {
    /*获取链接参数*/
    $.getUrlParam = function (name) {
        //构造一个含有目标参数的正则表达式对象  
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        //匹配目标参数
        var r = window.location.search.substr(1).match(reg);
        //返回参数值
        if (r != null) return unescape(r[2]);
        return null;
    };
    /*获取链接参数*/
    $.getReferrerUrlParam = function (name) {
        //构造一个含有目标参数的正则表达式对象
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        //匹配目标参数
        var r = document.referrer.substr( document.referrer.indexOf("?")+1).match(reg);
        //返回参数值
        if (r != null) return unescape(r[2]);
        return null;
    };

    $.addUrlParam = function (url, addParam) {
        if (url.indexOf(addParam) < 0) {
            if (url.indexOf('?') > 0)
                url += "&" + addParam;
            else
                url += "?" + addParam;
        }
        return url;
    };
    //每三个数字用,隔开
    $.addCommas = function (nStr) {
        nStr += '';
        x = nStr.split('.');
        x1 = x[0];
        x2 = x.length > 1 ? '.' + x[1] : '';
        var rgx = /(\d+)(\d{3})/;
        while (rgx.test(x1)) {
            x1 = x1.replace(rgx, '$1' + ',' + '$2');
        }
        return x1 + x2;
    };
    //警告框
    $.showTips = function (csstype, strong, message) {
        var result = "<div class='alert " + csstype + " alert-dismissible fade in' role='alert'>"
            + "<button type='button' class='close' data-dismiss='alert'><span aria-hidden='true'>×</span><span class='sr-only'>Close</span></button>"
            + "<strong>" + strong + "</strong>" + message + "</div>"
        return result;
    };

    /*判断值是否为空*/
    $.isNullOrEmpty = function (strVal) {
        if (strVal === '' || strVal === null || strVal === undefined) {
            return true;
        } else {
            return false;
        }
    };
    //只能输入数字
    $.checkNumber = function (obj) {
        obj.value = obj.value.replace(/[^\d]/g, "");
    };
    //只能输入数字和小数点
    $.checkNumberAndFloat = function (obj) {

        obj.value = obj.value.replace(/[^\d.]/g, "");
        obj.value = obj.value.replace(/^\./g, "");
        obj.value = obj.value.replace(/\.{2,}/g, ".");
        obj.value = obj.value.replace(".", "$#$").replace(/\./g, "").replace("$#$", ".");
    };
    //提示有关闭按钮
    $.prompt = function (obj, csstype, strTip, vertype) {
        if (vertype === 2) {
            obj.html('<div class="' + csstype + '" role="alert"><a class="close" data-dismiss="alert">×</a><strong>' + strTip + '</strong></div>');

        }
        else if (vertype === 3) {
            obj.html('<div class=\"' + csstype + '\"><button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-hidden=\"true\">×</button><strong>' + strTip + '</strong></div>');
        }
    };
})(jQuery);