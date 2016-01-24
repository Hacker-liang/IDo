//
//  GainRedMoneyModel.m
//  IDo
//
//  Created by 柯南 on 16/1/24.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "GainRedMoneyModel.h"

@implementation GainRedMoneyModel
-(id)initWithJson:(id)json
{
    self=[super init];
    if (self) {
        _headImage =[json objectForKey:@""];
        _sexImage =[json objectForKey:@""];
        _nameLab =[json objectForKey:@""];
        _moneyLab =[json objectForKey:@""];
        _timeLab =[json objectForKey:@""];
    }
    return self;
}
@end
