document.addEventListener('WebViewJavascriptBridgeReady', function(){

    var slotLayer = new View('slotLayer');
    slotLayer.setPosition(View.width, 0);
    setTimeout(function(){
        slotLayer.moveTo(0, 0);
    }, 0);

    Hammer($('startBtn')).on('tap', function(){
        var y1 = -37;
        var y2 = -37;
        var y3 = -37;
        var speed1 = 1;
        var speed2 = 2;
        var speed3 = 3;
        setInterval(function(){
            $('item1').style.top = y1 + 'px';
            $('item2').style.top = y2 + 'px';
            $('item3').style.top = y3 + 'px';
            y1 = (y1 - speed1) % 411;
            y2 = (y2 - speed2) % 411;
            y3 = (y3 - speed3) % 411;
        }, 1);
    });

    var bet = 0;
    Hammer($('betBtn')).on('tap', function(){
        bet = (bet + 100) % 1100;
        $('bet').innerHTML = bet;
    });

}, false);