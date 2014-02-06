//
//  DianruViewController.h
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-11-13.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import "AdWallViewController.h"
#import  "DianRuAdWall.h"
#import "ParentViewDelegate.h"
#import "AdWallDelegate.h"
@interface DianruViewController : AdWallViewController <DianRuAdWallDelegate>
-(id)initWithParams:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil udid:(NSString *)udid;
@property(weak,nonatomic) id<ParentViewDelegate> parentViewdelegate;
@property(weak,nonatomic) id<AdWallDelegate> adWallDelegate;
@property(nonatomic)int spendGold;
@property(nonatomic)int viewDidLoaded;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
@end
