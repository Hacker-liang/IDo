//
//  UserLocationManager.m
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "UserLocationManager.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface UserLocationManager () <CLLocationManagerDelegate, AMapSearchDelegate>

@property (nonatomic, copy) void (^userLocationCompletionBlock)(CLLocation *userLocation, NSString *address);
@property (nonatomic, strong) CLLocationManager* locationManager;

@property (nonatomic, strong) AMapSearchAPI *search;


@end
@implementation UserLocationManager

+ (UserLocationManager *)shareInstance
{
    static UserLocationManager *locationManager;
    static dispatch_once_t token;
    dispatch_once(&token,^{
        //这里调用私有的initSingle方法
        locationManager = [[UserLocationManager alloc] init];
    });
    return locationManager;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;

    }
    return _locationManager;
}

- (void)getUserLocationWithCompletionBlcok:(void (^) (CLLocation *userLocation, NSString *address))block
{
    _userLocationCompletionBlock = block;
    [self updateUserLocation];
}

- (void)updateUserLocation
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [self.locationManager requestAlwaysAuthorization];
    }

    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    NSString *url = @"http://restapi.amap.com/v3/assistant/coordinate/convert";
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[NSString stringWithFormat:@"%lf,%lf",  location.coordinate.longitude,  location.coordinate.latitude] forKey:@"locations"];
    [mDict setObject:@"gps" forKey:@"coordsys"];
    [mDict setObject:@"json" forKey:@"output"];
    [mDict setObject:@"1f6a71da431504fd184266684ca745eb" forKey:@"key"];

    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response) {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSInteger status = [[dict objectForKey:@"status"] integerValue];
            if (status == 1) {
                
                NSString *location = [dict objectForKey:@"locations"];
                double lng = [[[location componentsSeparatedByString:@","] firstObject] doubleValue];
                double lat = [[[location componentsSeparatedByString:@","] lastObject] doubleValue];

                _userLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];

                if ([[UserManager shareUserManager] isLogin]) {
                    [UserManager shareUserManager].userInfo.lat = _userLocation.coordinate.latitude;
                    [UserManager shareUserManager].userInfo.lng = _userLocation.coordinate.longitude;
                    
                    [[UserManager shareUserManager] saveUserData2Cache];
                    [self updateSeaverLocation];
                }
                [self.locationManager stopUpdatingLocation];

                [self getAddressByLocation:_userLocation];

            } else {
                
            }
            
        } else {
            
        }
    }];
}

- (void)updateSeaverLocation
{
    NSString *url = [NSString stringWithFormat:@"%@getapk", baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[NSString stringWithFormat:@"%lf", _userLocation.coordinate.latitude] forKey:@"lat"];
    [mDict setObject:[NSString stringWithFormat:@"%lf", _userLocation.coordinate.longitude] forKey:@"lng"];
    [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];

    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response) {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            if ([[dict objectForKey:@"status"] integerValue] == 30001 || [[dict objectForKey:@"status"] integerValue] == 30002) {
                if ([UserManager shareUserManager].isLogin) {
                                        [UserManager shareUserManager].userInfo = nil;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"info"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoError" object:nil];
                    }];
                }
                return;
            }
            NSInteger status = [[dict objectForKey:@"status"] integerValue];
            if (status == 1) {
              
            } else {
              
            }
            
        } else {
            
        }
    }];
}


//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        AMapReGeocode *regeoCode = response.regeocode;
        NSString *address = regeoCode.formattedAddress;
        _userCityCode = regeoCode.addressComponent.citycode;
        _userCityName = regeoCode.addressComponent.city;
        _userProvinceName = regeoCode.addressComponent.province;
        if (!_userCityName) {
            _userCityName = _userProvinceName;
        }
        _districtid = regeoCode.addressComponent.adcode;
        
        if ([[UserManager shareUserManager] isLogin]) {
            [UserManager shareUserManager].userInfo.address = address;
            [UserManager shareUserManager].userInfo.districtid = regeoCode.addressComponent.adcode;
           
            if (_userCityName) {
                [UserManager shareUserManager].userInfo.cityName = _userCityName;
            } else {
                [UserManager shareUserManager].userInfo.cityName = _userProvinceName;
            }
            [UserManager shareUserManager].userInfo.provinceName = _userProvinceName;

            [[UserManager shareUserManager] saveUserData2Cache];

        }
        if (_userLocationCompletionBlock) {
            NSLog(@"%@", address);
            _userLocationCompletionBlock(_userLocation, address);
        }

    }
}
- (void)getAddressByLocation:(CLLocation *)location
{
    [AMapSearchServices sharedServices].apiKey = @"6a7ece2e9426d1dba4deea411bf64dcc";
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeo];
}

@end
