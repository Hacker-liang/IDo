//
//  OrderDetailViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/26/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "PayViewController.h"

@interface OrderDetailViewController ()
{
    NSTimer *timer;
}

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic) int countdown;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    _mapview.showsUserLocation = YES;
    
    [[UserLocationManager shareInstance] getUserLocationWithCompletionBlcok:^(CLLocation *userLocation, NSString *address) {
        [self adjustMapViewWithLocation:userLocation.coordinate];
    }];
    _avatarImageView.layer.cornerRadius = 17.0;
    _avatarImageView.clipsToBounds = YES;
    [self getOrderInfo];
    [self.view addSubview:self.footerView];

}

- (void)viewDidLayoutSubviews
{
    [self.view bringSubviewToFront:self.footerView];
}

- (void)adjustMapViewWithLocation:(CLLocationCoordinate2D)location
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(location,span);
    MKCoordinateRegion adjustedRegion = [_mapview regionThatFits:region];
    [_mapview setRegion:adjustedRegion animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateView
{
    UserInfo *userInfo;
    if (_isSendOrder) {
        userInfo = _orderDetail.grabOrderUser;
    } else {
        userInfo = _orderDetail.sendOrderUser;
    }
    if (!_isSendOrder && userInfo.userid != 0) {
        _userDescLabel.text = [NSString stringWithFormat:@"已经发送%@单", userInfo.sendOrderCount];
    } else if (userInfo.userid != 0 && userInfo.userid != 0) {
        _userDescLabel.text = [NSString stringWithFormat:@"已经接%@单", userInfo.sendOrderCount];
    } else {
        _userDescLabel.text = nil;
    }
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"icon_avatar_default.png"]];
    _nickNameLabel.text = userInfo.nickName;

    _orderTimeLabel.text = _orderDetail.tasktime;
    _orderContentLabel.text = _orderDetail.content;
    _priceLabel.text = [NSString stringWithFormat:@"%@元", _orderDetail.price];
    [_addressBtn setTitle:_orderDetail.address forState:UIControlStateNormal];
    [_orderNumberBtn setTitle:[NSString stringWithFormat:@"订单编号  %@", _orderDetail.orderNumber] forState:UIControlStateNormal];
    
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([_orderDetail.lat floatValue], [_orderDetail.lng floatValue]);
    MKPointAnnotation* item = [[MKPointAnnotation alloc]init];
    item.coordinate = location;
    [_mapview addAnnotation:item];
    [_mapview setCenterCoordinate:location animated:YES];
    [self adjustMapViewWithLocation:location];
    [self setupFooterView];
    
    if (_orderDetail.orderStatus == kOrderGrabSuccess && _isSendOrder) {
        _countdown = _orderDetail.payCountdown;
        [self startCountdown];
        
    } else if (_orderDetail.orderStatus == kOrderInProgress) {
        _countdown = _orderDetail.grabCountdown;
        [self startCountdown];
    } else {
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        _timeLeftLabel.text = nil;
    }
}


- (void)startCountdown
{
    int min = _countdown/60;
    int sec = _countdown%60;
    if (sec < 10) {
        _timeLeftLabel.text = [NSString stringWithFormat:@"剩余(%d:0%d)", min, sec];
    } else {
        _timeLeftLabel.text = [NSString stringWithFormat:@"剩余(%d:%d)", min, sec];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLeftTime) userInfo:nil repeats:YES];
}

- (void)updateLeftTime
{
    if (_countdown == 0) {
        [timer invalidate];
        timer = nil;
    }
    _countdown--;
    int min = _countdown/60;
    int sec = _countdown%60;
    if (sec < 10) {
        _timeLeftLabel.text = [NSString stringWithFormat:@"剩余(%d:0%d)", min, sec];
    } else {
        _timeLeftLabel.text = [NSString stringWithFormat:@"剩余(%d:%d)", min, sec];
    }
}

- (void)grabOrder:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"正在抢单"];
    NSString *url = [NSString stringWithFormat:@"%@scrambleorder",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    [mDict setObject:_orderId forKey:@"orderid"];
    [mDict safeSetObject:[UserManager shareUserManager].userInfo.address forKey:@"address"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response) {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if ((NSNull *)tempStatus != [NSNull null]&&[tempStatus isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"恭喜你，抢单成功"];
                
            } else{
                [SVProgressHUD showErrorWithStatus:@"抢单失败了"];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"抢单失败了"];
        }
    }];
}

- (void)payOrder:(id)sender
{
    PayViewController *vc = [[PayViewController alloc] initWithPaySuccessBlock:^(BOOL success, NSString *errorStr) {
        if (success) {
            _orderDetail.orderStatus = kOrderPayed;
            [self updateView];
            [self setupFooterView];
        }
    }];
    vc.price = _orderDetail.price;
    vc.orderid = _orderDetail.orderId;
    vc.huoerbaoID = _orderDetail.grabOrderUser.userid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupFooterView
{
    if (_footerView) {
        _footerView = nil;
    }
    NSString *tipsString;
    NSString *statusString;

    if (_orderDetail.orderStatus == kOrderCancelGrabTimeOut) {
        statusString =  _orderDetail.orderStatusDesc;
        tipsString = @"保持良好记录有助于快速成交订单";
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];

    } else if (_orderDetail.orderStatus == kOrderInProgress && _isSendOrder) {
        statusString = _orderDetail.orderStatusDesc;
        tipsString = @"保持良好记录有助于快速成交订单";

        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-160, kWindowWidth, 60)];
        
    }  else if (_orderDetail.orderStatus == kOrderInProgress && !_isSendOrder) {
        tipsString = @"小提示：所示金额系统已自动扣减8%佣金";
        statusString = _orderDetail.orderStatusDesc;

        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-110, kWindowWidth, 110)];
        
        UIButton *orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, _footerView.bounds.size.width-40, 35)];
        orderBtn.layer.cornerRadius = 5.0;
        orderBtn.backgroundColor = APP_THEME_COLOR;
        [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        orderBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [orderBtn setTitle:@"立即抢单" forState:UIControlStateNormal];
        [orderBtn addTarget:self action:@selector(grabOrder:) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:orderBtn];
        
    } else if (_orderDetail.orderStatus == kOrderPayed) {
        tipsString = @"保持良好记录有助于快速成交订单";
        statusString = _orderDetail.orderStatusDesc;

        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-110, kWindowWidth, 110)];
        
        UIButton *orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, _footerView.bounds.size.width-40, 35)];
        orderBtn.layer.cornerRadius = 5.0;
        orderBtn.backgroundColor = APP_THEME_COLOR;
        [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        orderBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [orderBtn setTitle:@"立即验收" forState:UIControlStateNormal];
        [orderBtn addTarget:self action:@selector(checkOrder:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:orderBtn];
        
    } else if (_orderDetail.orderStatus == kOrderCancelPayTimeOut) {
        statusString = _orderDetail.orderStatusDesc;
        tipsString = @"保持良好记录有助于快速成交订单";

        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];
        
    } else if (_orderDetail.orderStatus == kOrderGrabSuccess && !_isSendOrder) {
        statusString = _orderDetail.orderStatusDesc;
        tipsString = @"保持良好记录有助于快速成交订单";
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];
        
    } else if (_orderDetail.orderStatus == kOrderCancelDispute) {
        statusString = _orderDetail.orderStatusDesc;
        tipsString = @"保持良好记录有助于快速成交订单";

        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];
        
    } else if (_orderDetail.orderStatus == kOrderGrabSuccess && _isSendOrder) {
        tipsString = @"保持良好记录有助于快速成交订单";
        statusString = _orderDetail.orderStatusDesc;
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-110, kWindowWidth, 110)];
        
        UIButton *orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, _footerView.bounds.size.width-40, 35)];
        orderBtn.layer.cornerRadius = 5.0;
        orderBtn.backgroundColor = APP_THEME_COLOR;
        [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        orderBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [orderBtn setTitle:@"立即付款" forState:UIControlStateNormal];
        [orderBtn addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:orderBtn];

    }
    
    _footerView.backgroundColor = [UIColor whiteColor];
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _footerView.bounds.size.width, 25)];
    tipsLabel.text = tipsString;
    tipsLabel.textColor = UIColorFromRGB(0x727272);
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont systemFontOfSize:14.0];
    [_footerView addSubview:tipsLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, _footerView.bounds.size.width, 25)];
    NSString *statusStr = [NSString stringWithFormat:@"状态: %@", statusString];
    NSMutableAttributedString *statusAttr = [[NSMutableAttributedString alloc] initWithString:statusStr];
    [statusAttr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName: APP_THEME_COLOR} range:NSMakeRange(3, statusStr.length-3)];
    [statusAttr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName: UIColorFromRGB(0x727272)} range:NSMakeRange(0, 3)];

    statusLabel.attributedText = statusAttr;
    statusLabel.textAlignment = NSTextAlignmentCenter;
    [_footerView addSubview:statusLabel];
    [self.view addSubview:_footerView];

}

- (void)getOrderInfo
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSString *url = [NSString stringWithFormat:@"%@getorderdetails",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:_orderId forKey:@"orderid"];
    
    if (_isSendOrder){
        [mDict setObject:@"1" forKey:@"type"];
    }else{
        [mDict setObject:@"2" forKey:@"type"];
    }
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [SVProgressHUD dismiss];
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if([tempStatus integerValue] == 1) {
                _orderDetail = [[OrderDetailModel alloc] initWithJson:[dict objectForKey:@"data"] andIsSendOrder:_isSendOrder];
                [self updateView];
            }
        }
    }];
}

#pragma mark -确认支付给活儿宝

- (void)checkOrder:(id)sender
{
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"确认任务验收" message:@"对方已按照要求完成任务，请确认支付，资金将直接支付给抢单人，谨慎操作。" delegate:self cancelButtonTitle:@"稍后验收" otherButtonTitles:@"确认验收", nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self confpay];
        }
    }];
}

- (void)confpay
{
    NSString *url = [NSString stringWithFormat:@"%@confpay",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:_orderDetail.orderId forKey:@"orderid"];
    [SVProgressHUD showWithStatus:@"正在付款"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [SVProgressHUD dismiss];
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if ([tempStatus integerValue] == 1) {
                UIAlertView * alertV = [[UIAlertView alloc]initWithTitle:@"恭喜，任务验收成功!" message:@"订单金额已向抢单人实时支付!您可以对抢单人的服务进行评价。" delegate:self cancelButtonTitle:@"稍后评价" otherButtonTitles:@"去评价", nil];
                _orderDetail.orderStatus = kOrderCheckDone;
                [self updateView];
                [self setupFooterView];
                [alertV showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
//                        EvaluationViewController *control = [[EvaluationViewController alloc] init];
//                        control.evaluationType = 1;
//                        control.orderid = self.orderId;
//                        [self.navigationController pushViewController:control animated:YES];
                    }
                }];
                
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"付款给活儿宝失败，请重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"付款给活儿宝失败，请重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}



@end
