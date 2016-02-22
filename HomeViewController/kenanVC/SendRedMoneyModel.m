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
//        NSLog(@"派出的红包信息%@",json);
        
        _redId=[json objectForKey:@"redId"];
        _money=[json objectForKey:@"money"];
        _grabCount=[json objectForKey:@"grabCount"];
        _totalCount=[json objectForKey:@"totalCount"];
        _moneyGrab=[json objectForKey:@"moneyGrab"];
        int redStatus=[[json objectForKey:@"status"] intValue];
        switch (redStatus) {
            case 0:
                _status=@"已领取";
                break;
            case 1:
                _status=@"已过期";
                break;
            case 2:
                _status=@"已完成";
                break;
                
            default:
                break;
        }
        
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
