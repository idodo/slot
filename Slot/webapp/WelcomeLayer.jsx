var WelcomeLayer = View.derive({
    init : function(){
        this.setPosition(View.width, 0);
        Hammer($('enter-slot')).on('tap', this.onEnterSlot.bind(this));
        Hammer($('enter-earn')).on('tap', this.onEnterEarn.bind(this));

        var sound = new Audio('bg.mp3');
        sound.loop = true;
        sound.preload = 'auto';
        sound.autoplay = true;
        sound.load();
    },
    onEnterSlot : function(){
        Player.update(function(){
            Director.show('slot');
        });
    },
    onEnterEarn : function(){
        Player.earn(function(earn){
            Director.show('earn').setTradeList(earn);
        });
    }
});