//
//  HomeMenuViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "HomeMenuViewController.h"
#import "REFrostedViewController.h"
#import "HomeMenuTableViewHeaderView.h"
#import "HomeMenuTableViewCell.h"
#import "MyWalletViewController.h"
#import "MyProfileTableViewController.h"
#import "LoginViewController.h"

@interface HomeMenuViewController ()

@property (nonatomic, strong) HomeMenuTableViewHeaderView *headerView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation HomeMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    _headerView = [HomeMenuTableViewHeaderView homeMenuTableViewHeaderView];
    _headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 210);
    [_headerView.headerBtn addTarget:self action:@selector(gotoMyProfile) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeMenuCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@{@"icon": @"icon_menu_wallet.png", @"title": @"我的钱包"},
                        @{@"icon": @"icon_menu_mine.png", @"title": @"个人中心"},
                        @{@"icon": @"icon_menu_message.png", @"title": @"信息中心"},
                        @{@"icon": @"icon_menu_setting.png", @"title": @"关于我们"}
                        ];
    }
    return _dataSource;
}

#pragma mark - IBAction Methods

- (void)gotoMyWallet
{
    if ([[UserManager shareUserManager] isLogin]) {
        [self.frostedViewController hideMenuViewController];
        MyWalletViewController *ctl = [[MyWalletViewController alloc] init];
        [_mainViewController.navigationController pushViewController:ctl animated:YES];

    } else {
        [self gotoLogin];
    }
}

- (void)gotoMyProfile
{
    if ([[UserManager shareUserManager] isLogin]) {
        [self.frostedViewController hideMenuViewController];
        MyProfileTableViewController *ctl = [[MyProfileTableViewController alloc] init];
        [_mainViewController.navigationController pushViewController:ctl animated:YES];
    } else {
        [self gotoLogin];
    }
}

- (void)gotoAbout
{
    
}

- (void)gotoLogin
{
    [self.frostedViewController hideMenuViewController];
    LoginViewController *ctl = [[LoginViewController alloc] init];
    [_mainViewController.navigationController pushViewController:ctl animated:YES];
}

#pragma mark - TableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 210;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _headerView.userInfo = [UserManager shareUserManager].userInfo;
    return _headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeMenuCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.headerImageView.image = [UIImage imageNamed:[dic objectForKey:@"icon"]];
    cell.titleLabel.text = [dic objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self gotoMyWallet];
        
    } else if (indexPath.row == 1) {
        [self gotoMyProfile];
    }
}

@end





