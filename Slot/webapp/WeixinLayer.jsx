var WeixinLayer = View.derive({
    init : function(){
        Hammer($('weixin-back-btn')).on('tap', function(){
            Director.show('share', -1);
        });
    }
});