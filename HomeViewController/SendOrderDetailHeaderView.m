//
//  SendOrderDetailHeaderView.m
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "SendOrderDetailHeaderView.h"
#import "FYAnnotationView.h"
#import "FYAnnotation.h"
#import "MyAnnotation.h"
#import <MapKit/MapKit.h>

@interface SendOrderDetailHeaderView ()<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) NSMutableArray *annotationList;



@end

@implementation SendOrderDetailHeaderView

+ (id)sendOrderDetailHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SendOrderDetailHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    _city = @"beijing";
    _mapView.delegate = self;
    _vipContentView.hidden = YES;
    _locationBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _vipAvatarImageView.layer.cornerRadius = 19;
    _vipAvatarImageView.clipsToBounds = YES;
    _locationBtn.titleLabel.numberOfLines = 0;
    _myLocationBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    _myLocationBtn.layer.cornerRadius = 5.0;
    _myLocationBtn.clipsToBounds = YES;
    [_myLocationBtn addTarget:self action:@selector(showUserLocation) forControlEvents:UIControlEventTouchUpInside];
    
    UserLocationManager *locationManager = [UserLocationManager shareInstance];
    _lat = [UserManager shareUserManager].userInfo.lat;
    _lng = [UserManager shareUserManager].userInfo.lng;
    _address = [UserManager shareUserManager].userInfo.address;
    _missionLocation = CLLocationCoordinate2DMake(_lat, _lng);

    [_locationBtn setTitle:_address forState:UIControlStateNormal];
    
//    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
////    tg.icon = @"ic_location_marker.png";
//    ann.coordinate = _missionLocation;
//    [self.mapView addAnnotation:ann];

    [self adjustMapViewWithLocation:_missionLocation];
    
    [locationManager getUserLocationWithCompletionBlcok:^(CLLocation *userLocation, NSString *address) {
        [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        self.mapView.showsUserLocation = YES;
        NSLog(@"%@", self.mapView.userLocation);
        _lat = userLocation.coordinate.latitude;
        _lng = userLocation.coordinate.longitude;
        _address = address;
        _city = locationManager.userCityCode;
        [_locationBtn setTitle:_address forState:UIControlStateNormal];
        [_locationBtn setTitle:address forState:UIControlStateNormal];
        _missionLocation = userLocation.coordinate;
    }];
}

- (void)showUserLocation
{
    [self adjustMapViewWithLocation: CLLocationCoordinate2DMake([UserManager shareUserManager].userInfo.lat, [UserManager shareUserManager].userInfo.lng)];
}

- (void)setUserList:(NSMutableArray *)userList
{
    _userList = userList;
    [self datouzhen];
}

- (void)adjustMapViewWithLocation:(CLLocationCoordinate2D)location
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
    MKCoordinateRegion region = MKCoordinateRegionMake(location,span);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
    [_mapView setRegion:adjustedRegion animated:YES];
}


#pragma mark getWoGanUserdata 在地图上显示自定义的大头针模型
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(FYAnnotation *)annotation
{
    //    返回nil就会按照系统的默认做法
    if (![annotation isKindOfClass:[FYAnnotation class]]) return nil;
    //        1.获得大头针控件
    FYAnnotationView *annoView=[FYAnnotationView annotationViewWithMapView:self.mapView];
    //        2.传递模型
    annoView.annotation=annotation;

    NSInteger tag = [self.annotationList indexOfObject:annotation];
    annoView.tag = tag;
    return annoView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"view tag: %ld", view.tag);
    if (view.tag > _userList.count-1) {
        return;
    }
    MyAnnotation *an = _userList[view.tag];
    if ([an.level integerValue] == 1) {
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"向 VIP 用户指定派单" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            _vipAnnotation = an;
            _vipContentView.hidden = NO;
            [_vipAvatarImageView sd_setImageWithURL:[NSURL URLWithString: an.avatar] placeholderImage:[UIImage imageNamed:@"Icon"]];
            _nickNameLabel.text = an.nickName;
            _subtitleLabel.text = an.subtitle;
            NSString *sex = an.sex;
            if ([sex isEqualToString:@"1"] || [sex isEqualToString:@"0"]) {
                [_vipSexImageView setImage:[UIImage imageNamed:@"icon_male.png"]];
            } else {
                [_vipSexImageView setImage:[UIImage imageNamed:@"icon_female.png"]];
            }

        }
    }];
}

#pragma mark datouzhen 设置 大头针

-(void)datouzhen
{
    [self.mapView.layer removeAllAnimations];
    [self.mapView removeOverlays:self.mapView.overlays];;
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    _annotationList = [[NSMutableArray alloc] init];
    for (MyAnnotation *an in self.userList)
    {
        FYAnnotation *tg=[[FYAnnotation alloc]init];
        [_annotationList addObject:tg];
        
        if ( ([an.sex isEqualToString:@"1"] || [an.sex isEqualToString:@"0"]) &&[an.level isEqualToString:@"1"])
        {
            tg.icon=@"men1.png";
        }
        else if (([an.sex isEqualToString:@"1"] || [an.sex isEqualToString:@"0"])&&[an.level isEqualToString:@"2"])
        {
            tg.icon=@"men_vip1.png";
        }
        else if ([an.sex isEqualToString:@"2"] && [an.level isEqualToString:@"1"])
        {
            tg.icon=@"MYwomen.png";
        }
        else if ([an.sex isEqualToString:@"2"]&&[an.level isEqualToString:@"2"])
        {
            tg.icon=@"MYwomen_vip1.png";
        }
        tg.coordinate=CLLocationCoordinate2DMake([an.lat doubleValue], [an.lng doubleValue]);
        [self.mapView addAnnotation:tg];
    }
 
    FYAnnotation *tg=[[FYAnnotation alloc]init];
    tg.icon = @"ic_location_marker.png";
    tg.coordinate = _missionLocation;
    [self.mapView addAnnotation:tg];
    
    [self adjustMapViewWithLocation:_missionLocation];
}

@end
