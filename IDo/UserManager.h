//
//  UserManager.h
//  IDo
//
//  Created by liangpengshuai on 9/24/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

@property (nonatomic, strong) UserInfo *userInfo;

+ (UserManager *)shareUserManager;

- (BOOL)isLogin;

- (void)updateUserDataFromServer:(NSDictionary*)dict;

@end
