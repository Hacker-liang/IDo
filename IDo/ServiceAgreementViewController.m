//
//  ServiceAgreementViewController.m
//  IDo
//
//  Created by YangJiLei on 15/7/31.
//  Copyright (c) 2015年 IDo. All rights reserved.
//

#import "ServiceAgreementViewController.h"

@interface ServiceAgreementViewController ()<UIWebViewDelegate>

@end

@implementation ServiceAgreementViewController

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"软件许可及服务协议";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBt setTitle:@"返回" forState:UIControlStateNormal];
    [leftBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBt addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:leftBt]];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-10, self.view.bounds.size.width)];
    textView.backgroundColor = [UIColor whiteColor];
    NSString *path = path = [[NSBundle mainBundle] pathForResource:@"RegistrationAgreement" ofType:@"txt"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    textView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    textView.editable = NO;
    textView.textColor = [UIColor grayColor];
    textView.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:textView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
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
