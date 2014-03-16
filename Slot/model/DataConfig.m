//
//  DataConfig.m
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-11-10.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import "DataConfig.h"

@implementation DataConfig
static DataConfig *_sharedInstance = nil;
static dispatch_once_t onceToken;
+(instancetype)getInstance
{
    dispatch_once(&onceToken, ^{
        _sharedInstance =[DataConfig alloc];
        _sharedInstance.showBannerAd = 0;
        _sharedInstance.minMoneyRatio = 1000;
        _sharedInstance.inReview = 0;
        _sharedInstance.httpKey = @"19821021isme";
        _sharedInstance.duihuanBtnStatus = 1;
        _sharedInstance.earnBtnStatus = 1;
    });
    return _sharedInstance;
}
static NSString *DOMOB_CUSTOMERID = @"96ZJ0PsQze86XwTA7A";
static NSString *YOUMI_CUSTOMERID = @"e9ad445f2e1d4866";
static NSString *YOUMI_CUSTOMER_PASSWORD = @"8ddf3fae3ca26c18";
static NSString *DIANRU_CUSTOMERID = @"0000171010000055";
static NSString *LIMEI_CUSTOMERID = @"c68025499e648a33826427ef3bf384f9";//@"d2b0c4296dc009ddc00d10da9c4cf83e";////
static NSString *ADWO_CUSTOMERID = @"868cdf4365d645309e528ca958db4aeb";


+(NSString*)getDomobCustomerId{
    return DOMOB_CUSTOMERID;
    
}
+(NSString*)getYoumiCustomerId{
    return YOUMI_CUSTOMERID;
}
+(NSString*)getYoumiCustomerPwd{
    return YOUMI_CUSTOMER_PASSWORD;
}
+(NSString*)getDianruCustomerId{
    return DIANRU_CUSTOMERID;
}
+(NSString*)getLimeiCustomerId{
    return LIMEI_CUSTOMERID;
}
+(NSString*)getAdWoCustomerId{
    return ADWO_CUSTOMERID;
}
+(int)getMajorVersion{
    return 3;
}
+(int)getMinorVersion{
    return 0;
}
+(NSString*)getChannelCode{
    return @"tongbu";
}

@end
