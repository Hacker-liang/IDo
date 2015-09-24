//
//  MyWalletViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyWalletTableViewHeaderView.h"

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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end
