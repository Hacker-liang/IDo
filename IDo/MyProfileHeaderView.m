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
    _backgroundImageView.backgroundColor = APP_THEME_COLOR;
    _headerImageView.clipsToBounds = YES;
    _headerImageView.layer.cornerRadius = 35.0;
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
    _sexImageView.hidden = !_showSexImage;
}

- (void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    _nickNameLabel.text = _userInfo.nickName;
    _ratingView.scorePercent = [_userInfo.rating intValue]/5.0;;
    _ratingView.userInteractionEnabled = NO;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar_default.png"]];
    
    {
        _sendOrderCountBtn.titleLabel.numberOfLines = 0;
        [_sendOrderCountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _sendOrderCountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        NSString *sendOrderStr = [NSString stringWithFormat:@"%@笔\n发单", _userInfo.sendOrderCount];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:sendOrderStr];
        [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25.0] range:NSMakeRange(0, attStr.length-4)];
        [_sendOrderCountBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    }
    
    {
        _grabOrderCountBtn.titleLabel.numberOfLines = 0;
        [_grabOrderCountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _grabOrderCountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        NSString *grabOrderStr = [NSString stringWithFormat:@"%@笔\n抢单", _userInfo.grabOrderCount];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:grabOrderStr];
        [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25.0] range:NSMakeRange(0, attStr.length-4)];
        [_grabOrderCountBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    }

    {
        _complainBtn.titleLabel.numberOfLines = 0;
        [_complainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _complainBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        NSString *str = [NSString stringWithFormat:@"%@笔\n被投诉", _userInfo.complainCount];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25.0] range:NSMakeRange(0, attStr.length-5)];
        [_complainBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    }
    
    NSString *sex = userInfo.sex;
    if ([sex isEqualToString:@"1"] || [sex isEqualToString:@"0"]) {
        [_sexImageView setImage:[UIImage imageNamed:@"icon_male.png"]];
    } else {
        [_sexImageView setImage:[UIImage imageNamed:@"icon_female.png"]];
    }

}

@end
