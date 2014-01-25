var WelcomeLayer = cc.Layer.extend({
    helloLabel : null,
    init : function(){
        this._super();
        var size = cc.Director.getInstance().getWinSize();
        this.helloLabel = cc.LabelTTF.create('it works!', 'Arial', '40');
        this.helloLabel.setPosition(size.width / 2, size.height / 2);
        this.helloLabel.setColor(new cc.Color3B(255, 255, 255));
        this.addChild(this.helloLabel, 1);
        this.setTouchEnabled(true);
        return true;
    }
});