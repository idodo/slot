document.addEventListener('WebViewJavascriptBridgeReady', function(){

    var backBtns = document.querySelectorAll('.back-btn');
    for(var i = 0, len = backBtns.length; i < len; i++){
        Hammer(backBtns[i]).on('tap', function(){
            var layer = this.getAttribute('data-show') || 'welcome';
            Director.show(layer, -1);
        });
    }

    var container = $('gameContainer');
    var height = (document.body.clientHeight - 50) + 'px';
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
    Director.show('welcome');

}, false);