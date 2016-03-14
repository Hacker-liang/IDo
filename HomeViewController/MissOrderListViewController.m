//
//  MissOrderListViewController.m
//  IDo
//
//  Created by liangpengshuai on 1/3/16.
//  Copyright © 2016 com.Yinengxin.xianne. All rights reserved.
//

#import "MissOrderListViewController.h"
#import "MissOrderListTableViewCell.h"
#import "OrderManager.h"

@interface MissOrderListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *dataSource;

@end

@implementation MissOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"错过的订单";
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MissOrderListTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListCell"];
    [OrderManager asyncLoadMissOrderListWithPage:-1 pageSize:-1 completionBlock:^(BOOL isSuccess, NSArray *orderList) {
        if (isSuccess) {
            _dataSource = orderList;
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MissOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderListModel *model = [self.dataSource objectAtIndex:indexPath.section];
    cell.orderDetail = model;
    return cell;
}


@end
