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
    
    if (_isVip) {
        _contentLabel.text = @"您的VIP信息如下:\n1、授理日期：%1$s\n2、有效期截止：%2$s";
        [_requestBtn setTitle:@"" forState:UIControlStateNormal];
        _requestBtn.userInteractionEnabled = NO;
        [_requestBtn setTitle:@"恭喜，您是VIP用户，享受VIP特权" forState:UIControlStateNormal];
        
    } else {
        _contentLabel.text = @"成为VIP，享受VIP专属特权，VIP会员在软件首页地图页头像将加“Ｖ”显示，并能直接点击头像指定下单，让您的抢单无须排队，优先抢单，从而满足您在《我干》专业抢单诉求。\n&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;凡《我干》注册用户，均可在此提交申请，《我干》将在1-7个工作日内安排专人与您取得联系，您也可拨打400-611-8091转人工客服进行咨询。谢谢！";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
