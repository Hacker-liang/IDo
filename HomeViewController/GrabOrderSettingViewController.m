//
//  GrabOrderSettingViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/27/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "GrabOrderSettingViewController.h"
#import "GrabSettingPushTableViewCell.h"
#import "GrabSettingNotiTableViewCell.h"
#import "GrabSetTagTableViewCell.h"
#import "InputTagTableViewCell.h"
#import "HotTagTableViewCell.h"

@interface GrabOrderSettingViewController () <HotTagTableViewCellDelegate, GrabSetTagTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *allTagArray;
@property (nonatomic) BOOL hasScroll2Top;
@property (nonatomic) NSInteger rowCount;

@end

@implementation GrabOrderSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rowCount = 6;
    self.tableView.backgroundColor = APP_PAGE_COLOR;
    [self.tableView registerNib:[UINib nibWithNibName:@"GrabSettingPushTableViewCell" bundle:nil] forCellReuseIdentifier:@"grabSettingPushCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GrabSettingNotiTableViewCell" bundle:nil] forCellReuseIdentifier:@"grabSettingNotiCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GrabSetTagTableViewCell" bundle:nil] forCellReuseIdentifier:@"grabSetTagCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"InputTagTableViewCell" bundle:nil] forCellReuseIdentifier:@"inputTagCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HotTagTableViewCell" bundle:nil] forCellReuseIdentifier:@"hotTagCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"commonCell"];
    [self getMemberData];
    [self getALLabData];
    [self getMyLabData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSMutableArray *)allTagArray
{
    if (!_allTagArray) {
        _allTagArray = [[NSMutableArray alloc] init];
    }
    return _allTagArray;
}

-(void)getMemberData
{
    NSString *url = [NSString stringWithFormat:@"%@getmembermes",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
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
            if ([dict[@"status"] integerValue] == 1) {
                [UserManager shareUserManager].userInfo.pushType = [NSString stringWithFormat:@"%@",dict[@"data"][@"tsstatic"]];
                if ([[UserManager shareUserManager].userInfo.pushType isEqualToString:@"1"]) {
                    self.rowCount = 2;
                } else {
                    self.rowCount = 6;
                }
                [self.tableView reloadData];
            }
        }
    }];
}

- (void)getALLabData
{
    NSString *url = [NSString stringWithFormat:@"%@systemlabel",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"0" forKey:@"loadnumber"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];

            [self.allTagArray removeAllObjects];
            if ([dict isKindOfClass:[NSDictionary class]]) {
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
                for (NSDictionary *d in dict[@"data"]) {
                    [self.allTagArray addObject:d[@"name"]];
                }
                [self.tableView reloadData];
            }
           
        }
    }];
}

- (void)getMyLabData
{
    NSString *url = [NSString stringWithFormat:@"%@mylabel",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
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
            if ([dict[@"status"] integerValue] == 1) {
                NSArray *arr = dict[@"data"];
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                for (NSDictionary *d in arr) {
                    NSString *name = [NSString stringWithFormat:@"%@",d[@"labelname"]];
                    [tempArray addObject:name];
                }
                [UserManager shareUserManager].userInfo.tagArray = tempArray;
                [self.tableView reloadData];
            }
        }
    }];
}

- (void)saveChange
{
    GrabSettingPushTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    NSString *url = [NSString stringWithFormat:@"%@setqdrule",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];

    if (cell.allOrderBtn.selected) {
        [mDict setObject:@"2" forKey:@"tsstatic"];
    }
    [SVProgressHUD showWithStatus:@"正在设置"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response) {
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
            NSString *str=[NSString stringWithFormat:@"%@",dict[@"status"]];
            if ([str isEqualToString:@"1"]) {
                if (cell.allOrderBtn.selected) {
                    cell.allOrderBtn.selected = NO;
                    cell.tagOrderBtn.selected = YES;
                    [UserManager shareUserManager].userInfo.pushType = @"2";
                    [self getALLabData];
                    self.rowCount = 6;
                    
                } else {
                    cell.allOrderBtn.selected = YES;
                    cell.tagOrderBtn.selected = NO;
                    [UserManager shareUserManager].userInfo.pushType = @"1";
                    self.rowCount = 2;

                }
                [self.tableView reloadData];
                [SVProgressHUD showSuccessWithStatus:@"设置成功"];
                
            } else {
                [SVProgressHUD showErrorWithStatus:@"设置失败"];
                
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"设置失败"];
        }
    }];
}

- (void)pushSwitch:(UISwitch *)btn
{
    
}

- (void)allOrderAction:(UIButton *)btn
{
    if (!btn.selected) {
        [self saveChange];
    }
}

- (void)tagOrderAction:(UIButton *)btn
{
    if (!btn.selected) {
        [self saveChange];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3 || section == 4) {
        return 0.0001;
    }
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return [GrabSetTagTableViewCell heigthOfCellWithDataSource:[UserManager shareUserManager].userInfo.tagArray];
    } else if (indexPath.section == 4) {
        return 84.0;
        
    } else if (indexPath.section == 5){
        return [HotTagTableViewCell heigthOfCellWithDataSource:_allTagArray];
    } else {
        return 44.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GrabSettingNotiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"grabSettingNotiCell" forIndexPath:indexPath];
        [cell.switchBtn addTarget:self action:@selector(pushSwitch:) forControlEvents:UIControlEventValueChanged];
        [cell.switchBtn setOn:![UserManager shareUserManager].userInfo.isMute];
        return cell;
        
    } else if (indexPath.section == 1) {
        GrabSettingPushTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"grabSettingPushCell" forIndexPath:indexPath];
        [cell.allOrderBtn addTarget:self action:@selector(allOrderAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.tagOrderBtn addTarget:self action:@selector(tagOrderAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([[UserManager shareUserManager].userInfo.pushType isEqualToString:@"1"]) {
            cell.allOrderBtn.selected = YES;
            cell.tagOrderBtn.selected = NO;
        } else {
            cell.allOrderBtn.selected = NO;
            cell.tagOrderBtn.selected = YES;
        }

        return cell;

    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commonCell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"icon_myself.png"];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.text = @"我的标签";
        return cell;
        
    } else if (indexPath.section == 3) {
        GrabSetTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"grabSetTagCell" forIndexPath:indexPath];
        cell.dataSource = [UserManager shareUserManager].userInfo.tagArray;
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == 4) {
        InputTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inputTagCell" forIndexPath:indexPath];
        [cell.addBtn addTarget:self action:@selector(addTagAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        HotTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotTagCell" forIndexPath:indexPath];
        cell.dataSource = _allTagArray;
        cell.delegate = self;
        return cell;
    }
}

#pragma mark - HotTagTableViewCellDelegate

- (void)hotTagDidSelectItemAtIndex:(NSIndexPath *)indexPath
{
    [self addTag:[_allTagArray objectAtIndex:indexPath.row]];
}

- (void)addTag:(NSString *)tag
{
    [SVProgressHUD showWithStatus:@"正在添加"];
    NSString *url = [NSString stringWithFormat:@"%@addlabel",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    [mDict safeSetObject:tag forKey:@"labelname"];
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
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
            if((NSNull *)tempStatus != [NSNull null] && ![tempStatus isEqualToString:@"0"]) {
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                [[UserManager shareUserManager].userInfo.tagArray addObject:tag];
                [self.tableView reloadData];
                
            } else {
                [SVProgressHUD showErrorWithStatus:@"添加失败"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"添加失败"];
        }
    }];
}

- (void)setTagDidSelectItemAtIndex:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认删除标签吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSString *tag = [[UserManager shareUserManager].userInfo.tagArray objectAtIndex:indexPath.row];
            NSString *url = [NSString stringWithFormat:@"%@removelabel",baseUrl];
            NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
            [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
            [mDict setObject:tag forKey:@"labelname"];
            [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
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
                if((NSNull *)tempStatus != [NSNull null] && ![tempStatus isEqualToString:@"0"]) {
                    [[UserManager shareUserManager].userInfo.tagArray removeObjectAtIndex:indexPath.row];
                    [self.tableView reloadData];
                }
            }];
        }
    }];
   }

- (void)addTagAction:(UIButton *)btn
{
    InputTagTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:4]];
    if (cell.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"输入的标签不能为空"];
        return;
    }
    [self addTag:cell.textField.text];
    cell.textField.text = @"";
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 64 && [scrollView isEqual:self.tableView] && scrollView.contentOffset.y > 0 && !_hasScroll2Top) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGrabShouldSroll2Buttom object:nil];
        _hasScroll2Top = YES;
    } else if (scrollView.contentOffset.y < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGrabShouldSroll2Top object:nil];
        _hasScroll2Top = NO;
    }
}
@end
