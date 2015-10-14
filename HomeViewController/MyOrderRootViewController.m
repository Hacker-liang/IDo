//
//  MyOrderRootViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/26/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "MyOrderRootViewController.h"
#import "MyOrderHistoryTableViewController.h"
#import "MyOrderInProgressTableViewController.h"

@interface MyOrderRootViewController ()

@end

@implementation MyOrderRootViewController

- (void)viewDidLoad {
    self.indictorWidth = 90;
    self.segmentedTitles = @[@"待处理订单", @"历史订单"];
    MyOrderInProgressTableViewController *ctl = [[MyOrderInProgressTableViewController alloc] init];
    MyOrderHistoryTableViewController *ctl1 = [[MyOrderHistoryTableViewController alloc] init];
    ctl.isGrabOrder = _isGrabOrder;
    ctl1.isGrabOrder = _isGrabOrder;
    self.viewControllers = @[ctl, ctl1];
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change2InprogressOrderList) name:kSendOrderSuccess object:nil];

}

- (void)change2InprogressOrderList
{
    [self changePage:0];
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
