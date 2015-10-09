//
//  EvaluationRecordViewController.m
//  IDo
//
//  Created by YangJiLei on 15/9/5.
//  Copyright (c) 2015年 IDo. All rights reserved.
//

#import "EvaluationRecordViewController.h"
#import "EvaluationTableViewCell.h"

@interface EvaluationRecordViewController ()

@end

@implementation EvaluationRecordViewController
@synthesize evaluationType,dataArr;

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价记录";
    self.view.backgroundColor = APP_PAGE_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"EvaluationTableViewCell" bundle:nil] forCellReuseIdentifier:@"ratingCell"];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getRecord];
    }];
       [[NSNotificationCenter defaultCenter] addObserver:self.tableView.header selector:@selector(beginRefreshing) name:kNewRating object:nil];
    
    [self.tableView.header beginRefreshing];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getRecord
{
    NSString *url = @"";
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    if (self.evaluationType == 1) {
        //发单人对接单人的评价，传的是接单人的id
        url = [NSString stringWithFormat:@"%@guzhucomment",baseUrl];
    }else{
         //接单人对发单人的评价，传的是发单人的id
        url = [NSString stringWithFormat:@"%@huobaocomment",baseUrl];
    }
    [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];


    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [self.tableView.header endRefreshing];
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if ([tempStatus integerValue] == 1) {
                self.dataArr = dict[@"data"];
                [self.tableView reloadData];
            }
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table view data source
//设置区域个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 20;
}

//设置每个区域的Item个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)stableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ratingCell" forIndexPath:indexPath];
    cell.evaluationType = evaluationType;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentDic = dataArr[indexPath.section];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
@end
