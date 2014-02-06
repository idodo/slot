//
//  DianruViewController.m
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-11-13.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import "DianruViewController.h"
#import "DataConfig.h"
#import "AdWall.h"
#import "DianRuAdWall.h"
@interface DianruViewController ()

@end

@implementation DianruViewController

-(id)initWithParams:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil udid:(NSString *)udid
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [DianRuAdWall beforehandAdWallWithDianRuAppKey:[DataConfig getDianruCustomerId]];
        [DianRuAdWall initAdWallWithDianRuAdWallDelegate:self];
    }
   
    // self.viewDidLoaded = 0;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    //[DianRuAdWall showAdWall:self];
    //self.viewDidLoaded = 1;
    //[DianRuAdWall initAdWallWithDianRuAdWallDelegate:self];
    //[DianRuAdWall showAdWall:self];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self showWall];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)showWall
{
    
    [DianRuAdWall showAdWall:self];

}

-(void)moveGold{
    [DianRuAdWall getRemainPoint];

    
}

/*
 用于消费积分结果的回调
 */
-(void)didReceiveSpendScoreResult:(BOOL)isSuccess{
    if(isSuccess == TRUE){
        NSLog(@"consume point success, request consume gold: %d", _spendGold );
        [[self adWallDelegate] onConsumeGold:_spendGold adtype:dianru];
    }else{
        NSLog(@"consume point failed, request consume gold: %d", _spendGold );
        [[self adWallDelegate] onConsumeGold:0 adtype:dianru];
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
        [[self adWallDelegate] onConsumeGold:0 adtype:dianru];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dianruAdWallClose
{
    [self.navigationController popViewControllerAnimated:true ];
    if( self.parentViewdelegate != Nil){
        [self.parentViewdelegate onCloseChildView];
    }else{
        NSLog(@"[dianru]parentViewDelegate is null");
    }
    
    NSLog(@"点入积分墙已退出");
}

-(IBAction)onClickShowBtn:(id)sender{
    [self showWall];
}


@end
