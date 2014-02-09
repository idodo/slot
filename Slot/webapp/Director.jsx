var Director = {
    currentLayer : null,
    _map : {},
    addLayer : function(layer, name){
        if(this._map.hasOwnProperty(name)){
            throw 'exists layer id [' + name + ']';
        }
        this._map[name] = layer;
    },
    getLayer : function(name){
        return this._map[name];
    },
    show : function(name, reverse){
        reverse = reverse ? -1 : 1;
        $('layer-mask').style.display = 'block';
        if(this._map.hasOwnProperty(name)){
            if(this.currentLayer){
                if(this.currentLayer._moving) return;
                this.currentLayer.moveTo(-View.width * reverse, 0);
            }
            this.currentLayer = this._map[name];
            this.currentLayer.setPosition(View.width * reverse, 0).moveTo(0, 0);
            return this.currentLayer;
        } else {
            throw 'undefined layer [' + name + ']';
        }
    }
};