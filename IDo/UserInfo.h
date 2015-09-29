//
//  UserInfo.h
//  WisdomHear
//
//  Created by Tan Anzhen on 11-9-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//工具类，用于读取配置文件

#import <Foundation/Foundation.h>


@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *userLabel;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *lock;
@property (nonatomic, copy) NSString *zhifubao;
@property (nonatomic, copy) NSString *weixin;
@property (nonatomic, copy) NSString *grabOrderCount;
@property (nonatomic, copy) NSString *sendOrderCount;
@property (nonatomic, copy) NSString *complainCount;
@property (assign,nonatomic)double lat;
@property (assign,nonatomic)double lng;
@property (assign,nonatomic)double tasklat;
@property (assign,nonatomic)double tasklng;

@property (nonatomic, copy) NSString *cityname;
@property (nonatomic, copy) NSString *provincename;

- (id)initWithJson:(id)json;

@end

