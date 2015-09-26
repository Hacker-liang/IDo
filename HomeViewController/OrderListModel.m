//
//  OrderListModel.m
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

- (id)initWithJson:(id)json
{
    if (self = [super init]) {
        _content = [json objectForKey:@"content"];
        _orderId = [json objectForKey:@"id"];
        _price = [json objectForKey:@"money"];
        _orderNumber = [json objectForKey:@"ordernumber"];
        _sex = [json objectForKey:@"sex"];
        _tasktime = [json objectForKey:@"timelength"];
        _address = [json objectForKey:@"serviceaddress"];

        if ([json objectForKey:@"member"]) {
            _userInfo = [[UserInfo alloc] initWithJson:[json objectForKey:@"member"]];
        } else {
            _userInfo = [[UserInfo alloc] initWithJson:[json objectForKey:@"fadanren"]];
        }
        if ([[json objectForKey:@"status"] isEqualToString:@"1"]) {
            _orderStatus = kOrderInProgress;
            _statusDesc = @"等待抢单";
        }
        if ([[json objectForKey:@"status"] isEqualToString:@"2"]) {
            _orderStatus = kOrderCancel;
            _statusDesc = @"无人抢单,已取消";
        }

    }
    return self;
}

@end
