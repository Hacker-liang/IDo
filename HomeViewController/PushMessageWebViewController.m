//
//  PushMessageWebViewController.m
//  IDo
//
//  Created by liangpengshuai on 12/30/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "PushMessageWebViewController.h"
#import "ShareViewController.h"

@interface PushMessageWebViewController ()

@end

@implementation PushMessageWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APP_PAGE_COLOR;
    self.webView.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight-49);
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-49, kWindowWidth, 49)];
    footerView.backgroundColor = APP_PAGE_COLOR;
    [self.view addSubview:footerView];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake((kWindowWidth-60)/2, kWindowHeight-40, 60, 30)];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    shareBtn.layer.borderColor = LineColor.CGColor;
    shareBtn.layer.borderWidth = 0.5;
    shareBtn.layer.cornerRadius = 4.0;
    [shareBtn addTarget:self action:@selector(shareMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setPushMessageData:(NSDictionary *)pushMessageData
{
    _pushMessageData = pushMessageData;
    self.urlStr = [pushMessageData objectForKey:@"url"];
    self.titleStr = @"信息详情";
}

- (void)shareMessage
{
    ShareViewController *ctl = [[ShareViewController alloc] init];
    ctl.shareTitle = [_pushMessageData objectForKey:@"title"];
    ctl.shareContent = [_pushMessageData objectForKey:@"description"];
    ctl.shareUrl = [_pushMessageData objectForKey:@"share_url"];
    ctl.shareImageUrl = [_pushMessageData objectForKey:@"img_content_url"];
    [self.navigationController pushViewController:ctl animated:YES];

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
