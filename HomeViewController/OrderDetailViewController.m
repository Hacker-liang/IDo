//
//  OrderDetailViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/26/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()

@property (nonatomic, strong) UIView *footerView;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    _mapview.showsUserLocation = YES;
    
    [[UserLocationManager shareInstance] getUserLocationWithCompletionBlcok:^(CLLocation *userLocation, NSString *address) {
        [self adjustMapViewWithLocation:userLocation];
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

- (void)adjustMapViewWithLocation:(CLLocation *)location
{
    CLLocationCoordinate2D centerPoint = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerPoint,span);
    MKCoordinateRegion adjustedRegion = [_mapview regionThatFits:region];
    [_mapview setRegion:adjustedRegion animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateView
{
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_orderDetail.userInfo.avatar]];
    _nickNameLabel.text = _orderDetail.userInfo.nickName;
    _userDescLabel.text = _orderDetail.userInfo.userLabel;
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

- (UIView *)footerView
{
    if (!_footerView) {
        NSString *tipsString;
        NSString *statusString;

        if (_orderDetailType == HistoryPie) {
            statusString = @"无人抢单，已取消";
            tipsString = @"小提示：保持良好的记录有助于快速成交订单";
            _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];

        } else if (_orderDetailType == OrderIngPie) {
            statusString = @"等待活儿宝抢单";
            tipsString = @"小提示：保持良好的记录有助于快速成交订单";
            _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];
            
        }  else if (_orderDetailType == OrderIngGrab) {
            tipsString = @"小提示：所示金额系统已自动扣减8%佣金";
            statusString = @"等待活儿宝抢单";
            _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-110, kWindowWidth, 110)];
            
            UIButton *orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, _footerView.bounds.size.width-40, 35)];
            orderBtn.layer.cornerRadius = 5.0;
            orderBtn.backgroundColor = APP_THEME_COLOR;
            [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            orderBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
            [orderBtn setTitle:@"立即抢单" forState:UIControlStateNormal];
            [orderBtn addTarget:self action:@selector(grabOrder:) forControlEvents:UIControlEventTouchUpInside];
            
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

    }
    return _footerView;
}

- (void)getOrderInfo
{
    NSString *url = [NSString stringWithFormat:@"%@getorderdetails",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:_orderId forKey:@"orderid"];
    
    if (self.orderDetailType == HistoryPie || self.orderDetailType == OrderIngPie || self.orderDetailType == OrderFinish){
        [mDict setObject:@"1" forKey:@"type"];
    }else{
        [mDict setObject:@"2" forKey:@"type"];
    }
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if([tempStatus integerValue] == 1) {
                _orderDetail = [[OrderDetailModel alloc] initWithJson:[dict objectForKey:@"data"]];
                [self updateView];
            }
        }
    }];
}


@end
