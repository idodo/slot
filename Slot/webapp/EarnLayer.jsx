var EarnLayer = View.derive({
    init: function () {
        this.on('explain', 'tap', function () {
            Player.getPlayerEarns(function(data){
                if(data && data.length){
                    var html = '';
                    data.forEach(function(item){
                        html += '<li style="margin-top:10px;font-size:12px;">' +
                            item.createdAt.replace(/\.\d+/g, '') + ' ' +
                            item.comment + '</li>';
                    });
                    $('earn-list').innerHTML = html;
                    Director.show('earn-history');
                } else {
                    Dialog.show('提示', '暂时没有记录哦');
                }
            });
            //Dialog.show('提示：', '1.金币任务每天都会更新；<br/>2.相同的任务即使在不同的平台，只第一次下载才有效哦~；<br/>3.任务完成后，金币获取会有一定的延迟，不要着急哦。');
        });
        this.on('share', 'tap', function(){
            Director.getLayer('welcome').onEnterShare();
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
    showYoumiOfferWall : '按照说明安装应用即可获得金币',
    showMiddiOfferWall : '按照说明安装应用即可获得金币',
    showDianruOfferWall : '按照说明安装应用即可获得金币',
    showDMOfferWall : '按照说明安装应用即可获得金币',
    showLimeiOfferWall : '按照说明安装应用即可获得金币',
    showAdwoOfferWall : '按照说明安装应用即可获得金币',
    showYijifenOfferWall : '按照说明安装应用即可获得金币'
};

EarnLayer.wall = function(name){
    var button = '<span class="button_small" style="display: inline-block" onclick="WebViewJavascriptBridge.callHandler(\'' + name + '\')">开始</span>'
    Dialog.show('平台赚金币说明', Player.getEarnDesc() || '按照说明安装应用即可获得金币', button);
};