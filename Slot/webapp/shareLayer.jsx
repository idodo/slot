var ShareLayer = View.derive({
    init : function(){
        Hammer($('tuijian')).on('tap', function(){
            Director.show('tuijian');
        });
        Hammer($('guanzhu')).on('tap', function(){
            Director.show('guanzhu');
        });
        Hammer($('5star')).on('tap', function(){
            Director.show('5star');
        });
        Hammer($('install')).on('tap', function(){
            Director.show('install');
        });
        Hammer($('weixin')).on('tap', function(){
            Director.show('weixin');
        });
    }
});