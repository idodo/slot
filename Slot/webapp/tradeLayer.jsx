var TradeLayer = View.derive({
    init: function () {
        Hammer($('history')).on('tap', function(){
            Player.duihuanHistory(function(data){
                Director.show('history').setHistoryList(data);
            });
        });
        Hammer($('trade-infos')).on('tap', function (evt) {
            var tag = evt.target.tagName.toLocaleLowerCase();
            if (tag === 'ul') return;
            var li = tag === 'span' ? evt.target.parentNode : evt.target;
            NSLog('category ' + li.getAttribute('data-category'));
            NSLog('gold ' + li.getAttribute('data-gold'));
            NSLog('idx' + li.getAttribute('data-type'));
            var duihuanItem = li.getAttribute('data-type');
            Player.duihuan(duihuanItem, function () {
                self.lock = false;
                Dialog.show('提示', '申请兑换成功！');
            }, function (code, msg) {
                self.lock = false;
                Dialog.show('保存失败', msg);
            });
        });
    },
    setTradeList: function (infos) {
        if (infos && infos.length) {
            var html = '';
            infos.forEach(function (item) {
                var attr = [
                    'data-category="' + item.category + '"',
                    'data-gold="' + item.needGold + '"',
                    'data-type="' + item.idx + '"'

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