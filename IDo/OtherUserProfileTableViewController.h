//
//  OtherUserProfileTableViewController.h
//  IDo
//
//  Created by liangpengshuai on 10/7/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherUserProfileTableViewController : TZTableViewController

@property (nonatomic, strong) UserInfo *userInfo;

@property (nonatomic) int evaluationType; //1发单人评价 2接单人评价


@end
