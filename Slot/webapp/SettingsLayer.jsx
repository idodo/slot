var SettingsLayer = View.derive({
    lock : false,
    init : function(){
        Hammer($('settings-save-btn')).on('tap', this.onSaveUserInfo.bind(this));
    },
    setUserInfo : function(data){
//        $('uid').innerHTML = data.id;
        $('qq').value = data.qq;
        $('zhifubao').value = data.zhifubao;
        $('phone').value = data.phone;
    },
    invalid : function(val){
        return /[&<>'"]/.test(val);
    },
    onSaveUserInfo : function(){
        var qq = $('qq').value.trim();
        var info = {};
        if(qq){
            if(this.invalid(qq)) {
                Dialog.show('格式错误', 'QQ号写错啦');
                return;
            }
            info.qq = qq;
        }
        var zhifubao = $('zhifubao').value.trim();
        if(zhifubao){
            if(this.invalid(zhifubao)){
                Dialog.show('格式错误', '支付宝账号写错啦');
                return;
            }
            info.zhifubao = zhifubao;
        }
        var phone = $('phone').value.trim();
        if(phone){
            if(!/^\d{11}$/.test(phone)){
                Dialog.show('格式错误', '手机号写错啦');
                return;
            }
            info.phone = phone;
        }
        if(this.lock) return;
        this.lock = true;
        var self = this;
        Player.saveSettings(info, function(){
            self.lock = false;
            Director.show('welcome', -1);
        }, function(code, msg){
            self.lock = false;
            Dialog.show('保存失败', msg);
        });
    }
});