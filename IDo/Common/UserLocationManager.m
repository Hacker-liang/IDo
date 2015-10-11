//
//  UserLocationManager.m
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "UserLocationManager.h"

@interface UserLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, copy) void (^userLocationCompletionBlock)(CLLocation *userLocation, NSString *address);
@property (nonatomic, strong) CLLocationManager* locationManager;

@property (nonatomic, strong) CLGeocoder *geocoder;


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

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)getUserLocationWithCompletionBlcok:(void (^) (CLLocation *userLocation, NSString *address))block
{
    _userLocationCompletionBlock = block;
    [self updateUserLocation];
}

- (void)updateUserLocation
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    _userLocation = location;
    if ([[UserManager shareUserManager] isLogin]) {
        [UserManager shareUserManager].userInfo.lat = location.coordinate.latitude;
        [UserManager shareUserManager].userInfo.lng = location.coordinate.longitude;
        
        [[UserManager shareUserManager] saveUserData2Cache];
        [self updateSeaverLocation];
    }

    [self.locationManager stopUpdatingLocation];
    [self getAddressByLocation:_userLocation];
}

- (void)updateSeaverLocation
{
    NSString *url = [NSString stringWithFormat:@"%@getapk", baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[NSString stringWithFormat:@"%lf", _userLocation.coordinate.latitude] forKey:@"lat"];
    [mDict setObject:[NSString stringWithFormat:@"%lf", _userLocation.coordinate.longitude] forKey:@"lng"];
    [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];

    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response) {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSInteger status = [[dict objectForKey:@"status"] integerValue];
            if (status == 1) {
              
            } else {
              
            }
            
        } else {
            
        }
    }];
}

- (void)getAddressByLocation:(CLLocation *)location
{
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        
        NSDictionary *dic = placemark.addressDictionary;
        NSString *address = placemark.name;
        NSString *addressTwo = [NSString stringWithFormat:@"%@%@%@", dic[@"City"], dic[@"SubLocality"], dic[@"Street"]];

        _userCityCode = dic[@"City"];
        if ([[UserManager shareUserManager] isLogin]) {
            [UserManager shareUserManager].userInfo.lat = location.coordinate.latitude;
            [UserManager shareUserManager].userInfo.lng = location.coordinate.longitude;
            if (address.length > addressTwo.length) {
                [UserManager shareUserManager].userInfo.address = address;
            } else {
                [UserManager shareUserManager].userInfo.address = addressTwo;
            }
            [[UserManager shareUserManager] saveUserData2Cache];
        }
        
        if (_userLocationCompletionBlock) {
            _userLocationCompletionBlock(_userLocation, [UserManager shareUserManager].userInfo.address);
        }
    }];
}

@end
