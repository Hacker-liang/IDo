//
//  EvaluationTableViewCell.h
//  IDo
//
//  Created by liangpengshuai on 10/5/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@interface EvaluationTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *contentDic;
@property (nonatomic) int evaluationType;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet CWStarRateView *ratingView;
@end
