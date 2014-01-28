var WelcomeLayer = View.derive({
    init : function(){
        this.setPosition(View.width, 0);
        Hammer($('enter-slot')).on('tap', this.onEnterSlot.bind(this));
    },
    onEnterSlot : function(){
        Player.updateScore(function(){
            Director.show('slot');
        });
    }
});