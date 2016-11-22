var detail = detail || {};
detail.APP =detail.APP || {};
detail.GLOBAL = detail.GLOBAL || {};
detail.APP.flag = true;
detail.GLOBAL.table = $("#dg"); // 默认表单名


// 信息提示封装
detail.GLOBAL.cue = function (msg, success, error, warning) {
    var success = arguments[1] ? arguments[1] : function(){};
    var error = arguments[2] ? arguments[2] : function(){};
    var warning = arguments[3] ? arguments[3] : function(){};

    if(msg.msg == 'success'){
        layer.msg(msg.message,{
            icon : 1,
            time : 800
        });
        setTimeout(function () {
            success();
        },777)
    }else if(msg.msg == 'error'){
        layer.msg(msg.message, {
            icon : 11
        });
        setTimeout(function () {
            error();
        },888)
    }else{
        layer.msg(msg.message, {
            icon : 0
        });
        setTimeout(function () {
            warning();
        },999)
    }
};

detail.GLOBAL.tips = function (text, task) {

    layer.tips(text, task, {
        tips : 2,tipsMore:true
    });
};


// 获取所属id
detail.GLOBAL.getSelfId =function (self, elem, target) {
    var val = arguments[2] ? arguments[2] : 'id';
    return self.parents(elem).attr(val).substring(3);
};

// in_array
detail.GLOBAL.in_array = function(stringToSearch, arrayToSearch){
    for (var s = 0; s < arrayToSearch.length; s++) {
        var thisEntry = arrayToSearch[s].toString();
        if (thisEntry == stringToSearch) {
            return true;
        }
    }
    return false;
};

// 判断数组下标
detail.GLOBAL.in_array_key = function (stringToSearch, arrayToSearch) {
    for(var key in arrayToSearch){
        var thisEntry = key.toString();
        if (thisEntry == stringToSearch) {
            return true;
        }
    }
    return false;
};

// 根据key删除元素
detail.GLOBAL.unset_key_array= function (stringToSearch, arrayToSearch) {
    var arr = new Array;
    for(var key in arrayToSearch){
        var thisEntry = key.toString();
        if (thisEntry == stringToSearch) {
            continue;
        }else{
            arr[key] = arrayToSearch[key];
        }
    }
    return arr;
};

// 根据value删除元素
detail.GLOBAL.unset_value_array= function (stringToSearch, arrayToSearch) {
    var arr = new Array;
    for(var key in arrayToSearch){
        if (arrayToSearch[key] == stringToSearch) {
            continue;
        }else{
            arr.unshift(arrayToSearch[key]);
        }
    }
    return arr;
};

// array_key
detail.GLOBAL.array_key= function(arr){
    var data = new Array;
    for(var key in arr){
        data.push(arr[key]);
    }
    return data;
};

// ajax 数据传输
detail.GLOBAL.Ajax = function (url,type,data,dataType,async,success) {
    $.ajax({
        url: url,
        type : type,
        async : async,
        data : data,
        dataType : dataType,
        success : success,
        error :function () {
            /*layer.msg("数据获取异常，请刷新浏览器稍后重试～",{
             time : 1200
             });*/
        }
    })
};

// ajaxsubmit 表单那提交
detail.GLOBAL.formSubmit = function (form, url, type, data, dataType, async, success) {
    form.ajaxSubmit({
        url: url,
        type : type,
        async : async,
        data : data,
        dataType : dataType,
        success : success,
        error :function () {
            /*layer.msg("数据获取异常，请刷新浏览器稍后重试～",{
             time : 1200
             });*/
        }
    })
};

// 判断ie版本
detail.GLOBAL.isIE = function(ver){
    var b = document.createElement('b');
    b.innerHTML = '';
    return b.getElementsByTagName('i').length === 1;
};

// 控制radio选中
detail.GLOBAL.switch_radio = function (elem, value){
    elem.each(function (i, item) {
        var self =$(item);
        if(self.val() == value){
            self.prop("checked", true);
        }else{
            self.prop("checked", false);
        }
    });
};
