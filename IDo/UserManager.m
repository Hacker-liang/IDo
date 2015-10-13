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
    return self.userInfo != nil;
}

- (void)asyncLogout:(void (^)(BOOL))completion
{
    NSString *url = [NSString stringWithFormat:@"%@editMemberLoginStatus",baseUrl];

    NSMutableDictionary *mDict=  [[NSMutableDictionary alloc] init];
    [mDict safeSetObject:_userInfo.userid forKey:@"memberid"];
    [mDict setObject:@"0" forKey:@"content"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response) {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSInteger status = [[dict objectForKey:@"status"] integerValue];
            if (status == 1) {
                self.userInfo = nil;
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:LoginInfoMark];
                [[NSUserDefaults standardUserDefaults] synchronize];
                completion(YES);

            } else {
                if (completion) {
                    completion(NO);
                }
            }
            
        } else {
            if (completion) {
                completion(NO);
            }
            
        }
    }];
}

- (void)setNotiMute:(BOOL)isMute
{
    _userInfo.isMute = isMute;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isMute] forKey:[NSString stringWithFormat:@"%@_isMute", _userInfo.userid]];
}

//读取配置文件，加载数据
-(void)loadUserDataFromCache
{
    id dict = [[NSUserDefaults standardUserDefaults] objectForKey:LoginInfoMark];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        _userInfo = [[UserInfo alloc] initWithJson:dict];
        _userInfo.isMute = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_isMute", _userInfo.userid]] boolValue];

        [[UserLocationManager shareInstance] getUserLocationWithCompletionBlcok:^(CLLocation *userLocation, NSString *address) {
            _userInfo.address = address;
            _userInfo.lat = userLocation.coordinate.latitude;
            _userInfo.lng = userLocation.coordinate.longitude;
        }];

    }
}

//设置 用户数据
- (void)updateUserDataFromServer:(NSDictionary*)dict
{
    if (_userInfo) {
        _userInfo.userid = [dict objectForKey:@"id"];
        _userInfo.nickName = [dict objectForKey:@"nikename"];
        _userInfo.tel = [dict objectForKey:@"tel"];
        _userInfo.sex = [dict objectForKey:@"sex"];
        _userInfo.avatar = [NSString stringWithFormat:@"%@%@",headURL,[dict objectForKey:@"img"]];
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
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    [mDict safeSetObject:_userInfo.userid forKey:@"id"];
    [mDict safeSetObject:_userInfo.nickName forKey:@"nikename"];
    [mDict safeSetObject:_userInfo.tel forKey:@"tel"];
    [mDict safeSetObject:_userInfo.sex forKey:@"sex"];
    [mDict safeSetObject:_userInfo.avatar forKey:@"img"];
    [mDict safeSetObject:_userInfo.level forKey:@"level"];
    [mDict safeSetObject:_userInfo.lock forKey:@"lock"];
    [mDict safeSetObject:_userInfo.zhifubao forKey:@"zhifubao"];
    [mDict safeSetObject:_userInfo.weixin forKey:@"weixin"];
    [mDict safeSetObject:_userInfo.rating forKey:@"star"];
    [mDict safeSetObject:_userInfo.districtid forKey:@"districtid"];
    [mDict safeSetObject:_userInfo.sendOrderCount forKey:@"fadannumber"];
    [mDict safeSetObject:_userInfo.grabOrderCount forKey:@"jiedannumber"];
    [mDict safeSetObject:_userInfo.complainCount forKey:@"totalComplaintTimes"];
    [mDict safeSetObject:_userInfo.cityName forKey:@"cityName"];
    [mDict safeSetObject:_userInfo.provinceName forKey:@"provinceName"];

    if (_userInfo.isMute) {
        [mDict setObject:@"1" forKey:@"isMute"];
    } else {
        [mDict setObject:@"0" forKey:@"isMute"];
    }
    [mDict safeSetObject:[NSNumber numberWithFloat:_userInfo.lat] forKey:@"lat"];
    [mDict safeSetObject:[NSNumber numberWithFloat:_userInfo.lng] forKey:@"lng"];
    [[NSUserDefaults standardUserDefaults] setObject:mDict forKey:LoginInfoMark];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
