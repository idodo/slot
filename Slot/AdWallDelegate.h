//
//  AdWallDelegate.h
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-11-12.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AdWallDelegate <NSObject>
@optional
-(void)onConsumeGold:(int)gold adtype:(int)adtype;
@end
