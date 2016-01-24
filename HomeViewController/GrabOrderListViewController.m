//
//  GrabOrderListViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/24/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "GrabOrderListViewController.h"
#import "OrderListTableViewCell.h"
#import "OrderListModel.h"
#import "OrderDetailViewController.h"
#import "OrderListEmptyView.h"
#import "MissOrderListViewController.h"
#import "OrderManager.h"

@interface GrabOrderListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) OrderListEmptyView *emptyView;
@property (nonatomic) NSInteger currentPage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *missOrderBtn;

@end

@implementation GrabOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    _dataSource = [[NSMutableArray alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderListTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListCell"];
    self.tableView.backgroundColor = APP_PAGE_COLOR;
    [self.tableView.header beginRefreshing];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [self getOrderWithPage:_currentPage+1];
    }];
    
    //    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        [self getOrderWithPage:_currentPage+1];
    //    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView.header selector:@selector(beginRefreshing) name:kNewOrderNoti object:nil];
    
    _missOrderBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [_missOrderBtn setTitle:@"错过\n订单" forState:UIControlStateNormal];
    _missOrderBtn.titleLabel.numberOfLines = 2;
    [_missOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_missOrderBtn addTarget:self action:@selector(gotoMissOrderList) forControlEvents:UIControlEventTouchUpInside];
    _missOrderBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    _missOrderBtn.layer.cornerRadius = 20;
    
//    _missOrderBtn.hidden = YES;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (void)gotoMissOrderList
{
    MissOrderListViewController *ctl = [[MissOrderListViewController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)getOrderWithPage:(NSInteger)page
{
    [OrderManager asyncLoadNearByOrderListWithPage:page pageSize:200 completionBlock:^(BOOL isSuccess, NSArray *orderList) {
        if (isSuccess) {
            _currentPage = page;
            if (_currentPage == 1) {
                [_dataSource removeAllObjects];
            }
            [_dataSource addObjectsFromArray:orderList];
        }
        [self setupEmptyView];
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
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
    OrderListModel *model = [self.dataSource objectAtIndex:indexPath.section];
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderListCell" forIndexPath:indexPath];
    
    cell.isGrabOrder = YES;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 64 && [scrollView isEqual:self.tableView] && scrollView.contentOffset.y > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGrabShouldSroll2Buttom object:nil];
    } else if (scrollView.contentOffset.y < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGrabShouldSroll2Top object:nil];
    }
}

@end
