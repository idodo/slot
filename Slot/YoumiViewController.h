//
//  YoumiViewController.h
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-11-13.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import "AdWallViewController.h"
#import "YouMiConfig.h"
#import "ParentViewDelegate.h"
#import "AdWallDelegate.h"
@interface YoumiViewController : AdWallViewController
-(id)initWithParams:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil udid:(NSString *)udid;
@property(weak,nonatomic) id<ParentViewDelegate> parentViewdelegate;
@property(weak,nonatomic) id<AdWallDelegate> adWallDelegate;
@end
