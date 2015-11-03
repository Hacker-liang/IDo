//
//  Requtst2BeVIPViewController.m
//  IDo
//
//  Created by liangpengshuai on 10/1/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "Requtst2BeVIPViewController.h"

@interface Requtst2BeVIPViewController ()

@property (nonatomic) BOOL isVip;

@end

@implementation Requtst2BeVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"VIP设置";
    _isVip = [UserManager shareUserManager].userInfo.isVip;
    _requestBtn.layer.cornerRadius = 4.0;
    _requestBtn.clipsToBounds = YES;
    [_requestBtn setBackgroundImage:[ConvertMethods createImageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    [_requestBtn setBackgroundImage:[ConvertMethods createImageWithColor:APP_THEME_COLOR] forState:UIControlStateNormal];
    
    if (_isVip) {
        _contentLabel.text = @"您的VIP信息如下:\n1、授理日期：%1$s\n2、有效期截止：%2$s";
        [_requestBtn setTitle:@"" forState:UIControlStateNormal];
        _requestBtn.userInteractionEnabled = NO;
        [_requestBtn setTitle:@"恭喜，您是VIP用户，享受VIP特权" forState:UIControlStateNormal];

    } else {
        _contentLabel.text = @"成为VIP，享受VIP专属特权，VIP会员在软件首页地图页头像将加“Ｖ”显示，并能直接点击头像指定下单，让您的抢单无须排队，优先抢单，从而满足您在《我干》专业抢单诉求。\n    凡《我干》注册用户，均可在此提交申请，《我干》将在1-7个工作日内安排专人与您取得联系，您也可拨打400-611-8091转人工客服进行咨询。谢谢！";
        [_requestBtn setTitle:@"VIP 申请提交" forState:UIControlStateNormal];
        [_requestBtn setTitle:@"您的申请已提交，请等待客服与您联系" forState:UIControlStateDisabled];

        
        NSString *vipCacheKey = [NSString stringWithFormat:@"%@_vip_request", [UserManager shareUserManager].userInfo.userid];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:vipCacheKey] boolValue]) {
            _requestBtn.enabled = NO;
            _requestBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];

        } else {
            _requestBtn.enabled = YES;
            [_requestBtn addTarget:self action:@selector(request2BeVIP:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)request2BeVIP:(id)sender
{
    NSString *url = [NSString stringWithFormat:@"%@buyvip", baseUrl];
    
    [SVProgressHUD showWithStatus:@"正在提交"];
    [SVHTTPRequest POST:url parameters:@{@"memberid": [UserManager shareUserManager].userInfo.userid} completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
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
                [SVProgressHUD showSuccessWithStatus:@"恭喜,申请成功"];
                NSString *vipCacheKey = [NSString stringWithFormat:@"%@_vip_request", [UserManager shareUserManager].userInfo.userid];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:vipCacheKey];
                _requestBtn.enabled = NO;
            } else {
                [SVProgressHUD showErrorWithStatus:@"申请失败"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"申请失败"];
        }
    }];

}


@end
