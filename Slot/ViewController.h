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
#define PUBLISHER_ID @"96ZJ0PsQze86XwTA7A" // online

@interface ViewController : UIViewController<UIWebViewDelegate,immobViewDelegate,DMOfferWallDelegate,DMOfferWallManagerDelegate,DianRuAdWallDelegate> {
    
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
