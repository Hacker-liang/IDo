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
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_orderDetail.userInfo.avatar] placeholderImage:[UIImage imageNamed:@"icon_avatar_default.png"]];
    _titleLabel.text = _orderDetail.userInfo.nickName;
    _subtitleLabel.text = _orderDetail.userInfo.userLabel;
    _timeLabel.text = _orderDetail.tasktime;
    _contentLabel.text = _orderDetail.content;
    _priceLabel.text = [NSString stringWithFormat:@"%@元", _orderDetail.price];
    _orderStatusLabel.text = _orderDetail.statusDesc;
    [_addressBtn setTitle:_orderDetail.address forState:UIControlStateNormal];
}

@end
