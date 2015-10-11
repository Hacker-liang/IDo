//
//  MyOrderHistoryTableViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/26/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "MyOrderHistoryTableViewController.h"
#import "OrderListModel.h"
#import "OrderListTableViewCell.h"
#import "OrderDetailViewController.h"
#import "OrderListEmptyView.h"


@interface MyOrderHistoryTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) OrderListEmptyView *emptyView;

@end

@implementation MyOrderHistoryTableViewController

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
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (OrderListEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[OrderListEmptyView alloc] initWithFrame:CGRectMake(0,30, self.view.bounds.size.width, 200) andContent:@"暂无待处理订单"];
    }
    return _emptyView;
}

- (void)setupEmptyView
{
    if (!_dataSource.count) {
        [self.emptyView removeFromSuperview];
        [self.tableView addSubview:self.emptyView];
    } else {
        [self.emptyView removeFromSuperview];
    }
}

- (void)getOrder
{
    NSString *url;
    if (_isGrabOrder) {
        url = [NSString stringWithFormat:@"%@historyqiangdan",baseUrl];

    } else {
        url = [NSString stringWithFormat:@"%@historyfadan",baseUrl];
    }
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [self.tableView.header endRefreshing];
        if (response)
        {
            [self.dataSource removeAllObjects];
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSArray *tempList = dict[@"data"];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if((NSNull *)tempStatus != [NSNull null] && ![tempStatus isEqualToString:@"0"]) {
                for (NSDictionary *dic in tempList) {
                    OrderListModel *order = [[OrderListModel alloc] initWithJson:dic andIsSendOrder:!_isGrabOrder];
                    [self.dataSource addObject:order];
                }
            } else {
            }
            [self.tableView reloadData];
        }
        [self setupEmptyView];
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
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderListCell" forIndexPath:indexPath];
    cell.isGrabOrder = _isGrabOrder;
    OrderListModel *model = [self.dataSource objectAtIndex:indexPath.section];
    cell.orderDetail = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListModel *model = [self.dataSource objectAtIndex:indexPath.section];
    OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
    ctl.orderId = model.orderId;
    ctl.isSendOrder = !_isGrabOrder;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll: %lf", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < 64 && [scrollView isEqual:self.tableView] && scrollView.contentOffset.y > 0) {
        if (_isGrabOrder) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kGrabShouldSroll2Buttom object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kSendShouldSroll2Buttom object:nil];
            
        }
    } else if (scrollView.contentOffset.y < 0) {
        if (_isGrabOrder) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kGrabShouldSroll2Top object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kSendShouldSroll2Top object:nil];
            
        }
    }
}
@end
