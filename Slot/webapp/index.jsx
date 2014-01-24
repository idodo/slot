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
});