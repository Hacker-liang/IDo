//
//  OrderDetailModel.m
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel

- (id)init
{
    if (self = [super init]) {
        _address = @"";
        _sex = @"";
        _price = @"";
        _content = @"";
        _tasktime = @"";
        _distance = @"";
    }
    return self;
}

@end
