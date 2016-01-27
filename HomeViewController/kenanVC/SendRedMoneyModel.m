//
//  SendRedMoneyModel.m
//  IDo
//
//  Created by 柯南 on 16/1/18.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "SendRedMoneyModel.h"

@implementation SendRedMoneyModel

-(id)initWithJson:(id)json
{
    self=[super init];
    if (self) {
        _redId=[json objectForKey:@"redId"];
        _money=[json objectForKey:@"money"];
        _grabCount=[json objectForKey:@"grabCount"];
        _totalCount=[json objectForKey:@"totalCount"];
        _moneyGrab=[json objectForKey:@"moneyGrab"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
        double resultTime=[[NSString stringWithFormat:@"%@",[json objectForKey:@"createTime"]] doubleValue]/1000;
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:resultTime];
        NSString *confromTimeStr=[formatter stringFromDate:date];
        
        NSString *time=[confromTimeStr substringWithRange:NSMakeRange(5, 12)];

        _createTime=time;
        }
    return self;
}
@end
