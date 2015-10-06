//
//  FYAnnotation.h
//  闲人帮
//
//  Created by fengyan on 15/3/31.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FYAnnotation : NSObject<MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *icon;
@end
