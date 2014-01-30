var EarnLayer = View.derive({
    init : function(){
        Hammer($('earn-back-btn')).on('tap', function(){
            Director.show('welcome', -1);
        });
    },
    setTradeList : function(data){
        var dom = $('trade-list');
        var html = '';
        data.forEach(function(record){
            html += '<li>' +
                record.user +
                '在' + record.platform + '平台获得<span>' +
                record.earn + '</span>金币(' +
                record.time + '前)</li>';
        });
        dom.innerHTML = html;
        if(data.length >= 5){
            this.marquee();
        }
    },
    marquee : function(){
        var dom = $('trade-list');
        dom.className = '';
        dom.style.webkitTransform = 'translateY(0)';
        var children = dom.getElementsByTagName('li');
        if(this._verbose) {
            dom.removeChild(children[0]);
        }
        var first = children[0];
        var clone = first.cloneNode(true);
        dom.appendChild(clone);
        this._verbose = true;
        var me = this;
        setTimeout(function(){
            dom.className = 'transform';
            dom.style.webkitTransform = 'translateY(-19px)';
            setTimeout(me.marquee.bind(me), 4000);
        }, 0);
    }
});