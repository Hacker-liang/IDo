//
//  OrderListTableViewCell.m
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "OrderListTableViewCell.h"

@implementation OrderListTableViewCell

- (void)awakeFromNib {
    _headerImageView.layer.cornerRadius = 17.0;
    _headerImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderDetail:(OrderListModel *)orderDetail
{
    _orderDetail = orderDetail;
    UserInfo *userInfo;
    if (_isGrabOrder) {
        userInfo = _orderDetail.sendOrderUser;
    } else {
        userInfo = _orderDetail.grabOrderUser;
    }
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"icon_avatar_default.png"]];
    _titleLabel.text = userInfo.nickName;

    if (_isGrabOrder && userInfo.userid != 0) {
        _subtitleLabel.text = [NSString stringWithFormat:@"已经发送%@单", userInfo.sendOrderCount];
    } else if (userInfo.userid != 0) {
        _subtitleLabel.text = [NSString stringWithFormat:@"已经接%@单", userInfo.sendOrderCount];
    } else {
        _subtitleLabel.text = nil;
    }
    _timeLabel.text = _orderDetail.tasktime;
    _contentLabel.text = _orderDetail.content;
    _priceLabel.text = [NSString stringWithFormat:@"%@元", _orderDetail.price];
    _orderStatusLabel.text = _orderDetail.orderStatusDesc;
    [_addressBtn setTitle:_orderDetail.address forState:UIControlStateNormal];
}

@end
