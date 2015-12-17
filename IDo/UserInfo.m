//
//  UserInfo.m
//  WisdomHear
//
//  Created by Tan Anzhen on 11-9-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (id)initWithJson:(id)dict
{
    if (self = [super init]) {
        _userid = [dict objectForKey:@"id"];
        _nickName = [dict objectForKey:@"nikename"];
        _tel = [dict objectForKey:@"tel"];
        _sex = [dict objectForKey:@"sex"];
        if ([[dict objectForKey:@"img"] rangeOfString:@"http"].location != NSNotFound) {
            _avatar = [dict objectForKey:@"img"];
        } else {
            _avatar = [NSString stringWithFormat:@"%@%@",headURL,[dict objectForKey:@"img"]];
        }
        _level = [dict objectForKey:@"level"];
        _lock = [dict objectForKey:@"lock"];
        _zhifubao = [dict objectForKey:@"zhifubao"];
        _weixin = [dict objectForKey:@"weixin"];
        _token = [dict objectForKey:@"token"];
        _userLabel = [dict objectForKey:@"label"];
        _address = [dict objectForKey:@"address"];
        _lat = [[dict objectForKey:@"lat"] doubleValue];
        _lng = [[dict objectForKey:@"lng"] doubleValue];
        _pushType = [dict objectForKey:@"tsstatic"];
        _districtid = [dict objectForKey:@"districtid"];
        _tagArray = [[_userLabel componentsSeparatedByString:@","] mutableCopy];
       
        _rating = [dict objectForKey:@"star"];
        if (![dict objectForKey:@"jiedannumber"] || [dict objectForKey:@"jiedannumber"] == [NSNull null]) {
            _grabOrderCount = @"0";
        } else {
            _grabOrderCount = [dict objectForKey:@"jiedannumber"];
        }
        if (![dict objectForKey:@"fadannumber"] || [dict objectForKey:@"fadannumber"] == [NSNull null]) {
            _sendOrderCount = @"0";
        } else {
            _sendOrderCount = [dict objectForKey:@"fadannumber"];
        }
        if (![dict objectForKey:@"totalComplaintTimes"] || [dict objectForKey:@"totalComplaintTimes"] == [NSNull null]) {
            _complainCount = @"0";
        } else {
            _complainCount = [dict objectForKey:@"totalComplaintTimes"];
        }

        _cityName = [dict objectForKey:@"cityName"];
        _provinceName = [dict objectForKey:@"provinceName"];

    }
    return self;
}


@end