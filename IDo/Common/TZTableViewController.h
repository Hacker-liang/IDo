//
//  :TZTableViewController.h
//  PeachTravel
//
//  Created by liangpengshuai on 12/9/14.
//  Copyright (c) 2014 com.aizou.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZTableViewController : UITableViewController

/**
 *  退出
 */
- (void)goBack;

/**
 *  当前 controller 是否正在显示
 */
@property (nonatomic) BOOL isShowing;

@end
