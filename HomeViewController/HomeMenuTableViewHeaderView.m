//
//  HomeMenuTableViewHeaderView.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "HomeMenuTableViewHeaderView.h"
#import "CWStarRateView.h"
@implementation HomeMenuTableViewHeaderView


+ (id)homeMenuTableViewHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeMenuTableViewHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    self.backgroundColor = APP_THEME_COLOR;
    _headerImageView.layer.cornerRadius = 35.0;
    _headerImageView.clipsToBounds = YES;
    ((CWStarRateView *)_ratingView).scorePercent = [[UserManager shareUserManager].userInfo.rating intValue]/5.0;
    ((CWStarRateView *)_ratingView).userInteractionEnabled = NO;
}

- (void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar_default.png"]];
    _nickNameLabel.text = _userInfo.nickName;
}



@end
