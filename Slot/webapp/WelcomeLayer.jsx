var WelcomeLayer = View.derive({
    init: function () {
        this.setPosition(View.width, 0);
        Hammer($('enter-slot')).on('tap', this.onEnterSlot.bind(this));
        Hammer($('enter-earn')).on('tap', this.onEnterEarn.bind(this));
        Hammer($('enter-settings')).on('tap', this.onEnterSettings.bind(this));
        Hammer($('enter-share')).on('tap', this.onEnterShare.bind(this));
        Hammer($('enter-trade')).on('tap', this.onEnterTrade.bind(this));
        Hammer($('enter-help')).on('tap', this.onEnterHelp.bind(this));
        Sound.init();
    },
    onEnterSlot: function () {
        Player.update(function () {
            Director.show('slot');
        });
    },
    onEnterEarn: function () {
        NSConsumeEarnGold();
        Player.earn(function (earn, status) {
            Director.show('earn').setTradeList(earn, status);
        });
    },
    onEnterSettings: function () {
        Player.update(function (score, data) {
            Director.show('settings').setUserInfo(data.playerInfo);
        });
    },
    onEnterShare: function () {
        Player.shareInfos(function (data) {
            Director.show('share').setShareList(data);
        });
    },
    onEnterTrade: function () {
        Player.tradeInfos(function (data) {
            Director.show('trade').setTradeList(data);
        });
    },
    onEnterHelp: function () {
        Director.show('help');
    },

    setBtnStatus: function (earnBtnStatus, duihuanBtnStatus) {
        if (earnBtnStatus == 0) {
            $('enter-earn').style.display = "none";
        }
        if (duihuanBtnStatus == 0) {
            $('enter-trade').style.display = "none";
        }
    }

});
