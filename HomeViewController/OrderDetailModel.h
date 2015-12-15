//
//  OrderDetailModel.h
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

typedef enum : NSUInteger {
    
    //派单成功，等待抢单
    kOrderInProgress = 1,
    
    //抢单成功，等待付款
    kOrderGrabSuccess,
    
    //付款成功，等待验收
    kOrderPayed,
    
    //验收成功，等待评价
    kOrderCheckDone,
    
    //订单完成
    kOrderCompletion,
    
    //订单取消，因为无人抢单
    kOrderCancelGrabTimeOut,
    
    //订单取消，因为付款超时
    kOrderCancelPayTimeOut,
    
    //订单取消，因为纠纷
    kOrderCancelDispute,
    
    //订单不属于你
    kOrderNotBelongYou,
    
    
} OrderStatus;


#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface OrderDetailModel : NSObject

@property(copy, nonatomic) UserInfo *sendOrderUser;
@property(copy, nonatomic) UserInfo *grabOrderUser;

@property(copy, nonatomic) NSString *orderId;
@property(copy, nonatomic) NSString *orderNumber;
@property(copy, nonatomic) NSString *address; //地址
@property(copy, nonatomic) NSString *lng;
@property(copy, nonatomic) NSString *lat;
@property(copy, nonatomic) NSString *content;  //内容
@property(copy, nonatomic) NSString *price;    //价格
@property(copy, nonatomic) NSString *tasktime; //系统传输时间
@property(copy, nonatomic) NSString *sex;      //性
@property(copy, nonatomic) NSString *distance; //范围
@property(copy, nonatomic) NSString *reminderCount; //范围

@property (nonatomic)BOOL isAsk2CancelFromFadanren; //由发单人取消订单
@property (nonatomic)BOOL isAsk2CancelFromQiangdanren; //由抢单人取消订单

@property (nonatomic) long payCountdown;  //付款倒计时
@property (nonatomic) long grabCountdown;  //付款倒计时
@property (nonatomic) long cancelCountdown;  //取消倒计时


@property (nonatomic) BOOL isSendOrder;
@property (nonatomic) OrderStatus orderStatus;
@property (nonatomic, copy) NSString *orderStatusDesc;


- (id)initWithJson:(id)json andIsSendOrder:(BOOL)isSendOrder;

@end
