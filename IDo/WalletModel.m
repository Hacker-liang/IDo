//
//  WalletModel.m
//  IDo
//
//  Created by liangpengshuai on 10/1/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "WalletModel.h"

@implementation WalletModel

- (id)initWithJson:(id)json
{
    if (self = [super init]) {
        _cashMoney = [json objectForKey:@"txmoney"];
        _remainingMoney = [json objectForKey:@"yue"];
        _earnMoney = [json objectForKey:@"shourumoney"];
        _payMoney = [json objectForKey:@"xiaofeimoney"];
    }
    return self;
}
@end
