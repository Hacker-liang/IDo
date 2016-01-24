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
    _orderStatusLabel.adjustsFontSizeToFitWidth = YES;
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
        if (_orderDetail.sendOrderUser) {
            userInfo = _orderDetail.sendOrderUser;
        } else {
            userInfo = _orderDetail.member;
        }
    } else {
        userInfo = _orderDetail.grabOrderUser;
    }
    NSString *sex = userInfo.sex;
    if ([sex isEqualToString:@"1"] || [sex isEqualToString:@"0"]) {
        [_sexImageView setImage:[UIImage imageNamed:@"icon_male.png"]];
    } else {
        [_sexImageView setImage:[UIImage imageNamed:@"icon_female.png"]];
    }
    if (userInfo.userid.length == 0) {
        _sexImageView.hidden = YES;
    } else {
        _sexImageView.hidden = NO;
    }
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar_default.png"]];
    _titleLabel.text = userInfo.nickName;

    if (_isGrabOrder && userInfo.userid != 0) {
        _subtitleLabel.text = [NSString stringWithFormat:@"成功发单%@笔", userInfo.sendOrderCount];
    } else if (userInfo.userid != 0) {
        _subtitleLabel.text = [NSString stringWithFormat:@"成功接单%@笔", userInfo.grabOrderCount];
    } else {
        _subtitleLabel.text = nil;
    }
    _timeLabel.text = _orderDetail.tasktime;
    _contentLabel.text = _orderDetail.content;
    
    NSString *str = [NSString stringWithFormat:@"%@元", _orderDetail.price];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0] range:NSMakeRange(0,str.length-1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str.length-1)];
    _priceLabel.attributedText = attStr;
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    
    _orderStatusLabel.text = _orderDetail.orderStatusDesc;
    [_addressBtn setTitle:_orderDetail.address forState:UIControlStateNormal];
}

@end
