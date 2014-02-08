//
//  initServer.h
//  yjfSDKDemo_beta1
//
//  Created by nemo on 13-1-27.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *initEscore;
NSString *yjfSid;
@interface YJFInitServer : NSObject<NSURLConnectionDelegate>
-(void) getInitEscoreData;

@end
