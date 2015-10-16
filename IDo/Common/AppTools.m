//
//  AppTools.m
//  JinMaJia
//
//  Created by YJL on 12-5-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AppTools.h"

@implementation AppTools

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
//    
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    
//    NSString * CT = @"^1((77|33|53|8[09])[0-9]|349)\\d{7}$";
//    
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    if (([regextestmobile evaluateWithObject:mobile] == YES)
//        || ([regextestcm evaluateWithObject:mobile] == YES)
//        || ([regextestct evaluateWithObject:mobile] == YES)
//        || ([regextestcu evaluateWithObject:mobile] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
    NSString *regex = @"^1\\d{10}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([regextestmobile evaluateWithObject:mobile] == YES) {
        return YES;
    }
    return NO;

}

//替换UIWebView背景
+(void) hideGradientBackground:(UIView*)theView
{
    for (UIView * subview in theView.subviews)
    {
        if ([subview isKindOfClass:[UIImageView class]])
            subview.hidden = YES;
        
        [self hideGradientBackground:subview];
    }
}

+(void) clearTabViewLine:(UITableView*)aView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [aView setTableFooterView:view];
    [aView setTableHeaderView:view];
}

//判断是否直辖市
#pragma mark currentlocation
+(BOOL)isMunicipalities:(NSString *)provinceName
{
    if ([provinceName rangeOfString:@"北京" options:NSCaseInsensitiveSearch].length>0 || [provinceName rangeOfString:@"天津" options:NSCaseInsensitiveSearch].length>0 || [provinceName rangeOfString:@"上海" options:NSCaseInsensitiveSearch].length>0 || [provinceName rangeOfString:@"重庆" options:NSCaseInsensitiveSearch].length>0) {
        return YES;
    }
    return NO;
    
}

/*比较与当前时间是否为同一天*/
+ (BOOL)isCurrentDay:(NSString *)timeStr
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:timeStr];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:d];
    NSDate *otherDate = [cal dateFromComponents:components];
    if([today isEqualToDate:otherDate])
        return YES;
    
    return NO;
}

/*处理返回应该显示的时间*/
+ (NSString *) returnUploadTime:(NSString *)timeStr isCurrentDay:(BOOL)isSame
{
    //Tue May 21 10:56:45 +0800 2013
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:timeStr];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha= late - now;
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    
    if(isSame){
        if (cha/86400<1) {
            timeString = [NSString stringWithFormat:@"今天 %@",[dateformatter stringFromDate:d]];
        }
    }else{
        timeString = [NSString stringWithFormat:@"明天 %@",[dateformatter stringFromDate:d]];
    }
    
    if (cha/86400>1&&cha/86400<2)
    {
        timeString = [NSString stringWithFormat:@"明天 %@",[dateformatter stringFromDate:d]];
    }
    if (cha/86400>2 && cha/86400<3)
    {
        timeString = [NSString stringWithFormat:@"后天 %@",[dateformatter stringFromDate:d]];
        
    }
    
    return timeString;
}

//时间差
+(NSInteger) compareCurrentTime:(NSString*) compareStr
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * senddate=[NSDate date];
    //结束时间
    NSDate *endDate = [dateFormatter dateFromString:compareStr];
    //当前时间
    NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
    //得到相差秒数
    NSTimeInterval time=[senderDate timeIntervalSinceDate:endDate];
    NSInteger Seconds = (int)time;
    return Seconds;
}

//时间戳转换
+(NSString *)time:(NSString *)aTime
{
    double lastactivityInterval = [aTime doubleValue];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
    
    
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}
@end
