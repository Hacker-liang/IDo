//
//  MissOrderModel.m
//  IDo
//
//  Created by liangpengshuai on 1/3/16.
//  Copyright © 2016 com.Yinengxin.xianne. All rights reserved.
//

#import "MissOrderModel.h"

@implementation MissOrderModel

- (id)initWithJson:(id)json
{
    if (self = [super init]) {
        _content = [json objectForKey:@"content"];
        _orderId = [json objectForKey:@"id"];
        _address = [json objectForKey:@"address"];
        _money = [json objectForKey:@"money"];
        
        float priceValue = [_money floatValue];
        if (priceValue - (int)priceValue) {
            _money = [NSString  stringWithFormat:@"%.2f", priceValue];
        } else {
            _money = [NSString stringWithFormat:@"%d", (int)priceValue];
        }
        
        _orderNumber = [json objectForKey:@"ordernumber"];
        _lat = [json objectForKey:@"lat"];
        _lng = [json objectForKey:@"lng"];
        _publishTime = [json objectForKey:@"publishTime"];
        _updateTime = [json objectForKey:@"updateTime"];
        
        _orderSender = [[MissOrderModelUser alloc] init];
        _orderSender.nickName = [[json objectForKey:@"member"] objectForKey:@"nickName"];
        _orderSender.userId = [[json objectForKey:@"member"] objectForKey:@"id"];
        if ([[[json objectForKey:@"member"] objectForKey:@"img"] rangeOfString:@"http"].location != NSNotFound) {
            _orderSender.avatar = [[json objectForKey:@"member"] objectForKey:@"img"];
        } else {
            _orderSender.avatar = [NSString stringWithFormat:@"%@%@",headURL,[[json objectForKey:@"member"] objectForKey:@"img"]];
        }
        
        if ([[json objectForKey:@"status"] integerValue] == 1) {    //订单未被抢
            if ([json objectForKey:@""]) {
                
            }
        } else  if ([[json objectForKey:@"status"] integerValue] == 2) {   //订单取消
            if ([[json objectForKey:@"subscribermemberid"] intValue] == 0) {
                _orderStatusDesc = @"订单过期失效";
                
            } else {
                _orderStatusDesc = @"订单被取消";
            }
        } else  if ([[json objectForKey:@"status"] integerValue] == 3) {    //订单被抢成功
            if ([[json objectForKey:@"haspay"] intValue] == 1) {
                if ([[json objectForKey:@"hasconfpay"] intValue] == 1) {
                    _orderStatusDesc = @"订单已完成";
                } else {
                    _orderStatusDesc = @"订单执行中";
                }
            } else {
                _orderStatusDesc = @"订单执行中";
            }
        }
    }
    return self;
}

@end


@implementation MissOrderModelUser


@end