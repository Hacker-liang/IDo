//
//  SendOrderSegmentedViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "SendOrderSegmentedViewController.h"
#import "SenderOrderViewController.h"
#import "MyOrderRootViewController.h"
#import "EvaluationRecordViewController.h"

@interface SendOrderSegmentedViewController ()

@property (nonatomic, strong) SenderOrderViewController *senderOrderCtl;
@property (nonatomic, strong) MyOrderRootViewController *mySendOrderCtl;

@end

@implementation SendOrderSegmentedViewController

- (void)viewDidLoad {
    self.view.backgroundColor = APP_PAGE_COLOR;
    self.segmentedNormalImages = @[@"icon_paidan.png", @"icon_order.png", @"icon_rating.png"];
    self.segmentedSelectedImages = @[@"icon_paidan.png", @"icon_order.png", @"icon_rating.png"];
    self.indictorWidth = 70;

    self.segmentedTitles = @[@"立即派单", @"我的订单", @"我的评价"];
    
    _senderOrderCtl = [[SenderOrderViewController alloc] initWithNibName:@"SenderOrderViewController" bundle:nil];
    _mySendOrderCtl = [[MyOrderRootViewController alloc] init];
    _mySendOrderCtl.isGrabOrder = NO;
    
    EvaluationRecordViewController *ctl2 = [[EvaluationRecordViewController alloc] init];
    ctl2.evaluationType = 2;
    self.viewControllers = @[_senderOrderCtl, _mySendOrderCtl, ctl2];
    [super viewDidLoad];
    
    for (int i=0; i<self.viewControllers.count; i++) {
        if (i!= 0) {
            UIViewController *ctl = [self.viewControllers objectAtIndex:i];
            CGRect frame = ctl.view.frame;
            frame.origin.y += 20;
            frame.size.height -= 20;
            ctl.view.frame = frame;
        } else {
            UIViewController *ctl = [self.viewControllers objectAtIndex:i];
            CGRect frame = ctl.view.frame;
            frame.origin.y += 11;
            frame.size.height -= 11;
            ctl.view.frame = frame;

        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change2InprogressOrderList) name:kSendOrderSuccess object:nil];
    
}

- (void)change2InprogressOrderList
{
    [self changePage:1];
}


@end
