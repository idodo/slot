//
//  Insert.h
//  yjfSDKDemo_beta1
//
//  Created by emaryjf on 13-2-5.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJFInterstitialDelegate <NSObject,NSURLConnectionDelegate>
@optional
-(void)openInterstitial:(int)_value;//1 插屏弹出成功  0 插屏弹出失败
-(void)closeInterstitial;//插屏关闭
-(void)getInterstitialDataSuccess;//获取数据成功
-(void)getInterstitialDataFail;//获取数据失败
-(void)getImageDataSuccess;//获取图片成功

@end

NSMutableString *interstitialPar;
@interface YJFInterstitial : UIView<YJFInterstitialDelegate>
{
    id<YJFInterstitialDelegate> delegate;
    NSMutableArray *array;
    NSMutableData *receivedData;
}
@property (assign) id<YJFInterstitialDelegate> delegate;
@property (nonatomic, retain) id vc;
@property (retain) NSMutableData *receivedData;
@property CGRect picFrame;
@property (assign) UIImageView *imagebian ;

-(void) getInterstitialData;
- (id)initWithFrame:(CGRect)frame andPicFrame:(CGRect)picFrame andOrientation:(NSString *)orientations andDelegate:(id<YJFInterstitialDelegate>)_delegate;
@end
