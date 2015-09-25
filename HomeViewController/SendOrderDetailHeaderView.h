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

@interface SendOrderDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@property (nonatomic, strong) OrderDetailModel *orderDetailModel;

+ (id)sendOrderDetailHeaderView;

@end
