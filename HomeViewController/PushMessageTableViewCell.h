//
//  PushMessageTableViewCell.h
//  IDo
//
//  Created by liangpengshuai on 12/30/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushMessageTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *messageData;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
