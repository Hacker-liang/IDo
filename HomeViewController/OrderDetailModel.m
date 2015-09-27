//
//  OrderDetailModel.m
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel

- (id)initWithJson:(id)json andIsSendOrder:(BOOL)isSendOrder
{
    if (self = [super init]) {
        _isSendOrder = isSendOrder;
        _content = [json objectForKey:@"content"];
        _orderId = [json objectForKey:@"id"];
        _price = [json objectForKey:@"money"];
        _orderNumber = [json objectForKey:@"ordernumber"];
        _sex = [json objectForKey:@"sex"];
        _tasktime = [json objectForKey:@"timelength"];
        _address = [json objectForKey:@"serviceaddress"];
        _lat = [json objectForKey:@"lat"];
        _lng = [json objectForKey:@"lng"];
        _sendOrderUser = [[UserInfo alloc] initWithJson:[json objectForKey:@"member"]];
        _grabOrderUser = [[UserInfo alloc] initWithJson:[json objectForKey:@"jiedanren"]];
        
        //订单被抢
        if ([[json objectForKey:@"status"] intValue] == 3) {
            if ([[json objectForKey:@"haspay"] intValue] == 0) {
                _orderStatus = kOrderGrabSuccess;
                _orderStatusDesc = @"已经接单，等待付款";
            } else if ([[json objectForKey:@"haspay"] intValue] == 1) {
                if ([[json objectForKey:@"hasconf"] intValue] == 0) {
                    _orderStatus = kOrderPayed;
                    _orderStatusDesc = @"已经付款，等待验收";
                } else {
                    if (_isSendOrder) {
                        if ([[json objectForKey:@"hascommenttoperson"] intValue] == 1) {
                            _orderStatus = kOrderCompletion;
                            _orderStatusDesc = @"订单已经完成";

                        } else {
                            _orderStatus = kOrderCheckDone;
                            _orderStatusDesc = @"已经验收，等待评价";

                        }
                    } else {
                        if ([[json objectForKey:@"hascommentfromperson"] intValue] == 1) {
                            _orderStatus = kOrderCompletion;
                            _orderStatusDesc = @"订单已经完成";

                        } else {
                            _orderStatus = kOrderCheckDone;
                            _orderStatusDesc = @"已经验收，等待评价";

                        }
                        
                    }
                    
                }
            }
        } else if ([[json objectForKey:@"status"] intValue] == 1) {
            if ([[json objectForKey:@"tomemberid"] intValue] == 0) {
                _orderStatus = kOrderInProgress;
                _orderStatusDesc = @"等待活宝抢单";

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

@end
