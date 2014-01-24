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
    
    [_webView setDelegate:self];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    if ([path length]) {
        _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback){
            NSLog(@"ObjC received message from JS: %@", data);
            responseCallback(@"Response for message from ObjC");
        }];
        
        [_bridge registerHandler:@"alert" handler:^(id data, WVJBResponseCallback responseCallback) {
            [self alert:data];
        }];
        
        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [_webView setUserInteractionEnabled:YES];
        [_webView setOpaque:NO];
        [_webView loadHTMLString:html baseURL:baseURL];
        
        [_bridge send:@"A string sent from ObjC after Webview has loaded."];
    }
    NSLog(@"%@", path);
}

- (void)alert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]
                            initWithTitle:nil
                            message: message
                            delegate:nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil];
    [alert show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}
    
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
