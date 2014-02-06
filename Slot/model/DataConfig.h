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
+(int)getMajorVersion;
+(int)getMinorVersion;
+(NSString*)getAdKey;
@property (nonatomic)int minMoneyRatio;
@property (strong,nonatomic)NSString* appWebLink;
@end