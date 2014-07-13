//
//  ViewController.h
//  Slot
//
//  Created by fouber on 14-1-24.
//  Copyright (c) 2014年 fouber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
#import <immobSDK/immobView.h>
#import "DMOfferWallManager.h"
#import "MBProgressHUD.h"
#import "NSString+MD5.h"
#import  "DianRuAdWall.h"
#import <Escore/YJFUserMessage.h> 
#import <Escore/YJFInitServer.h>
#import "MiidiManager.h"
#import "MiidiAdWallShowAppOffersDelegate.h"
#import "MiidiAdWallAwardPointsDelegate.h"
#import "MiidiAdWallSpendPointsDelegate.h"
#import "MiidiAdWallGetPointsDelegate.h"
#import "MiidiAdWallRequestToggleDelegate.h"
#import "MiidiAdWall.h"
#import "AdwoOfferWall.h"
#import "GADBannerViewDelegate.h"
#import <Escore/YJFIntegralWall.h>
#import <Escore/YJFInterstitial.h>
#import <Escore/YJFScore.h>
#import <Escore/YJFAdWall.h>
#import "MarqueeLabel.h"
#import "GuoMobWallViewController.h"
#import "MopanAdWall.h"
#import "WapsOffer/AppConnect.h"
#import "JupengConfig.h"
#import "DianJoySDK.h"
#import "DianJoyOffersWallConstants.h"
//#import "DMAdView.h"
#import "WXApi.h"
@class GADBannerView;
@class GADRequest;
enum ALERT_TYPE{
    RELOAD,
    NEW_VERSION,
    MESSAGE
};
#define PUBLISHER_ID @"96ZJ0PsQze86XwTA7A" // online
static NSString* const AdWoErrCodeList[] = {
    @"successful",
    @"offer wall is disabled",
    @"login connection failed",
    @"offer wall has not been loginned",
    @"offer wall is not initialized",
    @"offer wall has been loginned",
    @"unknown error",
    @"invalid event flag",
    @"app list request failed",
    @"app list response failed",
    @"app list parameter malformatted",
    @"app list is being requested",
    @"offer wall is not ready for show",
    @"keywords malformatted",
    @"current device has not enough space to save resource",
    @"resource malformatted",
    @"resource load failed",
    @"you are have already loginned",
    @"exceed max show count",
    @"exceed max login count",
    @"you have not enough points",
    @"points consumption is not available",
    @"points consumption is negative value",
};
@interface ViewController : UIViewController<UIWebViewDelegate,immobViewDelegate,DMOfferWallManagerDelegate,DianRuAdWallDelegate,MiidiAdWallShowAppOffersDelegate,
 MiidiAdWallAwardPointsDelegate,
 MiidiAdWallSpendPointsDelegate,
 MiidiAdWallGetPointsDelegate,
MiidiAdWallRequestToggleDelegate,
GADBannerViewDelegate,
YJFIntegralWallDelegate,
YJFAdWallDelegate,
GuoMobWallDelegate,
MopanAdWallDelegate,
DianJoySDKDelegate,
//DMAdViewDelegate,
WXApiDelegate> {
  
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet WebViewJavascriptBridge *bridge;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;

/**ad wall**/
@property (nonatomic, strong)immobView *limeiAdWall;
@property (strong,nonatomic) DMOfferWallManager *domobAdWallManager;
@property (strong,nonatomic)  GuoMobWallViewController *guomobWall;
@property (strong,nonatomic) MopanAdWall *mopanWall;
@property (nonatomic)int dianruSpendGold;
@property (nonatomic)int domobSpendGold;
@property (nonatomic)int limeiSpendGold;
@property (nonatomic)int middiSpendGold;
@property (nonatomic)int mopanSpendGold;
@property (nonatomic)int dianjoySpendGold;
@property (nonatomic)int firstLoad; //是否是第一次进入游戏
@property (nonatomic)int alertType; //弹出alert类型，用于alert回调
@property (strong,nonatomic)NSString* versionLink;
@property (strong,nonatomic)NSString* currentPageName;
@property (strong,nonatomic)MBProgressHUD *hud;
@property (strong, nonatomic)NSMutableArray *moveFlags;
@property (nonatomic)long long importTimestamp; //配置载入的时间戳
-(void)consumeEarnGold;
-(void)checkVersion;
-(void)reloadCheck;
-(void)appBecomeActive;
@property(nonatomic, strong) GADBannerView *adBanner;

- (GADRequest *)request;

@end
