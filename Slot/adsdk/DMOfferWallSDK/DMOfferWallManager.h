//
//  DMOfferWallManager.h
//  DomobOfferWallSDK
//
//  Created by wangxijin on 13-11-22.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMOfferWallManagerDelegate.h"

@interface DMOfferWallManager : NSObject {
    
    id<DMOfferWallManagerDelegate> _delegate;
}

@property(nonatomic,assign)id<DMOfferWallManagerDelegate> delegate;

// 使用Publisher ID初始化DMOfferWallManager
// Create DMOfferWallManager with your own Publisher ID
- (id)initWithPublishId:(NSString *)publishId;

// 使用Publisher ID和应用当前登陆用户的User ID（或其它的在应用中唯一标识用户的ID）初始化DMOfferWallManager
// Create DMOfferWallManager with your own Publisher ID and User ID.
- (id)initWithPublishId:(NSString *)publishId userId:(NSString *)userId;

// 请求在线消费指定积分，成功或失败都会回调Online Usage Callbacks中关于consume的相应方法。
// 请特别注意参数类型为unsigned int，需要消费的积分为非负值。
- (void)requestOnlineConsumeWithPoint:(NSUInteger)pointToConsume;

// 请求在线积分检查，成功或失败都会回调Online Usage Callbacks中关于point check的相应方法。
- (void)requestOnlinePointCheck;

// 判断积分墙是否可用
// get OfferWall enable state.
- (void)checkOfferWallEnableState;
@end