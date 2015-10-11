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
        if ([[dict objectForKey:@"img"] containsString:@"http"]) {
            _avatar = [dict objectForKey:@"img"];
        } else {
            _avatar = [NSString stringWithFormat:@"%@%@",headURL,[dict objectForKey:@"img"]];
        }
        _level = [dict objectForKey:@"level"];
        _lock = [dict objectForKey:@"lock"];
        _zhifubao = [dict objectForKey:@"zhifubao"];
        _weixin = [dict objectForKey:@"weixin"];
        _userLabel = [dict objectForKey:@"label"];
        _lat = [[dict objectForKey:@"lat"] doubleValue];
        _lng = [[dict objectForKey:@"lng"] doubleValue];
        _adcode = [dict objectForKey:@"adcode"];
       
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

        _isMute = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_isMute", _userid]] boolValue];

    }
    return self;
}

- (void)setIsMute:(BOOL)isMute
{
    _isMute = isMute;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_isMute] forKey:[NSString stringWithFormat:@"%@_isMute", _userid]];
}
@end