document.addEventListener('WebViewJavascriptBridgeReady', function(){

    Director.addLayer(new WelcomeLayer('welcomeLayer'), 'welcome');
    Director.addLayer(new SlotLayer('slotLayer'), 'slot');
    Director.show('welcome');

}, false);