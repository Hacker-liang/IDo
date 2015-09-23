//
//  SendOrderSegmentedViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "SendOrderSegmentedViewController.h"

@interface SendOrderSegmentedViewController ()

@end

@implementation SendOrderSegmentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.segmentedNormalImages = @[];
    self.segmentedSelectedImages = @[];
    self.segmentedTitles = @[@"抢单", @"我的订单", @"评价"];
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
