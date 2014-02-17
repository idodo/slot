document.addEventListener('WebViewJavascriptBridgeReady', function(){

    Director.addLayer(new WelcomeLayer('welcomeLayer'), 'welcome');
    Director.addLayer(new SlotLayer('slotLayer'), 'slot');
    Director.addLayer(new EarnLayer('earnLayer'), 'earn');
    Director.addLayer(new SettingsLayer('settingsLayer'), 'settings');
    Director.addLayer(new ShareLayer('shareLayer'), 'share');
    Director.addLayer(new TradeLayer('tradeLayer'), 'trade');
    Director.addLayer(new WeixinLayer('weixinLayer'), 'weixin');
    Director.show('welcome');

}, false);