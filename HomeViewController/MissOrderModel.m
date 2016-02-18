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
        _content = [json objectForKey:@"publishContent"];
        _orderId = [NSString stringWithFormat:@"%@", [json objectForKey:@"id"]];
        _address = [json objectForKey:@"address"];
        _money = [json objectForKey:@"money"];
        
        float priceValue = [_money floatValue];
        if (priceValue - (int)priceValue) {
            _money = [NSString  stringWithFormat:@"%.2f", priceValue];
        } else {
            _money = [NSString stringWithFormat:@"%d", (int)priceValue];
        }
        
        _orderNumber = [json objectForKey:@"ordernumber"];
        _lat = [NSString stringWithFormat:@"%@", [json objectForKey:@"lat"]];
        _lng = [NSString stringWithFormat:@"%@", [json objectForKey:@"lng"]];
        
        
        _publishTime = [ConvertMethods dateToString:[NSDate dateWithTimeIntervalSince1970:[[json objectForKey:@"publishTime"] integerValue]/1000] withFormat:@"MM-dd HH:mm" withTimeZone:[NSTimeZone systemTimeZone]];
        _updateTime = [NSString stringWithFormat:@"%@", [json objectForKey:@"updateTime"]];
        _orderSender = [[MissOrderModelUser alloc] init];
        _orderSender.nickName = [[json objectForKey:@"member"] objectForKey:@"nickName"];
        _orderSender.userId = [[[json objectForKey:@"member"] objectForKey:@"id"] integerValue];
        _orderSender.sex = [[[json objectForKey:@"member"] objectForKey:@"sex"] integerValue];
        if ([[json objectForKey:@"memberStat"] isKindOfClass:[NSDictionary class]]) {
            _orderSender.sendOrderCount = [[[json objectForKey:@"memberStat"] objectForKey:@"totalPublish"] integerValue];
        }
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
                _orderStatusDesc = @"订单已错过";
                
            } else {
                _orderStatusDesc = @"订单已错过";
            }
        } else  if ([[json objectForKey:@"status"] integerValue] == 3) {    //订单被抢成功
            if ([[json objectForKey:@"haspay"] intValue] == 1) {
                if ([[json objectForKey:@"hasconfpay"] intValue] == 1) {
                    _orderStatusDesc = @"订单已错过";
                } else {
                    _orderStatusDesc = @"订单已错过";
                }
            } else {
                _orderStatusDesc = @"订单已错过";
            }
        }
    }
    return self;
}

@end


@implementation MissOrderModelUser


@end