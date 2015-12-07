//
//  MyOrderInProgressTableViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/26/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "MyOrderInProgressTableViewController.h"
#import "OrderListTableViewCell.h"
#import "OrderDetailViewController.h"
#import "OrderListEmptyView.h"
#import "OrderManager.h"

@interface MyOrderInProgressTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) OrderListEmptyView *emptyView;
@property (nonatomic) NSInteger currentPage;


@end

@implementation MyOrderInProgressTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderListTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListCell"];
    self.tableView.backgroundColor = APP_PAGE_COLOR;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        [self getOrder];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _currentPage++;
        [self getOrder];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView.header selector:@selector(beginRefreshing) name:OrderGrabStatusChange object:nil];
    
    [self.tableView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.header beginRefreshing];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.tableView.header];
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
    if (_isGrabOrder) {
        
        [OrderManager asyncLoadMyGrabInProgressOrderListWithPage:_currentPage pageSize:15 completionBlock:^(BOOL isSuccess, NSArray *orderList) {
            if (isSuccess) {
                if (_currentPage == 1) {
                    [_dataSource removeAllObjects];
                }
                [_dataSource addObjectsFromArray:orderList];
            }
            [self.tableView reloadData];
            [self setupEmptyView];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
        }];
        
    } else {
        [OrderManager asyncLoadMySendInProgressOrderListWithPage:_currentPage pageSize:15 completionBlock:^(BOOL isSuccess, NSArray *orderList) {
            if (isSuccess) {
                if (_currentPage == 1) {
                    [_dataSource removeAllObjects];
                }
                [_dataSource addObjectsFromArray:orderList];
            }
            [self.tableView reloadData];
            [self setupEmptyView];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
        }];
    }
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
