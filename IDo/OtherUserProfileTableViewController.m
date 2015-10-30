//
//  OtherUserProfileTableViewController.m
//  IDo
//
//  Created by liangpengshuai on 10/7/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "OtherUserProfileTableViewController.h"
#import "MyProfileHeaderView.h"
#import "MyProfileTableViewCell.h"
#import "ASIFormDataRequest.h"
#import "Requtst2BeVIPViewController.h"
#import "EvaluationTableViewCell.h"

@interface OtherUserProfileTableViewController () <UIImagePickerControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) MyProfileHeaderView *myprofileHeaderView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIImage *headerImage;


@end

@implementation OtherUserProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"EvaluationTableViewCell" bundle:nil] forCellReuseIdentifier:@"ratingCell"];
    [self getRecord];
    self.navigationItem.title = @"个人中心";
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 70)];
    self.tableView.tableFooterView = view;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (MyProfileHeaderView *)myprofileHeaderView
{
    if (!_myprofileHeaderView) {
        _myprofileHeaderView = [MyProfileHeaderView myProfileHeaderView];
        _myprofileHeaderView.showSexImage = YES;
        _myprofileHeaderView.userInfo = _userInfo;
    }
    return _myprofileHeaderView;
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
    [mDict setObject:_userInfo.userid forKey:@"memberid"];
    
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
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if ([tempStatus integerValue] == 1) {
                self.dataSource = dict[@"data"];
                [self.tableView reloadData];
            }
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
    if (section == 0) {
        return 270;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.myprofileHeaderView;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)stableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ratingCell" forIndexPath:indexPath];
    cell.evaluationType = _evaluationType;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentDic = _dataSource[indexPath.section-1];
    return cell;
}

@end
