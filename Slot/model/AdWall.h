//
//  AdWall.h
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-11-12.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import <Foundation/Foundation.h>
enum adtype{
    domob=0,
    limei,
    youmi,
    dianru,
    middi,
    adwo,
    adtype_num
};


@interface AdWall : NSObject
@property(nonatomic) int inReview;
@property(strong,nonatomic)NSMutableArray *adInfoArray;
+ (instancetype)getInstance;
- (void)initWall;
@end
