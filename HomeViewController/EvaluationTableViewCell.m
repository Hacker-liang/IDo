//
//  EvaluationTableViewCell.m
//  IDo
//
//  Created by liangpengshuai on 10/5/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "EvaluationTableViewCell.h"

@implementation EvaluationTableViewCell

- (void)awakeFromNib {
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.layer.cornerRadius = 17.5;
    _ratingView.isYellow = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentDic:(NSDictionary *)contentDic
{
    _contentDic = contentDic;

    if (self.evaluationType == 1) {
        _nickLabel.text = contentDic[@"guzhumes"][@"nikename"];
        NSString *str = [NSString stringWithFormat:@"成功发单%@次", contentDic[@"guzhumes"][@"fadannumber"]];
        NSString *sex = contentDic[@"guzhumes"][@"sex"];
        if ([sex isEqualToString:@"1"] || [sex isEqualToString:@"0"]) {
            [_sexImageView setImage:[UIImage imageNamed:@"icon_male.png"]];
        } else {
            [_sexImageView setImage:[UIImage imageNamed:@"icon_female.png"]];
        }
        NSString *avatar = contentDic[@"guzhumes"][@"img"];
        NSString *totalAvatar = [NSString stringWithFormat:@"%@%@",headURL,avatar];
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:totalAvatar] placeholderImage:[UIImage imageNamed:@"Icon"]];
        _subtitleLabel.text = str;
    }else{
        _nickLabel.text = contentDic[@"huobaomes"][@"nikename"];
        NSString *str = [NSString stringWithFormat:@"成功接单%@次", contentDic[@"huobaomes"][@"jiedannumber"]];
        _subtitleLabel.text = str;
        NSString *sex = contentDic[@"huobaomes"][@"sex"];
        if ([sex isEqualToString:@"1"] || [sex isEqualToString:@"0"]) {
            [_sexImageView setImage:[UIImage imageNamed:@"icon_male.png"]];
        } else {
            [_sexImageView setImage:[UIImage imageNamed:@"icon_female.png"]];
        }
        NSString *avatar = contentDic[@"huobaomes"][@"img"];
        NSString *totalAvatar = [NSString stringWithFormat:@"%@%@",headURL,avatar];

        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:totalAvatar] placeholderImage:[UIImage imageNamed:@"Icon"]];
    }
    
    if (self.evaluationType == 1) {
        _dateLabel.text = contentDic[@"commenttimetoperson"];
    }else{
        _dateLabel.text = contentDic[@"commenttimefromperson"];
    }

    if (self.evaluationType == 1) {
        
        _ratingView.scorePercent = [contentDic[@"commentstartoperson"] integerValue]/5.0;
        
    }else{
        _ratingView.scorePercent = [contentDic[@"commentstarfromperson"] integerValue]/5.0;

    }
    
    NSString *contentStr;
    if (self.evaluationType == 1) {
        contentStr = contentDic[@"commentcontenttoperson"];
    }else{
        contentStr = contentDic[@"commentcontentfromperson"];
    }
    _contentLabel.text = contentStr;
}

@end
