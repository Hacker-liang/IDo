//
//  MySendOrderRootViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/26/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "MySendOrderRootViewController.h"
#import "MySendOrderHistoryTableViewController.h"
#import "MySendOrderInProgressTableViewController.h"

@interface MySendOrderRootViewController ()

@end

@implementation MySendOrderRootViewController

- (void)viewDidLoad {
    self.segmentedTitles = @[@"待处理订单", @"历史订单"];
    MySendOrderInProgressTableViewController *ctl = [[MySendOrderInProgressTableViewController alloc] init];
    MySendOrderHistoryTableViewController *ctl1 = [[MySendOrderHistoryTableViewController alloc] init];
    self.viewControllers = @[ctl, ctl1];
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
