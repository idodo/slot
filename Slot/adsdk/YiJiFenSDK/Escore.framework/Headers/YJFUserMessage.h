//
//  UserMessage.h
//  InsetDemo
//
//  Created by emaryjf on 13-1-25.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <Foundation/Foundation.h>

NSMutableString *yjfUserAppId;
NSMutableString *yjfChannel;
NSMutableString *yjfUserDevId;
NSMutableString *yjfAppKey;
NSMutableString *yjfCoop_info;

@interface YJFUserMessage : NSObject
-(void)setAppId:(NSString *)_appId;
-(void)setChannel:(NSString *)_channel;
-(void)setDevId:(NSString*)_devId;
-(void)setAppKey:(NSString*)_appKey;
-(void)setCoop_info:(NSString*)_coop_info;
@end
