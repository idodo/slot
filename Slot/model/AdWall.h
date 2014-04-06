//
//  AdWall.h
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-11-12.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import <Foundation/Foundation.h>
enum adtype{
    domob=0, //多盟
    limei, //力美
    youmi, //有米
    dianru, //点入
    middi, //米迪
    adwo, //安沃
    yijifen, //易积分
    guomob, //果盟
    mopan, //磨盘
    adtype_num
};


@interface AdWall : NSObject
@property(strong,nonatomic)NSMutableArray *adInfoArray;
+ (instancetype)getInstance;
- (void)initWall;
@end
