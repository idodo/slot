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
@end
