//
//  MyWalletTableViewHeaderView.h
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletTableViewHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *accountRemainingBtn;

@property (weak, nonatomic) IBOutlet UIButton *totalExpendBtn;
@property (weak, nonatomic) IBOutlet UIButton *cashBtn;
@property (weak, nonatomic) IBOutlet UILabel *earnLabel;

+ (id)myWalletTableViewHeaderView;

@end
