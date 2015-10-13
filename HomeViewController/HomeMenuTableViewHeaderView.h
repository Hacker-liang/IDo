//
//  HomeMenuTableViewHeaderView.h
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMenuTableViewHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;

@property (nonatomic, strong) UserInfo *userInfo;


+ (id)homeMenuTableViewHeaderView;

@end
