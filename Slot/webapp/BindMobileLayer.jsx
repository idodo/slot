var BindMobileLayer = View.derive({
    lock : false,
    init : function(){
        this.lock = false;
        Hammer($('get-verify-code')).on('tap', this.onGetVerifyCode.bind(this));
        Hammer($('bind-save-btn')).on('tap', this.onBindSave.bind(this));
    },
    onGetVerifyCode : function(){
        if(this.lock) return;
        this.lock = true;
        var self = this;
        var input = $('bind-phone');
        var phone = input.value.trim();
        if(/^1\d{10}$/.test(phone)){
            Player.getVerfiyCode(phone, function(){
                self.lock = false;
                input.disabled = true;
                Dialog.show('提示', '发送成功！您会接到一通电话，请接听并记录您听到的验证码');
//                Director.back();
            }, function(code, msg){
                self.lock = false;
                Dialog.show('保存失败', msg);
            });
        } else {
            Dialog.show('提示', '手机号码格式错误');
        }
    },
    onBindSave : function(){
        var code = $('bind-code').value.trim();
        if(!/^\d+$/.test(code)){
            Dialog.show('提示', '验证码格式错误');
        } else {
            Player.bindMobile(code, function(){
                Director.back();
            });
        }
    }
});