//
//  MissOrderModel.h
//  IDo
//
//  Created by liangpengshuai on 1/3/16.
//  Copyright © 2016 com.Yinengxin.xianne. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MissOrderModelUser;

@interface MissOrderModel : NSObject

@property(copy, nonatomic) NSString *orderId;
@property(copy, nonatomic) NSString *orderNumber;
@property(copy, nonatomic) NSString *address; //地址
@property(copy, nonatomic) NSString *lng;
@property(copy, nonatomic) NSString *lat;
@property(copy, nonatomic) NSString *content;  //内容
@property(copy, nonatomic) NSString *money;
@property(copy, nonatomic) NSString *publishTime;
@property(copy, nonatomic) NSString *updateTime;

@property (nonatomic, copy) NSString *orderStatusDesc;  //订单状态的描述
@property (nonatomic, strong) MissOrderModelUser *orderSender;  //发单人

- (id)initWithJson:(id)json;

@end


@interface MissOrderModelUser : NSObject

@property(copy, nonatomic) NSString *nickName;
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger sex;
@property(copy, nonatomic) NSString *avatar;
@property(nonatomic) NSInteger sendOrderCount;

@end
