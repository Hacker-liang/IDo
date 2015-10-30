//
//  ChangeAlipayViewController.m
//  IDo
//
//  Created by liangpengshuai on 10/28/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "ChangeAlipayViewController.h"

@interface ChangeAlipayViewController ()

@end

@implementation ChangeAlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改支付宝帐号";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    self.navigationItem.rightBarButtonItem = item;
    _contentTextField.text = [UserManager shareUserManager].userInfo.zhifubao;
    
}

- (void)confirm
{
    [self changeUserSet:_contentTextField.text Type:@"4"];
}

- (void)changeUserSet:(NSString *)aContent Type:(NSString*)aType
{
    [SVProgressHUD showWithStatus:@"正在修改"];
    NSString *url = [NSString stringWithFormat:@"%@editmembermes",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    [mDict setObject:aContent forKey:@"content"];
    [mDict setObject:aType forKey:@"type"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"jsonString = %@",jsonString);
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSInteger status = [[dict objectForKey:@"status"] integerValue];
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
            if (status == 1) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [UserManager shareUserManager].userInfo.zhifubao = aContent;
                [[UserManager shareUserManager] saveUserData2Cache];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"修改失败"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
