//
//  AdWall.m
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-11-12.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import "AdWall.h"
@implementation AdWall
static AdWall *_sharedInstance = nil;
static dispatch_once_t onceToken;
+(instancetype)getInstance
{
    dispatch_once(&onceToken, ^{
        _sharedInstance =[AdWall alloc];
        _sharedInstance.adInfoArray = [[NSMutableArray alloc] initWithCapacity:adtype_num];
        for (unsigned i = 0; i < adtype_num; i++) {
            [_sharedInstance.adInfoArray addObject:[NSNull null]];
        }

    });
    return _sharedInstance;
}

-(void)initWall{

}




@end
