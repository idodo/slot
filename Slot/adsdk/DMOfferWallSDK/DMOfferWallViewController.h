//
//  DMOfferWallViewController.h
//  DomobOfferWallSDK
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class DMOfferWallViewController;
@protocol DMOfferWallDelegate <NSObject>
// 积分墙开始加载列表数据。
// Offer wall starts to fetch list info.
- (void)offerWallDidStartLoad;
// 积分墙加载完成。
// Fetching offer wall list successfully.
- (void)offerWallDidFinishLoad;
// 积分墙加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
// Failed to load offer wall.
- (void)offerWallDidFailLoadWithError:(NSError *)error;
// 积分墙页面被关闭。
// Offer wall closed.
- (void)offerWallDidClosed;

@optional
#pragma mark OfferWall Interstitial
// 当积分墙插屏广告被成功加载后，回调该方法
// Called when interstitial ad is loaded successfully.
- (void)dmOfferWallInterstitialSuccessToLoadAd:(DMOfferWallViewController *)dmOWInterstitial;
// 当积分墙插屏广告加载失败后，回调该方法
// Called when failed to load interstitial ad.
- (void)dmOfferWallInterstitialFailToLoadAd:(DMOfferWallViewController *)dmOWInterstitial withError:(NSError *)err;
// 当积分墙插屏广告要被呈现出来前，回调该方法
// Called when interstitial ad will be presented.
- (void)dmOfferWallInterstitialWillPresentScreen:(DMOfferWallViewController *)dmOWInterstitial;
// 当积分墙插屏广告被关闭后，回调该方法
// Called when interstitial ad has been closed.
- (void)dmOfferWallInterstitialDidDismissScreen:(DMOfferWallViewController *)dmOWInterstitial;
@end

@interface DMOfferWallViewController : UIViewController

@property (nonatomic, assign) NSObject<DMOfferWallDelegate> *delegate;
@property (nonatomic, assign) UIViewController *rootViewController;
// 禁用StoreKit库提供的应用内打开store页面的功能，采用跳出应用打开OS内置AppStore。默认为NO，即使用StoreKit。
@property (nonatomic, assign) BOOL disableStoreKit;

// 使用Publisher ID初始化积分墙ViewController
// Create OfferWallViewController with your own Publisher ID
- (id)initWithPublisherID:(NSString *)publisherID;

// 使用Publisher ID和应用当前登陆用户的User ID（或其它的在应用中唯一标识用户的ID）初始化积分墙ViewController
// Create OfferWallViewController with your own Publisher ID and User ID.
- (id)initWithPublisherID:(NSString *)publisherID andUserID:(NSString *)userID;

// 使用App的rootViewController来弹出并显示积分墙。
// Present offer wall in ModelView way with App's rootViewController.
- (void)presentOfferWall;

// 使用开发者传入的UIViewController来弹出显示OfferWallViewController。
// Present OfferWallViewController with developer's controller.
- (void)presentOfferWallWithViewController:(UIViewController *)controller;

#pragma mark OfferWall Interstitial
// 请求加载插屏积分墙
// Request to load interstitial.
- (void)loadOfferWallInterstitial;
// 询问积分墙插屏是否完成，该方法立即返回当前状态，不会阻塞主线程。
// Check if interstitial is ready to show.
- (BOOL)isOfferWallInterstitialReady;
// 显示加载完成的积分墙插屏。若没有加载完成，不会展现。
// Request a present of loaded interstitial.
- (void)presentOfferWallInterstitial;
@end
