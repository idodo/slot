#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

#define WAPS_SDK_VERSION_NUMBER            @"1.6.5"

@protocol AppConnectDelegate;
@class WapsUserPoints;

enum WapsConnectionType {
    WAPS_CONNECT_TYPE_CONNECT = 0,
    WAPS_CONNECT_TYPE_ALT_CONNECT,
    WAPS_CONNECT_TYPE_USER_ID,
    WAPS_CONNECT_TYPE_SDK_LESS,
    WAPS_CONNECT_TYPE_SCHEME_INFO,
};

@interface AppConnect : NSObject {

@private
    NSString *appID_;
    NSString *userID_;
    NSString *plugin_;
    NSMutableData *data_;
    int connectAttempts_;
    BOOL isInitialConnect_;
    BOOL isAutoGetPoints_;
    int responseCode_;
    NSURLConnection *connectConnection_;
    NSURLConnection *userIDConnection_;
    NSURLConnection *SDKLessConnection_;
    NSString *appChannel_;
    NSString *appCount_;
    NSString *appleID_;
}

@property(nonatomic, copy) NSString *appID;
@property(nonatomic, copy) NSString *appChannel;
@property(nonatomic, copy) NSString *userID;
@property(nonatomic, copy) NSString *plugin;
@property(nonatomic, copy) NSMutableDictionary *configItems;
@property(nonatomic, copy) NSString *appCount;
@property(nonatomic, copy) NSString *appleID;
@property(assign) BOOL isInitialConnect;
@property(assign) BOOL isAutoGetPoints;
@property(nonatomic, retain) id <AppConnectDelegate> delegate;


+ (AppConnect *)getConnect:(NSString *)appID;

+ (AppConnect *)getConnect:(NSString *)appID pid:(NSString *)appChannel;

+ (AppConnect *)getConnect:(NSString *)appID pid:(NSString *)appChannel userID:(NSString *)theUserID;

+ (AppConnect *)actionComplete:(NSString *)actionID;

+ (AppConnect *)sharedAppConnect;

+ (void)deviceNotificationReceived;

+ (NSString *)getAppID;

+ (void)setUserID:(NSString *)theUserID;

+ (NSString *)getUserID;

+ (NSMutableDictionary *)getConfigItems;

- (void)connectWithType:(int)connectionType withParams:(NSDictionary *)params;

- (NSString *)getURLStringWithConnectionType:(int)connectionType;

- (void)initiateConnectionWithConnectionType:(int)connectionType requestString:(NSString *)requestString;

- (BOOL)isJailBroken;

+ (NSString *)isJailBrokenStr;

- (NSMutableDictionary *)genericParameters;

- (NSString *)createQueryStringFromDict:(NSDictionary *)paramDict;

+ (NSString *)createQueryStringFromDict:(NSDictionary *)paramDict;

- (NSString *)createQueryStringFromString:(NSString *)string;

+ (NSString *)createQueryStringFromString:(NSString *)string;

+ (void)clearCache;

+ (NSString *)getOpenID;

+ (NSString *)getIDFA;

+ (NSString *)getIDFV;

+ (NSString *)getMACAddress;

+ (NSString *)getMACID;

+ (NSString *)getUniqueIdentifier;

+ (NSString *)getTimeStamp;

+ (void)autoGetPoints:(BOOL)isAuto;

@end


@protocol AppConnectDelegate
@required

- (void)onWapsConnectSuccess;

- (void)onWapsConnectFailed;

- (void)onWapsUpdatePoints:(WapsUserPoints *)userPoints;

- (void)onWapsGetPointsSuccess:(WapsUserPoints *)userPoints;

- (void)onWapsGetPointsFailed:(NSString *)error;

- (void)onWapsAwardPointsSuccess:(int)awardPoint;

- (void)onWapsAwardPointsFailed:(NSString *)error;

- (void)onWapsSpendPointsSuccess:(int)spendPoint;

- (void)onWapsSpendPointsFailed:(NSString *)error;

- (void)onWapsOfferClose;

- (void)onWapsBannerShow;

- (void)onWapsBannerShowFailed;

- (void)onWapsBannerClick;

- (void)onWapsBannerClose;

- (void)onWapsPopAdInitSuccess;

- (void)onWapsPopAdInitFailed:(NSString *)error;

- (void)onWapsPopAdInitNull:(NSString *)error;

- (void)onWapsPopAdShowSuccess;

- (void)onWapsPopAdShowFailed:(NSString *)error;

- (void)onWapsPopAdClose;

- (void)onWapsPopAdClick;

@end

#import "AppConnectConstants.h"