//
//  OrderListModel.m
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

- (id)initWithJson:(id)json andIsSendOrder:(BOOL)isSendOrder
{
    if (self = [super init]) {
        
        _isSendOrder = isSendOrder;
        _content = [json objectForKey:@"content"];
        _orderId = [json objectForKey:@"id"];
        _price = [json objectForKey:@"money"];
        
        float priceValue = [_price floatValue];
        if (priceValue - (int)priceValue) {
            _price = [NSString  stringWithFormat:@"%.2f", priceValue];
        } else {
            _price = [NSString stringWithFormat:@"%d", (int)priceValue];
        }
        
        
        _orderNumber = [json objectForKey:@"ordernumber"];
        _sex = [json objectForKey:@"sex"];
        _tasktime = [json objectForKey:@"timelength"];
        _address = [json objectForKey:@"serviceaddress"];
        _reminderCount = [json objectForKey:@"ask_money_times"];

        if ([json objectForKey:@"jiedanren"]) {
            _grabOrderUser = [[UserInfo alloc] initWithJson:[json objectForKey:@"jiedanren"]];
        }
        if ([json objectForKey:@"fadanren"]) {
            _sendOrderUser = [[UserInfo alloc] initWithJson:[json objectForKey:@"fadanren"]];
        }
        
        if ([json objectForKey:@"member"]) {
            _member = [[UserInfo alloc] initWithJson:[json objectForKey:@"member"]];
        }
        //订单被抢
        if ([[json objectForKey:@"status"] intValue] == 3) {
            if ([[json objectForKey:@"haspay"] intValue] == 0) {
                _orderStatus = kOrderGrabSuccess;
                if (!_isSendOrder) {
                    _orderStatusDesc = @"已抢单，等待对方付款";
                } else {
                    _orderStatusDesc = @"订单已被抢，请您付款";
                    
                }
            } else if ([[json objectForKey:@"haspay"] intValue] == 1) {
                if ([[json objectForKey:@"hasconfpay"] intValue] == 0) {
                    _orderStatus = kOrderPayed;
                    if (_isSendOrder) {
                        if ([[json objectForKey:@"fromMemberAskCancel"]intValue] == 1) {
                            _orderStatusDesc = @"您已取消订单，等待对方确认";
                        } else {
                            _orderStatusDesc = @"已经付款，请验收";
                        }
                    } else {
                        if ([[json objectForKey:@"fromMemberAskCancel"]intValue] == 1) {
                            _orderStatusDesc = @"对方请求取消订单";
                        } else {
                            _orderStatusDesc = @"对方已付款，任务进行中";
                        }
                    }
                } else {
                    if (_isSendOrder) {
                        if ([[json objectForKey:@"hascommenttoperson"] intValue] == 1) {
                            _orderStatus = kOrderCompletion;
                            _orderStatusDesc = @"任务完成，订单已结束";
                            
                        } else {
                            _orderStatus = kOrderCheckDone;
                            _orderStatusDesc = @"已验收，请评价";
                            
                        }
                    } else {
                        if ([[json objectForKey:@"hascommentfromperson"] intValue] == 1) {
                            _orderStatus = kOrderCompletion;
                            _orderStatusDesc = @"任务完成，订单已结束";
                            
                        } else {
                            _orderStatus = kOrderCheckDone;
                            _orderStatusDesc = @"已验收，请评价";
                            
                        }
                        
                    }
                    
                }
            }
        } else if ([[json objectForKey:@"status"] intValue] == 1) {
            if ([[json objectForKey:@"tomemberid"] intValue] == 0) {
                _orderStatus = kOrderInProgress;
                _orderStatusDesc = @"等待活儿宝抢单";
                
            }
        } else if ([[json objectForKey:@"status"] intValue] == 2) {
            if ([[json objectForKey:@"tomemberid"] intValue] == 0) {
                _orderStatus = kOrderCancelGrabTimeOut;
                _orderStatusDesc = @"无人抢单,已取消";
                
            } else  if ([[json objectForKey:@"haspay"] intValue] == 1) {
                _orderStatus = kOrderCancelDispute;
                _orderStatusDesc = @"订单纠纷,已取消";
                
            } else {
                _orderStatus = kOrderCancelPayTimeOut;
                _orderStatusDesc = @"超时未付款,已取消";
                
            }
        }
    }

    return self;
}

- (void)setOrderStatus:(OrderStatus)orderStatus
{
    _orderStatus = orderStatus;
    switch (_orderStatus) {
        case kOrderCancelDispute:
            _orderStatusDesc = @"订单纠纷,已取消";
            break;
            
        case kOrderPayed:
            _orderStatusDesc = @"已经付款，等待验收";
            break;
            
        case kOrderCancelGrabTimeOut:
            _orderStatusDesc = @"无人抢单,已取消";
            break;
            
        case kOrderCancelPayTimeOut:
            _orderStatusDesc = @"超时未付款,已取消";
            break;
            
        case kOrderCheckDone:
            _orderStatusDesc = @"已验收，请评价";
            break;
            
        case kOrderCompletion:
            _orderStatusDesc = @"任务完成，订单已结束";
            break;
            
        case kOrderGrabSuccess:
            _orderStatusDesc = @"已经接单，等待付款";
            break;
            
        case kOrderInProgress:
            _orderStatusDesc = @"等待活宝抢单";
            break;
            
        default:
            break;
    }
}


@end
