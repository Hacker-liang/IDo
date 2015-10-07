//
//  Annotation.h
//  xianne
//
//  Created by fengyan on 15/4/24.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAnnotation : NSObject

@property(copy,nonatomic)NSString *sex;
@property(copy,nonatomic)NSString *lng;
@property(copy,nonatomic)NSString *lat;
@property(copy,nonatomic)NSString *level;
@property(copy,nonatomic)NSString *userid;
@property(copy,nonatomic)NSString *nickName;
@property(copy,nonatomic)NSString *avatar;
@property (copy, nonatomic) NSString *subtitle;




-(id)initWithDic:(NSDictionary *)dic;

@end
