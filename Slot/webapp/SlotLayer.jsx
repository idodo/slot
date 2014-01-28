var SLOT_OFFSET = -35;

var SlotLayer = View.derive({
    init : function(){
        this.score = 0;
        this.y1 = this.y2 = this.y3 = SLOT_OFFSET;
        this.y1T = this.y2T = this.y3T = SLOT_OFFSET;
        this.s1 = 30;
        this.s2 = 40;
        this.s3 = 25;
        this.bet = 0;
        this.playing = false;
        this.setPosition(View.width, 0);
        this._draw();
        this.on('startBtn', 'tap', this._bind(this.play));
        this.on('betBtn', 'tap', this._bind(this.bet100));
        this.on('betAllBtn', 'tap', this._bind(this.betAll));
    },
    _bind : function(fn){
        var me = this;
        return function(){
            $('slot-inner').className = '';
            fn.apply(me, arguments);
        };
    },
    play : function(x, y, z){
        if(this.playing) return;
        this.playing = true;
        x = Math.floor(Math.random() * 6);
        y = Math.floor(Math.random() * 6);
        z = Math.floor(Math.random() * 6);
        NSLog(x, y, z);
        this.y1T = SLOT_OFFSET - (x + 6 * (80 + Math.round(Math.random() * 20)) ) * 68.5;
        this.y2T = SLOT_OFFSET - (y + 6 * (80 + Math.round(Math.random() * 20)) ) * 68.5;
        this.y3T = SLOT_OFFSET - (z + 6 * (80 + Math.round(Math.random() * 20)) ) * 68.5;
        this._run();
    },
    setScore : function(score){
        this.score = score;
        $('score').innerHTML = this.score;
    },
    bet100 : function(){
        this.bet = (this.bet + 100) % 1100;
        $('bet').innerHTML = this.bet;
    },
    betAll : function(){

    },
    onFinished : function(){
        $('slot-inner').className = 'anim';
    },
    _draw : function(){
        $('item1').style.top = Math.floor(this.y1 % 411) + 'px';
        $('item2').style.top = Math.floor(this.y2 % 411) + 'px';
        $('item3').style.top = Math.floor(this.y3 % 411) + 'px';
    },
    _run : function() {
        var y1D = Math.abs(this.y1T - this.y1) < 0.5;
        var y2D = Math.abs(this.y2T - this.y2) < 0.5;
        var y3D = Math.abs(this.y3T - this.y3) < 0.5;
        if(y1D){
            this.y1 = this.y1T;
        } else {
            this.y1 += (this.y1T - this.y1) / this.s1;
        }
        if(y2D){
            this.y2 = this.y2T;
        }  else {
            this.y2 += (this.y2T - this.y2) / this.s2;
        }
        if(y3D){
            this.y3 = this.y3T;
        } else {
            this.y3 += (this.y3T - this.y3) / this.s3;
        }
        if(y1D && y2D && y3D){
            this.y1 = this.y1T % 411;
            this.y2 = this.y2T % 411;
            this.y3 = this.y3T % 411;
            this.playing = false;
            this.onFinished();
        } else {
            this._draw();
            setTimeout(this._run.bind(this), 1);
        }
    }
});