//
//  GrabOrderSegmentedViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "GrabOrderSegmentedViewController.h"
#import "GrabOrderListTableViewController.h"

@interface GrabOrderSegmentedViewController ()

@end

@implementation GrabOrderSegmentedViewController

- (void)viewDidLoad {
    self.segmentedNormalImages = @[];
    self.segmentedSelectedImages = @[];
    self.segmentedTitles = @[@"立即抢单", @"我的订单", @"评价"];
    GrabOrderListTableViewController *ctl = [[GrabOrderListTableViewController alloc] init];
    
    UIViewController *ctl1 = [[UIViewController alloc] init];
    UIViewController *ctl2 = [[UIViewController alloc] init];


    self.viewControllers = @[ctl, ctl1, ctl2];
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
