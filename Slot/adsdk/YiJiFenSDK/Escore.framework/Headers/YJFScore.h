//
//  yjfScore.h
//  yjfSDKDemo_beta1
//
//  Created by emaryjf on 13-4-9.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJFScore : NSObject
+(NSString *)getScore;//查询积分
+(int)consumptionScore:(int)_score;//消耗积分
@property (retain) NSMutableData *receivedData;
@end
