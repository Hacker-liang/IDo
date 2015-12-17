//
//  ReceiveViewController.m
//  xianne
//
//  Created by coca on 15/6/26.
//  Copyright (c) 2015年 coca. All rights reserved.
//

#import "ApplyForViewController.h"
#import "AliPayTool.h"

@interface ApplyForViewController ()
{
    UITextField *contentTextF;
}
@end

@implementation ApplyForViewController

@synthesize yueStr,titleStr;

#pragma mark - backClick
-(void)backClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = APP_PAGE_COLOR;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = self.titleStr;
    [self creatMainView];
}

#pragma mark - GetDataFromSever
//申请提现
-(void)applyForFromSever
{
    int num = [contentTextF.text intValue];

    if ([self.titleStr isEqualToString:@"申请提现"]) {
        int yue = [self.yueStr intValue];
        if (num >= 30) {
            if (num>yue) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提现金额不能大于您的余额" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提现金额不能少于30元" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        NSString *url = [NSString stringWithFormat:@"%@appExtract",baseUrl];
        NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
        [mDict setObject:[UserManager shareUserManager].userInfo.zhifubao forKey:@"alipay"];
        [mDict setObject:[UserManager shareUserManager].userInfo.nickName forKey:@"nickname"];
        [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];

        [mDict setObject:contentTextF.text forKey:@"money"];
        
        [SVProgressHUD showWithStatus:@"正在提现"];
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
                NSString *status = dict[@"status"];
                if ([status intValue] == 1) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"恭喜你，你的申请已成功" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                } else {
                    NSString *info = [dict objectForKey:@"info"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:info delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
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

    }else{//充值
        if (num==0) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"充值金额不能为0" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }

        [self payforSure];
    }
    
    [contentTextF resignFirstResponder];
    
}

-(void)payforSure
{

//    AliPayTool *ali=[[AliPayTool alloc]init];
//    NSString *status=[ali AliPayWithProductName:@"充值" AndproductDescription:@"给活儿宝的充值" andAmount:@"0" Orderid:@"0" MoneyBao:contentTextF.text AliPayMoney:contentTextF.text ShouKuanID:[UserManager shareUserManager].userInfo.userid];
//    if ([status isEqualToString:@"1"])
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"您已成功付款" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}

-(void)creatMainView
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 16+64, [UIScreen mainScreen].bounds.size.width, 44)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
  
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 120, 24)];
    titleLabel.text = [self.titleStr isEqualToString:@"申请提现"]?@"提现金额：":@"充值金额：";
    titleLabel.font = [UIFont systemFontOfSize:17];
    [backView addSubview:titleLabel];
    
    contentTextF = [[UITextField alloc]initWithFrame:CGRectMake(15*2+titleLabel.frame.size.width, 10, [UIScreen mainScreen].bounds.size.width-15*3-titleLabel.frame.size.width, 24)];
    contentTextF.placeholder = self.yueStr;
    contentTextF.textAlignment = NSTextAlignmentRight;
    contentTextF.font = [UIFont systemFontOfSize:17];
    contentTextF.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:contentTextF];
    [contentTextF becomeFirstResponder];
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, backView.frame.origin.y+backView.frame.size.height+15, [UIScreen mainScreen].bounds.size.width, 44)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    titleLabel = [[UILabel alloc]initWithFrame:titleLabel.frame];
    titleLabel.text = @"支付宝账号：";
    titleLabel.font = [UIFont systemFontOfSize:17];
    [backView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:contentTextF.frame];
    contentLabel.text = [UserManager shareUserManager].userInfo.zhifubao;
    contentLabel.font = [UIFont systemFontOfSize:17];
    contentLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:contentLabel];
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, backView.frame.origin.y+backView.frame.size.height+1, [UIScreen mainScreen].bounds.size.width, 44)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    titleLabel = [[UILabel alloc]initWithFrame:titleLabel.frame];
    titleLabel.text = @"昵称：";
    titleLabel.font = [UIFont systemFontOfSize:17];
    [backView addSubview:titleLabel];
    
    contentLabel = [[UILabel alloc]initWithFrame:contentTextF.frame];
    contentLabel.text = [UserManager shareUserManager].userInfo.nickName;
    contentLabel.font = [UIFont systemFontOfSize:17];
    contentLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:contentLabel];
    
    UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(backView.frame) + 10, [UIScreen mainScreen].bounds.size.width-20, 80)];
    la.text = @"*请确保您的支付宝账号输入正确，如因支付宝错误导致的资金损失由您自行承担。\n*单笔提现金额应大于30元，每天仅能提现一次，单月累计不得超过10次";
    la.textAlignment = NSTextAlignmentLeft;
    la.numberOfLines = 0;
    la.textColor = [UIColor grayColor];
    la.font = [UIFont systemFontOfSize:11];

    if ([self.titleStr isEqualToString:@"申请提现"]) {
        [self.view addSubview:la];
    }
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = APP_THEME_COLOR;
    [btn setTitle:[self.titleStr isEqualToString:@"申请提现"]?@"提交":@"充值" forState:UIControlStateNormal];
    btn.frame = CGRectMake(10, CGRectGetMaxY(la.frame)+20, [UIScreen mainScreen].bounds.size.width - 20, 40);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 4.0;
    [btn addTarget:self action:@selector(applyForFromSever) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

#pragma mark - TouchDelegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [contentTextF resignFirstResponder];
}
#pragma mark - Action
-(void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
