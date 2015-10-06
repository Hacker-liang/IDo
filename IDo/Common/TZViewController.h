//
//  TZViewController.h
//  PeachTravel
//
//  Created by liangpengshuai on 12/5/14.
//  Copyright (c) 2014 com.aizou.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZViewController : UIViewController

- (void)goBack;

@property (nonatomic, strong) UIButton *backButton;

/**
 *  当前 controller 是否正在显示
 */
@property (nonatomic) BOOL isShowing;

@end
