//
//  ViewController.m
//  Slot
//
//  Created by fouber on 14-1-24.
//  Copyright (c) 2014年 fouber. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    _webView = [[UIWebView alloc] initWithFrame:screenFrame];
    self.view = _webView;
    
    [_webView setDelegate:self];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    if ([path length]) {
        _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback){
            //NSLog(@"ObjC received message from JS: %@", data);
            //responseCallback(@"Response for message from ObjC");
        }];
        
        [_bridge registerHandler:@"alert" handler:^(id message, WVJBResponseCallback responseCallback) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message: message
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }];
        
        [_bridge registerHandler:@"log" handler:^(id message, WVJBResponseCallback responseCallback) {
            NSLog(@"%@", message);
        }];
        
        [_bridge registerHandler:@"startLoading" handler:^(id message, WVJBResponseCallback responseCallback) {
            [_loading startAnimating];
        }];
        
        [_bridge registerHandler:@"stopLoading" handler:^(id message, WVJBResponseCallback responseCallback) {
            [_loading stopAnimating];
        }];
        
        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        
        id webDocumentView = [_webView performSelector:@selector(_browserView)];
        id backingWebView = [webDocumentView performSelector:@selector(webView)];
        [backingWebView performSelector:@selector(_setWebGLEnabled:) withObject:[NSNumber numberWithBool:YES]];
        
        [_webView setUserInteractionEnabled:YES];
        [_webView setOpaque:NO];
        [_webView loadHTMLString:html baseURL:baseURL];
        
        //add loading
        _loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _loading.backgroundColor = [UIColor whiteColor];
        _loading.alpha = 0.5;
        _loading.layer.cornerRadius = 6;
        _loading.layer.masksToBounds = YES;
        [_loading setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
        [self.view addSubview:_loading];
        
        [_bridge send:@"A string sent from ObjC after Webview has loaded."];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidFinishLoad");
}
    
- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidStartLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
