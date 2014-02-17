var ShareLayer = View.derive({
    init : function(){
        Hammer($('share-back-btn')).on('tap', function(){
            Director.show('welcome', -1);
        });
        Hammer($('weixin')).on('tap', function(){
            Director.show('weixin');
        });
    }
});