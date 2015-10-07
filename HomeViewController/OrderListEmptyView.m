//
//  OrderListEmptyView.m
//  IDo
//
//  Created by liangpengshuai on 10/8/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "OrderListEmptyView.h"

@implementation OrderListEmptyView

- (id)initWithFrame:(CGRect)frame andContent:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-70)/2, 0, 70, 70)];
        imageView.image = [UIImage imageNamed:@"icon_empty.png"];
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + 90, frame.size.width, 30)];
        label.textColor = [UIColor grayColor];
        label.text = title;
        label.font = [UIFont systemFontOfSize:15.0];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}

@end
