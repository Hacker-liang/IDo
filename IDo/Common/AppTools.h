//
//  AppTools.h
//  JinMaJia
//
//  Created by YJL on 12-5-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppTools : NSObject

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile;
+(void) hideGradientBackground:(UIView *)theView;
+(void) clearTabViewLine:(UITableView *)aView;
+(BOOL)isMunicipalities:(NSString *)provinceName;
//计算时间差
+ (NSString *) returnUploadTime:(NSString *)timeStr isCurrentDay:(BOOL)isSame;
//比较时间，是否为当天
+ (BOOL)isCurrentDay:(NSString *)timeStr;
//获取时间差 秒
+(NSInteger) compareCurrentTime:(NSString*) compareStr;
//时间戳转换时间
+(NSString *)time:(NSString *)aTime;
@end
