function $(id){
    return document.getElementById(id);
}

var View = Object.derive({
    constructor : function(id){
        this.dom = (typeof id === 'string' ? $(id) : id);
        this._tX = this._x = this._tY = this._y = 0;
        this.speed = 10;
        this._running = false;
        this.init();
    },
    init : function(){},
    setBackground : function(url, repeat){
        this.dom.style.backgroundImage = 'url(' + url + ')';
        this.dom.style.backgroundRepeat = repeat || 'no-repeat';
        this.dom.style.backgroundSize = '100%';
    },
    addChild : function(view){
        this.dom.appendChild(view.dom);
    },
    removeChild : function(view){
        this.dom.removeChild(view.dom);
    },
    moveTo : function(x, y, speed){
        this._tX = x;
        this._tY = y;
        this.speed = speed || this.speed;
        if(!this._running){
            this._run();
        }
    },
    _run : function(){
        if(Math.abs(this._tX - this._x) < 0.5 && Math.abs(this._tY - this._y) < 0.5){
            this.setPosition(this._tX, this._tY);
            this._running = false;
        } else {
            var x = this._x + (this._tX - this._x) / this.speed;
            var y = this._y + (this._tY - this._y) / this.speed;
            this.setPosition(x, y);
            var me = this;
            setTimeout(function(){ me._run(); }, 0);
            this._running = true;
        }
    },
    setSize : function(w, h){
        this._w = w;
        this._h = h;
        this.dom.style.width = this._w + 'px';
        this.dom.style.height = this._h + 'px';
    },
    setPosition : function(x, y){
        this._x = x;
        this._y = y;
        this.dom.style.left = Math.ceil(this._x) + 'px';
        this.dom.style.top = Math.ceil(this._y) + 'px';
    }
});
View.width = document.documentElement.clientWidth;
View.height = document.documentElement.clientHeight;
View.create = function(tag){
    return new View(document.createElement(tag));
};