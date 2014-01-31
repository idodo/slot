//
//  DMVideoViewController.h
//  DomobOfferWallSDK
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DMVideoViewController;

@protocol DMVideoControllerDelegate <NSObject>
// 开始加载视频广告。
// Offer Video starts to fetch video.
- (void)offerVideoDidStartLoad;
// 积分视频广告加载完成。
// Fetching Offer Video successfully.
- (void)offerVideoDidFinishLoad;
// 积分视频广告加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
// Failed to load Offer Video.
- (void)offerVideoDidFailLoadWithError:(NSError *)error;
// 积分视频广告页面被关闭。
// Offer Video closed.
- (void)offerVideoDidClosed;

@end

@interface DMVideoViewController : UIViewController

@property(nonatomic,assign)id<DMVideoControllerDelegate> delegate;

// 使用Publisher ID初始化视频积分墙ViewController
// Create DMVideoViewController with your own Publisher ID
- (id)initWithPublisherID:(NSString *)publisherID;

// 使用Publisher ID和应用当前登陆用户的User ID（或其它的在应用中唯一标识用户的ID）初始化积分墙ViewController
// Create DMVideoViewController with your own Publisher ID and User ID.
- (id)initWithPublisherID:(NSString *)publisherID andUserID:(NSString *)userID;

// 使用App的rootViewController来弹出并显示视频积分墙。
// Present video offer wall in ModelView way with App's rootViewController.
- (void)presentVideoAdView;

// 使用开发者传入的UIViewController来弹出显示DMVideoViewController。
// Present DMVideoViewController with developer's controller.
- (void)presentVideoAdViewWithController:(UIViewController *)controller;

@end

