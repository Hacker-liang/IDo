//
//  FYAnnotationView.m
//  闲人帮
//
//  Created by fengyan on 15/3/31.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "FYAnnotationView.h"
#import "FYAnnotation.h"
//#import "UIView+Extension.h"

@interface FYAnnotationView ()
@end

@implementation FYAnnotationView
+ (instancetype)annotationViewWithMapView:(MKMapView *)mapView
{
    static NSString *ID = @"anno";
    FYAnnotationView *annotationView = (FYAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annotationView == nil) {
        // 传入循环利用标识来创建大头针控件
        annotationView = [[FYAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }
    return annotationView;
}

- (void)setAnnotation:(FYAnnotation *)annotation
{
    [super setAnnotation:annotation];
    
    self.image = [UIImage imageNamed:annotation.icon];
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    if (CGRectContainsPoint(self.redView.frame, point)) {
//        return self.redView;
//    }
//    return [super hitTest:point withEvent:event];
//}
@end
