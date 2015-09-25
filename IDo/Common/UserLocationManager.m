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
    NSLog(@"latitude纬度: %f, longitude经度: %f",location.coordinate.latitude, location.coordinate.longitude);
    [self.locationManager stopUpdatingLocation];
    [self getAddressByLocation:_userLocation];
}

- (void)getAddressByLocation:(CLLocation *)location
{
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSString *address = placemark.locality;
        if (_userLocationCompletionBlock) {
            _userLocationCompletionBlock(_userLocation, address);
        }
    }];
}

@end
