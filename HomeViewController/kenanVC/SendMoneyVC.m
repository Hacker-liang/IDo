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
#import "PayViewController.h"

#import "RedRuleVC.h"
@interface SendMoneyVC ()<UIActionSheetDelegate, ChangeLocationDelegate, UITextViewDelegate>

@property (nonatomic ,strong) SendOrderDetailHeaderView *headerView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) OrderDetailModel *orderDetail;
@property (nonatomic, copy) NSString *showtime;
@property (nonatomic, strong) NSMutableArray *userList;

//发送红包的金额，个数，内容
@property (nonatomic,strong) NSString *moneyTotal;
@property (nonatomic,strong) NSString *moneyCount;
@property (nonatomic,strong) NSString *moneyContent;

@property (nonatomic,strong) NSString *RedMoneyID;


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
    _moneyTotal = @"0";
    _moneyCount = @"0";

    _orderDetail.distance = @"10";
    self.navigationItem.title = @"派红包";
    self.view.backgroundColor=APP_PAGE_COLOR;
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"customCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderContentCell"];
    [self Time];
    [self setupTableViewFooterView];
    [self getWoGanUserdata];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xb73725);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
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
    UIView *footerView;
    UIButton *logoutBtn;
    if (IS_IPHONE_6P) {
         footerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 190)];
        footerView.backgroundColor=APP_PAGE_COLOR;
        logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,140, footerView.bounds.size.width-20, 40)];

    } else if (IS_IPHONE_6) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 140)];
        footerView.backgroundColor=APP_PAGE_COLOR;
        logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,footerView.frame.size.height-60, footerView.bounds.size.width-20, 40)];
    } else {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 140)];
        footerView.backgroundColor=APP_PAGE_COLOR;
        logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,footerView.frame.size.height-90, footerView.bounds.size.width-20, 40)];
    }
    
    UIButton *moneyRuleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    moneyRuleBtn.frame=CGRectMake(0.33*WIDTH, 20, 0.3*WIDTH, 30*HEIGHT/1136);
    [moneyRuleBtn setBackgroundImage:[UIImage imageNamed:@"MoneyRoalIcon"] forState:UIControlStateNormal];
//    [moneyRuleBtn setBackgroundImage:[UIImage imageNamed:@"MoneyRoalIconCh"] forState:UIControlStateHighlighted];
    [moneyRuleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
    [moneyRuleBtn setTitle:@"红包派发规则" forState:UIControlStateNormal];
    [moneyRuleBtn setTitleColor:UIColorFromRGB(0x606060) forState:UIControlStateNormal];
    moneyRuleBtn.titleLabel.font=[UIFont systemFontOfSize:0.05*WIDTH];
//    [moneyRuleBtn setTitleColor:APP_THEME_COLOR forState:UIControlStateHighlighted];
//    moneyRuleBtn.backgroundColor=[UIColor yellowColor];
    [moneyRuleBtn addTarget:self action:@selector(redRule) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:moneyRuleBtn];
    
    
    
    
    logoutBtn.backgroundColor = UIColorFromRGB(0xBC4E3F);
    logoutBtn.layer.cornerRadius = 5.0;
    [logoutBtn setTitle:@"立即派红包" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logoutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [logoutBtn addTarget:self action:@selector(sendMoney:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutBtn];
    self.tableView.tableFooterView = footerView;
}

#pragma mark 红包派发规则
-(void)redRule
{
    RedRuleVC *redRule=[[RedRuleVC alloc]init];
    [self.navigationController pushViewController:redRule animated:NO];
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
    
//    NSLog(@"[_moneyTotal floatValue] %f",[_moneyTotal doubleValue]);
    
    if ([_moneyTotal doubleValue] < 0.010000) {
        [SVProgressHUD showErrorWithStatus:@"红包总金额不得低于0.01元"];
        return;
    }
    
    if ([_moneyTotal doubleValue] >200) {
        [SVProgressHUD showErrorWithStatus:@"红包总金额不许大于200元"];
        return;
    }
    
    if ([_moneyCount intValue] == 0) {
        [SVProgressHUD showErrorWithStatus:@"红包总个数不得低于1"];
        return;
    }
    
    if ([_moneyCount intValue] > 50) {
        [SVProgressHUD showErrorWithStatus:@"红包总个数不得大于50"];
        return;
    }
    
    
    
    NSLog(@"[_moneyTotal floatValue]/[_moneyCount intValue] %f",[_moneyTotal doubleValue]/[_moneyCount intValue]);
    
    if ([_moneyTotal doubleValue]/[_moneyCount intValue] <0.010000 == YES ) {
        [SVProgressHUD showErrorWithStatus:@"红包单个金额不得低于0.01"];
        return;
    }

    
    NSString *url;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    
    [SVProgressHUD showWithStatus:@"正在派红包"];
    
    if (_headerView.vipContentView.hidden) {
        url = [NSString stringWithFormat:@"%@sendRedEnvelope",baseUrl];
        [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"publisherMemberId"];
        [mDict safeSetObject:[NSString stringWithFormat:@"%lf", _headerView.missionLocation.longitude] forKey:@"lng"];
        [mDict safeSetObject:[NSString stringWithFormat:@"%lf", _headerView.missionLocation.latitude] forKey:@"lat"];
        [mDict safeSetObject:_moneyTotal forKey:@"money"];
        [mDict safeSetObject:_moneyCount forKey:@"totalCount"];
        [mDict safeSetObject:_orderDetail.content forKey:@"content"];
        [mDict safeSetObject:_orderDetail.address forKey:@"address"];


    } else {
        url = [NSString stringWithFormat:@"%@sendRedEnvelope",baseUrl];
        [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"publisherMemberId"];
        [mDict safeSetObject:[NSString stringWithFormat:@"%lf", _headerView.missionLocation.longitude] forKey:@"lng"];
        [mDict safeSetObject:[NSString stringWithFormat:@"%lf", _headerView.missionLocation.latitude] forKey:@"lat"];
        [mDict safeSetObject:_moneyTotal forKey:@"money"];
        [mDict safeSetObject:_moneyCount forKey:@"totalCount"];
        [mDict safeSetObject:_orderDetail.content forKey:@"content"];
        //        [mDict safeSetObject:_orderDetail.tasktime forKey:@"timelength"];
        [mDict safeSetObject:_orderDetail.address forKey:@"address"];
        //        [mDict safeSetObject:[UserManager shareUserManager].userInfo.districtid forKey:@"districtid"];
        
    }
    
//    [mDict safeSetObject:_orderDetail.distance forKey:@"distance_range"];
    
    NSLog(@"0121%@%@",url,mDict);
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
//            NSLog(@"kenan kenan %@",dict);

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
                _RedMoneyID=[dict objectForKey:@"data"][@"redId"];
//                [self sendOrderPushWithRedId:_RedMoneyID];
                if (_headerView.vipContentView.hidden) {
                    [SVProgressHUD showSuccessWithStatus:@"派单成功"];
//                    [self.navigationController popViewControllerAnimated:YES];
                    NSLog(@"红包发送成功");
                    [self payRedMoney];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kSendOrderSuccess object:nil];
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


#pragma mark 红包支付
- (void)payRedMoney
{
    PayViewController *vc = [[PayViewController alloc] init];
    vc.fatherC=@"RedMoney";
    vc.price = _moneyTotal;
    vc.redEnvelopeId=_RedMoneyID;
    vc.isRedMoney=YES;
    [self.navigationController pushViewController:vc animated:YES];

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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, WIDTH-70, 30)];
        label.backgroundColor = APP_PAGE_COLOR;
        label.text = @"            *单个红包金额将根据您设定的总数随机生成*";
        label.font = [UIFont systemFontOfSize:11.0];
//        label.textAlignment = 1;
        label.textAlignment=0;
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
        return 90;
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
        cell.placeholderTextField.text = @"请输入您的红包寄语...";
        cell.isSendRed = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
        
    } else {
        
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.indicateImageView.image = [UIImage imageNamed: imageName];
        if (indexPath.row == 0 && indexPath.section == 0) {
            NSString *str = [NSString stringWithFormat:@"红包总金额 %@ 元", _moneyTotal];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(5,str.length-7)];
            [attStr addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(5, str.length-7)];
            cell.titleLabel.attributedText = attStr;
            
        } else if (indexPath.row == 0 && indexPath.section == 1) {
            NSString *str = [NSString stringWithFormat:@"红包总数 %@ 个", _moneyCount];
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"红包总金额" message:nil delegate:nil cancelButtonTitle:@"取消"otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf=[alert textFieldAtIndex:0];
        if ([_moneyTotal isEqualToString:@"0"]) {
            tf.text = @"";
        } else {
            tf.text = _moneyTotal;
        }
        tf.keyboardType = UIKeyboardTypeDefault;
        
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //得到输入框
                UITextField *tf=[alert textFieldAtIndex:0];
                if (tf.text.length > 0 )
                {
                    _moneyTotal = [NSString stringWithFormat:@"%0.2f",[tf.text floatValue]];
                    
                    [self.tableView reloadData];
                }
            }
        }];
        
    } else if (indexPath.row == 0 && indexPath.section == 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"红包总数" message:nil delegate:nil cancelButtonTitle:@"取消"otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf=[alert textFieldAtIndex:0];
        if ([_moneyCount intValue] == 0) {
            tf.text = @"";
        } else {
            tf.text = _moneyCount;
        }
        tf.keyboardType = UIKeyboardTypeNumberPad;
        
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //得到输入框
                UITextField *tf=[alert textFieldAtIndex:0];
                if (tf.text.length > 0 && [tf.text integerValue] > 0)
                {
                    NSInteger test = [tf.text integerValue];
                    _moneyCount = [NSString stringWithFormat:@"%ld",test];
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
