//
//  SendMoneyVC.m
//  IDo
//
//  Created by 柯南 on 16/1/13.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "SendMoneyVC.h"
#import "SendOrderDetailViewController.h"
#import "SendOrderDetailHeaderView.h"
#import "CustomTableViewCell.h"
#import "OrderDetailModel.h"
#import "OrderContentTableViewCell.h"
#import "FYTimeViewController.h"
#import "ChangeLocationTableViewController.h"
#import "MyAnnotation.h"
#import "OrderDetailViewController.h"
#import "APService.h"
@interface SendMoneyVC ()<UIActionSheetDelegate, ChangeLocationDelegate>

@property (nonatomic ,strong) SendOrderDetailHeaderView *headerView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) OrderDetailModel *orderDetail;
@property (nonatomic, copy) NSString *showtime;
@property (nonatomic, strong) NSMutableArray *userList;

@end

@implementation SendMoneyVC

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        _orderDetail = [[OrderDetailModel alloc] init];
        UserInfo *userInfo = [UserManager shareUserManager].userInfo;
        _orderDetail.lat = [NSString stringWithFormat:@"%lf", userInfo.lat];
        _orderDetail.lng = [NSString stringWithFormat:@"%lf", userInfo.lng];
        _orderDetail.address = userInfo.address;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderDetail.price = @"0";
    _orderDetail.distance = @"10";
    self.navigationItem.title = @"派红包";
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"customCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderContentCell"];
    [self Time];
    [self setupTableViewFooterView];
    [self getWoGanUserdata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@[@{@"icon": @"icon_money.png"}],
                        @[@{@"icon": @"MoneyNumIcon"},
                          @{@"icon": @"RedMoneyIcon"},
                          @{@"icon": @""}
                          ]];
    }
    return _dataSource;
}

- (NSMutableArray *)userList
{
    if (!_userList) {
        _userList = [[NSMutableArray alloc] init];
    }
    return _userList;
}

- (SendOrderDetailHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [SendOrderDetailHeaderView sendOrderDetailHeaderView];
        [_headerView.locationBtn addTarget:self action:@selector(setupAddress) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _headerView;
}

- (void)setupTableViewFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 140)];
//    footerView.backgroundColor=[UIColor yellowColor];
    
    UIButton *moneyRuleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    moneyRuleBtn.frame=CGRectMake(0.3*WIDTH, 20, 0.4*WIDTH, 0.04*HEIGHT);
    [moneyRuleBtn setBackgroundImage:[UIImage imageNamed:@"MoneyRoalIcon"] forState:UIControlStateNormal];
    [moneyRuleBtn setBackgroundImage:[UIImage imageNamed:@"MoneyRoalIconCh"] forState:UIControlStateHighlighted];
//    moneyRuleBtn.backgroundColor=[UIColor yellowColor];
    [footerView addSubview:moneyRuleBtn];
    
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0.1*HEIGHT, footerView.bounds.size.width-20, 40)];
    logoutBtn.backgroundColor = APP_THEME_COLOR;
    logoutBtn.layer.cornerRadius = 5.0;
    [logoutBtn setTitle:@"立即派红包" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logoutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [logoutBtn addTarget:self action:@selector(sendMoney:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutBtn];
    self.tableView.tableFooterView = footerView;
}

- (void)setupAddress
{
    ChangeLocationTableViewController *ctl = [[ChangeLocationTableViewController alloc] init];
    ctl.delegate = self;
    ctl.cityCode = _headerView.city;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:ctl] animated:YES completion:nil];
}

//获取十分钟之后的时间
-(void)Time
{
    //    获取系统的当前时间
    NSDate *now = [NSDate date];
    
    NSDate *nextday=[NSDate dateWithTimeInterval:10*60 sinceDate:now];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nextday];
    
    int year =(int) [dateComponent year];
    int month =(int) [dateComponent month];
    int myday =(int) [dateComponent day];
    
    int myhour =(int) [dateComponent hour];
    int minute =(int) [dateComponent minute];
    //    int second=(int)[dateComponent second];
    _orderDetail.tasktime = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d:00",year,month,myday,myhour,minute];
    
    _showtime = [AppTools returnUploadTime:_orderDetail.tasktime isCurrentDay:YES];
}

#pragma mark - ChangeLocationDelegate

- (void)didChangeAddress:(float)lat lng:(float)lng address:(NSString *)address
{
    _orderDetail.lat = [NSString stringWithFormat:@"%lf", lat];
    _orderDetail.lng = [NSString stringWithFormat:@"%lf", lng];
    _orderDetail.address = address;
    [_headerView.locationBtn setTitle:address forState:UIControlStateNormal];
    _headerView.missionLocation = CLLocationCoordinate2DMake(lat, lng);
    [_headerView datouzhen];
}

#pragma mark - IBAction Methods

- (void)sendMoney:(id)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:1];
    OrderContentTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.orderDetail.content = cell.contentTextView.text;
    if (self.orderDetail.content.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"请输入红包寄语"];
        return;
    }
    
    if (!_orderDetail.address || _orderDetail.address.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请等待定位完成"];
        return;
    }
    
    if ([_orderDetail.price intValue] == 0) {
        [SVProgressHUD showErrorWithStatus:@"红包总金额不得低于0.01元"];
        return;
    }
    
    NSString *url;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    
    [SVProgressHUD showWithStatus:@"正在派单"];
    
    if (_headerView.vipContentView.hidden) {
        url = [NSString stringWithFormat:@"%@surepublishorder",baseUrl];
        [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"frommemberid"];
        [mDict safeSetObject:_orderDetail.content forKey:@"content"];
        [mDict safeSetObject:_orderDetail.price forKey:@"money"];
        [mDict safeSetObject:_orderDetail.tasktime forKey:@"timelength"];
        [mDict safeSetObject:_orderDetail.address forKey:@"serviceaddress"];
        [mDict safeSetObject:[UserManager shareUserManager].userInfo.districtid forKey:@"districtid"];
        [mDict safeSetObject:@"0" forKey:@"sex"];
        [mDict safeSetObject:@"0" forKey:@"range"];
        [mDict safeSetObject:[NSString stringWithFormat:@"%lf", _headerView.missionLocation.longitude] forKey:@"lng"];
        [mDict safeSetObject:[NSString stringWithFormat:@"%lf", _headerView.missionLocation.latitude] forKey:@"lat"];
        [mDict safeSetObject:@"" forKey:@"img"];
    } else {
        url = [NSString stringWithFormat:@"%@surepublishorderToVip", baseUrl];
        [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"frommemberid"];
        [mDict safeSetObject:_headerView.vipAnnotation.userid forKey:@"tomemberid"];
        [mDict safeSetObject:_orderDetail.content forKey:@"content"];
        [mDict safeSetObject:_orderDetail.price forKey:@"money"];
        [mDict safeSetObject:_orderDetail.tasktime forKey:@"timelength"];
        [mDict safeSetObject:_orderDetail.address forKey:@"serviceaddress"];
        [mDict safeSetObject:[UserManager shareUserManager].userInfo.districtid forKey:@"districtid"];
        [mDict safeSetObject:@"0" forKey:@"sex"];
        [mDict safeSetObject:@"0" forKey:@"range"];
        [mDict safeSetObject:_orderDetail.lng forKey:@"lng"];
        [mDict safeSetObject:_orderDetail.lat forKey:@"lat"];
        [mDict safeSetObject:@"" forKey:@"img"];
        
    }
    
    [mDict safeSetObject:_orderDetail.distance forKey:@"distance_range"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
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
            if([tempStatus integerValue] == 1) {
                [self sendOrderPushWithOrderId:[[dict objectForKey:@"data"] objectForKey:@"id"]];
                if (_headerView.vipContentView.hidden) {
                    [SVProgressHUD showSuccessWithStatus:@"派单成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kSendOrderSuccess object:nil];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"向VIP用户派单成功" message:@"可到正在进行的订单中关注状态" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
                        ctl.isSendOrder = YES;
                        ctl.orderId = [[dict objectForKey:@"data"] objectForKey:@"id"];
                        NSMutableArray *ctls = [self.navigationController.viewControllers mutableCopy];
                        [ctls replaceObjectAtIndex:ctls.count-1 withObject:ctl];
                        self.navigationController.viewControllers = ctls;
                    }];
                }
                
            } else {
                NSString *info = [dict objectForKey:@"info"];
                [SVProgressHUD showErrorWithStatus:info];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"派单失败"];
        }
    }];
}

- (void)sendOrderPushWithOrderId:(NSString *)orderId
{
    NSString *url = [NSString stringWithFormat:@"%@gettzpersonnum", baseUrl];
    
    [SVHTTPRequest POST:url parameters:@{@"orderid": orderId, @"devnumber": [APService registrationID]} completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
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
            if([tempStatus integerValue] == 1) {
                
            } else {
            }
        } else {
        }
    }];
    
}

- (void)getWoGanUserdata
{
    NSString *url = [NSString stringWithFormat:@"%@getuserinfo",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lat] forKey:@"lat"];
    [mDict setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lng] forKey:@"lng"];
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
            NSArray *tempList = dict[@"data"];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if((NSNull *)tempStatus != [NSNull null] && ![tempStatus isEqualToString:@"0"]) {
                [self.userList removeAllObjects];
                for (int i = 0; i < [tempList count]; i ++) {
                    MyAnnotation *annotation=[[MyAnnotation alloc]initWithDic:tempList[i]];
                    [self.userList addObject:annotation];
                }
                _headerView.userList = self.userList;
            }
            
        }
    }];
}

#pragma mark - TableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 250;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.headerView;
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 30)];
        label.backgroundColor = APP_PAGE_COLOR;
        label.text = @"*单个红包金额将根据您设定的总数随机生成*";
        label.font = [UIFont systemFontOfSize:11.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x858585);
        return label;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 && indexPath.section == 1) {
        return 100;
    }
//    if (indexPath.row == 2 && indexPath.section == 1) {
//        return 0.1;
//    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imageName = [[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"icon"];
    if (indexPath.row == 1 && indexPath.section == 1) {
        OrderContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderContentCell" forIndexPath:indexPath];
        cell.indicateImageView.image = [UIImage imageNamed: imageName];
        cell.placeholderTextField.text=@"请输入您的红包寄语...";
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
        
    } else {
        
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.indicateImageView.image = [UIImage imageNamed: imageName];
        if (indexPath.row == 0 && indexPath.section == 0) {
            NSString *str = [NSString stringWithFormat:@"红包总金额 %@ 元", _orderDetail.price];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(5,str.length-7)];
            [attStr addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(5, str.length-7)];
            cell.titleLabel.attributedText = attStr;
            
        } else if (indexPath.row == 0 && indexPath.section == 1) {
            NSString *str = [NSString stringWithFormat:@"红包总数 %@ 个", _orderDetail.price];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(5,str.length-7)];
            [attStr addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(5, str.length-7)];
            cell.titleLabel.attributedText = attStr;
            
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.row == 0 && indexPath.section == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"悬赏金额" message:nil delegate:nil cancelButtonTitle:@"取消"otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf=[alert textFieldAtIndex:0];
        if ([_orderDetail.price intValue] == 0) {
            tf.text = @"";
        } else {
            tf.text = _orderDetail.price;
        }
        tf.keyboardType = UIKeyboardTypeNumberPad;
        
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //得到输入框
                UITextField *tf=[alert textFieldAtIndex:0];
                if (tf.text.length > 0 && [tf.text integerValue] > 0)
                {
                    NSInteger test = [tf.text integerValue];
                    _orderDetail.price = [NSString stringWithFormat:@"%ld",test];
                    [self.tableView reloadData];
                }
            }
        }];
        
    } else if (indexPath.row == 0 && indexPath.section == 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"悬赏个数" message:nil delegate:nil cancelButtonTitle:@"取消"otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf=[alert textFieldAtIndex:0];
        if ([_orderDetail.price intValue] == 0) {
            tf.text = @"";
        } else {
            tf.text = _orderDetail.price;
        }
        tf.keyboardType = UIKeyboardTypeNumberPad;
        
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //得到输入框
                UITextField *tf=[alert textFieldAtIndex:0];
                if (tf.text.length > 0 && [tf.text integerValue] > 0)
                {
                    NSInteger test = [tf.text integerValue];
                    _orderDetail.price = [NSString stringWithFormat:@"%ld",test];
                    [self.tableView reloadData];
                }
            }
        }];
        
    }
}

#pragma mark --
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex + 1 >= actionSheet.numberOfButtons ) {
        return;
    }
    if (buttonIndex == 0)
    {
        if (actionSheet.tag == 600) {
            _orderDetail.sex = @"0";
        }else{
            _orderDetail.distance = @"5";
        }
    }
    else if (buttonIndex == 1)
    {
        if (actionSheet.tag == 600) {
            _orderDetail.sex = @"1";
        }else{
            _orderDetail.distance = @"10";
        }
    }
    else if (buttonIndex == 2)
    {
        if (actionSheet.tag == 600) {
            _orderDetail.sex = @"2";
        }else{
            _orderDetail.distance = @"15";
        }
    }
    [self.tableView reloadData];
}


@end
