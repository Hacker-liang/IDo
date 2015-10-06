//
//  AboutViewController.h
//  IDo
//
//  Created by YangJiLei on 15/7/30.
//  Copyright (c) 2015年 IDo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : TZViewController<UITableViewDelegate ,UITableViewDataSource>
@property(strong,nonatomic)UITableView *tableView;
@end
