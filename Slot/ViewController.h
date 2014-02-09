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
#import "DMOfferWallViewController.h"
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
@interface ViewController : UIViewController<UIWebViewDelegate,immobViewDelegate,DMOfferWallDelegate,DMOfferWallManagerDelegate,DianRuAdWallDelegate,MiidiAdWallShowAppOffersDelegate
, MiidiAdWallAwardPointsDelegate
, MiidiAdWallSpendPointsDelegate
, MiidiAdWallGetPointsDelegate, MiidiAdWallRequestToggleDelegate> {
    
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet WebViewJavascriptBridge *bridge;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
/**ad wall**/
@property (nonatomic, strong)immobView *limeiAdWall;
@property(strong,nonatomic) DMOfferWallManager *domobAdWallManager;
@property(strong,nonatomic)  DMOfferWallViewController *domobAdWallController;
@property (nonatomic)int spendGold;
@property (strong,nonatomic)MBProgressHUD *hud;
@property(strong, nonatomic)NSMutableArray *moveFlags;

@end
