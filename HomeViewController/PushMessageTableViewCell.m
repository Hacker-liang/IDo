//
//  PushMessageTableViewCell.m
//  IDo
//
//  Created by liangpengshuai on 12/30/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "PushMessageTableViewCell.h"

@implementation PushMessageTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = APP_PAGE_COLOR;
    _bgView.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    _timeLabel.text = [_messageData objectForKey:@"create_time"];
    _titleLabel.text = [_messageData objectForKey:@"title"];
    _contentLabel.text = [_messageData objectForKey:@"description"];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[_messageData objectForKey:@"img_content_url"]] placeholderImage:nil];
}

@end
