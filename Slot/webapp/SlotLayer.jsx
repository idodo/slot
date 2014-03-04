var SLOT_OFFSET = -35;

var SlotLayer = View.derive({
    init : function(){
        this.y1 = this.y2 = this.y3 = SLOT_OFFSET;
        this.y1T = this.y2T = this.y3T = SLOT_OFFSET;
        this.s1 = 30;
        this.s2 = 40;
        this.s3 = 25;
        this.playing = false;
        this.score = Player.getScore();
        this.winGold = -1;
        this.setPosition(View.width, 0);
        this._moveItems();
        this.on('bingo', 'tap', this._bind(this.hideBingo));
        this.on('slotRate', 'tap', this._bind(this.hideRate));
        this.on('startBtn', 'tap', this._bind(this.play));
        this.on('betBtn',   'tap', this._bind(this.bet100));
        this.on('rateBtn',   'tap', this._bind(this.showRate));
        this.on('backBtn',  'tap', this._bind(this.back));
    },
    _bind : function(fn){
        var me = this;
        return function(){
            $('slot-inner').className = '';
            fn.apply(me, arguments);
        };
    },
    hideBingo : function(){
        clearTimeout(this.bingoTimer);
        $('bingo').style.display = 'none';
    },
    hideRate : function(){
        document.body.className = '';
        $('slotRate').style.display = 'none';
    },
    showRate : function(){
        document.body.className = 'show-mask';
        $('slotRate').style.display = 'block';
    },
    play : function(){
        if(this.playing) return;
        var earn = $('earn');
        earn.innerHTML = '0';
        earn.className = 'score';
        var bet = parseInt($('bet').innerHTML.trim());
        if(bet){
            var score = Player.getScore();
            if(score > bet){
                var me = this;
                Player.bet(bet, function(bet, winGold, score){
                    me.playing = true;
                    me.winGold = winGold;
                    me.score = score;
                    me.y1T = SLOT_OFFSET - (bet[0] + 6 * (80 + Math.round(Math.random() * 20)) ) * 68.5;
                    me.y2T = SLOT_OFFSET - (bet[1] + 6 * (80 + Math.round(Math.random() * 20)) ) * 68.5;
                    me.y3T = SLOT_OFFSET - (bet[2] + 6 * (80 + Math.round(Math.random() * 20)) ) * 68.5;
                    me._run();
                });
            } else {
                Dialog.show('啊哈', '金币不够啦，快去赚一些吧！');
            }
        } else {
            Dialog.show('啊哈', '亲，您还没有下注哦！');
        }
    },
    stop : function(){
        var earn = $('earn');
        earn.innerHTML = '0';
        earn.className = 'score';
        this.playing = false;
        this.y1 = this.y2 = this.y3 = SLOT_OFFSET;
        this._moveItems();
    },
    bet100 : function(){
        var dom = $('bet');
        var bet = parseInt(dom.innerHTML.trim());
        var score = Player.getScore();
        if(score > 0){
            if( score >= 1000 ){
                var _bet = bet + 50;
            }else{
                var _bet = bet + 10;
            }
            if( _bet > score ){
                _bet = 0;
            }
            dom.innerHTML = (_bet);
        } else {
            Dialog.show('哎呀', '您的金币不足啦！');
        }
    },
    back : function(){
        this.stop();
        Director.show('welcome', true);
    },
    onFinished : function(){
        if(this.winGold > 0){
            var earn = $('earn');
            earn.innerHTML = this.winGold;
            earn.className = 'score anim';
            Player.setScore(this.score);
            $('bingo').style.display = 'block';
            this.bingoTimer = setTimeout(this._bind(this.hideBingo), 3000);
            this.winGold = -1;
        }
    },
    _moveItems : function(){
        $('item1').style.top = Math.floor(this.y1 % 411) + 'px';
        $('item2').style.top = Math.floor(this.y2 % 411) + 'px';
        $('item3').style.top = Math.floor(this.y3 % 411) + 'px';
    },
    _run : function() {
        if(!this.playing) return;
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
            this._moveItems();
            setTimeout(this._run.bind(this), 1);
        }
    }
});