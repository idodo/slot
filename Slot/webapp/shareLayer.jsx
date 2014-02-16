var ShareLayer = View.derive({
    init : function(){
        Hammer($('share-back-btn')).on('tap', function(){
            Director.show('welcome', -1);
        });
    }
});