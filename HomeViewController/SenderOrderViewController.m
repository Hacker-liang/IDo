//
//  SenderOrderViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "SenderOrderViewController.h"

@interface SenderOrderViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sendOrderBtn;

@end

@implementation SenderOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sendOrderBtn.titleLabel.numberOfLines = 2.0;
    [_sendOrderBtn setTitle:@"立即\n派单" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendOrder:(id)sender {
}
@end
