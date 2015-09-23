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

@interface HomeMenuViewController ()

@property (nonatomic, strong) HomeMenuTableViewHeaderView *headerView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation HomeMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _headerView = [HomeMenuTableViewHeaderView homeMenuTableViewHeaderView];
    self.tableView.tableHeaderView = _headerView;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeMenuCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.frostedViewController.navigationController setNavigationBarHidden:YES animated:NO];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.frostedViewController.navigationController setNavigationBarHidden:NO animated:NO];
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

#pragma mark - TableViewDataSource 

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
    return cell;
}

@end
