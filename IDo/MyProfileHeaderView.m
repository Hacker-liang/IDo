//
//  MyProfileHeaderView.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "MyProfileHeaderView.h"

@implementation MyProfileHeaderView

+ (id)myProfileHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MyProfileHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    CGFloat width = kWindowWidth/3;
    UIView *spaceView1 = [[UIView alloc] initWithFrame:CGRectMake(width, 8, 0.5, _sendOrderCountBtn.bounds.size.height-16)];
    spaceView1.backgroundColor = [UIColor grayColor];
    [_sendOrderCountBtn addSubview:spaceView1];
    
    UIView *spaceView2 = [[UIView alloc] initWithFrame:CGRectMake(width, 8, 0.5, _sendOrderCountBtn.bounds.size.height-16)];
    spaceView2.backgroundColor = [UIColor grayColor];
    [_grabOrderCountBtn addSubview:spaceView2];
    
    UIView *spaceView3 = [[UIView alloc] initWithFrame:CGRectMake(width, 8, 0.5, _sendOrderCountBtn.bounds.size.height-16)];
    spaceView3.backgroundColor = [UIColor grayColor];
    [_complainBtn addSubview:spaceView3];
    
}
@end
