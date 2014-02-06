function $(id){
    return typeof id === 'string' ? document.getElementById(id) : id;
}

var View = Object.derive({
    constructor : function(id){
        this.dom = $(id);
        this._tX = this._x = this._tY = this._y = 0;
        this._moving = false;
        this.speed = View.speed;
        this.init();
    },
    init : function(){},
    on : function(id, type, callback, opt){
        Hammer($(id), opt).on(type, callback);
    },
    setBackground : function(url, repeat){
        this.dom.style.backgroundImage = 'url(' + url + ')';
        this.dom.style.backgroundRepeat = repeat || 'no-repeat';
        this.dom.style.backgroundSize = '100%';
        return this;
    },
    addChild : function(view){
        this.dom.appendChild(view.dom);
        return this;
    },
    removeChild : function(view){
        this.dom.removeChild(view.dom);
        return this;
    },
    moveTo : function(x, y, speed){
        this._tX = x;
        this._tY = y;
        this.speed = speed || this.speed;
        if(!this._moving){
            this._move();
        }
        return this;
    },
    onMoveFinished : function(){},
    _move : function(){
        if(Math.abs(this._tX - this._x) < 0.5 && Math.abs(this._tY - this._y) < 0.5){
            this.setPosition(this._tX, this._tY);
            this._moving = false;
            this.onMoveFinished();
        } else {
            var x = this._x + (this._tX - this._x) / this.speed;
            var y = this._y + (this._tY - this._y) / this.speed;
            this.setPosition(x, y);
            setTimeout(this._move.bind(this), 0);
            this._moving = true;
        }
    },
    setSize : function(w, h){
        this._w = w;
        this._h = h;
        this.dom.style.width = this._w + 'px';
        this.dom.style.height = this._h + 'px';
        return this;
    },
    setPosition : function(x, y){
        this._x = x;
        this._y = y;
        this.dom.style.left = Math.ceil(this._x) + 'px';
        this.dom.style.top = Math.ceil(this._y) + 'px';
        return this;
    }
});
View.width = document.documentElement.clientWidth;
View.height = document.documentElement.clientHeight;
View.speed = 15;
View.create = function(tag){
    return new View(document.createElement(tag));
};