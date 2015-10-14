//
//  OrderDetailViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/26/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "PayViewController.h"
#import "EvaluationViewController.h"
#import "ComplaintViewController.h"
#import "FYAnnotation.h"
#import "FYAnnotationView.h"
#import "MoreTextViewController.h"
#import "OtherUserProfileTableViewController.h"

@interface OrderDetailViewController () <MKMapViewDelegate>
{
    NSTimer *timer;
}

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic) CLLocationCoordinate2D userLocation;
@property (nonatomic) CLLocationCoordinate2D missionLocation;

@property (nonatomic) int countdown;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
//    _mapview.showsUserLocation = YES;
    _cancelBtn.hidden = YES;
    _complainBtn.hidden = YES;
    _mapview.delegate = self;
    _orderContentLabel.adjustsFontSizeToFitWidth = YES;
    _conteViewConstraint.constant = 14;
    _addressBtn.titleLabel.numberOfLines = 0;
    _complainBtn.layer.cornerRadius = 3.0;
    _complainBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _complainBtn.layer.borderWidth = 0.5;
    
    _cancelBtn.layer.cornerRadius = 3.0;
    _cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _cancelBtn.layer.borderWidth = 0.5;
    
    UITapGestureRecognizer *tapGestureTwo = [[UITapGestureRecognizer alloc] init];
    tapGestureTwo.numberOfTapsRequired = 1;
    tapGestureTwo.numberOfTouchesRequired = 1;
    [tapGestureTwo addTarget:self action:@selector(gotoMoreContent)];
    [_orderContentLabel addGestureRecognizer:tapGestureTwo];
    
    _avatarImageView.layer.cornerRadius = 20.0;
    _avatarImageView.clipsToBounds = YES;
    [self getOrderInfo];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [tapGesture addTarget:self action:@selector(gotoUserProfile)];
    [_avatarImageView addGestureRecognizer:tapGesture];

    [self.view addSubview:self.footerView];
    [_phoneLabel addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
    [_complainBtn addTarget:self action:@selector(complainAction) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc
{
    _mapview.showsUserLocation = NO;
    _mapview.delegate = nil;
    _mapview = nil;
    [_mapview removeFromSuperview];
}

- (void)updateDetailViewWithStatus:(OrderStatus)status andShouldReloadOrderDetail:(BOOL)isReload
{
    _orderDetail.orderStatus = status;
    [self updateView];
    if (isReload) {
        [self getOrderInfo];
    }
}

- (void)viewDidLayoutSubviews
{
    [self.view bringSubviewToFront:self.footerView];
}

- (void)adjustMapViewWithLocation:(CLLocationCoordinate2D)location
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
    MKCoordinateRegion region = MKCoordinateRegionMake(location,span);
    MKCoordinateRegion adjustedRegion = [_mapview regionThatFits:region];
    [_mapview setRegion:adjustedRegion animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)gotoMoreContent
{
    MoreTextViewController *ctl = [[MoreTextViewController alloc] initWithNibName:@"MoreTextViewController" bundle:nil];
    [self.navigationController pushViewController:ctl animated:YES];
    ctl.content = _orderDetail.content;
}

- (void)gotoUserProfile
{
    UserInfo *userInfo;
    if (_isSendOrder) {
        userInfo = _orderDetail.grabOrderUser;
    } else {
        userInfo = _orderDetail.sendOrderUser;
    }
    OtherUserProfileTableViewController *ctl = [[OtherUserProfileTableViewController alloc] init];
    ctl.userInfo = userInfo;
    if (_isSendOrder){
        ctl.evaluationType = 1;
    }else{
        ctl.evaluationType = 2;
    }
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)updateView
{
    UserInfo *userInfo;
    if (_isSendOrder) {
        userInfo = _orderDetail.grabOrderUser;
    } else {
        userInfo = _orderDetail.sendOrderUser;
    }
    if (userInfo.userid.length != 0) {
        _conteViewConstraint.constant = 64;
    } else {
        _conteViewConstraint.constant = 14;
    }
    NSString *sex = userInfo.sex;
    if ([sex isEqualToString:@"1"]) {
        [_sexImageView setImage:[UIImage imageNamed:@"icon_male.png"]];
    } else {
        [_sexImageView setImage:[UIImage imageNamed:@"icon_female.png"]];
    }
    
    CLLocation *current = [[CLLocation alloc] initWithLatitude:_userLocation.latitude longitude:_userLocation.longitude];
    //第二个坐标
    CLLocation *before=[[CLLocation alloc] initWithLatitude:_missionLocation.latitude longitude:_missionLocation.longitude];
    CLLocationDistance meters=[current distanceFromLocation:before];

    if (!_isSendOrder && userInfo.userid != 0) {
        _userDescLabel.text = [NSString stringWithFormat:@"成功发单%@笔  距离%.3f公里", userInfo.sendOrderCount, (int)meters/1000.0];
    } else if (userInfo.userid != 0 && userInfo.userid != 0) {
        _userDescLabel.text = [NSString stringWithFormat:@"成功接单%@笔  距离%.3f公里", userInfo.grabOrderCount, (int)meters/1000.0];
    } else {
        _userDescLabel.text = nil;
    }
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"icon_avatar_default.png"]];
    _nickNameLabel.text = userInfo.nickName;

    _orderTimeLabel.text = _orderDetail.tasktime;
    _orderContentLabel.text = _orderDetail.content;
    _orderContentLabel.adjustsFontSizeToFitWidth = YES;
    
    NSString *str = [NSString stringWithFormat:@"%@元", _orderDetail.price];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0] range:NSMakeRange(0,str.length-1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str.length-1)];
    _priceLabel.attributedText = attStr;
    _priceLabel.adjustsFontSizeToFitWidth = YES;


    [_addressBtn setTitle:_orderDetail.address forState:UIControlStateNormal];
    [_orderNumberBtn setTitle:[NSString stringWithFormat:@"订单编号  %@", _orderDetail.orderNumber] forState:UIControlStateNormal];
    
    [self setupFooterView];
    
    if (_orderDetail.orderStatus == kOrderGrabSuccess) {
        _countdown = _orderDetail.payCountdown;
        if (_countdown > 0) {
            [self startCountdown];
        }
        
    } else if (_orderDetail.orderStatus == kOrderInProgress) {
        _countdown = _orderDetail.grabCountdown;
        if (_countdown > 0) {
            [self startCountdown];
        } else {
            [self updateDetailViewWithStatus:kOrderCancelGrabTimeOut andShouldReloadOrderDetail:NO];
        }
    } else {
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        _timeLeftLabel.text = nil;
    }
    if (_orderDetail.orderStatus == kOrderPayed) {
        _phoneLabel.enabled = YES;
    } else {
        _phoneLabel.enabled = NO;
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
    } else if (sec > 0){
        _timeLeftLabel.text = [NSString stringWithFormat:@"剩余(%d:%d)", min, sec];
    } else {
        if (_orderDetail.orderStatus == kOrderGrabSuccess) {
            [self updateDetailViewWithStatus:kOrderCancelPayTimeOut andShouldReloadOrderDetail:YES];
        } else {
            [self updateDetailViewWithStatus:kOrderCancelGrabTimeOut andShouldReloadOrderDetail:YES];
        }
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

                [self updateDetailViewWithStatus:kOrderGrabSuccess andShouldReloadOrderDetail:YES];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"恭喜抢单成功！" message:@"抢单成功，请耐心等待发单人付款确认" delegate:self cancelButtonTitle:@"关注此订单" otherButtonTitles:@"继续抢单", nil];
                [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kGrabOrderSuccess object:nil];
                    }
                }];
                
            } else{
                if ([[dict objectForKey:@"info"] length]) {
                    [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"info"]];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"抢单失败了"];
                }
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
            [self updateDetailViewWithStatus:kOrderPayed andShouldReloadOrderDetail:YES];
        }
    }];
    vc.orderNumber = _orderDetail.orderNumber;
    vc.price = _orderDetail.price;
    vc.orderid = _orderDetail.orderId;
    vc.huoerbaoID = _orderDetail.grabOrderUser.userid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)complainAction
{
    ComplaintViewController *control = [[ComplaintViewController alloc] init];
    UserInfo *userInfo;
    if (_isSendOrder) {
        userInfo = _orderDetail.grabOrderUser;
    } else {
        userInfo = _orderDetail.sendOrderUser;
    }
    
    control.tousuId = [UserManager shareUserManager].userInfo.userid;
    control.beitousuId = userInfo.userid;
    [self.navigationController pushViewController:control animated:YES];
}

- (void)cancelOrder
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认取消订单吗？" message:@"很抱歉我们的活儿宝未能向您提供完善的服务" delegate:nil cancelButtonTitle:@"再等等"otherButtonTitles:@"取消订单", nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [SVProgressHUD showWithStatus:@"正在取消"];
            NSString *url = [NSString stringWithFormat:@"%@delorder",baseUrl];
            NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
            [mDict safeSetObject:_orderDetail.orderId forKey:@"orderid"];
            
            [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                [SVProgressHUD dismiss];
                if (response)
                {
                    NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                    NSDictionary *dict = [jsonString objectFromJSONString];
                    NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
                    if ([tempStatus integerValue] == 1) {
                        UIAlertView *canclealert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"订单取消成功。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [canclealert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                            if (buttonIndex == 0) {
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                        }];
                        
                        
                    }
                }

            }];
        }
    }];
}

- (void)setupFooterView
{
    if (_footerView) {
        [_footerView removeFromSuperview];
        _footerView = nil;
    }
    _complainBtn.hidden = YES;
    _addressConstraint.constant = 8;
    _cancelBtn.hidden = YES;
    _cancelBtnConstraint.constant = 52;
    
    NSString *tipsString;
    NSString *statusString;

    if (_orderDetail.orderStatus == kOrderCancelGrabTimeOut) {
        statusString =  _orderDetail.orderStatusDesc;
        tipsString = @"保持良好记录有助于快速成交订单";
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];

    } else if (_orderDetail.orderStatus == kOrderInProgress && _isSendOrder) {
        _cancelBtn.hidden = NO;
        _addressConstraint.constant = 70;
        _cancelBtnConstraint.constant = 12;
        statusString = _orderDetail.orderStatusDesc;
        tipsString = @"保持良好记录有助于快速成交订单";

        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];
        
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
        
    } else if (_orderDetail.orderStatus == kOrderPayed && _isSendOrder) {
        
        statusString = _orderDetail.orderStatusDesc;
        _addressConstraint.constant = 70;
        _complainBtn.hidden = NO;
        
        tipsString = @"保持良好记录有助于快速成交订单";
        statusString = _orderDetail.orderStatusDesc;

        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-110, kWindowWidth, 110)];
        
        UIButton *orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, _footerView.bounds.size.width-40, 35)];
        orderBtn.layer.cornerRadius = 5.0;
        orderBtn.backgroundColor = APP_THEME_COLOR;
        [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        orderBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [orderBtn setTitle:@"立即验收" forState:UIControlStateNormal];
        [orderBtn addTarget:self action:@selector(checkOrder:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:orderBtn];
        
    } else if (_orderDetail.orderStatus == kOrderPayed && !_isSendOrder) {
        _complainBtn.hidden = NO;
        _addressConstraint.constant = 70;
        tipsString = @"小提示：所示金额系统已自动扣减8%佣金";
        statusString = _orderDetail.orderStatusDesc;
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-110, kWindowWidth, 110)];
        
        UIButton *orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, _footerView.bounds.size.width-40, 35)];
        orderBtn.layer.cornerRadius = 5.0;
        orderBtn.backgroundColor = APP_THEME_COLOR;
        [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        orderBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        NSString *str = [NSString stringWithFormat:@"请派单人验收任务(%@次)", _orderDetail.reminderCount];
        [orderBtn setTitle:str forState:UIControlStateNormal];
        [orderBtn addTarget:self action:@selector(reminderUserPay:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:orderBtn];
 
    } else if (_orderDetail.orderStatus == kOrderCancelPayTimeOut) {
        statusString = _orderDetail.orderStatusDesc;
        tipsString = @"小提示：所示金额系统已自动扣减8%佣金";
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];
        
    } else if (_orderDetail.orderStatus == kOrderGrabSuccess && !_isSendOrder) {
        
        _addressConstraint.constant = 70;
        _cancelBtn.hidden = NO;
        _addressConstraint.constant = 70;
        _cancelBtnConstraint.constant = 12;

        statusString = _orderDetail.orderStatusDesc;
        tipsString = @"小提示：所示金额系统已自动扣减8%佣金";
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];
        
    }  else if (_orderDetail.orderStatus == kOrderGrabSuccess && _isSendOrder) {
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
        
    } else if(_orderDetail.orderStatus == kOrderCheckDone) {
        tipsString = @"保持良好记录有助于快速成交订单";
        statusString = _orderDetail.orderStatusDesc;
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-110, kWindowWidth, 110)];
        
        UIButton *orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, _footerView.bounds.size.width-40, 35)];
        orderBtn.layer.cornerRadius = 5.0;
        orderBtn.backgroundColor = APP_THEME_COLOR;
        [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        orderBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [orderBtn setTitle:@"去评价" forState:UIControlStateNormal];
        [orderBtn addTarget:self action:@selector(ratingAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:orderBtn];
        
    } else if (_orderDetail.orderStatus == kOrderCompletion) {
        statusString = _orderDetail.orderStatusDesc;
        tipsString = @"保持良好记录有助于快速成交订单";
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];
    }   else if (_orderDetail.orderStatus == kOrderCancelDispute) {
        statusString = _orderDetail.orderStatusDesc;
        tipsString = @"小提示：所示金额系统已自动扣减8%佣金";
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];
        
    } else if (_orderDetail.orderStatus == kOrderNotBelongYou) {
        statusString = _orderDetail.orderStatusDesc;
        tipsString = @"小提示：所示金额系统已自动扣减8%佣金";
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-60, kWindowWidth, 60)];
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
                _missionLocation = CLLocationCoordinate2DMake([_orderDetail.lat floatValue], [_orderDetail.lng floatValue]);
                [self datouzhen];
                [self drawRoute];
                [self updateView];
            }
        }
    }];
}

- (void)datouzhen
{
    [self.mapview.layer removeAllAnimations];
    [self.mapview removeOverlays:self.mapview.overlays];;
    [self.mapview removeAnnotations:self.mapview.annotations];
   
    UserInfo *userInfo = _orderDetail.grabOrderUser;
   
    FYAnnotation *tag2 = [[FYAnnotation alloc]init];
    tag2.coordinate = _missionLocation;
    tag2.icon = @"ic_location_marker.png";
    
    [self.mapview addAnnotation:tag2];
    [self adjustMapViewWithLocation:_missionLocation];
   
    if ([userInfo.userid integerValue] == 0) {
        if (_isSendOrder) {
            return;
        } else {
            _userLocation = CLLocationCoordinate2DMake([UserManager shareUserManager].userInfo.lat, [UserManager shareUserManager].userInfo.lng);
            userInfo = [UserManager shareUserManager].userInfo;
        }
    } else {
        _userLocation = CLLocationCoordinate2DMake(_orderDetail.grabOrderUser.lat, _orderDetail.grabOrderUser.lng);
    }
    
    FYAnnotation *tg = [[FYAnnotation alloc]init];
    tg.coordinate = _userLocation;
    
    if ( [userInfo.sex isEqualToString:@"1"] &&[userInfo.level isEqualToString:@"1"])
    {
        tg.icon=@"men1.png";
    }
    else if ([userInfo.sex isEqualToString:@"1"]&&[userInfo.level isEqualToString:@"2"])
    {
        tg.icon=@"men_vip1.png";
    }
    else if ([userInfo.sex isEqualToString:@"2"] && [userInfo.level isEqualToString:@"1"])
    {
        tg.icon=@"MYwomen.png";
    }
    else
    {
        tg.icon=@"MYwomen_vip1.png";
    }
    [self.mapview addAnnotation:tg];
    
    [self moveMapToCenteratMapView:self.mapview];

}

- (void)drawRoute
{
    if (_userLocation.latitude ==0 || _missionLocation.latitude == 0) {
        return;
    }
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:_userLocation.latitude longitude:_userLocation.longitude];

    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:_missionLocation.latitude longitude:_missionLocation.longitude];

    [geocoder reverseGeocodeLocation:startLocation completionHandler:^(NSArray *placemarkOne, NSError *error) {
        CLPlacemark *startPlacemark = [placemarkOne firstObject];
        [geocoder reverseGeocodeLocation:endLocation completionHandler:^(NSArray *placemarTwo, NSError *error) {
            CLPlacemark *endPlacemark = [placemarTwo firstObject];
            [self startDirectionsWithStartClPlacemark:startPlacemark endCLPlacemark:endPlacemark];
        }];
    }];

}

- (void)callClick
{
    UserInfo *userInfo;
    if (_isSendOrder) {
        userInfo = _orderDetail.grabOrderUser;
    } else {
        userInfo = _orderDetail.sendOrderUser;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认拨打以下电话？" message:userInfo.tel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", userInfo.tel]];
            [[UIApplication sharedApplication] openURL:url];
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

//催款
- (void)reminderUserPay:(id)sender
{
    [SVProgressHUD showWithStatus:@"正在催款"];
    NSString *url = [NSString stringWithFormat:@"%@dept",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:_orderDetail.orderId forKey:@"orderid"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"jsonString = %@",jsonString);
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if ([tempStatus integerValue] == 1) {
                int number = [_orderDetail.reminderCount intValue] + 1;
                _orderDetail.reminderCount = [NSString stringWithFormat:@"%d", number];
                [self updateDetailViewWithStatus:_orderDetail.orderStatus andShouldReloadOrderDetail:NO];
                [SVProgressHUD showSuccessWithStatus:@"您的催款信息已发送"];
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"付款给活儿宝失败，请重试!"];
            }
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"付款给活儿宝失败，请重试!"];

        }
    }];

}

//评价
- (void)ratingAction:(UIButton *)btn
{
    EvaluationViewController *control = [[EvaluationViewController alloc] init];
    if (_isSendOrder){
        control.evaluationType = 1;
    }else{
        control.evaluationType = 2;
    }
    control.orderDetail = self.orderDetail;
    [self.navigationController pushViewController:control animated:YES];
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
                UIAlertView * alertV = [[UIAlertView alloc]initWithTitle:@"恭喜，任务验收成功!" message:@"订单金额已向抢单人实时支付!您可以对抢单人的服务进行评价。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"去评价", nil];

                [self updateDetailViewWithStatus:kOrderCheckDone andShouldReloadOrderDetail:YES];
                [alertV showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        [self ratingAction:nil];
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



- (void)startDirectionsWithStartClPlacemark:(CLPlacemark *)startCLPlacemark endCLPlacemark:(CLPlacemark *)endCLPlacemark

{
    MKPlacemark *startMKPlacemark = [[MKPlacemark alloc] initWithPlacemark:startCLPlacemark];
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startMKPlacemark];
    MKPlacemark *endMKPlacemark = [[MKPlacemark alloc] initWithPlacemark:endCLPlacemark];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endMKPlacemark];
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = startItem;
    request.destination = endItem;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        for (MKRoute *route in response.routes) {
            [self.mapview addOverlay:route.polyline];
        }
    }];
}

- (void)moveMapToCenteratMapView:(MKMapView *)mv_bmap
{
    double minLat = 0.0;
    double minLon = 0.0;
    double maxLat = 0.0;
    double maxLon = 0.0;
    
    minLat = _userLocation.latitude;
    minLon = _userLocation.longitude;
    maxLat = _missionLocation.latitude;
    maxLon = _missionLocation.longitude;

    minLon = minLon - 0.01;
    minLat = minLat - 0.01;
    maxLon = maxLon + 0.01;
    maxLat = maxLat + 0.01;
    double midLat = (minLat + maxLat) / 2;
    double midLon = (minLon + maxLon) / 2;
    CLLocationCoordinate2D centerPoint = CLLocationCoordinate2DMake(midLat, midLon);
    MKCoordinateSpan span = MKCoordinateSpanMake(fabs((maxLat - minLat)*1.6), fabs((maxLon - minLon)*1.6));
    MKCoordinateRegion region = MKCoordinateRegionMake(centerPoint,span);
    MKCoordinateRegion adjustedRegion = [_mapview regionThatFits:region];
    [_mapview setRegion:adjustedRegion animated:YES];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    // 创建一条路径遮盖
    MKPolylineRenderer*line = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    line.lineWidth = 3; // 路线宽度
    line.strokeColor = [UIColor redColor];//路线宽度
    return line;
}

#pragma mark getWoGanUserdata 在地图上显示自定义的大头针模型
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(FYAnnotation *)annotation
{
    if (![annotation isKindOfClass:[FYAnnotation class]]) return nil;
    //        1.获得大头针控件
    FYAnnotationView *annoView=[FYAnnotationView annotationViewWithMapView:self.mapview];
    //        2.传递模型
    annoView.annotation=annotation;
    return annoView;
}

@end
