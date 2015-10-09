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
#import "AboutViewController.h"

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
                        @{@"icon": @"icon_menu_message.png", @"title": @"关于我们"},
                        @{@"icon": @"icon_menu_setting.png", @"title": @"检查更新"}
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
    AboutViewController *ctl = [[AboutViewController alloc] init];
    [self.frostedViewController hideMenuViewController];

    [_mainViewController.navigationController pushViewController:ctl animated:YES];
}

- (void)gotoLogin
{
    [self.frostedViewController hideMenuViewController];
    
    LoginViewController *ctl = [[LoginViewController alloc] init];
    [_mainViewController.navigationController pushViewController:ctl animated:YES];
}


- (void)get_version{
    [SVProgressHUD showWithStatus:@"正在检查新版本"];
    [SVHTTPRequest POST:@"https://itunes.apple.com/lookup?id=983842433" parameters:nil completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [SVProgressHUD dismiss];
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            if (dict)
            {
                NSInteger resultCount = [[dict objectForKey:@"resultCount"] integerValue];
                if (resultCount == 1) {
                    NSArray *arr = [dict objectForKey:@"results"];
                    if (arr.count) {
                        NSDictionary *arrDict = arr[0];
                        if (arrDict) {
                            NSString *version = [arrDict objectForKey:@"version"];
                            NSString *locVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
                            int result = [locVersion compare:version];
                            if (result == -1)
                            {
                                NSString *appUrl = [arrDict objectForKey:@"trackViewUrl"];
                                NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
                                NSString *versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
                                if ([versionNum floatValue] < [version floatValue]) {
                                    NSString *meaasge = [NSString stringWithFormat:@"发现新版本%@，是否更新?",version];
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:meaasge delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                                    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                                        if (buttonIndex == 1) {
                                            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:appUrl]];
                                        }
                                    }];
                                } else {
                                    [SVProgressHUD showSuccessWithStatus:@"恭喜你，已经是最新版本"];
                                }
                               
                            }
                        }
                    }
                }
            }
        }
    }];
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeMenuCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.headerImageView.image = [UIImage imageNamed:[dic objectForKey:@"icon"]];
    cell.titleLabel.text = [dic objectForKey:@"title"];
    
    if (indexPath.row == 3) {
        NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
        NSString *versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
        NSString *text =[NSString stringWithFormat:@"v%@",versionNum];
        cell.subtitleLabel.text = text;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self gotoMyWallet];
        
    } else if (indexPath.row == 1) {
        [self gotoMyProfile];
    } else if (indexPath.row == 2) {
        [self gotoAbout];
    } else if (indexPath.row ==3) {
        [self get_version];
    }
}

@end





