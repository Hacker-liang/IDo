//
//  MyWalletViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyWalletTableViewHeaderView.h"
#import "DealDetailViewController.h"
#import "ApplyForViewController.h"

@interface MyWalletViewController ()

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) MyWalletTableViewHeaderView *myWalletView;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = APP_PAGE_COLOR;
    _dataSource = @[@"收支明细", @"提现明细"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    [self setupTableViewFooterView];
    
    self.navigationItem.title = @"我的钱包";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupTableViewFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 200)];
    
    UIButton *cashBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 130, footerView.bounds.size.width-20, 40)];
    cashBtn.backgroundColor = APP_THEME_COLOR;
    cashBtn.layer.cornerRadius = 5.0;
    [cashBtn setTitle:@"申请提现" forState:UIControlStateNormal];
    [cashBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cashBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [cashBtn addTarget:self action:@selector(request2Cash) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:cashBtn];
    self.tableView.tableFooterView = footerView;
    [self updateView];
    [self getdata];
}

- (MyWalletTableViewHeaderView *)myWalletView
{
    if (!_myWalletView) {
        _myWalletView = [MyWalletTableViewHeaderView myWalletTableViewHeaderView];
    }
    return _myWalletView;
}

- (void)request2Cash
{
    WalletModel *wallet = [UserManager shareUserManager].userInfo.wallet;

    if ([wallet.remainingMoney isEqualToString:@"0"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"您的账户余额为0，不能进行提现" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if ([UserManager shareUserManager].userInfo.zhifubao.length ==0 || ![UserManager shareUserManager].userInfo.zhifubao) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"无支付宝账号，请到账号中心修改" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    ApplyForViewController * receive = [[ApplyForViewController alloc]init];
    receive.yueStr = wallet.remainingMoney;
    receive.titleStr = @"申请提现";
    [self.navigationController pushViewController:receive animated:YES];
}

-(void)getdata
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSString *url = [NSString stringWithFormat:@"%@getmyqianbo",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    
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
            NSString *str=[NSString stringWithFormat:@"%@",dict[@"status"]];
            if ([str isEqualToString:@"1"])
            {
                [UserManager shareUserManager].userInfo.wallet = [[WalletModel alloc] initWithJson:dict[@"data"]];
                [self updateView];
            }
        }
        else
        {
            UIAlertView *failedAlert = [[UIAlertView alloc]initWithTitle:nil message:messageError delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [failedAlert show];
        }
    }];
}

-(void)updateView
{
    WalletModel *wallet = [UserManager shareUserManager].userInfo.wallet;
    _myWalletView.earnLabel.text = [NSString stringWithFormat:@"￥%@", wallet.earnMoney];
    
    {
        NSString *str = [NSString stringWithFormat:@" 账户余额\n￥%@", wallet.remainingMoney];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:NSMakeRange(0, 5)];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 5)];

        [_myWalletView.accountRemainingBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    }
    
    {
        NSString *str = [NSString stringWithFormat:@" 已经提现\n￥%@", wallet.cashMoney];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:NSMakeRange(0, 5)];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 5)];

        [_myWalletView.cashBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    }
    
    {
        NSString *str = [NSString stringWithFormat:@" 累计消费\n￥%@", wallet.payMoney];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:NSMakeRange(0, 5)];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 5)];

        [_myWalletView.totalExpendBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    }
}

///收支明细
-(void)tap1Click
{
    DealDetailViewController * dealDetailVC = [[DealDetailViewController alloc]init];
    dealDetailVC.titleStr = @"收支明细";
    [self.navigationController pushViewController:dealDetailVC animated:YES];
}
///提现明细
-(void)tap2Click
{
    DealDetailViewController * dealDetailVC = [[DealDetailViewController alloc]init];
    dealDetailVC.titleStr = @"提现明细";
    [self.navigationController pushViewController:dealDetailVC animated:YES];
}

#pragma mrak - UITableViewDatasourece

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.myWalletView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self tap1Click];
    } else {
        [self tap2Click];

    }
}

@end
