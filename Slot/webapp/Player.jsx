(function($$){
    var score = 0;
    var REMOTE_SERVER = 'http://192.168.137.139:8080';
    $$.ajax = function(opt){
        var xhr = new window.XMLHttpRequest();
        var timer;
        if(typeof opt.async === 'undefined'){
            opt.async = true;
        }
        opt.error = opt.error || function(){};
        xhr.onreadystatechange = function(){
            if(xhr.readyState === 4){
                clearTimeout(timer);
                if((xhr.status >= 200 && xhr.status < 300) || xhr.status === 0){
                    if(opt.async){
                        opt.success(xhr.responseText, xhr, opt);
                    }
                } else {
                    opt.error('unsuccesful', xhr, opt);
                }
            }
        };
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
            opt.error('timeout', xhr, opt);
        }, opt.timeout || 20000);
        try {
            xhr.send(opt.data);
        } catch (e){
            opt.error('unknown', xhr, opt);
        }
        if(!opt.async){
            opt.success(xhr.responseText, xhr, opt);
        }
        return xhr;
    };
    $$.Player = {
        getInfoUrl : REMOTE_SERVER + '/user.php',
        getScore : function(success, error){
            NSStartLoading();
            $$.ajax({
                url : this.getInfoUrl,
                success : function(res){
                    var data = JSON.parse(res);
                    if(data && typeof data.score === 'number'){
                        success(data.score);
                    } else {
                        error('no score');
                    }
                    NSStopLoading();
                },
                error : function(err){
                    error(err);
                    NSStopLoading();
                }
            });
        }
    };
})(window);