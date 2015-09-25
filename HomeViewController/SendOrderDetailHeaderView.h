//
//  SendOrderDetailHeaderView.h
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SendOrderDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

+ (id)sendOrderDetailHeaderView;

@end
