var WelcomeLayer = cc.Layer.extend({
    btnIndex : 0,
    init : function(){
        this._super();
        var menu = cc.Menu.create(
            this.createBtn('play'),
            this.createBtn('settings'),
            this.createBtn('trade')
        );
        menu.setPosition(0, 0);
        this.addChild(menu);

        this.setTouchEnabled(true);
        return true;
    },
    gotoScene : function(label){
        var layer;
        switch (label){
            case 'play':
                layer = new SlotLayer();
                break;
        }
        if(layer && layer.init()){
            var scene = cc.Scene.create();
            scene.addChild(layer);
            cc.Director.getInstance().replaceScene(cc.TransitionSlideInR.create(.2, scene));
        }
    },
    createBtn : function(label){
        var me = this;
        var btn = cc.MenuItemFont.create(label, function(){
            me.gotoScene(label);
        });
        btn.setAnchorPoint(.5, .5);
        btn.setPosition(SlotApp.centerX, SlotApp.centerY + 100 - (this.btnIndex++) * resources_map.fontSizeNormal * 1.5);
        btn.setColor(resources_map.fontColorNormal);
        return btn;
    }
});