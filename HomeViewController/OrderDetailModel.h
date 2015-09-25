//
//  OrderDetailModel.h
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

@property(copy, nonatomic) NSString *address; //地址
@property(copy, nonatomic) NSString *lng;
@property(copy, nonatomic) NSString *lat;
@property(copy, nonatomic) NSString *content;  //内容
@property(copy, nonatomic) NSString *price;    //价格
@property(copy, nonatomic) NSString *tasktime; //系统传输时间
@property(copy, nonatomic) NSString *sex;      //性别
@property(copy, nonatomic) NSString *distance; //范围

@end
