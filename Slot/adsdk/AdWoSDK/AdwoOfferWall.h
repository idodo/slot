//
//  AdwoOfferWall.h
//  AdwoOfferWall
//
//  Created by zenny_chen on 13-5-9.
//  Copyright (c) 2013年 zenny_chen. All rights reserved.
//

#ifndef AdwoOfferWall_AdwoOfferWall_h
#define AdwoOfferWall_AdwoOfferWall_h

#import <UIKit/UIKit.h>

// 当前Adwo积分墙版本号——1.3.0
#define ADWOOW_SDK_VERSION_VALUE                130

// Adwo积分墙返回的错误码
enum ADWO_OFFER_WALL_ERRORCODE
{
    ADWO_OFFER_WALL_ERRORCODE_SUCCESS,                      // 0: 状态成功
    ADWO_OFFER_WALL_ERRORCODE_OFFERWALL_DISABLED,           // 1: 积分墙被禁用，或当前PID不存在
    ADWO_OFFER_WALL_ERRORCODE_LOGIN_CONNECTION_FAILED,      // 2: 登陆网络连接失败
    ADWO_OFFER_WALL_ERRORCODE_NOT_LOGINNED,                 // 3: 积分墙尚未登录
    ADWO_OFFER_WALL_ERRORCODE_NOT_INITIALIZED,              // 4: 积分墙未被初始化
    ADWO_OFFER_WALL_ERRORCODE_ALREADY_LOGINNING,            // 5: 积分墙已经在登录了
    ADWO_OFFER_WALL_ERRORCODE_UNKNOWN_ERROR,                // 6: 未知错误
    ADWO_OFFER_WALL_ERRORCODE_INVALID_FLAG,                 // 7: 无效的标志
    ADWO_OFFER_WALL_ERRORCODE_APPLIST_REQUEST_FAILED,       // 8: 请求应用列表失败
    ADWO_OFFER_WALL_ERRORCODE_APPLIST_RESPONSE_FAILED,      // 9: 请求应用列表响应失败
    ADWO_OFFER_WALL_ERRORCODE_APPLIST_PARAM_MALFORMAT,      // 10: 应用请求列表参数格式错误
    ADWO_OFFER_WALL_ERRORCODE_APPLIST_ALREADY_REQUESTING,   // 11: 应用列表已经在请求中
    ADWO_OFFER_WALL_ERRORCODE_WALL_NOT_READY_FOR_SHOW,      // 12: 积分墙还没准备好来展示
    ADWO_OFFER_WALL_ERRORCODE_WALL_KEYWORDS_MALFORMATTED,   // 13: 关键字格式错误
    ADWO_OFFER_WALL_ERRORCODE_WALL_LACK_OF_SPACE_FOR_RESOURCE,  // 14: 用户磁盘空间不足，无法存放资源
    ADWO_OFFER_WALL_ERRORCODE_WALL_RESOURCE_MALFORMATED,    // 15: 资源格式错误
    ADWO_OFFER_WALL_ERRORCODE_WALL_RESOURCE_LOAD_FAILED,    // 16: 积分墙资源加载失败
    ADWO_OFFER_WALL_ERRORCODE_ALREADY_LOGINNED,             // 17: 积分墙已经登录
    ADWO_OFFER_WALL_ERRORCODE_EXCEED_MAX_SHOW_COUNT,        // 18: 超出当天积分墙最大展示次数
    ADWO_OFFER_WALL_ERRORCODE_EXCEED_MAX_INIT_COUNT,        // 19: 超出当天积分墙最大登录次数
    ADWO_OFFER_WALL_ERRORCODE_CURRENT_POINTS_NOT_ENOUGH,    // 20: 当前积分不够消费
    ADWO_OFFER_WALL_ERRORCODE_POINTS_CONSUMPTION_UNAVAILABLE,    // 21: 当前积分消费不可用
    ADWO_OFFER_WALL_ERRORCODE_POINTS_CONSUMPTION_NEGATIVE    // 22: 当前积分为负数
};

// 当前嵌积分墙应用的审核状态
enum ADWO_OFFER_WALL_REVIEW_STATE
{
    ADWO_OFFER_WALL_REVIEW_STATE_OFFERWALL_DISABLED = -1,   // 当前积分墙被禁用，或PID不存在
    ADWO_OFFER_WALL_REVIEW_STATE_NOT_REVIEWED,              // 当前应用未被审核，处于测试状态
    ADWO_OFFER_WALL_REVIEW_STATE_NORMAL,                    // 当前积分墙正常使用
    ADWO_OFFER_WALL_REVIEW_STATE_REVIEWED_BUT_NOT_PASS,     // 当前应用审核未通过
    ADWO_OFFER_WALL_REVIEW_STATE_REVIEWING = 5              // 当前应用在审核中
};

// Adwo积分墙消息响应事件标志
enum ADWO_OFFER_WALL_RESPONSE_EVENTS
{
    // 积分墙弹出响应事件
    ADWO_OFFER_WALL_RESPONSE_EVENTS_WALL_PRESENT = 0x1 << 0,
    // 积分墙退出响应事件
    ADWO_OFFER_WALL_RESPONSE_EVENTS_WALL_DISMISS = 0x1 << 1
};

// Adwo积分墙禁止使用特征
enum ADWO_OFFER_WALL_DISABLED_FEATURES
{
    // 禁用StoreKit
    ADWO_OFFER_WALL_DISABLED_FEATURES_STORE_KIT = 0x1 << 0
};

#ifdef __cplusplus
extern "C" {
#endif
    
/** 呈现Adwo积分墙；若能成功展现积分墙则返回YES，否则返回NO
    * 参数：
     * pid——给嵌积分墙的开发者所提供的唯一的积分墙发布ID，即publish ID。pid会做retain操作，因此如果开发者使用了alloc方法的NSString对象的话，需要调用release。
     * baseViewController——基视图控制器。Adwo积分墙SDK将通过此对象来弹出积分墙视图控制器
*/
extern BOOL AdwoOWPresentOfferWall(NSString *pid,UIViewController *baseViewController);

/** 设置关键字
 * 参数：关键字数组。每个元素都必须是一个NSString*对象
*/
extern BOOL AdwoOWSetKeywords(NSArray *keywords);

/** 获取Adwo积分墙最近一次的错误码 */
extern enum ADWO_OFFER_WALL_ERRORCODE AdwoOWFetchLatestErrorCode(void);

/** 积分消费：若返回为YES说明积分消费成功，否则积分消费失败。
 * 可以通过AdwoOWFetchLatestErrorCode()函数来查看错误状态信息。
 * 参数：
 * value：所要消费的积分点数
 * pRemainPoints：传出当前剩余积分。该值为当前积分剩余减去消费积分（value）后的值。
 * 若开发者要查询当前剩余积分，则直接调用此接口，将value值设为0即可。
*/
extern BOOL AdwoOWConsumePoints(NSInteger value, NSInteger *pRemainPoints);

/** 查询当前嵌积分墙的应用的审核状态
 * 参数：
 * pOutState：输出审核状态的枚举值
*/
extern BOOL AdwoOWCheckCurrentReviewState(enum ADWO_OFFER_WALL_REVIEW_STATE *pOutState);

/** 注册一个指定的响应事件。如果注册成功则返回YES，否则返回NO
 * 参数：
 * theEvent——相应的事件标志
 * target——事件触发后给所指定的对象发送消息
 * aSelector——事件触发后所要回调的方法。该原型必须与相应接口描述中所给出的回调方法的原型一致
 * 注：若先前已经注册了相应事件响应的target和selector，那么使用此接口将会覆盖先前所注册的target和selector
 * target参数不会被retain，因此如果你要彻底销毁此对象，那么在此之前必须先调用AdwoOWUnregisterResponseEvents接口
   来注销相应事件的响应
*/
extern BOOL AdwoOWRegisterResponseEvent(enum ADWO_OFFER_WALL_RESPONSE_EVENTS theEvent, NSObject *target, SEL aSelector);

/** 注销一组指定的响应事件。如果注销成功则返回YES，否则返回NO
 * 参数：
 * events——用按位或（|）所连接的一组ADWO_OFFER_WALL_RESPONSE_EVENTS事件，比如：
 ADWO_OFFER_WALL_RESPONSE_EVENTS_WALL_PRESENT | ADWO_OFFER_WALL_RESPONSE_EVENTS_WALL_DISMISS
 当然，也可只指定一个事件
 * 注：当开发者在销毁一个已经注册的target对象之前必须注销此相应事件。一般可以在- (void)dealloc方法中做注销。
*/
extern BOOL AdwoOWUnregisterResponseEvents(unsigned events);

/** 禁用一些iOS系统特征
 * 参数：
 * features——用按位或（|）所连接的一组ADWO_OFFER_WALL_DISABLED_FEATURES特征
*/
extern BOOL AdwoOWDisableFeatures(unsigned features);

#ifdef __cplusplus
}
#endif


#endif
