//
//  DataConfig.h
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-11-10.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataConfig : NSObject
+ (instancetype)getInstance;
+(NSString*)getDomobCustomerId;
+(NSString*)getYoumiCustomerId;
+(NSString*)getYoumiCustomerPwd;
+(NSString*)getDianruCustomerId;
+(NSString*)getLimeiCustomerId;
+(NSString*)getAdWoCustomerId;
+(int)getMajorVersion;
+(int)getMinorVersion;
+(NSString*)getChannelCode;
+(int)getReviewVersion;
+(NSString*)getAppName;
@property (nonatomic)int minMoneyRatio;
@property (strong,nonatomic)NSString* appWebLink;
@property (strong,nonatomic)NSString* earnDesc;
@property (nonatomic)int showBannerAd;
@property(nonatomic) int inReview;
@property (nonatomic)int earnBtnStatus;
@property (nonatomic)int duihuanBtnStatus;
@property (nonatomic)int topSrollbarStatus;
@property(strong,nonatomic) NSString* ituneAppId;
@property (strong,nonatomic)NSString* httpKey;
@end
