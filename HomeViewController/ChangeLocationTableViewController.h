//
//  ChangeLocationTableViewController.h
//  IDo
//
//  Created by liangpengshuai on 10/5/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeLocationDelegate <NSObject>

- (void)didChangeAddress:(float)lat lng:(float)lng address:(NSString *)address;

@end

@interface ChangeLocationTableViewController : UITableViewController

@property (nonatomic, weak)id<ChangeLocationDelegate>delegate;

@property (nonatomic, copy) NSString *cityCode;

@end
