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
#import "OrderListEmptyView.h"

@interface GrabOrderListTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) OrderListEmptyView *emptyView;

@end

@implementation GrabOrderListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderListTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListCell"];
    self.tableView.backgroundColor = APP_PAGE_COLOR;
    [self.tableView.header beginRefreshing];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getOrder];
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self.tableView.header selector:@selector(beginRefreshing) name:kNewOrderNoti object:nil];
    
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    NSString *url = [NSString stringWithFormat:@"%@getorderlist",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    [mDict setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lng] forKey:@"lng"];
    [mDict setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lat] forKey:@"lat"];

    
    NSLog(@"url %@  mdic %@",url,mDict);
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [self.tableView.header endRefreshing];
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
            NSArray *tempList = dict[@"data"];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if((NSNull *)tempStatus != [NSNull null] && ![tempStatus isEqualToString:@"0"]) {
                [self.dataSource removeAllObjects];
                for (NSDictionary *dic in tempList) {
                    OrderListModel *order = [[OrderListModel alloc] initWithJson:dic andIsSendOrder:NO];
                    [self.dataSource addObject:order];
                }
                [self setupEmptyView];
                
            } else {
                [self.dataSource removeAllObjects];
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
    NSLog(@"scrollViewDidScroll: %lf", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < 64 && [scrollView isEqual:self.tableView] && scrollView.contentOffset.y > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGrabShouldSroll2Buttom object:nil];
    } else if (scrollView.contentOffset.y < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGrabShouldSroll2Top object:nil];
    }
}
@end
