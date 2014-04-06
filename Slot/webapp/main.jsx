document.addEventListener('WebViewJavascriptBridgeReady', function () {

    var backBtns = document.querySelectorAll('.back-btn');
    for (var i = 0, len = backBtns.length; i < len; i++) {
        Hammer(backBtns[i]).on('tap', Director.back.bind(Director));
    }

    var container = $('gameContainer');
    var height = (document.body.clientHeight - 50) + 'px';
    var width = document.body.clientWidth;
    document.documentElement.style.minHeight = height;
    document.body.style.minHeight = height;
    container.style.minHeight = height;
    container.style.height = height;

    Director.addLayer(new WelcomeLayer('welcomeLayer'), 'welcome');
    Director.addLayer(new SlotLayer('slotLayer'), 'slot');
    Director.addLayer(new EarnLayer('earnLayer'), 'earn');
    Director.addLayer(new View('tuijianLayer'), 'tuijian');
    Director.addLayer(new View('guanzhuLayer'), 'guanzhu');
    Director.addLayer(new View('5starLayer'), '5star');
    Director.addLayer(new View('installLayer'), 'install');
    Director.addLayer(new SettingsLayer('settingsLayer'), 'settings');
    Director.addLayer(new ShareLayer('shareLayer'), 'share');
    Director.addLayer(new TradeLayer('tradeLayer'), 'trade');
    Director.addLayer(new HistoryLayer('historyLayer'), 'history');
    Director.addLayer(new WeixinLayer('weixinLayer'), 'weixin');
    Director.addLayer(new BindMobileLayer('bindMobileLayer'), 'bind');
    Director.show('welcome');

    var timer;
    Player.getLastDuihuans(function(res){
            var dom = $('earn-show');
            dom.style.display = 'block';
            var html = '<div class="item">';
            res = res || [];
            res.forEach(function(record){
                html += '<span>' + record.duihuanInfo + record.createdAt + record.comment + '</span>';
            });
            html += '</div>';
            html = '<table><tbody><tr><td>' + html + '</td><td>' + html + '</td></tr></tbody></table>';
            dom.innerHTML = html;
            var div = dom.getElementsByTagName('div')[0];
            var table = dom.getElementsByTagName('table')[0];
            var mWidth = div.offsetWidth;
            var distance = 2 * mWidth - width;
            var pos = 0;
            clearInterval(timer);
            timer = setInterval(function(){
                table.style.marginLeft = '-' + (pos) + 'px';
                pos = pos >= distance ? 0 : pos + 1;
            }, 40);
    });


}, false);