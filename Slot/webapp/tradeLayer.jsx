var TradeLayer = View.derive({
    init : function(){
        Hammer($('trade-back-btn')).on('tap', function(){
            Director.show('welcome', -1);
        });
        Hammer($('trade-infos')).on('tap', function(evt){
            var tag = evt.target.tagName.toLocaleLowerCase();
            if(tag === 'ul') return;
            var li = tag === 'span' ? evt.target.parentNode : evt.target;
            NSLog('category ' + li.getAttribute('data-category'));
            NSLog('gold ' + li.getAttribute('data-gold'));
        });
    },
    setTradeList : function(infos) {
        if(infos && infos.length){
            var html = '';
            infos.forEach(function(item){
                var attr = [
                    'data-category="' + item.category + '"',
                    'data-gold="' + item.needGold + '"'
                ].join(' ');
                html += '<li ' + attr + '>';
                html += '<span>' + item.comment + '</span>';
                html += '<span>' + item.needGold + '金币</span>';
                html += '</li>';
            });
            $('trade-infos').innerHTML = html;
        }
    }
});