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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderDetail:(OrderDetailModel *)orderDetail
{
    _orderDetail = orderDetail;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_orderDetail.userInfo.avatar] placeholderImage:[UIImage imageNamed:@"icon_avatar_default.png"]];
    _timeLabel.text = _orderDetail.userInfo.nickName;
    _timeLabel.text = _orderDetail.tasktime;
    _contentLabel.text = _orderDetail.content;
    [_addressBtn setTitle:_orderDetail.address forState:UIControlStateNormal];
}

@end
