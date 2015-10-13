//
//  MoreTextViewController.m
//  IDo
//
//  Created by liangpengshuai on 10/13/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "MoreTextViewController.h"

@interface MoreTextViewController ()

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation MoreTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentTextView.editable = NO;
    self.navigationItem.title = @"订单详情";
    _contentTextView.text = _content;
    // Do any additional setup after loading the view from its nib.
}

- (void)setContent:(NSString *)content
{
    _content = content;
    _contentTextView.text = _content;
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
