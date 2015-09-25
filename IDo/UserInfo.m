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
        _avatar = [NSString stringWithFormat:@"%@%@",headURL,[dict objectForKey:@"img"]];
        _level = [dict objectForKey:@"level"];
        _lock = [dict objectForKey:@"lock"];
        _zhifubao = [dict objectForKey:@"zhifubao"];
        _weixin = [dict objectForKey:@"weixin"];
    }
    return self;
}

@end