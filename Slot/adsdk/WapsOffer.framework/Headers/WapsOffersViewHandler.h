#import <UIKit/UIKit.h>
#import "AppConnect.h"

@class WapsOffersController;

typedef enum {
    WAPS_GROUPBUY,
    WAPS_SITE,
    WAPS_ARTICLES,
    WAPS_BBS,
    WAPS_OWNER_APPS
} WanpuMod;

@interface WapsOffersViewHandler : NSObject {
    WapsOffersController * _wapsOffersController;
}

@property (nonatomic, retain) WapsOffersController * wapsOffersController;

- (void)closeOffers;

- (void)removeOffersWebView;

- (UIView *)getOfferContentView;

+ (WapsOffersViewHandler *)sharedWapsOffersViewHandler;

- (void)showOfferWithController:(UIViewController *)controller;

- (void)showOfferWithController:(UIViewController *)controller animated:(BOOL)animated;

- (void)showOfferWithController:(UIViewController *)vController showNavBar:(BOOL)visible;

- (void)showOffersWithController:(UIViewController *)controller navBar:(UIView *)userNavBar;

- (void)showOffersWithUserURL:(NSString *)url Controller:(UIViewController *)controller;

- (void)showFeedBackWithController:(UIViewController *)controller;

- (void)loadViewWithUserURL:(NSString *)url Controller:(UIViewController *)controller;

@end


@interface AppConnect (WapsOffersViewHandler)

#pragma mark -
#pragma mark offer主要调用方法

+ (void)closeOffers;

+ (void)showOffers:(UIViewController *)controller;

+ (void)showOffers:(UIViewController *)controller animated:(BOOL)animated;

+ (void)showOffers:(UIViewController *)controller showNavBar:(BOOL)visible;

+ (UIView *)getOfferContentView;

+ (void)showOffers:(UIViewController *)controller navBar:(UIView *)userNavBar;

+ (void)showOffersWithURL:(NSString *)url Controller:(UIViewController *)viewController;

+ (void)showFeedBack:(UIViewController *)controller;

+ (void)loadViewWithURL:(NSString *)url Controller:(UIViewController *)controller;

@end