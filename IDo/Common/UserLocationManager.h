//
//  UserLocationManager.h
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface UserLocationManager : NSObject

@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, copy) NSString *userAddress;
@property (nonatomic, copy) NSString *userCityCode;


+ (UserLocationManager *)shareInstance;

- (void)getUserLocationWithCompletionBlcok:(void (^) (CLLocation *userLocation, NSString *address))block;

@end
