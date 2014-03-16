//
//  ViewController.m
//  Slot
//
//  Created by fouber on 14-1-24.
//  Copyright (c) 2014年 fouber. All rights reserved.
//

#import "ViewController.h"
#import "HttpClient.h"
#import "OpenUDID.h"
#import "Player.h"
#import "AdWall.h"
#import "DianRuAdWall.h"
#import "DataConfig.h"
#import "AdInfo.h"
#import <AdSupport/ASIdentifierManager.h>
#import "WXApi.h"
#import "AdWall.h"
#import "Player.h"
#import "YouMiConfig.h"
#import "YouMiPointsManager.h"
#import "YouMiWall.h"
#import "SvUDIDTools.h"
#import "AdUtil.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import <Escore/YJFUserMessage.h>
#import <Escore/YJFInitServer.h>
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* openUDID  = [SvUDIDTools UDID];
    NSLog(@"keychain udid:%@", openUDID );
    [Player getInstance].udid = openUDID;
	// Do any additional setup after loading the view, typically from a nib.

    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    _webView = [[UIWebView alloc] initWithFrame:screenFrame];
    self.view = _webView;
    
    
    [_webView setDelegate:self];
    self.firstLoad = 1;
    self.importTimestamp = 0;
    [self checkVersion];
        
        
        //id webDocumentView = [_webView performSelector:@selector(_browserView)];
        //id backingWebView = [webDocumentView performSelector:@selector(webView)];
        //[backingWebView performSelector:@selector(_setWebGLEnabled:) withObject:[NSNumber numberWithBool:YES]];
        
    MarqueeLabel *continuousLabel2 = [[MarqueeLabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 20) rate:100.0f andFadeLength:10.0f];
    continuousLabel2.tag = 101;
    continuousLabel2.marqueeType = MLContinuous;
    continuousLabel2.animationCurve = UIViewAnimationOptionCurveLinear;
    continuousLabel2.continuousMarqueeExtraBuffer = 50.0f;
    continuousLabel2.numberOfLines = 1;
    continuousLabel2.opaque = NO;
    continuousLabel2.enabled = YES;
    continuousLabel2.shadowOffset = CGSizeMake(0.0, -1.0);
    continuousLabel2.textAlignment = NSTextAlignmentLeft;
    continuousLabel2.textColor = [UIColor colorWithRed:0.234 green:0.234 blue:0.234 alpha:1.000];
    continuousLabel2.backgroundColor = [UIColor clearColor];
    continuousLabel2.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.000];
    continuousLabel2.text = @"This is another long label that scrolls continuously with a custom space between labels! You can also tap it to pause and unpause it!";
    
    [self.view addSubview:continuousLabel2];
    
}


-(void)updateScore
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if( [DataConfig getInstance].showBannerAd == 1){
        
        [self.adBanner loadRequest:[self request]];
    }
    
    
}
-(void)initBridge{
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback){
        //NSLog(@"ObjC received message from JS: %@", data);
        //responseCallback(@"Response for message from ObjC");
    }];
    
    [_bridge registerHandler:@"alert" handler:^(id message, WVJBResponseCallback responseCallback) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:nil
                              message: message
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }];
    
    [_bridge registerHandler:@"log" handler:^(id message, WVJBResponseCallback responseCallback) {
        NSLog(@"%@", message);
    }];
    
    [_bridge registerHandler:@"startLoading" handler:^(id message, WVJBResponseCallback responseCallback) {
        [_loading startAnimating];
    }];
    
    [_bridge registerHandler:@"stopLoading" handler:^(id message, WVJBResponseCallback responseCallback) {
        [_loading stopAnimating];
    }];
    
    [_bridge registerHandler:@"getInitData" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"getPlayerUdid called: %@", data);
        NSDictionary* response = @{@"udid":[Player getInstance].udid, @"inReview" : [NSNumber numberWithInt:[DataConfig getInstance].inReview] ,
                                    @"earnBtnStatus": [NSNumber numberWithInt:[DataConfig getInstance].earnBtnStatus],
                                   @"duihuanBtnStatus": [NSNumber numberWithInt:[DataConfig getInstance].duihuanBtnStatus]};
        responseCallback(response);
    }];
    
    [_bridge registerHandler:@"setCurrentPage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"setCurrentPage called: %@", data);
        self.currentPageName = (NSString*)data;
    }];
    
    [_bridge registerHandler:@"showDMOfferWall" handler:^(id message, WVJBResponseCallback responseCallback) {
        [self.domobAdWallController presentOfferWall];
    }];
    
    
    [_bridge registerHandler:@"showLimeiOfferWall" handler:^(id message, WVJBResponseCallback responseCallback) {
        [self.limeiAdWall immobViewRequest];
        
    }];
    
    [_bridge registerHandler:@"showDianruOfferWall" handler:^(id message, WVJBResponseCallback responseCallback) {
        [DianRuAdWall showAdWall:self];
    }];
    
    [_bridge registerHandler:@"showYoumiOfferWall" handler:^(id message, WVJBResponseCallback responseCallback) {
        [YouMiWall showOffers:YES didShowBlock:^{
            NSLog(@"有米积分墙已显示");
        } didDismissBlock:^{
            NSLog(@"有米积分墙已退出");
        }];
        
    }];
    
    [_bridge registerHandler:@"showMiddiOfferWall" handler:^(id message, WVJBResponseCallback responseCallback) {
        [MiidiAdWall showAppOffers:self withDelegate:self];
    }];
    
    
    [_bridge registerHandler:@"showAdwoOfferWall" handler:^(id message, WVJBResponseCallback responseCallback) {
        [self initAdWoAdWall];
    }];
    
    [_bridge registerHandler:@"showYijifenOfferWall" handler:^(id message, WVJBResponseCallback responseCallback) {
        YJFIntegralWall *integralWall = [[YJFIntegralWall alloc]init];
        integralWall.delegate = self;
        [self presentViewController:integralWall animated:YES completion:nil];
        //[integralWall release];
    }];
    
    
    
    [_bridge registerHandler:@"consumeEarnGold" handler:^(id message, WVJBResponseCallback responseCallback) {
        [self consumeEarnGold];
        
    }];
    
    [_bridge registerHandler:@"weixinShareMoney" handler:^(id message, WVJBResponseCallback responseCallback) {
        [self weixinShareMoney];
    }];
    
    [_bridge registerHandler:@"weixinShareAppCircle" handler:^(id message, WVJBResponseCallback responseCallback) {
        [self weixinShareAppCircle];
    }];
    
    [_bridge registerHandler:@"weixinShareApp" handler:^(id message, WVJBResponseCallback responseCallback) {
        [self weixinShareApp];
    }];
    
    [_bridge registerHandler:@"weixinShareMoneyCircle" handler:^(id message, WVJBResponseCallback responseCallback) {
        [self weixinShareMoneyCircle];
    }];
    
    [_bridge registerHandler:@"updateScore" handler:^(id message, WVJBResponseCallback responseCallback) {
        [self updateScore];
    }];
    
    [_bridge registerHandler:@"fiveStarReview" handler:^(id message, WVJBResponseCallback responseCallback) {
        [self fiveStarReview];
    }];
}

-(void) loadHtmlIndex
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    if ([path length]) {
        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [_webView setUserInteractionEnabled:YES];
        [_webView setOpaque:NO];
        [_webView setDataDetectorTypes:UIDataDetectorTypeNone];
        [_webView loadHTMLString:html baseURL:baseURL];
        
        _webView.scrollView.bounces = NO;
        UIScrollView *scrollView = (UIScrollView *)[[_webView subviews] objectAtIndex:0];
        scrollView.bounces = NO;
        
        //add loading
        _loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _loading.backgroundColor = [UIColor whiteColor];
        _loading.alpha = 0.5;
        _loading.layer.cornerRadius = 6;
        _loading.layer.masksToBounds = YES;
        [_loading setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
        [self.view addSubview:_loading];
        
        [_bridge send:@"A string sent from ObjC after Webview has loaded."];
        
        //[_bridge callHandler:@"initConfig" data:@{ @"udid": [Player getInstance].udid, @"inReview" : [NSNumber numberWithInt:[DataConfig getInstance].inReview] }];
        
        
    }
}
-(void)appBecomeActive{
    if( self.firstLoad == 0 ){
        [_bridge callHandler:@"appBecomeActive" data:Nil];
    }
    
}
-(void)reloadCheck{
    if( self.firstLoad == 0){
        NSDictionary* parameters = @{ @"impartTimestamp" : [NSNumber numberWithLongLong:self.importTimestamp], @"udid": [Player getInstance].udid, @"channelCode": [DataConfig getChannelCode]};
        [[HttpClient sharedClient] GET:@"player/reloadcheck" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSDictionary *result = (NSDictionary*)responseObject;
            NSLog(@"[check version] result:%@", result);
            //parse basic config info
            
            int reload = [[ result valueForKey:@"reload" ] intValue];
            if( reload == 1 ){
                self.alertType = RELOAD;
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:nil
                                      message: @"亲，有新的更新，游戏需要重新启动加载下~"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }
            int newVersion = [[ result valueForKey:@"hasNewversion" ] intValue];
            if( newVersion == 1){
                self.alertType = NEW_VERSION;
                self.versionLink = [ result valueForKey:@"newVersionLink" ];
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:nil
                                      message: @"亲，有新的版本了，请下载新的版本~"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }
        
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error:%@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载数据失败，请关闭程序重试" message:@"网络连接异常" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        if( self.alertType == RELOAD){
            exit(0);
        }else if( self.alertType == NEW_VERSION ){
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:self.versionLink]];
        }
    }
}
-(void)checkVersion{
    
    //NSString *idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //NSLog(@"idfa:%@", idfaString);
    //这里使用keychain存储udid
   

    NSNumber *majorVersion =[[NSNumber alloc] initWithInt:[DataConfig getMajorVersion]];
    NSNumber *minorVersion = [[NSNumber alloc] initWithInt:[DataConfig getMinorVersion]];
    NSDictionary *parameters = @{@"udid": [Player getInstance].udid, @"majorVersion" : majorVersion, @"minorVersion": minorVersion,
                                 @"channelCode" : [DataConfig getChannelCode]};
    
    
    [[HttpClient sharedClient] GET:@"player/checkversion" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *result = (NSDictionary*)responseObject;
        NSLog(@"[check version] result:%@", result);
        //parse basic config info
        NSNumber* inReview = [ result valueForKey:@"inReview" ];
        NSNumber* showBannerAd = [ result valueForKey:@"showBannerAd"];
        NSString* ituneAppId = [ result valueForKey:@"ituneAppId" ];
        NSNumber* impartTS = [ result valueForKey:@"impartTimestamp"];
        self.importTimestamp = [impartTS longLongValue];
        [AdWall getInstance];
        [[DataConfig getInstance] setInReview: inReview.intValue ];
        [[DataConfig getInstance] setShowBannerAd: showBannerAd.intValue ];
        [[DataConfig getInstance] setItuneAppId: ituneAppId ];
        NSDictionary* btnStatusDic = [ result valueForKey:@"btnStatus"];
        [DataConfig getInstance].earnBtnStatus = [[ btnStatusDic valueForKey:@"earnBtn"] intValue];
        [DataConfig getInstance].duihuanBtnStatus = [[ btnStatusDic valueForKey:@"duihuanBtn"] intValue];
        //parse ad config
        NSArray* adInfos = [ result valueForKey:@"adInfos"];
        for(id jadInfo in adInfos){
            
            if( self.firstLoad == 1){
                AdInfo* adInfo = [AdInfo alloc];
                int adType = [[jadInfo valueForKey:@"idx"] intValue];
                adInfo.idx = adType;
                NSString* adName = [jadInfo valueForKey:@"name"];
                adInfo.name = adName;
                int adStatus = [[jadInfo valueForKey:@"status"] intValue];
                adInfo.status = adStatus;
                [[AdWall getInstance].adInfoArray insertObject:adInfo atIndex:adInfo.idx];
            }else{
                AdInfo* adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:adInfo.idx];
                adInfo.status = [[jadInfo valueForKey:@"status"] intValue];
            }
        }
        [[AdWall getInstance] initWall];
        int minMoneyRatio = [[ result valueForKey:@"minMoneyRatio"] intValue];
        [DataConfig getInstance].appWebLink = [result valueForKey:@"appWebLink"];
        [DataConfig getInstance].minMoneyRatio = minMoneyRatio;
        NSDictionary* player = [ result valueForKey:@"playerInfo"];
        [Player getInstance].todayGold = [[ player valueForKey:@"todayEarnGold"] intValue];
        [Player getInstance].gold = [[ player valueForKey:@"gold"] intValue];
        if( self.firstLoad == 1){
            NSLog(@"[checkversion] 第一次加载游戏，加载主界面");
            //初始化积分墙
            [self initAdWall];
            //加载Bridge
            [self initBridge];
            //加载html主届面
            [self loadHtmlIndex];
            self.firstLoad = 0;
            
        }else{
             NSLog(@"[checkversion] 不是第一次加载游戏");
             
        }
        //苹果审核要求引用了广告sdk的应用需要显示出广告，为了过苹果审核，请求admob的banner广告
        //[self showDomobBannerAd];
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error:%@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载数据失败，请关闭程序重试" message:@"网络连接异常" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                               [alert show];
    }];

}
-(void)initAdWall{
    //init adwall
    if( [DataConfig getInstance].inReview == 0){
        AdInfo* adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:domob];
        if( adInfo.status == 1 ){
            _domobAdWallController = [[DMOfferWallViewController alloc] initWithPublisherID:[DataConfig getDomobCustomerId] andUserID:[Player getInstance].udid];
            _domobAdWallManager = [[DMOfferWallManager alloc] initWithPublishId:[DataConfig getDomobCustomerId] userId:[Player getInstance].udid];
            _domobAdWallManager.delegate = self;
        }
        
        adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:limei];
        if( adInfo.status == 1 ){
            NSLog(@"[limei]init adwall");
            _limeiAdWall=[[immobView alloc] initWithAdUnitID:[DataConfig getLimeiCustomerId]];
            _limeiAdWall.delegate=self;
            [_limeiAdWall.UserAttribute setObject:[Player getInstance].udid forKey:@"accountname"];
        }
        adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:dianru];
        if( adInfo.status == 1 ){
            [DianRuAdWall beforehandAdWallWithDianRuAppKey:[DataConfig getDianruCustomerId]];
            [DianRuAdWall initAdWallWithDianRuAdWallDelegate:self];
        }
        adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:youmi];
        if( adInfo.status == 1 ){
            NSLog(@"[youmi]init adwall");
            [YouMiConfig launchWithAppID:[DataConfig getYoumiCustomerId] appSecret:[DataConfig getYoumiCustomerPwd]];
            // 开启积分管理[本例子使用自动管理];
            [YouMiPointsManager enable];
            // 开启积分墙
            [YouMiWall enable];
            [YouMiConfig setFullScreenWindow:self.view.window];
        }
        adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:middi];
        if( adInfo.status == 1 ){
            NSLog(@"[middi]init adwall");
            [MiidiManager setAppPublisher:@"16867" withAppSecret:@"uff8905vy2ytuyde" withTestMode:NO];
        }
        adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:yijifen];
        if( adInfo.status == 1 ){
            NSLog(@"[yijifen]init yijifen");
            //开发者
            YJFUserMessage *user = [[YJFUserMessage alloc]init];
            [user setAppId:@"50326"];//应用ID
            [user setDevId:@"59842"];//开发者ID
            [user setAppKey:@"EM94S2R8E2N5X4MIT179I5CS9C6M86TOA7"];//appKey
            [user setChannel:@"IOS1.2.3"];//渠道号，默认当前SDK版本号
            //[user release];
            //初始化
            YJFInitServer *InitData  = [[YJFInitServer alloc]init];
            [InitData  getInitEscoreData];
            //[InitData  release];

        }
    }
    //init move gold flags for comsumeEarnGold
    _moveFlags = [NSMutableArray arrayWithCapacity:(adtype_num)];
    for(NSInteger i=0 ; i< adtype_num; i++){
        [_moveFlags addObject:[NSNumber numberWithInteger:0]];
    }
    
    CGPoint origin = CGPointMake(0.0, 0.0 );
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID before compiling.
    self.adBanner.adUnitID = @"a15305f2b2c2092";
    self.adBanner.delegate = self;
    self.adBanner.rootViewController = self;
    [self.view addSubview:self.adBanner];
    
    if( [DataConfig getInstance].showBannerAd == 1){
        [self.adBanner loadRequest:self.request];
    }


}
-(void)fiveStarReview{
    //NSString *appId = @"558444165";
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    NSString *link;
    if( version < 7.0 ){
        link  =  [[NSString alloc] initWithFormat: @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software", [DataConfig getInstance].ituneAppId];
    }else{
        link = [@"itms-apps://itunes.apple.com/app/id" stringByAppendingString:[DataConfig getInstance].ituneAppId];
    }
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:link]];
}
-(void)consumeEarnGold{
    if( [DataConfig getInstance].inReview == 0){
        for(int i=0; i  < [_moveFlags count]; i++ ){
            [_moveFlags replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
        }
        //self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //self.hud.mode = MBProgressHUDModeAnnularDeterminate;
        self.hud.labelText = @"Loading";
        self.hud.removeFromSuperViewOnHide = YES;
        AdInfo* adInfo = NULL;
        adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:domob];
        //消耗多盟平台上的金币
        if( adInfo.status == 1){
            NSLog(@"[domob] begin move gold");
            [_domobAdWallManager requestOnlinePointCheck];
        }
        
        adInfo = [[AdWall getInstance].adInfoArray  objectAtIndex:limei];
        if( adInfo.status == 1){
            NSLog(@"[limei] begin move gold");
            [_limeiAdWall immobViewQueryScoreWithAdUnitID:[DataConfig getLimeiCustomerId] WithAccountID:[Player getInstance].udid];
            
        }
        adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:dianru];
        if( adInfo.status == 1){
            NSLog(@"[dianru] begin move gold");
            [DianRuAdWall getRemainPoint];
            
        }
        adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:middi];
        if( adInfo.status == 1){
            NSLog(@"[middi] begin move gold");
            [MiidiAdWall requestGetPoints:self];
        }
        
        adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:adwo];
        if( adInfo.status == 1){
            NSLog(@"[adwo] begin move gold");
            NSInteger currPoints = 0;
            
            // 通过传0来查询剩余虚拟货币
            if(AdwoOWConsumePoints(0, &currPoints)){
                NSLog(@"[adwo] Current points: %d", currPoints);
                if( currPoints > 0 ){
                    if(AdwoOWConsumePoints(currPoints, NULL)){
                        [self onConsumeGold:currPoints adtype:adwo];
                    }else{
                        NSLog(@"Consume points failed, because %@", AdWoErrCodeList[AdwoOWFetchLatestErrorCode()]);
                        [self onConsumeGold:0 adtype:adwo];
                    }
                }else{
                    [self onConsumeGold:0 adtype:adwo];
                }
            }
            else{
                NSLog(@"[adwo] Fetch current points failed, because %@", AdWoErrCodeList[AdwoOWFetchLatestErrorCode()]);
                [self onConsumeGold:0 adtype:adwo];
            }
        }
        adInfo = [[AdWall getInstance].adInfoArray  objectAtIndex:youmi];
        if( adInfo.status == 1){
            NSLog(@"[youmi] begin move gold");
            //[[[AdWall getInstance] youmiController] moveGold];
            NSInteger score = [YouMiPointsManager pointsRemained];
            if( score > 0 ){
                if([YouMiPointsManager spendPoints:score] ){
                    [self onConsumeGold:score adtype:youmi];
                }
            }else{
                [self onConsumeGold:score adtype:youmi];
            }
        }
        adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:yijifen];
        if( adInfo.status == 1){
             NSString * str = [YJFScore getScore];
            int succ = [YJFScore consumptionScore:[str intValue]]; //[yjfScore consumptionScore:_sc] 返回1 表示成功消耗  0 失败
            if (succ == 1) {
                NSString * str = [YJFScore getScore];
                if (str) {
                    NSLog(@"[yijifen] 消耗积分成功 %@", str);
                    int score = [str intValue];
                    [self onConsumeGold:score adtype:yijifen];
                }
            }
            else
            {
                NSLog(@"[yijifen] 消耗积分失败");
                [self onConsumeGold:0 adtype:yijifen];
            }
        }
                  
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidFinishLoad");
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidStartLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


//-------------limei adwall callback begin-----------------------
#pragma mark limei  Callbacks
- (void) immobViewQueryScore:(NSUInteger)score WithMessage:(NSString *)message{
    NSLog(@"[limei] query gold result:%@, score:%d", message, score);
    if( [message isEqualToString:@""] && score > 0 ){
        _limeiSpendGold = score;
        [self.limeiAdWall immobViewReduceScore:score WithAdUnitID:[DataConfig getLimeiCustomerId] WithAccountID:[Player getInstance].udid];
        
        
    }else{
        [self onConsumeGold:0 adtype:limei];
    }
    
}

/**
 *减少积分接口回调
 */
- (void) immobViewReduceScore:(BOOL)status WithMessage:(NSString *)message{
    
    if(status){
        NSLog(@"[limei] request to consume gold:%d", _limeiSpendGold );
        [self onConsumeGold:_limeiSpendGold adtype:limei];
    }else{
        NSLog(@"[limei] failed to request to consume gold,%@", message );
        [self onConsumeGold:0 adtype:limei];
    }
    
}
- (void) onDismissScreen:(immobView *)immobView{
    NSLog(@"onDismissScreen");
}


- (void) immobViewDidReceiveAd:(immobView *)immobView{
    [self.view addSubview:immobView];
    [immobView immobViewDisplay];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight );
    
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotate
{
    return YES;
}

#endif
- (void) onLeaveApplication:(immobView *)immobView{
    NSLog(@"onLeaveApplication");
}
- (UIViewController *)immobViewController{
    
    return self;
}

/********************limei adwall callback end*********************/


/********************domob adwall callback begin*********************/
#pragma mark domob  Callbacks
// 积分墙开始加载数据。
// Offer wall starts to work.
- (void)offerWallDidStartLoad {
    NSLog(@"offerWallDidStartLoad");
}

// 积分墙加载完成。此方法实现中可进行积分墙入口Button显示等操作。
// Load offer wall successfully. You can set your IBOutlet.hidden to NO in this callback.
// This IBOutlet is the one which response to present OfferWall.
- (void)offerWallDidFinishLoad {
    NSLog(@"offerWallDidFinishLoad");
    //[self.view makeToast:@"Offer Wall Loading Finished."];
    //_statusLabel.text = @"空闲";
}

// 积分墙加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。建议在此隐藏积分墙入口Button。
// Failed to load offer wall. You should set THE IBOutlet.hidden to YES in this callback.
- (void)offerWallDidFailLoadWithError:(NSError *)error {
    NSLog(@"offerWallDidFailLoadWithError:%@", error);
    //[self.view makeToast:@"Offer Wall Loading Failed."];
    //_statusLabel.text = @"空闲";
}

-(void)offerWallDidClosed{
    
}


// 积分查询成功之后，回调该接口，获取总积分和总已消费积分。
- (void)offerWallDidFinishCheckPointWithTotalPoint:(NSInteger)totalPoint
                             andTotalConsumedPoint:(NSInteger)consumed {
    NSLog(@"[domob]  request consume gold: %d", totalPoint - consumed );
    _domobSpendGold = totalPoint-consumed;
    if( _domobSpendGold > 0 ){
        [_domobAdWallManager requestOnlineConsumeWithPoint:_domobSpendGold];
    }else{
        [self onConsumeGold:0 adtype:domob];
    }
    
    
}

// 积分查询失败之后，回调该接口，返回查询失败的错误原因。
- (void)offerWallDidFailCheckPointWithError:(NSError *)error {
    NSLog(@"offerWallDidFailCheckPointWithError:%@", error);
    //    _statusLabel.text = @"空闲";
    [self onConsumeGold:0 adtype:domob];
}


// 消费请求正常应答后，回调该接口，并返回消费状态（成功或余额不足），以及总积分和总已消费积分。
- (void)offerWallDidFinishConsumePointWithStatusCode:(DMOfferWallConsumeStatusCode)statusCode
                                          totalPoint:(NSInteger)totalPoint
                                  totalConsumedPoint:(NSInteger)consumed {
    NSLog(@"offerWallDidFinishConsumePoint");
    switch (statusCode) {
        case DMOfferWallConsumeStatusCodeSuccess:
            [self onConsumeGold: _domobSpendGold adtype:domob];
            break;
        case DMOfferWallConsumeStatusCodeInsufficient:
            [self onConsumeGold:0 adtype:domob];
            break;
        default:
            break;
    }
    
}

// 消费请求异常应答后，回调该接口，并返回异常的错误原因。
- (void)offerWallDidFailConsumePointWithError:(NSError *)error {
    NSLog(@"offerWallDidFailConsumePointWithError:%@", error);
    //_statusLabel.text = @"空闲";
}
//

/********************domob adwall callback end*********************/
/********************dianru adwall callback begin******************/
#pragma mark dianru  Callbacks
/*
 用于消费积分结果的回调
 */
-(void)didReceiveSpendScoreResult:(BOOL)isSuccess{
    if(isSuccess == TRUE){
        NSLog(@"[dianru] consume point success, request consume gold: %d", _dianruSpendGold );
        [self onConsumeGold:_dianruSpendGold adtype:dianru];
    }else{
        NSLog(@"[dianru] consume point failed, request consume gold: %d", _dianruSpendGold );
        [self onConsumeGold:0 adtype:dianru];
    }
}

/*
 用于获取剩余积分结果的回调
 */
-(void)didReceiveGetScoreResult:(int)point{
    NSLog(@"[dianru] query point , result %d", point );
    if( point > 0 ){
        _dianruSpendGold = point;
        [DianRuAdWall spendPoint: point];
        
    }else{
        NSLog(@"[dianru] query point failed, result %d", point );
        [self onConsumeGold:0 adtype:dianru];
    }
}
/********************dianru adwall callback end*********************/
/********************middi adwall callback begin********************/
#pragma mark middi  Callbacks

- (void)didReceiveOffers{
}

// 请求应用列表失败
//
// 详解:
//      广告墙请求失败后回调该方法
// 补充:

//
- (void)didFailToReceiveOffers:(NSError *)error{
}


// 显示全屏页面
//
// 详解:
//      全屏页面显示完成后回调该方法
- (void)didShowWallView{
}

// 隐藏全屏页面
//
// 详解:
//      全屏页面隐藏完成后回调该方法
// 补充:
- (void)didDismissWallView{
}



- (void)didReceiveSpendPoints:(NSInteger)totalPoints{
	NSLog(@"[middi] didReceiveSpendPoints success! totalPoints=%d",totalPoints);
	[self onConsumeGold:self.middiSpendGold adtype:middi];
	
	
}


- (void)didFailReceiveSpendPoints:(NSError *)error{
	NSLog(@"[middi] didFailReceiveSpendPoints failed!");
    [self onConsumeGold:0 adtype:middi];
}




- (void)didReceiveAwardPoints:(NSInteger)totalPoints{
	NSLog(@"[middi] didReceiveAwardPoints success! totalPoints=%d",totalPoints);
	
	
}

- (void)didFailReceiveAwardPoints:(NSError *)error{
	NSLog(@"[middi] didFailReceiveAwardPoints failed!");
}



- (void)didReceiveGetPoints:(NSInteger)totalPoints forPointName:(NSString*)pointName{
	NSLog(@"[middi] didReceiveGetPoints success! totalPoints:%d",totalPoints);
    self.middiSpendGold = totalPoints;
    if( totalPoints > 0 ){
        [MiidiAdWall requestSpendPoints:totalPoints withDelegate:self];
    }else{
        [self onConsumeGold:0 adtype:middi];
    }
	
}


- (void)didFailReceiveGetPoints:(NSError *)error{
	NSLog(@"[middi] didFailReceiveGetPoints failed!");
	[self onConsumeGold:0 adtype:middi];
	
	
}

// 成功请求积分墙开关
//
// 详解:当接收服务器返回积分墙开关成功后调用该函数
// 补充：toggle: 返回积分墙是否开启
- (void)didReceiveToggle:(BOOL)toggle
{
    NSLog(@"[middi] didReceiveToggle success! toggle:%d",toggle);
    
}

// 请求积分墙开关失败后调用
//
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：
- (void)didFailReceiveToggle:(NSError *)error
{
    NSLog(@"[middi] didFailReceiveToggle failed!");
}
#pragma mark  end
/********************middi adwall callback end**********************/
/********************adwo adwall callback begin********************/
#pragma mark adwo  Callbacks
-(void)initAdWoAdWall{
    // 注册登录事件消息
    AdwoOWRegisterResponseEvent(ADWO_OFFER_WALL_RESPONSE_EVENTS_WALL_PRESENT, self, @selector(loginSelector));
    
    // 注册积分墙被关闭事件消息
    AdwoOWRegisterResponseEvent(ADWO_OFFER_WALL_RESPONSE_EVENTS_WALL_DISMISS, self, @selector(dismissSelector));
    
    // 初始化并登录积分墙
    BOOL result = AdwoOWPresentOfferWall([DataConfig getAdWoCustomerId], self);
    if(!result)
    {
        enum ADWO_OFFER_WALL_ERRORCODE errCode = AdwoOWFetchLatestErrorCode();
        NSLog(@"[adwo] Initialization error, because %@", AdWoErrCodeList[errCode]);
    }
    else
        NSLog(@"[adwo] Initialization successfully!");
}

- (void)loginSelector
{
    enum ADWO_OFFER_WALL_ERRORCODE errCode = AdwoOWFetchLatestErrorCode();
    if(errCode == ADWO_OFFER_WALL_ERRORCODE_SUCCESS)
        NSLog(@"[adwo] Login successfully!");
    else
        NSLog(@"[adwo] Login failed, because %@", AdWoErrCodeList[errCode]);
}

- (void)dismissSelector
{
    NSLog(@"[adwo] I know, the wall is dismissed!");
}
#pragma mark  end

/********************adwo adwall callback end********************/
/********************yijifen callback begin********************/
#pragma mark -

#pragma mark YiJiFen delegate

#pragma mark end
/********************domob banner ad callback end********************/
/********************weixin callback begin***************************/
#pragma mark wexin callback
/**
 *分享app到微信朋友圈
 */
- (void)weixinShareAppCircle{
    NSDate* now = [NSDate date];
    if( [AdUtil isSameDay:[Player getInstance].wxAppCircleSharedDate date2:now ]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: nil
                              message: @"亲，今天已经分享过了哦，分享些别的吧，要不明天继续!"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"这APP用零散时间能挣到不少钱哦";
    message.description = @"把你的赚钱小密码告诉朋友们吧。";
    [message setThumbImage:[UIImage imageNamed:@"icon@2x.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [DataConfig getInstance].appWebLink;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [Player getInstance].shareType = app_friend_circle;
    [WXApi sendReq:req];

}
/**
 *分享收入到微信朋友
 */
- (void)weixinShareMoney{
    NSDate* now = [NSDate date];
    if( [AdUtil isSameDay:[Player getInstance].wxMoneySharedDate date2:now ]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: nil
                              message: @"亲，今天已经分享过了哦，分享些别的吧，要不明天继续!"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    float money = [Player getInstance].todayGold / [DataConfig getInstance].minMoneyRatio;
    if(money <= 1){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: nil
                              message: @"分享的收入至少大于1元，再努力赚点吧!"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [NSString stringWithFormat:@"今天我通过这个App赚到%d金币，可以兑换%f元。", [Player getInstance].todayGold, money] ;
    message.description = @"把你的赚钱小密码告诉朋友们吧。";
    [message setThumbImage:[UIImage imageNamed:@"icon@2x.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [DataConfig getInstance].appWebLink;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [Player getInstance].shareType = money_friend;
    [WXApi sendReq:req];
}
/**
 *分享收入到朋友圈
 */
- (void)weixinShareMoneyCircle{
    
    NSDate* now = [NSDate date];
    if( [AdUtil isSameDay:[Player getInstance].wxMoneyCircleSharedDate date2:now ]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: nil
                              message: @"亲，今天已经分享过了哦，分享些别的吧，要不明天继续!"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    float money = [Player getInstance].todayGold / [DataConfig getInstance].minMoneyRatio;
    if(money <= 1){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: nil
                              message: @"分享的收入至少大于1元，再努力赚点吧!"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [NSString stringWithFormat:@"今天我通过这个App赚到%d金币，可以兑换%f元。", [Player getInstance].todayGold, money] ;
    message.description = @"把你的赚钱小秘密告诉朋友们吧。";
    [message setThumbImage:[UIImage imageNamed:@"icon@2x.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [DataConfig getInstance].appWebLink;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [Player getInstance].shareType = money_friend_circle;
    [WXApi sendReq:req];
}
/**
 *维修分享app到朋友
 */
-(void) weixinShareApp{
    NSDate* now = [NSDate date];
    if( [AdUtil isSameDay:[Player getInstance].wxAppSharedDate date2:now ]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: nil
                              message: @"亲，今天已经分享过了哦，分享些别的吧，要不明天继续!"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"这APP用零散时间能挣到不少钱哦";
    message.description = @"把你的赚钱小秘密告诉朋友们吧。";
    [message setThumbImage:[UIImage imageNamed:@"icon@2x.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [DataConfig getInstance].appWebLink;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [Player getInstance].shareType = app_friend;
    [WXApi sendReq:req];

}



/********************weixin callback end***************************/
/********************admob callback begin**************************/
#pragma mark admob callback
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    request.testDevices = @[
                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                            // the console when the app is launched.
                           // GAD_SIMULATOR_ID
                            ];
    return request;
}



// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}
#pragma mark end
/********************admob callback end ***************************/
#pragma mark adwall cmmmon  Callbacks
- (void)onConsumeGold:(int)gold adtype:(int)adtype
{
    int adNum = 0; //有效的广告平台数
    for( AdInfo* adInfo in [AdWall getInstance].adInfoArray){
        if( adInfo.status == 1){
            adNum += 1;
        }
    }

    NSLog(@"adtype:%d", adtype);
    Player* player = [Player getInstance];
    if( gold > 0 ){
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        // NSTimeInterval is defined as double
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        NSString* md5checksumStr = [NSString stringWithFormat:@"%@|%d|%d|%ld|%@",player.udid, gold, adtype, [timeStampObj longValue], [DataConfig getInstance].httpKey ];
        NSString* md5checksum = [md5checksumStr MD5String];
        NSDictionary *params =  @{@"udid": player.udid, @"gold": [NSNumber numberWithInt:gold], @"adType":[NSNumber numberWithInt:adtype],
                                  @"timestamp":[NSNumber numberWithLong:timeStampObj.longValue], @"checksum":md5checksum};
        
        [[HttpClient sharedClient] GET:@"player/consumegold" parameters:params
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   NSDictionary *result = (NSDictionary*)responseObject;
                                   int res = [[result valueForKey:@"result"] intValue];
                                   if( res == 0 ){
                                       NSNumber* gold = [result valueForKey:@"gold"];
                                       int todayEarnGold = [[result valueForKey:@"todayEarnGold"] intValue];
                                  
                                       player.gold = gold.intValue;
                                       player.todayGold = todayEarnGold;
                                       @synchronized(self){
                                           [_moveFlags replaceObjectAtIndex:adtype withObject:[NSNumber numberWithInt:1]];
                                           int moveNum = 0;
                                           for( int i=0; i< adtype_num; i++){
                                               NSNumber *moveFlag = [_moveFlags objectAtIndex:i];
                                               moveNum = moveFlag.intValue + moveNum;
                                           }
                                           NSLog(@"moveNum:%d", moveNum);
                                           if(moveNum == adNum ){
                                               [_bridge callHandler:@"updateScore" data:@{ @"score": [NSNumber numberWithInt:[Player getInstance].gold] }];
                                               if( self.hud != NULL){
                                                   [self.hud hide:TRUE];
                                                   

                                               }
                                           
                                           }
                                       }
                                   }
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   NSLog(@"error:%@", error);
                                   [_moveFlags replaceObjectAtIndex:adtype withObject:[NSNumber numberWithInt:1]];
                               }];
    }else{
        [_moveFlags replaceObjectAtIndex:adtype withObject:[NSNumber numberWithInt:1]];
        int moveNum = 0;
        for( int i=0; i< adtype_num; i++){
            NSNumber *moveFlag = [_moveFlags objectAtIndex:i];
            moveNum = moveFlag.intValue + moveNum;
        }
        NSLog(@"adType:%d,moveNum:%d,adNum;%d", adtype, moveNum, adNum );
        if(moveNum == adNum ){
            if( self.hud != NULL){
                [self.hud hide:TRUE];
            }
        }
    }
    
}
- (void)dealloc {
    _adBanner.delegate = nil;
}
@end
