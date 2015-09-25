//
//  HomeMenuTableViewHeaderView.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "HomeMenuTableViewHeaderView.h"

@implementation HomeMenuTableViewHeaderView


+ (id)homeMenuTableViewHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeMenuTableViewHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    self.backgroundColor = APP_THEME_COLOR;
}

- (void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] placeholderImage:[UIImage imageNamed:@"icon_avatar_default.png"]];
    _nickNameLabel.text = _userInfo.nickName;
}



@end
