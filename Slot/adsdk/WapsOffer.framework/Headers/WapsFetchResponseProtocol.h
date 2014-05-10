#import <Foundation/Foundation.h>
#import "WapsTBXML.h"

@class WapsCoreFetcher;

typedef enum WapsResponseError {
    kWapsInternetFailure = 0,
    kWapsStatusNotOK = 1,
    kWapsRequestTimeOut = 2
} WapsResponseError;

@protocol WapsFetchResponseDelegate <NSObject>
@required

- (void)fetchResponseSuccessWithData:(WapsCoreFetcher *)dataObj withRequestTag:(int)aTag;

- (void)fetchResponseError:(WapsResponseError)errorType errorDescription:(id)errorDescObj requestTag:(int)aTag;
@end

