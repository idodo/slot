//
//  HttpClient.h
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-10-30.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface HttpClient : AFHTTPRequestOperationManager
+ (instancetype)sharedClient;
+(void)HTTPGet:(NSString*)url parameters:(NSDictionary *)parameters
       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
