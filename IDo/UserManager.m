//
//  UserManager.m
//  IDo
//
//  Created by liangpengshuai on 9/24/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "UserManager.h"

@interface UserManager()


@end

@implementation UserManager

+ (UserManager *)shareUserManager
{
    static UserManager *accountManager;
    static dispatch_once_t token;
    dispatch_once(&token,^{
        //这里调用私有的initSingle方法
        accountManager = [[UserManager alloc] init];
    });
    return accountManager;
}

- (id)init
{
    if (self = [super init]) {
        [self loadUserDataFromCache];
    }
    return self;
}

- (BOOL)isLogin
{
    return self.userInfo;
}

- (void)loginOut
{
    self.userInfo = nil;
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:LoginInfoMark];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//读取配置文件，加载数据
-(void)loadUserDataFromCache
{
    id dict = [[NSUserDefaults standardUserDefaults] objectForKey:LoginInfoMark];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        _userInfo = [[UserInfo alloc] initWithJson:dict];
    }
}

//设置 用户数据
- (void)updateUserDataFromServer:(NSDictionary*)dict
{
    if (_userInfo) {
        _userInfo.userid = [dict objectForKey:@"id"];
        _userInfo.nikename = [dict objectForKey:@"nikename"];
        _userInfo.tel = [dict objectForKey:@"tel"];
        _userInfo.sex = [dict objectForKey:@"sex"];
        _userInfo.img = [NSString stringWithFormat:@"%@%@",headURL,[dict objectForKey:@"img"]];
        _userInfo.level = [dict objectForKey:@"level"];
        _userInfo.lock = [dict objectForKey:@"lock"];
        _userInfo.zhifubao = [dict objectForKey:@"zhifubao"];
        _userInfo.weixin = [dict objectForKey:@"weixin"];
    } else {
        _userInfo = [[UserInfo alloc] initWithJson:dict];
    }
   
    [self saveUserData2Cache];
}

- (void)saveUserData2Cache
{
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    [mDict setObject:_userInfo.userid forKey:@"userid"];
    [mDict setObject:_userInfo.nikename forKey:@"nikename"];
    [mDict setObject:_userInfo.tel forKey:@"tel"];
    [mDict setObject:_userInfo.sex forKey:@"sex"];
    [mDict setObject:_userInfo.img forKey:@"img"];
    [mDict setObject:_userInfo.level forKey:@"level"];
    [mDict setObject:_userInfo.lock forKey:@"lock"];
    [mDict setObject:_userInfo.zhifubao forKey:@"zhifubao"];
    [mDict setObject:_userInfo.weixin forKey:@"weixin"];
    [[NSUserDefaults standardUserDefaults] setObject:mDict forKey:LoginInfoMark];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
