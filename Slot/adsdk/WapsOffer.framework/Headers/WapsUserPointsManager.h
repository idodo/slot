#import <Foundation/Foundation.h>
#import "WapsFetchResponseProtocol.h"
#import "AppConnect.h"
#import "WapsTBXML.h"

typedef enum {
    kWapsUserAccountRequestTagGetPoints = 0,
    kWapsUserAccountRequestTagSpendPoints = 1,
    kWapsUserAccountRequestTagAwardPoints = 2,
    kWapsUserAccountRequestTagMAX
} WapsUserAccountRequestTag;

@class WapsUserPointsRequestHandler;
@class WapsUserPoints;

@interface WapsUserPointsManager : NSObject <WapsFetchResponseDelegate> {
    WapsUserPoints *userPointsObj_;
    WapsUserPointsRequestHandler *userPointsGetPointsObj_;
    WapsUserPointsRequestHandler *userPointsSpendPointsObj_;
    WapsUserPointsRequestHandler *userPointsAwardPointsObj_;
    BOOL waitingForResponse_;
}

@property(nonatomic, retain) id <AppConnectDelegate> delegate;

+ (WapsUserPointsManager *)sharedWapsUserPointsManager;

- (void)getPoints;

- (void)spendPoints:(int)points;

- (void)awardPoints:(int)points;

- (void)fetchResponseSuccessWithData:(WapsCoreFetcher *)dataObj withRequestTag:(int)aTag;

- (void)fetchResponseError:(WapsResponseError)errorType errorDescription:(id)errorDescObj requestTag:(int)aTag;

- (void)updateUserAccountObjWithTBXMLElement:(WapsTBXMLElement *)userAccElement;

- (void)releaseUserAccount;

@end


@interface AppConnect (WapsUserPointsManager)

+ (void)getPoints;

+ (void)spendPoints:(int)points;

+ (void)awardPoints:(int)points;

+ (void)showEarnedPoints;

+ (void)showDefaultEarnedCurrencyAlert:(NSNotification *)notifyObj;

@end