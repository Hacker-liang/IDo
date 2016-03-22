//
//  PayViewController.m
//  IDo
//
//  Created by YangJiLei on 15/8/28.
//  Copyright (c) 2015年 IDo. All rights reserved.
//

#import "PayViewController.h"
#import "AliPayTool.h"
#import "MyOrderRootViewController.h"
#import "HomeViewController.h"
#import "APService.h"
#import "WXApi.h"

@interface PayViewController ()

@property (nonatomic) BOOL isPayWithAccountRemainingMoney;  //通过账户余额支付
@property (nonatomic) BOOL isPayWithAliPay;  //通过支付宝支付

@property (nonatomic, strong) UIButton *remainMoneyButton;

@end

@implementation PayViewController
@synthesize payTab,price,huoerbaoID,orderid;

- (id)initWithPaySuccessBlock:(PaySuccessBlock)block
{
    if (self = [super init]) {
        _paySuccessBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UserManager shareUserManager] asyncLoadUserWalletFromServer:^(BOOL isSuccess) {
        if (isSuccess) {
            if ([price floatValue]>[[UserManager shareUserManager].userInfo.wallet.remainingMoney floatValue]) {
                _isPayWithAccountRemainingMoney = NO;
            }
            [self.payTab reloadData];
        }
    }];
    _isPayWithAliPay = YES;
    // Do any additional setup after loading the view.
    self.title = @"支付";
//    Appdelegate.viewisWhere = PiePayView;
    
    NSLog(@"redEnvelopeId :%@",self.redEnvelopeId);
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backAfterPayed) name:@"paySuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PayError) name:@"payErrorNotification" object:nil];

    
    self.payTab = [[UITableView alloc]initWithFrame:CGRectMake(0.0f,0,kWindowWidth,kWindowHeight-100) style:UITableViewStylePlain];
    self.payTab.delegate = self;
    self.payTab.dataSource = self;
    self.payTab.backgroundView = nil;
    self.payTab.backgroundColor = [UIColor clearColor];
    [AppTools clearTabViewLine:self.payTab];
    self.payTab.scrollEnabled = NO;
    self.payTab.rowHeight = 44;
    self.payTab.separatorColor = [UIColor clearColor];
    self.payTab.tableHeaderView = [self creatHeadView];
    [self.view addSubview:self.payTab];
    
    UILabel *mylable=[[UILabel alloc]initWithFrame:CGRectMake(15,kWindowHeight-50, self.view.frame.size.width-30, 40)];
    mylable.textColor=[UIColor grayColor];
    mylable.textAlignment=NSTextAlignmentCenter;
    mylable.text=@"确认支付后费用将先行支付到平台,待抢单人完成服务并由您再次确认时才能收到此费用";
    mylable.numberOfLines=0;
    mylable.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:mylable];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(10, kWindowHeight-100, self.view.frame.size.width-20, 40);
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTintColor:[UIColor whiteColor]];
    [btn setBackgroundImage:[UIImage imageNamed:@"callbtn.png"] forState:UIControlStateNormal];
    [btn setTitle:@"确认支付" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(payOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (UIView*)creatHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 120)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 110)];
    bgView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:bgView];

    UILabel *pirceLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, kWindowWidth, 35)];
    pirceLab.text=[NSString stringWithFormat:@"￥%@",self.price];
    pirceLab.font=[UIFont systemFontOfSize:25];
    pirceLab.textAlignment=NSTextAlignmentCenter;
    pirceLab.textColor=[UIColor colorWithRed:(48)/255.0 green:(167)/255.0 blue:(59)/255.0 alpha:1];
    [headView addSubview:pirceLab];
    
    UILabel *textLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 65, kWindowWidth, 20)];
    textLab.text=@"订单金额";
    textLab.font=[UIFont systemFontOfSize:16];
    textLab.textAlignment=NSTextAlignmentCenter;
    textLab.textColor=[UIColor grayColor];
    [headView addSubview:textLab];
    
    return headView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([price floatValue]<=[[UserManager shareUserManager].userInfo.wallet.remainingMoney floatValue]) {
        return 3;
    }
    return 2;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

-(void)tableView:(UITableView*)tableView  willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableViews dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 44)];
        bgView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:bgView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 12, 20, 20)];
        imageView.tag = 990;
        [cell addSubview:imageView];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(46.0f, 0, kWindowWidth-166, 44)];
        titleLab.tag = 991;
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textColor = COLOR(79, 79,79);
        titleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:titleLab];
        
        if (indexPath.section == 2) {
            UIButton *checkBox = [[UIButton alloc] initWithFrame:CGRectMake(kWindowWidth-30, 15, 15, 15)];
            checkBox.tag = 100;
            checkBox.userInteractionEnabled = NO;
            [checkBox setImage:[UIImage imageNamed:@"ic_pay_uncheck.png"] forState:UIControlStateNormal];
            [checkBox setImage:[UIImage imageNamed:@"ic_pay_check.png"] forState:UIControlStateSelected];
            _remainMoneyButton = checkBox;
            [cell addSubview:checkBox];
            
            UILabel *moneyLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWindowWidth-146, 0, 100, 44)];
            moneyLeftLabel.tag = 992;
            moneyLeftLabel.font = [UIFont systemFontOfSize:13];
            moneyLeftLabel.textColor = COLOR(97, 97,97);
            moneyLeftLabel.adjustsFontSizeToFitWidth = YES;
            moneyLeftLabel.textAlignment = NSTextAlignmentRight;
            moneyLeftLabel.backgroundColor = [UIColor clearColor];
            [cell addSubview:moneyLeftLabel];
        }
        cell.tintColor = [UIColor colorWithRed:(48)/255.0 green:(167)/255.0 blue:(59)/255.0 alpha:1];
    }
    
    if (indexPath.section == 0) {
        if (_isPayWithAliPay) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }

        UIImageView *imageView = (UIImageView*)[cell viewWithTag:990];
        imageView.image = [UIImage imageNamed:@"ali_pay.png"];
        UILabel *titleLab = (UILabel*)[cell viewWithTag:991];
        titleLab.text = @"使用支付宝支付";
        
    } else if (indexPath.section == 1) {
        if (!_isPayWithAliPay && !_isPayWithAccountRemainingMoney) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
        UIImageView *imageView = (UIImageView*)[cell viewWithTag:990];
        imageView.image = [UIImage imageNamed:@"icon_pay_wechat.png"];
        UILabel *titleLab = (UILabel*)[cell viewWithTag:991];
        titleLab.text = @"使用微信支付";
        
    } else {
        cell.accessoryType=UITableViewCellAccessoryNone;
        UIButton *check = (UIButton*)[cell viewWithTag:100];
        check.selected = _isPayWithAccountRemainingMoney;
        
        UIImageView *imageView = (UIImageView*)[cell viewWithTag:990];
        imageView.image = [UIImage imageNamed:@"pay_wogan.png"];
        UILabel *titleLab = (UILabel*)[cell viewWithTag:991];
        titleLab.text = @"使用账户余额支付";
        
        UILabel *moneyLeftLabel = (UILabel*)[cell viewWithTag:992];
        moneyLeftLabel.text = [NSString stringWithFormat:@"可用余额:%@", [UserManager shareUserManager].userInfo.wallet.remainingMoney];
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 35;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kWindowWidth, 35)];
        view.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 30)];
        titleLab.text = @"   请选择支付方式";
        titleLab.backgroundColor = [UIColor whiteColor];
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textColor = COLOR(49, 49, 49);
        [view addSubview:titleLab];
        return view;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kWindowWidth, 10)];
        view.backgroundColor = APP_PAGE_COLOR;
        return view;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        _remainMoneyButton.selected = !_remainMoneyButton.selected;
        _isPayWithAccountRemainingMoney = _remainMoneyButton.isSelected;
        [self.payTab reloadData];
    }
    if (indexPath.section == 0) {
        _isPayWithAccountRemainingMoney = NO;
        _isPayWithAliPay = YES;
        [self.payTab reloadData];
    }
    if (indexPath.section == 1) {
        _isPayWithAccountRemainingMoney = NO;
        _isPayWithAliPay = NO;
        [self.payTab reloadData];
    }
}

- (void)payOrder
{
    if (_isPayWithAccountRemainingMoney) {
        [self payWithAccountWallet];
    } else if (_isPayWithAliPay){
        [self getAlipayInfoFromServer];
    } else {
        [self getWechatPayInfoFromServer];
    }
}

//通过余额支付
- (void)payWithAccountWallet
{
    [SVProgressHUD showWithStatus:@"正在付款"];
    NSString *url = [NSString stringWithFormat:@"%@payByWallet",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    if (self.isRedMoney==YES) {
        [mDict setObject:_redEnvelopeId forKey:@"redId"];
    }else
    {
        [mDict setObject:orderid forKey:@"orderId"];
    }
      NSLog(@"余额支付%@%@",url,mDict);
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
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
            NSString *status = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if ([status isEqualToString:@"1"]) {
                [[UserManager shareUserManager] userInfo].wallet.remainingMoney = [NSString stringWithFormat:@"%f", ([[[UserManager shareUserManager] userInfo].wallet.remainingMoney floatValue] - [price floatValue])];
                if ([self.fatherC isEqualToString:@"RedMoney"]) {
                    [self sendRedPushWithRedId:_redEnvelopeId];
                }
                else{
                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                    [self performSelector:@selector(backAfterPayed) withObject:nil afterDelay:0.3];

                }
                
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"支付失败，请稍后再试"];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"支付失败，请稍后再试"];
        }
    }];

}

- (void)sendRedPushWithRedId:(NSString *)redId
{
    NSString *url = [NSString stringWithFormat:@"%@gettzpersonnum", baseUrl];
    
    [SVHTTPRequest POST:url parameters:@{@"redId": redId, @"devnumber": [APService registrationID]} completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
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
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if([tempStatus integerValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"恭喜您，红包已成功派出，系统会随时通知能最新进展。"];
                [self performSelector:@selector(backAfterPayed) withObject:nil afterDelay:0.3];

            } else {
                [SVProgressHUD dismiss];
            }
        } else {
            [SVProgressHUD dismiss];
        }
    }];
    
}

-(void)getWechatPayInfoFromServer
{
    [SVProgressHUD showWithStatus:@"正在付款"];
    NSString *url = [NSString stringWithFormat:@"%@unifiedorder",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    if (self.isRedMoney) {
        [mDict setObject:_redEnvelopeId forKey:@"redEnvelopeId"];
    }else
    {
        [mDict setObject:orderid forKey:@"orderId"];
    }
    
    NSLog(@"微信支付%@%@",url,mDict);
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
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
            NSString *status = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if ([status isEqualToString:@"1"]) {
                [self sendWechatPayRequest:dict[@"data"]];
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"支付失败，请稍后再试"];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"支付失败，请稍后再试"];
        }
    }];
}

- (void)sendWechatPayRequest:(NSDictionary *)payInfo
{
    if (![WXApi isWXAppInstalled]) {
        [SVProgressHUD showErrorWithStatus:@"您没有安装微信，请选择其他支付方式"];
        return;
    }
    PayReq *request = [[PayReq alloc] init];
    request.openID = [payInfo objectForKey:@"appid"];
    request.partnerId = [payInfo objectForKey:@"partnerid"];
    request.prepayId= [payInfo objectForKey:@"prepayid"];
    request.package = [payInfo objectForKey:@"package_alia"];
    request.nonceStr= [payInfo objectForKey:@"noncestr"];
    request.timeStamp= (UInt32)[[payInfo objectForKey:@"timestamp"] longLongValue];
    request.sign= [payInfo objectForKey:@"sign"];
    [WXApi sendReq: request];
}

-(void)getAlipayInfoFromServer
{
    [SVProgressHUD showWithStatus:@"正在付款"];
    NSString *url = [NSString stringWithFormat:@"%@alipay",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    if (self.isRedMoney) {
        [mDict setObject:_redEnvelopeId forKey:@"redEnvelopeId"];
    }else
    {
        [mDict setObject:orderid forKey:@"orderId"];
    }

    NSLog(@"支付宝%@%@",url,mDict);
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
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
            NSString *status = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if ([status isEqualToString:@"1"]) {
                [self payWithAliPay:[dict[@"data"] objectForKey:@"aliPayParam"]];
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"支付失败，请稍后再试"];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"支付失败，请稍后再试"];
        }
    }];
}

- (void)payWithAliPay:(NSString *)alipayParam
{
    NSString *appScheme = @"xianne";

    [[AlipaySDK defaultService] payOrder:alipayParam fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSString *status=[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
        if ([status isEqualToString:@"9000"])
        {
            if (_isRedMoney) {
                [self sendRedPushWithRedId:_redEnvelopeId];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                [self performSelector:@selector(backAfterPayed) withObject:nil afterDelay:0.3];
            }
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"支付失败，请稍后再试"];

        }
    }];

}

// xuebao start
// 支付宝支付是否成功，服务器记录是否成功回调
// if success = YES 说明支付宝支付成功并且服务器记录成功，否则，支付不成功
- (void)aliPayCallBackWithSuccessed:(BOOL)success
{
    if (success) {
        // 确定派单推送订单成功(只是发送一个推送消息)
//        [self PayStatusSure];
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        [self backAfterPayed];

    }  else {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }
}

- (void)PayError
{
    [SVProgressHUD showErrorWithStatus:@"支付失败"];
}

- (void)PayStatusSure
{
    NSString *url = [NSString stringWithFormat:@"%@orderpayover",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:orderid forKey:@"orderid"];
    [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"fukuanrenid"];
    [mDict setObject:self.huoerbaoID forKey:@"shoukuanmemberid"];
    [mDict setObject:self.price forKey:@"shoukuanmembermoney"];
    [mDict setObject:@"0" forKey:@"dailiuserid"];
    [mDict setObject:@"0" forKey:@"dailiusermoney"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
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
            NSString *status = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if ([status isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"恭喜你，支付成功"];
                [self backAfterPayed];
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"支付失败，请稍后再试"];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"支付失败，请稍后再试"];
        }
    }];
}


// xuebao start
-(void)backAfterPayed
{
    if (self.isRedMoney==YES) {
        MyOrderRootViewController *myorder=[[MyOrderRootViewController alloc]init];
        myorder.isGrabOrder=NO;
        
        HomeViewController *home=[[HomeViewController alloc]init];
        [self.navigationController pushViewController:home animated:NO];
    }else{
       [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    if(self.paySuccessBlock)
    {
        self.paySuccessBlock (YES,nil);
    }
}

@end
