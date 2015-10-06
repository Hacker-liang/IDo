//
//  ConvertMethods.m
//  lvxingpai
//
//  Created by Luo Yong on 14-6-25.
//  Copyright (c) 2014年 aizou. All rights reserved.
//

#import "ConvertMethods.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ConvertMethods

+ (CLLocationDistance) getDistanceFrom:(CLLocationCoordinate2D)startPoint to:(CLLocationCoordinate2D)endPoint {
    MKMapPoint point1 = MKMapPointForCoordinate(startPoint);
    MKMapPoint point2 = MKMapPointForCoordinate(endPoint);
    return MKMetersBetweenMapPoints(point1,point2);
}

+ (NSDate *) stringToDate:(NSString *)string withFormat:(NSString *)format withTimeZone:(NSTimeZone *)zone {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format]; //@"HH:mm:ss"
    [dateFormatter setTimeZone:zone];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}


+ (NSString *)getCurrentDataWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)getCuttentData
{
    return [ConvertMethods getCurrentDataWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *) dateToString:(NSDate *)date withFormat:(NSString *)format withTimeZone:(NSTimeZone *)zone {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:zone];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *) timeIntervalToString:(long long)interval withFormat:(NSString *)format withTimeZone:(NSTimeZone *)zone
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    [dateFormatter setTimeZone:zone];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (UIImage*) createImageWithColor: (UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIColor *)RGBColor:(int)rgb withAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:alpha];
}

+ (NSString *)generateQiniuImageUrl: (NSString *)url width:(int)w height:(int)h {
    //客户端不再对图片进行处理，显示的图片内容（尺寸等）完全有服务器来定夺。
//    return [NSString stringWithFormat:@"%@?imageView/1/w/%d/h/%d/q/80/format/jpg/interlace/1", url, 2*w, 2*h];
    return url;
}

+ (NSArray *)mapPlatformInPhone
{
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://com.autonavi.amap"]]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@"高德地图" forKey:@"platform"];
        [dic setObject:[NSNumber numberWithInteger:kAMap] forKey:@"type"];
        [retArray addObject:dic];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://com.baidu.map"]]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@"百度地图" forKey:@"platform"];
        [dic setObject:[NSNumber numberWithInteger:kBaiduMap] forKey:@"type"];
        [retArray addObject:dic];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"苹果自带地图" forKey:@"platform"];
    [dic setObject:[NSNumber numberWithInteger:kAppleMap] forKey:@"type"];
    [retArray addObject:dic];
    return retArray;
}

+ (void)jumpBaiduMapAppWithPoiName:(NSString *)poiName lat:(double)lat lng:(double)lng
{
    NSString *urlStr = [[NSString stringWithFormat:@"baidumap://map/marker?location=%f,%f&title=%@&coord_type=gcj02&content=%@&src=taozi",lat, lng, poiName, poiName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}

+ (void)jumpGaodeMapAppWithPoiName:(NSString *)poiName lat:(double)lat lng:(double)lng
{
    NSString *urlStr = [[NSString stringWithFormat:@"iosamap://viewMap?sourceApplication=PeachTravel&backScheme=taozi0601&poiname=%@&lat=%f&lon=%f&dev=1",poiName, lat, lng] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }

}

+ (void)jumpAppleMapAppWithPoiName:(NSString *)poiName lat:(double)lat lng:(double)lng
{
    CLLocationCoordinate2D from;
    from.latitude = lat;
    from.longitude = lng;
    
    MKMapItem *currentLocation;
    if (from.latitude != 0.0) {
        currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:from addressDictionary:nil]];
        currentLocation.name = poiName;
    }
    
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, nil] launchOptions:nil];
}


+ (NSString *)sha1:(NSString *)str
{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

@end
