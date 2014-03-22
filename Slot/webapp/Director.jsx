var Director = {
    currentLayer : null,
    _map : {},
    _stack : [],
    addLayer : function(layer, name){
        if(this._map.hasOwnProperty(name)){
            throw 'exists layer id [' + name + ']';
        }
        this._map[name] = layer;
    },
    getLayer : function(name){
        return this._map[name];
    },
    _show : function(name, reverse){
        reverse = reverse ? -1 : 1;
        if(this._map.hasOwnProperty(name)){
            if(this.currentLayer){
                if(this.currentLayer._moving) return;
                this.currentLayer.moveTo(-View.width * reverse, 0);
            }
            setCurrentPage(name);
            this.currentLayer = this._map[name];
            this._stack.push(name);
            this.currentLayer.setPosition(View.width * reverse, 0).moveTo(0, 0);
            return this.currentLayer;
        } else {
            throw 'undefined layer [' + name + ']';
        }
    },
    show : function(name, reverse){
        $('layer-mask').style.display = 'block';
        var me = this;
        if(name == 'welcome'){
            getInitData(function(){
                me._show(name, reverse);
            });
            return this._map[name];
        } else {
            return this._show(name, reverse);
        }
    },
    back : function(){
        this._stack.pop();
        var targe = this._stack.pop() || 'welcome';
        this.show(targe, -1);
    }
};