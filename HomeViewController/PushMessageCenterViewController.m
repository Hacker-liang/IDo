//
//  PushMessageCenterViewController.m
//  IDo
//
//  Created by liangpengshuai on 12/30/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "PushMessageCenterViewController.h"
#import "PushMessageTableViewCell.h"
#import "PushMessageWebViewController.h"

@interface PushMessageCenterViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray *dateSource;
@property (nonatomic) NSInteger currentPage;
@end

@implementation PushMessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"信息中心";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"PushMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"pushMessageTableViewCell"];
    _currentPage = 1;
    [self loadPushMessage];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadPushMessage];
    }];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kPushUnreadNotiCacheKey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = APP_PAGE_COLOR;
    }
    return _tableView;
}

- (void)loadPushMessage
{
    NSString *url = @"http://a.bjwogan.com/Api/News";

    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[NSNumber numberWithInteger:_currentPage] forKey:@"page"];
    [mDict setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];

    [SVHTTPRequest GET:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [SVProgressHUD dismiss];
        [_tableView.footer endRefreshing];
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
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            NSString *content = dict[@"info"];
            if ([tempStatus integerValue] == 1) {
                _currentPage ++;
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObjectsFromArray:_dateSource];
                [array addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"list"]];
                _dateSource = array;
                [self.tableView reloadData];
                if ([[[dict objectForKey:@"data"] objectForKey:@"list"] count] < 10) {
                    [_tableView.footer noticeNoMoreData];
                }
               
            }else{
                if (content.length) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
            }
        } else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dateSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PushMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pushMessageTableViewCell" forIndexPath:indexPath];
    cell.messageData = _dateSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableViews deselectRowAtIndexPath:indexPath animated:YES];
    PushMessageWebViewController *ctl = [[PushMessageWebViewController alloc] init];
    ctl.pushMessageData = [_dateSource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}


@end
