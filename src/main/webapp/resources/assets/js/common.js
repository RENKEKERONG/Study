$(function () {
    /**
     * 将form表单元素的值序列化成对象
     */
    $.serializeObject = function (form) {
        var o = {};
        $.each(form.serializeArray(), function (index) {
            if (o[this['name']]) {
                o[this['name']] = o[this['name']] + "," + this['value'];
            } else {
                o[this['name']] = this['value'];
            }
        });
        return o;
    };

//打开新的tab
    function openTab(title, url) {
        top.postMessage(JSON.stringify({title: title, url: url}), '*');
    }

// 动态高度
    function getHeight() {
        return $(window).height() - 20;
    }

// 数据表格展开内容
    function detailFormatter(index, row) {
        var html = [];
        $.each(row, function (key, value) {
            html.push('<p><b>' + key + ':</b> ' + value + '</p>');
        });
        return html.join('');
    }

    function checkDouble(doub) {
        if (/^([0-9]\d*(\.\d*[0-9])?)|(0\.\d*[0-9])$/.test(doub)) {
            return true;
        }
        return false;
    }

    function checkString(str) {
        if (/^[A-Za-z0-9]+$/.test(str)) {
            return true;
        }
        return false;
    }

    function checkInt(num) {
        if (/^[1-9]\d*$|^0$/.test(num)) {
            return true;
        }
        return false;
    }

// 初始化input特效
    function initMaterialInput() {
        $('form input[type="text"]').each(function () {
            if ($(this).val() != '') {
                $(this).parent().find('label').addClass('active');
            }
        });
        $('select').select2();
        $("input.double").each(function () {
            $(this).on("keyup", function () {
                if (!checkDouble(this.value)) {
                    this.value = '';
                }
            });
        })
        $("input.string").each(function () {
            $(this).on("keyup", function () {
                if (!checkString(this.value)) {
                    this.value = '';
                }
            });
        })
        $("input.int").each(function () {
            $(this).on("keyup", function () {
                if (!checkInt(this.value)) {
                    this.value = '';
                }
            });
        })
    }

    Number.prototype.toFixed8 = function () {
        var changenum = (parseInt(Math.abs(this) * Math.pow(10, 8) + 0.5) / Math.pow(10, 8)).toString();
        return changenum;
    };

    Number.prototype.toFixed = function (s) {
        var changenum = (parseInt(parseFloat((Math.abs(this) * Math.pow(10, s)).toFixed8()) + 0.5) / Math.pow(10, s)).toString();
        var index = changenum.indexOf(".");
        if (index < 0 && s > 0) {
            changenum = changenum + ".";
            for (var i = 0; i < s; i++) {
                changenum = changenum + "0";
            }

        } else {
            index = changenum.length - index;
            for (var i = 0; i < (s - index) + 1; i++) {
                changenum = changenum + "0";
            }

        }
        if (this < 0) {
            return ~changenum + 1;
        } else {
            return changenum;
        }

    };

    Date.prototype.format = function (fmt) {
        var o = {
            "M+": this.getMonth() + 1,                 //月份
            "d+": this.getDate(),                    //日
            "h+": this.getHours(),                   //小时
            "m+": this.getMinutes(),                 //分
            "s+": this.getSeconds(),                 //秒
            "q+": Math.floor((this.getMonth() + 3) / 3), //季度
            "S": this.getMilliseconds()             //毫秒
        };
        if (/(y+)/.test(fmt)) {
            fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        }
        for (var k in o) {
            if (new RegExp("(" + k + ")").test(fmt)) {
                fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
            }
        }
        return fmt;
    }

//时间戳格式转化
    function formatDate(nS) {
        if (typeof (nS) == 'string') {
            nS = new Number(nS);
        }
        var now = new Date(nS);
        if (nS == '' || null == nS) {
            return null;
        }
        return now.format('yyyy-MM-dd');
    }

//时间戳格式转化
    function formatDateTime(nS) {
        if (typeof (nS) == 'string') {
            nS = new Number(nS);
        }
        var now = new Date(nS);
        if (nS == '' || null == nS) {
            return null;
        }
        return now.format('yyyy-MM-dd hh:mm:ss');
    }

//时间戳格式转化
    function formatTime(nS) {
        if (typeof (nS) == 'string') {
            nS = new Number(nS);
        }
        var now = new Date(nS);
        if (nS == '' || null == nS) {
            return null;
        }
        return now.format('yyyy-MM-dd hh:mm');
    }

//表格获取序号
    function tableIndex(value, row, index) {
        return index + 1;
    }

//根据父类创建实体，并继承实体属性和方法
    function createObj(parent, option) {
        var obj = deepCopy(parent);
        for (var i in option) {
            obj[i] = option[i];
        }
        return obj;
    }

//实体拷贝
    function deepCopy(p, c) {
        var c = c || {};
        for (var i in p) {
            if (typeof p[i] === 'object') {
                c[i] = (p[i].constructor === Array) ? [] : {};
                deepCopy(p[i], c[i]);
            } else {
                c[i] = p[i];
            }
        }
        return c;
    }

    Array.prototype.clone = function () {
        var newArray = this.concat();
        for (var i = 0; i < newArray.length; i++) {
            newArray[i] = deepCopy(newArray[i]);
        }
        return newArray;
    }


    function floatNumberFormat(num, d) {
        if (typeof num == "number") {
            return num.toFixed(d);
        } else if (typeof num == "string") {
            var n = parseFloat(num);
            return n.toFixed(d);
        } else {
            return 0;
        }
    }

    function isValidIP(ip) {
        var reg = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;
        return reg.test(ip);
    }

    function domainName(url) {
        var sign = "://";
        var pos = url.indexOf(sign);
        //如果以协议名开头
        //如：http://github.com/
        if (pos >= 0) {
            url = url.substring(pos + 3, url.length);
        }
        return url
    }

    function randomNum(n) {
        var t = '';
        for (var i = 0; i < n; i++) {
            t += Math.floor(Math.random() * 10);
        }
        return t;
    }

//json转url参数
    var parseParam = function (param, key) {
        var paramStr = "";
        if (param instanceof String || param instanceof Number || param instanceof Boolean) {
            paramStr += "&" + key + "=" + encodeURIComponent(encodeURIComponent(param));
        } else {
            $.each(param, function (i) {
                var k = key == null ? i : key + (param instanceof Array ? "[" + i + "]" : "[" + i + "]");
                paramStr += '&' + parseParam(this, k);
            });
        }
        return paramStr.substr(1);
    };
})


$.toast = function (title, msg, info ) {
    $.Toast(title, msg, info, {
        stack: true,
        position_class: "toast-top-right",
        has_icon: true,
        has_close_btn: true,
        fullscreen: false,
        timeout: 3000,
        sticky: false,
        has_progress: true,
        rtl: false
    });
}

$.confirm = function (text, type,callback ) {
    swal({
        title: '',
        text: text,
        type: type,  //error ,warning, success
        showCancelButton: true,
        confirmButtonText: '确定',
        cancelButtonText: '取消'
    }, function (isConfirm) {
        if(!isConfirm){
            return;
        }else {
            callback(isConfirm);
        }
    })
}

$.load = function (title) {
    $('body').loading({
        loadingWidth:240,
        title:title,
        name:'loading',
        discription:'',
        direction:'row',
        type:'origin',
        originBg:'#fff',
        // originBg:'#71EA71',
        originDivWidth:30,
        originDivHeight:30,
        originWidth:4,
        originHeight:4,
        smallLoading:true,
        // titleColor:'#388E7A',
        titleColor:'#fff',
        // loadingBg:'#312923',
        loadingMaskBg:'rgba(22,22,22,0.2)'
    });
}

$.pxAjax = function (url, data, callback, type,status) {
    if (jQuery.isFunction(data)) {
        status=status || type;
        type = callback;
        callback = data;
        data = undefined;
    }
    if(status==undefined) status = true;
    if(status){
        $.load("加载中......");
    }
    $.ajax({
        type: type,
        url: url,
        data: data,
        dataType:'json',
        success: function (result) {
            callback(result);
            removeLoading('loading');
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            removeLoading('loading');
            $.toast("提示", textStatus, "error");
        }
    });
}