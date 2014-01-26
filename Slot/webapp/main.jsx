var SlotApp = cc.Application.extend({
    config: document.ccConfig,
    ctor: function () {
        this._super();
        cc.COCOS2D_DEBUG = this.config['COCOS2D_DEBUG'];
        cc.initDebugSetting();
        cc.setup(this.config['tag']);
        cc.AppController.shareAppController().didFinishLaunchingWithOptions();
    },
    applicationDidFinishLaunching: function () {
        if(cc.RenderDoesnotSupport()){
            //show Information to user
            alert("Browser doesn't support WebGL");
            return false;
        }
        // initialize director
        var director = cc.Director.getInstance();
        var size = director.getWinSize();

        SlotApp.centerX = size.width;
        SlotApp.centerY = size.height;

        cc.MenuItemFont.setFontName('Marker Felt');
        cc.MenuItemFont.setFontSize(resources_map.fontSizeNormal);

        cc.EGLView.getInstance().resizeWithBrowserSize(true);
        cc.EGLView.getInstance().setDesignResolutionSize(size.width * 2, size.height * 2, cc.RESOLUTION_POLICY.SHOW_ALL);

        //director.setContentScaleFactor(2);
        director.setDisplayStats(this.config['showFPS']);
        director.setAnimationInterval(1.0 / this.config['frameRate']);

        //load resources
        cc.LoaderScene.preload(g_resources, function () {
            var scene = cc.Scene.create();
            var layer = new WelcomeLayer();
            layer.init();
            scene.addChild(layer);
            director.replaceScene(cc.TransitionZoomFlipX.create(.5, scene));
        }, this);

        return true;
    }
});

new SlotApp();