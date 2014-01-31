//
//  ViewController.h
//  Slot
//
//  Created by fouber on 14-1-24.
//  Copyright (c) 2014年 fouber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
#import "DMOfferWallViewController.h"

#define PUBLISHER_ID @"96ZJ0PsQze86XwTA7A" // online

@interface ViewController : UIViewController<UIWebViewDelegate, DMOfferWallDelegate> {
    DMOfferWallViewController *_offerWallController;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet WebViewJavascriptBridge *bridge;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@end
