//oo
Function.prototype.derive = function (constructor, proto) {
    if (typeof constructor === 'object') {
        proto = constructor;
        constructor = proto.constructor || function () {
        };
        delete proto.constructor;
    }
    var parent = this;
    var fn = function () {
        parent.apply(this, arguments);
        constructor.apply(this, arguments);
    };
    var tmp = function () {
    };
    tmp.prototype = parent.prototype;
    var fp = new tmp(),
        cp = constructor.prototype,
        key;
    for (key in cp) {
        if (cp.hasOwnProperty(key)) {
            fp[key] = cp[key];
        }
    }
    proto = proto || {};
    for (key in proto) {
        if (proto.hasOwnProperty(key)) {
            if (typeof proto[key] === 'function' && typeof fp[key] === 'function') {
                fp[key] = (function (subMethod, parentMethod) {
                    return function () {
                        this._super = parentMethod;
                        var ret = subMethod.apply(this, arguments);
                        delete this._super;
                        return ret;
                    };
                })(proto[key], fp[key]);
            } else {
                fp[key] = proto[key];
            }
        }
    }
    fp.constructor = constructor.prototype.constructor;
    fn.prototype = fp;
    return fn;
};

(function (callback) {
    if (window.WebViewJavascriptBridge) {
        callback(WebViewJavascriptBridge);
    } else {
        document.addEventListener('WebViewJavascriptBridgeReady', function () {
            callback(WebViewJavascriptBridge);
        }, false);
    }
})(function (bridge) {
    bridge.init(function (message, callback) {
        //receive message from object-c

    });

    window.NSAlert = function (message) {
        bridge.callHandler('alert', message);
    };
    window.NSLog = function () {
        var msg = [];
        for (var i = 0, len = arguments.length; i < len; i++) {
            var data = arguments[i];
            switch (typeof data) {
                case 'string':
                case 'number':
                case 'boolean':
                    msg.push(data);
                    break;
                case 'undefined':
                    msg.push('undefined');
                    break;
                default :
                    msg.push(JSON.stringify(arguments[i]));
                    break;
            }
        }
        bridge.callHandler('log', '[' + msg + ']');
    };
    window.NSStartLoading = function () {
        $('layer-mask').style.display = 'block';
        bridge.callHandler('startLoading');
    };
    window.NSStopLoading = function () {
        $('layer-mask').style.display = '';
        bridge.callHandler('stopLoading');
    };
    window.onerror = function (msg, url, num) {
        window.NSLog('UncatchException: ' + msg + ' [' + num + ']');
    };
    window.NSConsumeEarnGold = function () {
        bridge.callHandler("consumeEarnGold");
    };
    //初始化页面相关的配置数据，包括用户udid，app是否在review状态，这个是js主动调用objc接口
    window.getInitData = function (callback) {
        bridge.callHandler('getInitData', {}, function (response) {
            window.NSLog('[js getPlayerUdid] response:' + response);
            Player.updateInitData(response);
            if(callback) callback();
        });
    };
    //设置当前所在页面名字，如果程序在免费赚金币页面进入后台运行（此时很可能是由于用户去下载应用赚金币了），然后重新带回前台的时候，此时需要从广告平台搬运金币
    window.setCurrentPage = function (pageName) {
        bridge.callHandler('setCurrentPage', pageName);
    };
    window.xss = function (content) {
        return content.replace(/[<>&"']/g, function (m) {
            return '&#' + m.charCodeAt(0) + ';';
        });
    };
    bridge.registerHandler('updateUdid', function (data, responseCallback) {
        window.NSLog('ObjC called js updateUdid with:', data);
        Player.updateUdid(data);
    });
    bridge.registerHandler('updateScore', function (data, responseCallback) {
        window.NSLog('ObjC called js updateScore with:', data);
        Player.updateScore1(data.score);
    });
    bridge.registerHandler('update', function (data, responseCallback) {
        window.NSLog('ObjC called js updateScore with:', data);
        Player.updateScore(data);
    });
    //初始化页面相关的配置数据，包括用户udid，app是否在review状态，这个是obc调用js接口
    bridge.registerHandler('initConfig', function (data, responseCallback) {
        window.NSLog('ObjC called js initConfig with:', data);
        Player.updateInitData(data);
    });
    //app被从后台唤回
    bridge.registerHandler('appBecomeActive', function (data, responseCallback) {
        window.NSLog('ObjC called js [appBecomeActive]');
        Sound.init();
    });
});