//
//  SendOrderDetailViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "SendOrderDetailViewController.h"
#import "SendOrderDetailHeaderView.h"
#import "CustomTableViewCell.h"
#import "OrderDetailModel.h"
#import "OrderContentTableViewCell.h"
#import "FYTimeViewController.h"

@interface SendOrderDetailViewController () <UIActionSheetDelegate>

@property (nonatomic ,strong) SendOrderDetailHeaderView *headerView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) OrderDetailModel *orderDetail;
@property (nonatomic, copy) NSString *showtime;

@end

@implementation SendOrderDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderDetail = [[OrderDetailModel alloc] init];
    _orderDetail.price = @"5";
    _orderDetail.distance = @"5";
    self.navigationItem.title = @"立即派单";
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"customCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderContentCell"];
    [self Time];
    [self setupTableViewFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@{@"icon": @"icon_time"},
                        @{@"icon": @"icon_money.png"},
                        @{@"icon": @"icon_content.png"},
                        @{@"icon": @"icon_distance.png"}
                        ];
    }
    return _dataSource;
}


- (SendOrderDetailHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [SendOrderDetailHeaderView sendOrderDetailHeaderView];
    }
    return _headerView;
}

- (void)setupTableViewFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 140)];
    
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, footerView.bounds.size.width-20, 40)];
    logoutBtn.backgroundColor = APP_THEME_COLOR;
    logoutBtn.layer.cornerRadius = 5.0;
    [logoutBtn setTitle:@"立即派单" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logoutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [logoutBtn addTarget:self action:@selector(sendOrder:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutBtn];
    self.tableView.tableFooterView = footerView;
}

- (void)setupTime
{
    
}

- (void)setupMoney
{
    
}

- (void)setupDestance
{
    
}

- (void)setupAddress
{
    
}

//获取十分钟之后的时间
-(void)Time
{
    //    获取系统的当前时间
    NSDate *now = [NSDate date];
    
    NSDate *nextday=[NSDate dateWithTimeInterval:20*60 sinceDate:now];
    
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

#pragma mark - IBAction Methods

- (void)sendOrder:(id)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
    OrderContentTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.orderDetail.content = cell.contentTextView.text;
    if (self.orderDetail.content.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"请输入任务要求"];
        return;
    }
    
    if (_orderDetail.lat == 0) {
        [SVProgressHUD showErrorWithStatus:@"请等待定位完成"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在派单"];
    NSString *url = [NSString stringWithFormat:@"%@surepublishorder",baseUrl];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"frommemberid"];
    [mDict safeSetObject:_orderDetail.content forKey:@"content"];
    [mDict safeSetObject:@"0.01" forKey:@"money"];
    [mDict safeSetObject:_orderDetail.tasktime forKey:@"timelength"];
    [mDict safeSetObject:_orderDetail.address forKey:@"serviceaddress"];
    [mDict safeSetObject:_orderDetail.sex forKey:@"sex"];
    [mDict safeSetObject:@"1" forKey:@"range"];
    [mDict safeSetObject:@"" forKey:@"img"];
    [mDict safeSetObject:_orderDetail.lng forKey:@"lng"];
    [mDict safeSetObject:_orderDetail.lat forKey:@"lat"];
    [mDict safeSetObject:_orderDetail.distance forKey:@"distance_range"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if([tempStatus integerValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"派单成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"派单失败"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"派单失败"];
        }
    }];

}

#pragma mark - TableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 250;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.headerView.orderDetailModel = self.orderDetail;
    return self.headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return 100;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imageName = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"icon"];
    if (indexPath.row == 2) {
        OrderContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderContentCell" forIndexPath:indexPath];
        cell.indicateImageView.image = [UIImage imageNamed: imageName];
        cell.accessoryType = UITableViewCellAccessoryNone;

        return cell;
    } else {
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.indicateImageView.image = [UIImage imageNamed: imageName];
        if (indexPath.row == 0) {
            cell.titleLabel.text = _showtime;
        } else if (indexPath.row == 1) {
            cell.titleLabel.text = [NSString stringWithFormat:@"￥%@", _orderDetail.price];
        } else if (indexPath.row == 3) {
            cell.titleLabel.text = [NSString stringWithFormat:@"发单范围  %@公里", _orderDetail.distance];

        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.row == 0) {
        
        FYTimeViewController *control = [[FYTimeViewController alloc] init];
        control.postValue=^(NSString *aShowTime,NSString *aTaskTime)
        {
            _orderDetail.tasktime = aTaskTime;
            CustomTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            _showtime = aShowTime;
            cell.titleLabel.text = _showtime;
        };
        [self.navigationController pushViewController:control animated:YES];
        
    } else if (indexPath.row == 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"悬赏金额" message:nil delegate:nil cancelButtonTitle:@"取消"otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf=[alert textFieldAtIndex:0];
        tf.text = _orderDetail.price;
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
        
    } else if (indexPath.row == 3) {
        UIActionSheet * editActionSheet = [[UIActionSheet alloc] initWithTitle:@"发单范围" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"5公里",@"10公里",@"15公里",nil];
        [editActionSheet addButtonWithTitle:@"取消"];
        editActionSheet.delegate = self;
        editActionSheet.tag = 601;
        [editActionSheet showInView:self.view];
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
