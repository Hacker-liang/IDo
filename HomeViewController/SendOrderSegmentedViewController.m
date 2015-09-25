//
//  SendOrderSegmentedViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "SendOrderSegmentedViewController.h"
#import "SenderOrderViewController.h"

@interface SendOrderSegmentedViewController ()

@property (nonatomic, strong) SenderOrderViewController *senderOrderCtl;

@end

@implementation SendOrderSegmentedViewController

- (void)viewDidLoad {
    self.segmentedNormalImages = @[];
    self.segmentedSelectedImages = @[];
    self.segmentedTitles = @[@"立即派单", @"我的订单", @"评价"];
    
    _senderOrderCtl = [[SenderOrderViewController alloc] initWithNibName:@"SenderOrderViewController" bundle:nil];
    UIViewController *ctl1 = [[UIViewController alloc] init];
    UIViewController *ctl2= [[UIViewController alloc] init];
    self.viewControllers = @[_senderOrderCtl, ctl1, ctl2];
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
