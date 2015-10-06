//
//  FYAnnotationView.h
//  闲人帮
//
//  Created by fengyan on 15/3/31.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface FYAnnotationView : MKAnnotationView
+ (instancetype)annotationViewWithMapView:(MKMapView *)mapView;
@end
