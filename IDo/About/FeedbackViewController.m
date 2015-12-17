//
//  FeedbackViewController.m
//  98Liquor
//
//  Created by YJL on 15/7/6.
//  Copyright (c) 2015年 98Liquor. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>

@end

@implementation FeedbackViewController

#pragma mark -
#pragma mark backClick
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APP_PAGE_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    self.title = @"意见建议";
    
    self.content=[[UITextView alloc]initWithFrame:CGRectMake(5, 84, self.view.frame.size.width-10, 100)];
    self.content.delegate=self;
    self.content.scrollEnabled=YES;
    self.content.text=@"意见建议";
    self.content.textColor = [UIColor grayColor];
    self.content.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    self.content.font=[UIFont systemFontOfSize:17];
    [self.view addSubview:self.content];
    
    self.tijiao=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.tijiao.frame=CGRectMake(10, 200+64, self.view.frame.size.width-20, 44);
    [self.tijiao setTitle:@"提交" forState:UIControlStateNormal];
    self.tijiao.titleLabel.textAlignment=1;
    [self.tijiao setTintColor:[UIColor whiteColor]];
    self.tijiao.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.tijiao addTarget:self action:@selector(advice) forControlEvents:UIControlEventTouchUpInside];
    [self.tijiao setBackgroundImage:[UIImage imageNamed:@"callbtn.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.tijiao];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
//通过手势隐藏键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.content resignFirstResponder];
}

-(void)advice
{
    if (self.content.text.length<1) {
        UIAlertView *failedAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入内容!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [failedAlert show];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在提交"];
    
    NSString *url = [NSString stringWithFormat:@"%@suggest",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    [mDict setObject:self.content.text forKey:@"content"];

    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [SVProgressHUD dismiss];
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            if ([[dict objectForKey:@"status"] integerValue] == 30001 || [[dict objectForKey:@"status"] integerValue] == 30002) {
                if ([UserManager shareUserManager].isLogin) {
                                        [UserManager shareUserManager].userInfo = nil;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"info"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoError" object:nil];
                    }];
                }
                return;
            }
            if ([dict[@"status"] integerValue] == 1) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"您的意见已经成功提交！\n我们会根据您的意见提升自己" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:[dict objectForKey:@"info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }
        else
        {
            UIAlertView *failedAlert = [[UIAlertView alloc]initWithTitle:nil message:messageError delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [failedAlert show];
        }
    }];
}

-(void)backto
{
    [self.navigationController popViewControllerAnimated:YES];
}
//将回车键当作推出键盘的响应
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
