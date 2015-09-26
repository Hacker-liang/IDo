//
//  SendOrderSegmentedViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "SendOrderSegmentedViewController.h"
#import "SenderOrderViewController.h"
#import "MySendOrderRootViewController.h"

@interface SendOrderSegmentedViewController ()

@property (nonatomic, strong) SenderOrderViewController *senderOrderCtl;
@property (nonatomic, strong) MySendOrderRootViewController *mySendOrderCtl;

@end

@implementation SendOrderSegmentedViewController

- (void)viewDidLoad {
    self.segmentedNormalImages = @[];
    self.segmentedSelectedImages = @[];
    self.segmentedTitles = @[@"立即派单", @"我的订单", @"评价"];
    
    _senderOrderCtl = [[SenderOrderViewController alloc] initWithNibName:@"SenderOrderViewController" bundle:nil];
    _mySendOrderCtl = [[MySendOrderRootViewController alloc] init];
    UIViewController *ctl = [[UIViewController alloc] init];
    self.viewControllers = @[_senderOrderCtl, _mySendOrderCtl, ctl];
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
