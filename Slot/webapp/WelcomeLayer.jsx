var WelcomeLayer = View.derive({
    init : function(){
        this.setPosition(View.width, 0);
        Hammer($('enter-slot')).on('tap', this.onEnterSlot.bind(this));
        Hammer($('enter-earn')).on('tap', this.onEnterEarn.bind(this));
        Sound.init();
    },
    onEnterSlot : function(){
        Player.update(function(){
            Director.show('slot');
        });
    },
    onEnterEarn : function(){
        NSConsumeEarnGold();
        Player.earn(function(earn, status){
            Director.show('earn').setTradeList(earn, status);
        });
    }
});