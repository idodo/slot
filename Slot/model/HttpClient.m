//
//  HttpClient.m
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-10-30.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import "HttpClient.h"
#import "DataConfig.h"
//static NSString * const AFAppDotNetAPIBaseURLString = @"http://anansi.vicp.cc:8076/";
static NSString * const AFAppDotNetAPIBaseURLString = @"http://adwall.anansimobile.cn:8982/";
@implementation HttpClient
+ (instancetype)sharedClient {
    static HttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HttpClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        //[_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    });
    
    return _sharedClient;
}
+(void)HTTPGet:(NSString*)url parameters:(NSDictionary *)parameters
       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [dic setValue:[DataConfig getAppName] forKey:@"appName"];
    [dic setValue:[NSNumber numberWithInt:[DataConfig getReviewVersion]] forKey:@"reviewVersion"];
    
    [[HttpClient sharedClient] GET:url parameters:dic success:success failure:failure];
}
@end
