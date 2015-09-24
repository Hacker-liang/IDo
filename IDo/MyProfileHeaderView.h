//
//  MyProfileHeaderView.h
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *sendOrderCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *grabOrderCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *complainBtn;

+ (id)myProfileHeaderView;

@end
