//
//  GrabOrderDetailSegmentViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/24/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "GrabOrderDetailSegmentViewController.h"
#import "GrabOrderListViewController.h"
#import "GrabOrderSettingViewController.h"

@interface GrabOrderDetailSegmentViewController ()

@end

@implementation GrabOrderDetailSegmentViewController

- (void)viewDidLoad {
    
    self.indictorWidth = 90;
    self.segmentedTitles = @[@"附近订单", @"抢单设置"];
    GrabOrderListViewController *ctl = [[GrabOrderListViewController alloc] init];
    GrabOrderSettingViewController *ctl1 = [[GrabOrderSettingViewController alloc] init];
    self.viewControllers = @[ctl, ctl1];
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change2InprogressOrderList) name:kSendOrderSuccess object:nil];
    
}

- (void)change2InprogressOrderList
{
    [self changePage:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
