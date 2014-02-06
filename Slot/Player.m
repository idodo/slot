//
//  Player.m
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-11-2.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//

#import "Player.h"
#import "HttpClient.h"
@implementation Player

static Player *_sharedInstance = nil;
static dispatch_once_t onceToken;
+(instancetype)getInstance{
dispatch_once(&onceToken, ^{
    _sharedInstance =[Player alloc];
   // _sharedInstance.gold = [NSNumber numberWithInt:(int)0];
    
});
return _sharedInstance;
}

-(void)getPlayerGold{
    NSDictionary *params =  @{@"udid": _udid};
    [[HttpClient sharedClient] GET:@"player/getgold" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary*)responseObject;
        NSNumber* gold = [result valueForKey:@"gold"];
        _gold = gold.intValue;
        
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error:%@", error);
     }];
    
}
@end
