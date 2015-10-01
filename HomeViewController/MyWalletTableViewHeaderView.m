//
//  MyWalletTableViewHeaderView.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "MyWalletTableViewHeaderView.h"

@implementation MyWalletTableViewHeaderView

+ (id)myWalletTableViewHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MyWalletTableViewHeaderView" owner:nil options:nil] lastObject];
}


- (void)awakeFromNib
{
    CGFloat width = kWindowWidth/3;
    UIView *spaceView1 = [[UIView alloc] initWithFrame:CGRectMake(width, 8, 0.5, _accountRemainingBtn.bounds.size.height-16)];
    spaceView1.backgroundColor = [UIColor grayColor];
    [_accountRemainingBtn addSubview:spaceView1];
    
     UIView *spaceView2 = [[UIView alloc] initWithFrame:CGRectMake(width, 8, 0.5, _accountRemainingBtn.bounds.size.height-16)];
    spaceView2.backgroundColor = [UIColor grayColor];
    [_totalExpendBtn addSubview:spaceView2];
    
     UIView *spaceView3 = [[UIView alloc] initWithFrame:CGRectMake(width, 8, 0.5, _accountRemainingBtn.bounds.size.height-16)];
    spaceView3.backgroundColor = [UIColor grayColor];
    [_cashBtn addSubview:spaceView3];

    _cashBtn.titleLabel.numberOfLines = 0;
    _totalExpendBtn.titleLabel.numberOfLines = 0;
    _accountRemainingBtn.titleLabel.numberOfLines = 0;


}

@end
