//
//  ShareViewController.m
//  IDo
//
//  Created by liangpengshuai on 12/20/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "ShareViewController.h"
#import "TZButton.h"
#import "UMSocial.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"分享";
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
    
    UIImageView *QRImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kWindowWidth-200)/2, kWindowHeight-20-200, 200, 200)];
    QRImageView.image = [UIImage imageNamed:@"icon_app_QR.png"];
    [self.view addSubview:QRImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,  kWindowHeight-30-200-30, kWindowWidth-20, 20)];
    label.text = @"扫描二维码，轻松下载我干 APP";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:15.0];
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
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareTitle;
    UIImage *shareImage;
    if (_shareLocalImageName) {
        shareImage = [UIImage imageNamed:_shareLocalImageName];
    } else {
        shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_shareImageUrl]]];
    }
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_shareTitle image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
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
