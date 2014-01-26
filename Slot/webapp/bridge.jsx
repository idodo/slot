//oo
Function.prototype.derive = function(constructor, proto){
    if(typeof constructor === 'object'){
        proto = constructor;
        constructor = proto.constructor || function(){};
        delete proto.constructor;
    }
    var parent = this;
    var fn = function(){
        parent.apply(this, arguments);
        constructor.apply(this, arguments);
    };
    var tmp = function(){};
    tmp.prototype = parent.prototype;
    var fp = new tmp(),
        cp = constructor.prototype,
        key;
    for(key in cp){
        if(cp.hasOwnProperty(key)){
            fp[key] = cp[key];
        }
    }
    proto = proto || {};
    for(key in proto){
        if(proto.hasOwnProperty(key)){
            fp[key] = proto[key];
        }
    }
    fp.constructor = constructor.prototype.constructor;
    fn.prototype = fp;
    return fn;
};

(function(callback){
    if(window.WebViewJavascriptBridge){
        callback(WebViewJavascriptBridge);
    } else {
        document.addEventListener('WebViewJavascriptBridgeReady', function(){
            callback(WebViewJavascriptBridge);
        }, false);
    }
})(function(bridge){
    bridge.init(function(message, callback){
        //receive message from object-c
    });
    window.NSAlert = function(message){
        bridge.callHandler('alert', message);
    };
    window.NSLog = function(message) {
        bridge.callHandler('log', message);
    };
    window.NSStartLoading = function(){
        bridge.callHandler('startLoading');
    };
    window.NSStopLoading = function(){
        bridge.callHandler('stopLoading');
    };
    window.onerror = function(msg, url, num){
        window.NSLog('UncatchException: ' + msg + ' [' + num + ']');
    };
});