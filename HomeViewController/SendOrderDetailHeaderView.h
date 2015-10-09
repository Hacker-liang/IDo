//
//  SendOrderDetailHeaderView.h
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "OrderDetailModel.h"
#import "MyAnnotation.h"

@interface SendOrderDetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *myLocationBtn;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@property (weak, nonatomic) IBOutlet UIView *vipContentView;
@property (weak, nonatomic) IBOutlet UIImageView *vipAvatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vipSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, strong) MyAnnotation *vipAnnotation;

@property (nonatomic, strong) NSMutableArray *userList;

@property (nonatomic) CLLocationCoordinate2D missionLocation;

@property (nonatomic, strong) NSString *city;

@property (nonatomic) double lat;
@property (nonatomic) double lng;
@property (nonatomic, copy) NSString *address;

+ (id)sendOrderDetailHeaderView;

-(void)datouzhen;

@end
