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
    }
    window.onerror = function(msg, url, num){
        NSLog('UncatchException: ' + msg + ' [' + num + ']');
    };
});