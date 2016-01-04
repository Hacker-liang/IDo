//
//  ShareOrderViewController.m
//  IDo
//
//  Created by liangpengshuai on 12/20/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "ShareOrderViewController.h"
#import "TZButton.h"
#import "UMSocial.h"

@interface ShareOrderViewController ()

@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *shareImageUrl;
@property (nonatomic, copy) NSString *shareLocalImageName;

@end

@implementation ShareOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"分享";
    _shareUrl = [NSString stringWithFormat:@"http://a.bjwogan.com/Api/share/shareOrder/%@/%@", _userId, _orderId];
    _shareTitle = @"我干，一款派活接活神器！";
    _shareImageUrl = @"http://a.bjwogan.com/uploads/58.jpg";
    _shareLocalImageName = @"Icon";
    if (_isSender) {
        _shareContent = @"我给我干打满分！活儿嗖嗖就被活儿宝干完啦！大家快来围观我的订单吧！";
    } else {
        _shareContent = @"我给我干打满分！轻轻松松赚到钱！大家快来围观我的订单吧！";

    }
    CGFloat width = kWindowWidth/3;
    {
        TZButton *shareBtn = [[TZButton alloc] initWithFrame:CGRectMake(0, 84, width, width)];
        shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        shareBtn.imagePosition = IMAGE_AT_TOP;
        [shareBtn setImage:[UIImage imageNamed:@"icon_share_qq.png"] forState:UIControlStateNormal];
        [shareBtn setTitle:@"QQ" forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        shareBtn.topSpaceHight = 20;
        [shareBtn addTarget:self action:@selector(share2QQ) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareBtn];
    }
    {
        TZButton *shareBtn = [[TZButton alloc] initWithFrame:CGRectMake(width, 84, width, width)];
        shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        shareBtn.imagePosition = IMAGE_AT_TOP;
        [shareBtn setImage:[UIImage imageNamed:@"icon_share_timeline.png"] forState:UIControlStateNormal];
        [shareBtn setTitle:@"微信朋友圈" forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        shareBtn.topSpaceHight = 20;
        [shareBtn addTarget:self action:@selector(share2Timeline) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareBtn];
    }
    {
        TZButton *shareBtn = [[TZButton alloc] initWithFrame:CGRectMake(width*2, 84, width, width)];
        shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        shareBtn.imagePosition = IMAGE_AT_TOP;
        [shareBtn setImage:[UIImage imageNamed:@"icon_share_wechat.png"] forState:UIControlStateNormal];
        [shareBtn setTitle:@"微信好友" forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        shareBtn.topSpaceHight = 20;
        [shareBtn addTarget:self action:@selector(share2WeiChat) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareBtn];
    }
    
    NSString *contentStr;
    if (_isSender) {
        contentStr = @"我干小哥服务太棒了，晒单鼓励下";
    } else {
        contentStr = @"我在我干APP接单，我为自己代言";
    }
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, width + 100, kWindowWidth-40, 30)];
    contentLabel.textColor = [UIColor lightGrayColor];
    contentLabel.font = [UIFont systemFontOfSize:15.0];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = contentStr;
    [self.view addSubview:contentLabel];
    
    UIImageView *QRImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, kWindowHeight-60, 30, 30)];
    QRImageView.image = [UIImage imageNamed:@"Icon.png"];
    [self.view addSubview:QRImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70,  kWindowHeight-60, kWindowWidth-100, 30)];
    label.text = @"我干，一款派活接活神器！";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:16.0];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)share2QQ
{
    NSString *url = _shareUrl;
    NSString *shareContentWithoutUrl = _shareContent;
    NSString *imageUrl = _shareImageUrl;

    UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imageUrl];
    
    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qqData.title = _shareTitle;

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareContentWithoutUrl image:nil location:nil urlResource:resource presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];


}

- (void)share2Timeline
{
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareContent;
    UIImage *shareImage;
    if (_shareLocalImageName) {
        shareImage = [UIImage imageNamed:_shareLocalImageName];
    } else {
        shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_shareImageUrl]]];
    }
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_shareContent image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
    }];
}

- (void)share2WeiChat
{
    [UMSocialData defaultData].extConfig.wechatSessionData.title =_shareTitle;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareUrl;
    
    UIImage *shareImage;
    if (_shareLocalImageName) {
        shareImage = [UIImage imageNamed:_shareLocalImageName];
    } else {
        shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_shareImageUrl]]];
    }
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_shareContent image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
    }];

   
}

@end
