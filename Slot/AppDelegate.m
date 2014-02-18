//
//  AppDelegate.m
//  Slot
//
//  Created by fouber on 14-1-24.
//  Copyright (c) 2014年 fouber. All rights reserved.
//

#import "AppDelegate.h"
#import "HttpClient.h"
#import "Player.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //init wei xin
    [WXApi registerApp:@"wxf7f8f4e26c1f66d0"];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
}

-(void) onReq:(BaseReq*)req
{
    
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if( resp.errCode == 0 ){
            NSDictionary* parameters = @{@"udid":[Player getInstance].udid, @"shareType":[[NSNumber alloc] initWithInt:[Player getInstance].shareType]};
            [[HttpClient sharedClient] GET:@"player/weixinshare" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *result = (NSDictionary*)responseObject;
                int err_code = [[result valueForKey:@"err_code"] intValue];
                if(err_code == 1){
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: nil
                                          message: @"分享成功，系统发给您获得3金币作为奖励!"
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    int gold = [[result valueForKey:@"gold"] intValue];
                    int todayEarnGold = [[result valueForKey:@"todayEarnGold"] intValue];
                    [Player getInstance].gold = gold;
                    [Player getInstance].todayGold = todayEarnGold;
                    NSDate* now = [NSDate date];
                    switch( [Player getInstance].shareType){
                        case app_friend_circle: { [Player getInstance].wxAppCircleSharedDate = now; break; }
                        case app_friend: { [Player getInstance].wxAppSharedDate = now; break; }
                        case money_friend: { [Player getInstance].wxMoneySharedDate = now; break; }
                        case money_friend_circle: { [Player getInstance].wxMoneyCircleSharedDate = now; break; }
                    }
                    [alert show];
                    
                    return;
                    
                }else if( err_code == 2){
                    NSDate* now = [NSDate date];
                    switch( [Player getInstance].shareType){
                        case app_friend_circle: { [Player getInstance].wxAppCircleSharedDate = now; break; }
                        case app_friend: { [Player getInstance].wxAppSharedDate = now; break; }
                        case money_friend: { [Player getInstance].wxMoneySharedDate = now; break; }
                        case money_friend_circle: { [Player getInstance].wxMoneyCircleSharedDate = now; break; }
                    }
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: nil
                                          message: @"您今天已经分享过了，明天继续哦，亲!"
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
            }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"error:%@", error);
                                   }];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: nil
                                  message: @"分享失败!"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
            
        }
        
    }
}

@end
