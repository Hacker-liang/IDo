//
//  HowToSendVC.m
//  IDo
//
//  Created by 柯南 on 16/1/26.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "HowToSendVC.h"

@interface HowToSendVC ()<UIScrollViewDelegate>

@end

@implementation HowToSendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"如何派单";
    self.view.backgroundColor = APP_PAGE_COLOR;
    self.edgesForExtendedLayout=0;
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"common_icon_navigation_back_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"common_icon_navigation_back_highlight"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(goBack)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 48, 30)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    [self creatUI];
}

- (void)goBack
{
    if (self.navigationController.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)creatUI
{
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    //    自动缩放页面和自动检测电话
    webView.scalesPageToFit=YES;
    //    webView.detectsPhoneNumbers=YES;
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.bjwogan.com/pc/?url=/7/13/p3078779498fd0f"]];
    [self.view addSubview:webView];
    [webView loadRequest:request];
    
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
