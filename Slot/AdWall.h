//
//  AdWall.h
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-11-12.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdWallDelegate.h"
#import "MBProgressHUD.h"
enum adtype{
    domob=0,
    limei,
    youmi,
    dianru,
    adtype_num
};

@class DomobViewController;
@class YoumiViewController;
@class DianruViewController;
@class LimeiViewController;
@interface AdWall : NSObject <AdWallDelegate>
@property(strong,nonatomic) DomobViewController *domobController;
@property(strong,nonatomic) YoumiViewController *youmiController;
@property(strong,nonatomic) DianruViewController *dianruController;
@property(strong,nonatomic) LimeiViewController *limeiController;
@property(nonatomic) int inReview;
@property(strong, nonatomic)NSMutableArray *moveFlags;
@property(strong, nonatomic)UIAlertView *m_alert;
@property(strong,nonatomic)NSMutableArray *adInfoArray;
@property (strong,nonatomic)MBProgressHUD *hud ;
+ (instancetype)getInstance;
- (void)onConsumeGold:(int)gold adtype:(int)adtype;
- (void)moveGold:(UIView*)view;
- (void)initWall;
- (void)onPause;
- (void)onResume;
@end
