document.addEventListener('WebViewJavascriptBridgeReady', function(){

    Director.addLayer(new WelcomeLayer('welcomeLayer'), 'welcome');
    Director.addLayer(new SlotLayer('slotLayer'), 'slot');
    Director.addLayer(new EarnLayer('earnLayer'), 'earn');
    Director.show('welcome');

}, false);