//
//  SendOrderDetailHeaderView.m
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "SendOrderDetailHeaderView.h"

@interface SendOrderDetailHeaderView ()<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *currentLocation;

@end

@implementation SendOrderDetailHeaderView

+ (id)sendOrderDetailHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SendOrderDetailHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    _mapView.delegate = self;
    UserLocationManager *locationManager = [UserLocationManager shareInstance];
    [locationManager getUserLocationWithCompletionBlcok:^(CLLocation *userLocation, NSString *address) {
        [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        self.mapView.showsUserLocation = YES;
        _orderDetailModel.lat = [NSString stringWithFormat:@"%lf", userLocation.coordinate.latitude];
        _orderDetailModel.lng = [NSString stringWithFormat:@"%lf", userLocation.coordinate.longitude];
        _orderDetailModel.address = address;
        [_locationBtn setTitle:address forState:UIControlStateNormal];
        [self adjustMapViewWithLocation:userLocation.coordinate];
    }];
}

- (void)adjustMapViewWithLocation:(CLLocationCoordinate2D)location
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(location,span);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
    [_mapView setRegion:adjustedRegion animated:YES];
}


@end
