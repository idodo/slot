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
- (void) immobViewDidReceiveAd:(immobView *)immobView{
    [self.view addSubview:immobView];
    [immobView immobViewDisplay];
}


-(void)consumeEarnGold{
    if( [AdWall getInstance].inReview == 0){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //self.hud.mode = MBProgressHUDModeAnnularDeterminate;
        self.hud.labelText = @"Loading";
        self.hud.removeFromSuperViewOnHide = YES;
        AdInfo* adInfo = NULL;
        adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:domob];
        if( adInfo.status == 1){
            NSLog(@"[domob] begin move gold");
            [_domobAdWallManager requestOnlinePointCheck];
        }
        adInfo = [[AdWall getInstance].adInfoArray  objectAtIndex:youmi];
        if( adInfo.status == 1){
            NSLog(@"[youmi] begin move gold");
            //[[[AdWall getInstance] youmiController] moveGold];
             [self onConsumeGold:0 adtype:youmi];
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
    }
    //Player* player = [Player getInstance];
    //[player getPlayerGold];
}
-(void)initAdwallData{
    
    //NSString *idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //NSLog(@"idfa:%@", idfaString);
    NSString* openUDID = [OpenUDID value];
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
        AdInfo* adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:domob];
        if( adInfo.status == 1 ){
             _domobAdWallController = [[DMOfferWallViewController alloc] initWithPublisherID:[DataConfig getDomobCustomerId] andUserID:[Player getInstance].udid];
            _domobAdWallManager = [[DMOfferWallManager alloc] initWithPublishId:[DataConfig getDomobCustomerId] userId:[Player getInstance].udid];
            _domobAdWallManager.delegate = self;
        }
        
        adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:limei];
        if( adInfo.status == 1 ){
            _limeiAdWall=[[immobView alloc] initWithAdUnitID:@"c68025499e648a33826427ef3bf384f9"];
            _limeiAdWall.delegate=self;
        }
        adInfo = [[AdWall getInstance].adInfoArray objectAtIndex:dianru];
        if( adInfo.status == 1 ){
            [DianRuAdWall beforehandAdWallWithDianRuAppKey:[DataConfig getDianruCustomerId]];
            [DianRuAdWall initAdWallWithDianRuAdWallDelegate:self];
        }
        //init move gold flags for comsumeEarnGold
        _moveFlags = [NSMutableArray arrayWithCapacity:(adtype_num)];
        for(NSInteger i=0 ; i< adtype_num; i++){
            [_moveFlags addObject:[NSNumber numberWithInteger:0]];
        }
        
        
        //init wei xin
        [WXApi registerApp:@"wxf7f8f4e26c1f66d0"];
        
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
        NSLog(@"adType:%d,moveNum:%d", adtype, moveNum);
        if(moveNum == adNum ){
            if( self.hud != NULL){
                [self.hud hide:TRUE];
            }
        }
    }
    
}

@end
