//
//  DMOfferWallManagerDelegate.h
//  DomobOfferWallSDK
//
//  Created by wangxijin on 13-11-12.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import <Foundation/Foundation.h>

// 消费结果状态码
typedef enum {
    // 消费成功
    // Consume Successfully
    DMOfferWallConsumeStatusCodeSuccess = 1,
    // 剩余积分不足
    // Not enough point
    DMOfferWallConsumeStatusCodeInsufficient,
    // 订单重复
    // Duplicate consume order
    DMOfferWallConsumeStatusCodeDuplicateOrder
} DMOfferWallConsumeStatusCode;

@protocol DMOfferWallManagerDelegate <NSObject>

#pragma mark Point Check Callbacks
// 积分查询成功之后，回调该接口，获取总积分和总已消费积分。
// Called when finished to do point check.
- (void)offerWallDidFinishCheckPointWithTotalPoint:(NSInteger)totalPoint
                             andTotalConsumedPoint:(NSInteger)consumed;
// 积分查询失败之后，回调该接口，返回查询失败的错误原因。
// Called when failed to do point check.
- (void)offerWallDidFailCheckPointWithError:(NSError *)error;
#pragma mark Consume Callbacks
// 消费请求正常应答后，回调该接口，并返回消费状态（成功或余额不足），以及总积分和总已消费积分。
- (void)offerWallDidFinishConsumePointWithStatusCode:(DMOfferWallConsumeStatusCode)statusCode
                                          totalPoint:(NSInteger)totalPoint
                                  totalConsumedPoint:(NSInteger)consumed;
// 消费请求异常应答后，回调该接口，并返回异常的错误原因。
// Called when failed to do consume request.
- (void)offerWallDidFailConsumePointWithError:(NSError *)error;

#pragma mark CheckOfferWall Enable Callbacks
// 获取积分墙可用状态的回调。
// Called after get OfferWall enable state.
- (void)offerWallDidCheckEnableState:(BOOL)enable;

@end
