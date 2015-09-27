//
//  GrabOrderListTableViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/24/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "GrabOrderListTableViewController.h"
#import "OrderListTableViewCell.h"
#import "OrderListModel.h"
#import "OrderDetailViewController.h"

@interface GrabOrderListTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation GrabOrderListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderListTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListCell"];
    self.tableView.backgroundColor = APP_PAGE_COLOR;

    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getOrder];
    }];
    
    [self.tableView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)getOrder
{
    NSString *url = [NSString stringWithFormat:@"%@getorderlist",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    [mDict setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lng] forKey:@"lng"];
    [mDict setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lat] forKey:@"lat"];

    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [self.tableView.header endRefreshing];
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSArray *tempList = dict[@"data"];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if((NSNull *)tempStatus != [NSNull null] && ![tempStatus isEqualToString:@"0"]) {
                [self.dataSource removeAllObjects];
                for (NSDictionary *dic in tempList) {
                    OrderListModel *order = [[OrderListModel alloc] initWithJson:dic andIsSendOrder:NO];
                    [self.dataSource addObject:order];
                }
            } else {
            }
            
            [self.tableView reloadData];
        }
    }];
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
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderListCell" forIndexPath:indexPath];
    OrderListModel *model = [self.dataSource objectAtIndex:indexPath.section];
    cell.orderDetail = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderListModel *model = [self.dataSource objectAtIndex:indexPath.section];
    OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
    ctl.orderId = model.orderId;
    ctl.isSendOrder = NO;
    [self.navigationController pushViewController:ctl animated:YES];
    
}
@end
