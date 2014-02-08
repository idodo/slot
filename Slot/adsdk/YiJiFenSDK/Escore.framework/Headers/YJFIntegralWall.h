//
//  jifenWall.h
//  yjfSDKDemo_beta1
//
//  Created by emaryjf on 13-4-3.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJFFeedBack.h"
#import "YJFHelpView.h"
@protocol YJFIntegralWallDelegate <NSObject>
@optional
-(void)OpenIntegralWall:(int)_value;//1 打开成功  0 打开失败
-(void)CloseIntegralWall;//墙关闭

@end

@interface YJFIntegralWall : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    int page;
    int yjfscore;//积分
    id<YJFIntegralWallDelegate> delegate;
    int flag1;
}
@property (assign) id<YJFIntegralWallDelegate> delegate;
@property int yjfscore;
@property (nonatomic, retain) NSMutableArray* array;
@property (nonatomic, retain) NSMutableArray* displayArray;;
@property (nonatomic, assign) UITableView* tableView;
@property (retain) NSMutableData *receivedData;

@property (nonatomic,retain) YJFFeedBack* feedBackView;
@property (nonatomic,retain) YJFHelpView *helpView;

@property (nonatomic,assign) UIView *alertView ;



@property (assign) UILabel *title_demo;
@property (assign) UILabel *title_demo2;
@property (assign) UIButton *backBut;
@property (assign) UIImageView *logoImage;
@property (retain) UIView *tableFooterView;
@property (assign) UIButton *feedback;
@property (assign) UIImageView *feedbackImage;


@property (assign) UIView *blackBG;
@property (assign) UIImageView *imagebian;
@property (assign) UILabel *alerttitle;
@property (assign) UILabel *content;
@property (assign)  UIButton *cancle;
@property (assign)  UIButton *okbut;
  
@end

