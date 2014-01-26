var SlotLayer = cc.Layer.extend({
    bgImage : null,
    init : function(){
        this.bgImage = cc.Sprite.create(resources_map.slotBackground);
        this.bgImage.setPosition(SlotApp.centerX, SlotApp.centerY);
        this.addChild(this.bgImage);
        return true;
    }
});