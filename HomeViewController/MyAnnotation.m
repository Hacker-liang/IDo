//
//  Annotation.m
//  xianne
//
//  Created by fengyan on 15/4/24.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
-(id)initWithDic:(NSDictionary *)dic
{
    if (self=[super init])
    {
        self.sex=dic[@"sex"];
        self.level=dic[@"level"];
        self.lng=dic[@"lng"];
        self.lat=dic[@"lat"];
        self.userid=dic[@"id"];

    }
    return self;
}
@end
