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
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    _webView = [[UIWebView alloc] initWithFrame:screenFrame];
    self.view = _webView;
    
    //_offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:PUBLISHER_ID];
    //_offerWallController.delegate = self;
    
    [_webView setDelegate:self];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    if ([path length]) {
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
        [self initAdwallData];
        [_bridge registerHandler:@"log" handler:^(id message, WVJBResponseCallback responseCallback) {
            NSLog(@"%@", message);
        }];
        
        [_bridge registerHandler:@"startLoading" handler:^(id message, WVJBResponseCallback responseCallback) {
            [_loading startAnimating];
        }];
        
        [_bridge registerHandler:@"stopLoading" handler:^(id message, WVJBResponseCallback responseCallback) {
            [_loading stopAnimating];
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
        
        [_bridge registerHandler:@"consumeEarnGold" handler:^(id message, WVJBResponseCallback responseCallback) {
            [self consumeEarnGold];
            
        }];
        
        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        
        //id webDocumentView = [_webView performSelector:@selector(_browserView)];
        //id backingWebView = [webDocumentView performSelector:@selector(webView)];
        //[backingWebView performSelector:@selector(_setWebGLEnabled:) withObject:[NSNumber numberWithBool:YES]];
        
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
        
        [_bridge callHandler:@"updateUdid" data:@{ @"udid": [Player getInstance].udid }];
        
        
    }
    
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    if( [AdWall getInstance].inReview == 1){
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        {
            _dmAdView.frame = CGRectMake((screenSize.height - _adSize.width) / 2,
                                         _adY,
                                         _dmAdView.frame.size.width,
                                         _dmAdView.frame.size.height);
        }
        else
        {
            _dmAdView.frame = CGRectMake((screenSize.width - _adSize.width) / 2,
                                         _adY,
                                         _dmAdView.frame.size.width,
                                         _dmAdView.frame.size.height);
        }
    }
    
    
}
/**
 *显示多盟的banner广告
 */
-(void)showDomobBannerAd{
    //显示domob的banner广告，苹果审核要求引用了广告sdk的应用需要显示出广告
    if( [AdWall getInstance].inReview == 1){
        // 确定广告尺寸及位置
        //Set the size and origin
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            _adSize = DOMOB_AD_SIZE_320x50;
            if (!([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)) {
                _adY = 0;
            }
            
        }
        else
        {
            _adSize = DOMOB_AD_SIZE_728x90;
            _adX = ([UIScreen mainScreen].bounds.size.width - _adSize.width) / 2;
            _adY = 0;
        }
        _dmAdView = [[DMAdView alloc] initWithPublisherId:@"56OJz1F4uNOdLXWmNI"
                                              placementId:@"16TLmLxlAp0DkNUfva9cvJFi"
                                                     size:_adSize];
        
        // 设置广告视图的位置
        // Set the frame of advertisement view
        _dmAdView.frame = CGRectMake(_adX, _adY, _adSize.width, _adSize.height);
        _dmAdView.delegate = self;
        _dmAdView.rootViewController = self; // set RootViewController
        [self.view addSubview:_dmAdView];
        [_dmAdView loadAd];
    }

}
-(void)consumeEarnGold{
    if( [AdWall getInstance].inReview == 0){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    }
    
    //Player* player = [Player getInstance];
    //[player getPlayerGold];
}


-(void)initAdwallData{
    
    //NSString *idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //NSLog(@"idfa:%@", idfaString);
    //这里使用keychain存储udid
    NSString* openUDID  = [SvUDIDTools UDID];
    NSLog(@"keychain udid:%@", openUDID );
    NSNumber *majorVersion =[[NSNumber alloc] initWithInt:[DataConfig getMajorVersion]];
    NSNumber *minorVersion = [[NSNumber alloc] initWithInt:[DataConfig getMinorVersion]];
    NSDictionary *parameters = @{@"udid": openUDID, @"majorVersion" : majorVersion, @"minorVersion": minorVersion};
    [Player getInstance].udid = openUDID;
    
    
    [[HttpClient sharedClient] GET:@"player/checkversion" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *result = (NSDictionary*)responseObject;
        NSLog(@"[check version] result:%@", result);
        //parse basic config info
        NSNumber* inReview = [ result valueForKey:@"inReview" ];
        [AdWall getInstance];
        [[AdWall getInstance] setInReview: inReview.intValue ];
        
        //parse ad config
        NSArray* adInfos = [ result valueForKey:@"adInfos"];
        for(id jadInfo in adInfos){
            AdInfo* adInfo = [AdInfo alloc];
            int adType = [[jadInfo valueForKey:@"idx"] intValue];
            adInfo.idx = adType;
            NSString* adName = [jadInfo valueForKey:@"name"];
            adInfo.name = adName;
            int adStatus = [[jadInfo valueForKey:@"status"] intValue];
            adInfo.status = adStatus;
            [[AdWall getInstance].adInfoArray insertObject:adInfo atIndex:adInfo.idx];
        }
        [[AdWall getInstance] initWall];
        int minMoneyRatio = [[ result valueForKey:@"minMoneyRatio"] intValue];
        [DataConfig getInstance].appWebLink = [result valueForKey:@"appWebLink"];
        [DataConfig getInstance].minMoneyRatio = minMoneyRatio;
        
        //init adwall
        if( [AdWall getInstance].inReview == 0){
            AdInfo* adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:domob];
            if( adInfo.status == 1 ){
                 _domobAdWallController = [[DMOfferWallViewController alloc] initWithPublisherID:[DataConfig getDomobCustomerId] andUserID:[Player getInstance].udid];
                _domobAdWallManager = [[DMOfferWallManager alloc] initWithPublishId:[DataConfig getDomobCustomerId] userId:[Player getInstance].udid];
                _domobAdWallManager.delegate = self;
            }
            
            adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:limei];
            if( adInfo.status == 1 ){
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
        }
        //init move gold flags for comsumeEarnGold
        _moveFlags = [NSMutableArray arrayWithCapacity:(adtype_num)];
        for(NSInteger i=0 ; i< adtype_num; i++){
            [_moveFlags addObject:[NSNumber numberWithInteger:0]];
        }
        
        
        //init wei xin
        [WXApi registerApp:@"wxf7f8f4e26c1f66d0"];
        
        //苹果审核要求引用了广告sdk的应用需要显示出广告，为了过苹果审核，请求多盟的banner广告
        [self showDomobBannerAd];
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error:%@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载数据失败，请关闭程序重试" message:@"网络连接异常" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                               [alert show];
    }];

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
        _spendGold = score;
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
        NSLog(@"[limei] request to consume gold:%d", _spendGold );
        [self onConsumeGold:_spendGold adtype:limei];
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
    NSLog(@"In the domob offerWallDidFinishCheckPointWithTotalPoint, request consume gold: %d", totalPoint - consumed );
    int leftPoint = totalPoint-consumed;
    if( leftPoint > 0 ){
        [_domobAdWallManager requestOnlineConsumeWithPoint:leftPoint];
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
            [self onConsumeGold:consumed adtype:domob];
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
        NSLog(@"[dianru] consume point success, request consume gold: %d", _spendGold );
        [self onConsumeGold:_spendGold adtype:dianru];
    }else{
        NSLog(@"[dianru] consume point failed, request consume gold: %d", _spendGold );
        [self onConsumeGold:0 adtype:dianru];
    }
}

/*
 用于获取剩余积分结果的回调
 */
-(void)didReceiveGetScoreResult:(int)point{
    NSLog(@"[dianru] query point , result %d", point );
    if( point > 0 ){
        _spendGold = point;
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
	[self onConsumeGold:totalPoints adtype:middi];
	
	
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
    
    //NSArray *arr = [NSArray arrayWithObjects:@"test", nil];
    //AdwoOWSetKeywords(arr);
    
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
/********************domob banner ad callback begin********************/
#pragma mark -
#pragma mark DMAdView delegate

// 成功加载广告后，回调该方法
// This method will be used after load successfully
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] success to load ad.");
}

// 加载广告失败后，回调该方法
// This method will be used after load failed
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error
{
    NSLog(@"[Domob Sample] fail to load ad. %@", error);
}

// 当将要呈现出 Modal View 时，回调该方法。如打开内置浏览器
// When will be showing a Modal View, this method will be called. Such as open built-in browser
- (void)dmWillPresentModalViewFromAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] will present modal view.");
}

// 当呈现的 Modal View 被关闭后，回调该方法。如内置浏览器被关闭。
// When presented Modal View is closed, this method will be called. Such as built-in browser is closed
- (void)dmDidDismissModalViewFromAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] did dismiss modal view.");
}

// 当因用户的操作（如点击下载类广告，需要跳转到Store），需要离开当前应用时，回调该方法
// When the result of the user's actions (such as clicking download class advertising, you need to jump to the Store), need to leave the current application, this method will be called
- (void)dmApplicationWillEnterBackgroundFromAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] will enter background.");
}
#pragma mark end
/********************domob banner ad callback end********************/
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
    // gold = 100;
    if( gold > 0 ){
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        // NSTimeInterval is defined as double
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        NSString* md5checksumStr = [NSString stringWithFormat:@"%@|%d|%d|%ld|%@",player.udid, gold, adtype, [timeStampObj longValue], [DataConfig getAdKey] ];
        NSString* md5checksum = [md5checksumStr MD5String];
        NSDictionary *params =  @{@"udid": player.udid, @"gold": [NSNumber numberWithInt:gold], @"adType":[NSNumber numberWithInt:adtype],
                                  @"timestamp":[NSNumber numberWithLong:timeStampObj.longValue], @"checksum":md5checksum};
        
        [[HttpClient sharedClient] GET:@"player/consumegold" parameters:params
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   NSDictionary *result = (NSDictionary*)responseObject;
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
                                           if( self.hud != NULL){
                                               [self.hud hide:TRUE];
                                               //self.hud = nil;
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
                //self.hud = NULL;
            }
        }
    }
    
}

@end
