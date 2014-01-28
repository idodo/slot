document.addEventListener('WebViewJavascriptBridgeReady', function(){

    Player.getScore(function(score){
        //var slotLayer = new SlotLayer('slotLayer');
        //slotLayer.setScore(score);
        //slotLayer.moveTo(0, 0);
    }, function(err){
        Dialog.show('获取积分失败', err);
    });

}, false);