var EarnLayer = View.derive({
    init: function () {
        this.on('explain', 'tap', function () {
            Dialog.show('提示：', '1.金币任务每天都会更新；<br/>2.相同的任务即时在不同的平台，只第一次下载有效哦~；<br/>3.任务完成后，金币获取会有一定的延迟，不要着急哦。');
        });
        this.on('convert', 'tap', function(){
            Director.getLayer('welcome').onEnterTrade();
        });
    },
    setTradeList: function (data, status) {
        clearTimeout(this.listTimer);
        clearTimeout(this.listTimer2);
        var panel = $('pt-panel');
        for (var name in status) {
            if (status.hasOwnProperty(name) && status[name] == '1') {
                var d = $(name);
                if (d) {
                    panel.removeChild(d);
                    panel.appendChild(d);
                    d.style.display = 'inline-block';
                }
            }
        }
        var dom = $('trade-list');
        dom.className = 'transform';
        dom.style.webkitTransform = 'translateY(-19px)';
        var html = '';
        data.forEach(function (record) {
            html += '<li>' +
                record.user +
                '' + record.platform + '获得<span>' +
                record.earn + '</span>金币(' +
                record.time + '前)</li>';
        });
        dom.innerHTML = html;
        if (data.length >= 5) {
            this.marquee();
        }
    },
    marquee: function () {
        var dom = $('trade-list');
        dom.className = '';
        dom.style.webkitTransform = 'translateY(0)';
        var children = dom.getElementsByTagName('li');
        if (this._verbose) {
            dom.removeChild(children[0]);
        }
        var first = children[0];
        var clone = first.cloneNode(true);
        dom.appendChild(clone);
        this._verbose = true;
        var me = this;
        this.listTimer = setTimeout(function () {
            dom.className = 'transform';
            dom.style.webkitTransform = 'translateY(-19px)';
            me.listTimer2 = setTimeout(me.marquee.bind(me), 4000);
        }, 0);
    }
});

var WallDesc = {
    showYoumiOfferWall : '有米平台兑换说明',
    showMiddiOfferWall : '米迪平台兑换说明',
    showDianruOfferWall : '点入平台兑换说明',
    showDMOfferWall : '多盟平台兑换说明',
    showLimeiOfferWall : '力美平台兑换说明',
    showAdwoOfferWall : '安沃平台兑换说明',
    showYijifenOfferWall : '易积分平台兑换说明'
};

EarnLayer.wall = function(name){
    var button = '<span class="button_small" style="display: inline-block" onclick="WebViewJavascriptBridge.callHandler(\'' + name + '\')">兑换</span>'
    Dialog.show('平台赚金币说明', WallDesc[name] || '免费赚金币', button);
};