//
//  GrabOrderSegmentedViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "GrabOrderSegmentedViewController.h"
#import "GrabOrderDetailSegmentViewController.h"
#import "MyOrderRootViewController.h"
#import "EvaluationRecordViewController.h"

@interface GrabOrderSegmentedViewController ()

@end

@implementation GrabOrderSegmentedViewController

- (void)viewDidLoad {
    self.segmentedNormalImages = @[@"icon_qiangdan.png", @"icon_order.png", @"icon_rating.png"];
    self.segmentedSelectedImages = @[@"icon_qiangdan.png", @"icon_order.png", @"icon_rating.png"];
    self.indictorWidth = 70;
    self.segmentedTitles = @[@"立即抢单", @"我的订单", @"我的评价"];
    GrabOrderDetailSegmentViewController *ctl = [[GrabOrderDetailSegmentViewController alloc] init];
    MyOrderRootViewController *ctl1 = [[MyOrderRootViewController alloc] init];
    ctl1.isGrabOrder = YES;
    EvaluationRecordViewController *ctl2 = [[EvaluationRecordViewController alloc] init];
    ctl2.evaluationType = 1;

    self.viewControllers = @[ctl, ctl1, ctl2];
    [super viewDidLoad];
    self.view.backgroundColor = APP_PAGE_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    for (UIViewController *ctl in self.viewControllers) {
        CGRect frame = ctl.view.frame;
        frame.origin.y += 20;
        frame.size.height -= 20;
        ctl.view.frame = frame;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change2InprogressOrderList) name:kSendOrderSuccess object:nil];
    
}

- (void)change2InprogressOrderList
{
    [self changePage:0];
}

- (void)changePage:(NSInteger)pageIndex
{
    [super changePage:pageIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
