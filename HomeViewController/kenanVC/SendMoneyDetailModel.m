//
//  SendMoneyDetailModel.m
//  IDo
//
//  Created by 柯南 on 16/1/26.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "SendMoneyDetailModel.h"

@implementation SendMoneyDetailModel
-(id)initWithJson:(id)json
{
    self=[super init];
    if (self) {
        NSLog(@"红包领取详情%@",json);
        _headImage =[NSString stringWithFormat:@"%@%@",headURL,[json objectForKey:@"picture"]];
        _sexImage=[NSString stringWithFormat:@"%@",[json objectForKey:@"sex"]];
        if ([_sexImage isEqualToString:@"2"]) {
            _sexImage=@"icon_orderDetail_address@2x";
        } else {
            _sexImage=@"nan@2x";
        }
        
        _name=[json objectForKey:@"name"];
        _money=[json objectForKey:@"money"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
        double resultTime=[[NSString stringWithFormat:@"%@",[json objectForKey:@"createTime"]] doubleValue]/1000;
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:resultTime];
        NSString *confromTimeStr=[formatter stringFromDate:date];
        
        NSString *time=[confromTimeStr substringWithRange:NSMakeRange(5, 12)];
        _time=time;
        
    }
    return self;
}
@end
