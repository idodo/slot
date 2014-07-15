//
//  YouMiSpots.h
//  YouMiSDK
//
//  Created by 陈建峰 on 14-5-20.
//  Copyright (c) 2014年 YouMi Mobile Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YouMiSpots : NSObject
//请求插播数据
+(void)requestSpotData;

//展示开屏插播
+(void)showFullScreenSpots:(void(^)())didMissBlock;

//展示插屏
+(void)showSpots:(void(^)())didMissBlock;
@end
