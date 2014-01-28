(function($$){
    var score = 0;
    var REMOTE_SERVER = 'http://192.168.137.139:8080';
    function displayScore(value){
        $('score').innerHTML = score = value;
    }
    $$.ajax = function(opt){
        var xhr = new window.XMLHttpRequest();
        var timer;
        if(typeof opt.async === 'undefined'){
            opt.async = true;
        }
        var success = function(){
            NSStopLoading();
            if(opt.success){
                opt.success.apply(null, arguments);
            }
        };
        var error = function(){
            NSStopLoading();
            if(opt.error){
                opt.error.apply(null, arguments);
            }
        };
        xhr.onreadystatechange = function(){
            if(xhr.readyState === 4){
                clearTimeout(timer);
                if((xhr.status >= 200 && xhr.status < 300) || xhr.status === 0){
                    if(opt.async){
                        success(xhr.responseText, xhr, opt);
                    }
                } else {
                    error('unsuccesful', xhr, opt);
                }
            }
        };
        opt.url += (opt.url.indexOf('?') > -1 ? '&' : '?') + 't=' + Date.now();
        xhr.open(opt.type || 'GET', opt.url, opt.async);
        if(opt.headers){
            for(var header in opt.headers){
                if(opt.headers.hasOwnProperty(header)){
                    xhr.setRequestHeader(header, opt.headers[header]);
                }
            }
        }
        timer = setTimeout(function(){
            xhr.onreadystatechange = {};
            xhr.abort();
            error('timeout', xhr, opt);
        }, opt.timeout || 20000);
        try {
            NSStartLoading();
            xhr.send(opt.data);
        } catch (e){
            error('unknown', xhr, opt);
        }
        if(!opt.async){
            success(xhr.responseText, xhr, opt);
        }
        return xhr;
    };
    $$.Player = {
        getScore : function(){
            return score;
        },
        updateScoreUrl : REMOTE_SERVER + '/score.php',
        updateScore : function(success, error){
            error = error || function(code, err){
                NSLog('code: ' + code + '\treason: ' + err);
                Dialog.show('矮油', '等等，我们这有点忙~~');
            };
            $$.ajax({
                url : this.updateScoreUrl,
                success : function(res){
                    try {
                        var data = JSON.parse(res);
                        if(typeof data.score === 'number'){
                            displayScore(data.score);
                            success(data.score);
                        } else {
                            error(data.result, data.reason, data);
                        }
                    } catch(e) {
                        error(-1, e.message, e);
                    }
                },
                error : function(res){
                    error(-2, res);
                }
            });
        },
        betUrl : REMOTE_SERVER + '/bet.php',
        bet : function(value, success, error){
            error = error || function(code, reason){
                NSLog('code: ' + code + '\treason: ' + reason);
                switch (code){
                    case 1:
                        reason = '积分没有辣么多啦！';
                        break;
                    case 2:
                        reason = '亲，还没下注哦！';
                        break;
                    default :
                        reason = '服务器君，你肿么了！';
                        break;
                }
                Dialog.show('啊哦', reason);
            };
            $$.ajax({
                url: this.betUrl,
                type : 'POST',
                data : 'bet=' + parseInt(value),
                headers : { 'Content-Type' : 'application/x-www-form-urlencoded'},
                success : function(res){
                    try {
                        var data = JSON.parse(res);
                        displayScore(data.score);
                        if(data.result == 0){
                            success(data.bet);
                        } else {
                            error(data.result, data.reason, data);
                        }
                    } catch (e){
                        error(-1, e.message, e);
                    }

                },
                error : function(res){
                    error(-2, res);
                }
            });
        }
    };
})(window);