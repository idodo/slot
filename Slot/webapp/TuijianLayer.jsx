var TuijianLayer = View.derive({
  lock : false,
    init : function(){
    NSLog("in tuijianLayer init");
    Hammer($('tuijian-save-btn')).on('tap', this.onTuijian.bind(this));
    },
  onTuijian: function(){
    var tuijian_qq = $('tuijian_qq').value.trim();
  var info = {};
    NSLog("tuijian_qq:"+tuijian_qq);
    if(tuijian_qq){
        if(!/^\d+$/.test(tuijian_qq)){
            Dialog.show('格式错误', 'QQ号写错啦');
            return;
        }
        info.qq = tuijian_qq;
    }
    if(this.lock) return;
    this.lock = true;
    var self = this;
    Player.tuijian(info, function(){
        self.lock = false;
        Dialog.show('', '推荐成功！');
      }, function(code, msg){
            self.lock = false;
            Dialog.show('推荐失败', msg);
      }
    );

  }

    
});