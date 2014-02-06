//
//  YoumiViewController.m
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-11-13.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import "YoumiViewController.h"
#import "YouMiConfig.h"
#import "YouMiPointsManager.h"
#import "YouMiWall.h"
#import "DataConfig.h"
#import "AdWall.h"
@interface YoumiViewController ()

@end

@implementation YoumiViewController
-(id)initWithParams:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil udid:(NSString *)udid
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //[YouMiConfig setUserID:udid];
        [YouMiConfig launchWithAppID:[DataConfig getYoumiCustomerId] appSecret:[DataConfig getYoumiCustomerPwd]];
        // 开启积分管理[本例子使用自动管理];
        [YouMiPointsManager enable];
        // 开启积分墙
        [YouMiWall enable];
    }
    return self;
}
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        [YouMiConfig launchWithAppID:@"6191437ca20f2a14" appSecret:@"45e2b6f1f2a6ef2b"];
//        // 开启积分管理[本例子使用自动管理];
//        [YouMiPointsManager enable];
//        // 开启积分墙
//        [YouMiWall enable];
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置显示全屏广告的window
    [YouMiConfig setFullScreenWindow:self.view.window];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showWall
{
    
    [YouMiWall showOffers:YES didShowBlock:^{
        NSLog(@"有米积分墙已显示");
    } didDismissBlock:^{
        [self.navigationController popViewControllerAnimated:true ];
        if( self.parentViewdelegate != Nil){
            [self.parentViewdelegate onCloseChildView];
        }else{
            NSLog(@"parentViewDelegate is null");
        }

        NSLog(@"有米积分墙已退出");
    }];
}

-(void)moveGold{
    NSInteger score = [YouMiPointsManager pointsRemained];
    if( score > 0 ){
        if([YouMiPointsManager spendPoints:score] ){
            [_adWallDelegate onConsumeGold:score adtype:youmi];
        }
    }else{
        [_adWallDelegate onConsumeGold:score adtype:youmi];
    }
    
}

@end
