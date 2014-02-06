//
//  Player.h
//  RESideMenuExample
//
//  Created by qiuyonggang on 13-11-2.
//  Copyright (c) 2013年 Roman Efimov. All rights reserved.
//



@interface Player: NSObject
enum weixin_share_type{
    app_friend_circle=0,
    money_friend_circle,
    money_friend,
    app_friend
    
};

+ (instancetype)getInstance;
@property (readwrite, nonatomic) int playerId;
@property (strong, readwrite, nonatomic) NSString* name;
@property (strong, readwrite, nonatomic) NSString* udid;
@property (readwrite, nonatomic) int gold;
@property (strong, readwrite, nonatomic) NSString* qq;
@property (strong, readwrite, nonatomic) NSString* phone;
@property (strong, readwrite, nonatomic) NSString* zhifubao;
@property (readwrite,nonatomic) int shareType;
@property (readwrite,nonatomic) int totalGold;
@property (readwrite,nonatomic) int todayGold;
@property (strong,nonatomic) NSDate* lastEarnDate;
@property (strong,nonatomic) NSDate* wxAppSharedDate;
@property (strong,nonatomic) NSDate* wxAppCircleSharedDate;
@property (strong,nonatomic) NSDate* wxMoneyCircleSharedDate;
@property (strong,nonatomic) NSDate* wxMoneySharedDate;
-(void)getPlayerGold;
@end
