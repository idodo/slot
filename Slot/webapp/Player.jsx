(function ($$) {
    var score = 0;
    var name = "";
    var udid = "";
    var qq = "";
    var phone = "";


    var REMOTE_SERVER = 'http://anansi.vicp.cc:8076';

    function displayScore(value) {
        score = value;
        $('score').innerHTML = score;
        $('score2').innerHTML = score;
        $('score3').innerHTML = score;
    }

    $$.ajax = function (opt) {
        var xhr = new window.XMLHttpRequest();
        var timer;
        if (typeof opt.async === 'undefined') {
            opt.async = true;
        }
        var success = function () {
            NSStopLoading();
            if (opt.success) {
                opt.success.apply(null, arguments);
            }
        };
        var error = function () {
            NSStopLoading();
            if (opt.error) {
                opt.error.apply(null, arguments);
            }
        };
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                clearTimeout(timer);
                if ((xhr.status >= 200 && xhr.status < 300) || xhr.status === 0) {
                    if (opt.async) {
                        success(xhr.responseText, xhr, opt);
                    }
                } else {
                    error('server error', xhr, opt);
                }
            }
        };
        opt.url += (opt.url.indexOf('?') > -1 ? '&' : '?') + 't=' + Date.now();
        xhr.open(opt.type || 'GET', opt.url, opt.async);
        if (opt.headers) {
            for (var header in opt.headers) {
                if (opt.headers.hasOwnProperty(header)) {
                    xhr.setRequestHeader(header, opt.headers[header]);
                }
            }
        }
        timer = setTimeout(function () {
            xhr.onreadystatechange = {};
            xhr.abort();
            error('timeout', xhr, opt);
        }, opt.timeout || 20000);
        try {
            NSStartLoading();
            xhr.send(opt.data);
        } catch (e) {
            error('unknown', xhr, opt);
        }
        if (!opt.async) {
            success(xhr.responseText, xhr, opt);
        }
        return xhr;
    };
    $$.Player = {
        setScore: displayScore,
        //返回暂存的金币数据
        getScore: function () {
            return score;
        },
        updateUdid: function (data) {
            NSLog('js in updateUdid udid:' + data.udid);
            udid = data.udid;
        },
        updateScore: function (_data) {
            var data = JSON.parse(_data);
            displayScore(data.score);
        },
        //更新金币的url
        updateUrl: REMOTE_SERVER + '/player/getbyudid',
        //更新金币并回调
        update: function (success, error) {
            error = error || function (code, err) {
                NSLog('code: ' + code + '\treason: ' + err);
                Dialog.show('矮油', '等等，我们这有点忙~~');
            };
            $$.ajax({
                url: this.updateUrl,
                data: 'udid=' + udid,
                type: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded'},
                success: function (res) {
                    try {
                        var data = JSON.parse(res);
                        if (typeof data.playerInfo.gold === 'number') {
                            displayScore(data.playerInfo.gold);
                            success(data.playerInfo.gold, data);
                        } else {
                            error(data.result, data.reason, data);
                        }
                    } catch (e) {
                        error(-1, e.message, e);
                    }
                },
                error: function (res) {
                    error(-2, res);
                }
            });
        },
        //下注请求url
        betUrl: REMOTE_SERVER + '/player/bet',
        //赌金币并回调
        bet: function (value, success, error) {
            error = error || function (code, reason) {
                NSLog('code: ' + code + '\treason: ' + reason);
                switch (code) {
                    case 1:
                        reason = '金币没有辣么多啦，赶紧去赚点吧~';
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
                type: 'POST',
                data: 'betGold=' + parseInt(value) + '&udid=' + udid,
                headers: { 'Content-Type': 'application/x-www-form-urlencoded'},
                success: function (res) {
                    try {
                        var data = JSON.parse(res);
                        NSLog("[bet] res:" + res);
                        displayScore(score - value);
                        if (data.result == 0) {
                            success(data.bet, data.winGold, data.score);
                        } else {
                            error(data.result, data.reason, data);
                        }
                    } catch (e) {
                        error(-1, e.message, e);
                    }

                },
                error: function (res) {
                    error(-2, res);
                }
            });
        },
        //查询赚金币用户列表的url
        earnUrl: REMOTE_SERVER + '/player/earnrecords',

        //查询赚金币用户列表的回调函数
        earn: function (success, error) {
            error = error || function (code, err) {
                NSLog('code: ' + code + '\treason: ' + err);
                Dialog.show('矮油', '等等，我们这有点忙~~');
            };
            $$.ajax({
                url: this.earnUrl,
                data: 'udid=' + udid,
                type: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded'},
                success: function (res) {
                    try {
                        NSLog('[earnrecords] res:' + res);
                        var data = JSON.parse(res);
                        if (typeof data.score === 'number') {
                            displayScore(data.score);
                            success(data.earn, data.wall_status);
                        } else {
                            error(data.result, data.reason, data);
                        }
                    } catch (e) {
                        error(-1, e.message, e);
                    }
                },
                error: function (res) {
                    error(-2, res);
                }
            });
        },
        saveSettingsUrl: REMOTE_SERVER + '/player/updateduihuaninfo',
        saveSettings : function(info, success, error) {
            error = error || function (code, err) {
                NSLog('code: ' + code + '\treason: ' + err);
                Dialog.show('矮油', '等等，我们这有点忙~~');
            };
            var data = 'udid=' + udid;
            if(info.qq) data += '&qq=' + encodeURIComponent(info.qq);
            if(info.zhifubao) data += '&zhifubao=' + encodeURIComponent(info.zhifubao);
            if(info.phone) data += '&phone=' + encodeURIComponent(info.phone);
            $$.ajax({
                url: this.saveSettingsUrl,
                data: data,
                type: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded'},
                success: function (res) {
                    try {
                        NSLog('[updateduihuaninfo] res:' + res);
                        var data = JSON.parse(res);
                        if (data.result == 0) {
                            success(data);
                        } else {
                            error(data.result, data.reason, data);
                        }
                    } catch (e) {
                        error(-1, e.message, e);
                    }
                },
                error: function (res) {
                    error(-2, res);
                }
            });
        },
        tradeInfosUrl: REMOTE_SERVER + '/player/getduihuaninfos',
        tradeInfos : function(success, error) {
            error = error || function (code, err) {
                NSLog('code: ' + code + '\treason: ' + err);
                Dialog.show('矮油', '等等，我们这有点忙~~');
            };
            $$.ajax({
                url: this.tradeInfosUrl,
                data: 'udid=' + udid,
                type: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded'},
                success: function (res) {
                    try {
                        NSLog('[getduihuaninfos] res:' + res);
                        var data = JSON.parse(res);
                        if (data.result == 0) {
                            displayScore(data.playerGold);
                            success(data.duihuaninfos);
                        } else {
                            error(data.result, data.reason, data);
                        }
                    } catch (e) {
                        error(-1, e.message, e);
                    }
                },
                error: function (res) {
                    error(-2, res);
                }
            });
        }
    };
})(window);