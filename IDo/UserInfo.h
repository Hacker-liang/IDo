//
//  UserInfo.h
//  WisdomHear
//
//  Created by Tan Anzhen on 11-9-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//工具类，用于读取配置文件

#import <Foundation/Foundation.h>


@interface UserInfo : NSObject

@property (nonatomic ,strong) NSString *userid;
@property (nonatomic ,strong) NSString *nickName;
@property (nonatomic ,strong) NSString *tel;
@property (nonatomic ,strong) NSString *sex;
@property (nonatomic ,strong) NSString *avatar;
@property (nonatomic ,strong) NSString *address;

@property (nonatomic ,strong) NSString *level;
@property (nonatomic ,strong) NSString *lock;
@property (nonatomic ,strong) NSString *zhifubao;
@property (nonatomic ,strong) NSString *weixin;

@property (assign,nonatomic)double lat;
@property (assign,nonatomic)double lng;
@property (assign,nonatomic)double tasklat;
@property (assign,nonatomic)double tasklng;

@property (assign,nonatomic)double tastlat;
@property (assign,nonatomic)double tastlng;
@property (nonatomic ,strong) NSString *taskAddress;

@property (nonatomic ,strong) NSString *cityname;
@property (nonatomic ,strong) NSString *provincename;

- (id)initWithJson:(id)json;

@end

