//
//  AdWall.m
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-11-12.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import "AdWall.h"
#import "DomobViewController.h"
#import "YoumiViewController.h"
#import "DianruViewController.h"
#import "LimeiViewController.h"
#import "Player.h"
#import "HttpClient.h"
#import "DianRuAdWall.h"
//#import "XYLoadingView.h"
#import "AdInfo.h"
#import "MBProgressHUD.h"
#import "DataConfig.h"
#import "NSString+MD5.h"
@implementation AdWall
static AdWall *_sharedInstance = nil;
static dispatch_once_t onceToken;
+(instancetype)getInstance
{
    dispatch_once(&onceToken, ^{
        _sharedInstance =[AdWall alloc];
        _sharedInstance.adInfoArray = [[NSMutableArray alloc] init];

    });
    return _sharedInstance;
}

-(void)initWall{
    _moveFlags = [NSMutableArray arrayWithCapacity:(adtype_num)];
    for(NSInteger i=0 ; i< adtype_num; i++){
        [_moveFlags addObject:[NSNumber numberWithInteger:0]];
    }
    AdInfo* adInfo = NULL;
    if( _inReview == 0 ){
    // Player* player = [Player getInstance];
       adInfo = [self.adInfoArray objectAtIndex:domob];
        
//        if(  adInfo.status == 1 ){
//            _sharedInstance.domobController = [[DomobViewController alloc] initWithParams:@"DomobViewController" bundle: nil udid:player.udid];
//            _sharedInstance.domobController.adWallDelegate = _sharedInstance;
//        }
//        adInfo = [self.adInfoArray objectAtIndex:youmi];
//        if( adInfo.status == 1 ){
//            _sharedInstance.youmiController = [[YoumiViewController alloc] initWithParams:@"YoumiViewController" bundle:Nil udid:player.udid];
//            _sharedInstance.youmiController.adWallDelegate = _sharedInstance;
//        }
//        adInfo = [self.adInfoArray objectAtIndex:dianru];
//        if( adInfo.status == 1 ){
//            _sharedInstance.dianruController = [[DianruViewController alloc] initWithParams:@"DianruViewController" bundle:Nil udid:player.udid];
//            _sharedInstance.dianruController.adWallDelegate = _sharedInstance;
//        }
//        adInfo = [self.adInfoArray objectAtIndex:limei];
//        if( adInfo.status == 1 ){
//            _sharedInstance.limeiController = [[LimeiViewController alloc] initWithParams:@"LimeiViewController" bundle:Nil udid:player.udid];
//            _sharedInstance.limeiController.adWallDelegate = _sharedInstance;
//        }
        
    }
}



- (void)onResume{
    if( _inReview == 0){
        [DianRuAdWall dianruOnResume];
    }
}
-(void)onPause{
    if( _inReview == 0){
        [DianRuAdWall dianruOnPause];
    }
}
@end
