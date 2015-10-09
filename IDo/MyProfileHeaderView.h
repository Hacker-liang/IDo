//
//  MyProfileHeaderView.h
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView/CWStarRateView.h"

@interface MyProfileHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *sendOrderCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *grabOrderCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *complainBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet CWStarRateView *ratingView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

@property (nonatomic) BOOL showSexImage;

@property (nonatomic, strong) UserInfo *userInfo;

+ (id)myProfileHeaderView;

@end
