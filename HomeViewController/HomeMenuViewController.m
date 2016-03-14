//
//  HomeMenuViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "HomeMenuViewController.h"
#import "REFrostedViewController.h"
#import "HomeMenuTableViewHeaderView.h"
#import "HomeMenuTableViewCell.h"
#import "MyWalletViewController.h"
#import "MyProfileTableViewController.h"
#import "LoginViewController.h"
#import "AboutViewController.h"
#import "HelpVC.h"
#import "AutoSlideScrollView.h"
#import "SuperWebViewController.h"
#import "ShareViewController.h"
#import "PushMessageCenterViewController.h"

#import "MyRedMoneyVC.h"

@interface HomeMenuViewController ()

@property (nonatomic, strong) HomeMenuTableViewHeaderView *headerView;
@property (nonatomic, strong) AutoSlideScrollView *galleryView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation HomeMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    _headerView = [HomeMenuTableViewHeaderView homeMenuTableViewHeaderView];
    _headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 358*HEIGHT/1136);
    [_headerView.headerBtn addTarget:self action:@selector(gotoPersonInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeMenuCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = self.footerView;


//    if (360+150 >= kWindowHeight) {
//        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275, 150)];
//    } else {
//        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275, kWindowHeight-360)];
//    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275, 352*HEIGHT/1136)];
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake((_footerView.bounds.size.width-120)/2, 25*HEIGHT/1136, 120, 43*HEIGHT/1136)];
        [shareBtn setTitle:@"分享我干给好友" forState:UIControlStateNormal];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        shareBtn.layer.borderColor = LineColor.CGColor;
        shareBtn.layer.borderWidth = 0.5;
        shareBtn.layer.cornerRadius = 3.0;
        [shareBtn addTarget:self action:@selector(shareApp) forControlEvents:UIControlEventTouchUpInside];
        [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_footerView addSubview:shareBtn];
    }
    return _footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@{@"icon": @"icon_menu_wallet.png", @"title": @"我的钱包"},
                        @{@"icon": @"icon_menu_mine.png", @"title": @"我的红包"},
                        @{@"icon": @"icon_menu_message.png", @"title": @"信息中心"},
                        @{@"icon": @"help", @"title": @"帮助中心"},
                        @{@"icon": @"icon_menu_setting.png", @"title": @"关于我们"},
//                        @{@"icon": @"icon_menu_setting.png", @"title": @"检查更新"}
                        ];
    }
    return _dataSource;
}

- (void)setAdArray:(NSArray *)adArray
{
    _adArray = adArray;
    
    _galleryView = [[AutoSlideScrollView alloc] initWithFrame:CGRectMake(10, self.footerView.bounds.size.height-190*HEIGHT/1136-30, 275-20, 172*HEIGHT/1136) animationDuration:5];
    _galleryView.totalPagesCount = ^NSInteger(void){
        return adArray.count;
    };
    NSMutableArray *viewsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in _adArray) {
        NSString *imageUrl = [dic objectForKey:@"img"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _galleryView.bounds.size.width, 172*HEIGHT/1136)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"nil"]];
        [viewsArray addObject:imageView];
    }
    
    _galleryView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    
    __weak typeof(self)weakSelf = self;
    _galleryView.TapActionBlock = ^void (NSInteger pageIndex) {
        [weakSelf.frostedViewController hideMenuViewController];
        SuperWebViewController *ctl = [[SuperWebViewController alloc] init];
        ctl.urlStr = [[adArray objectAtIndex:pageIndex] objectForKey:@"link"];
        [weakSelf.mainViewController.navigationController pushViewController:ctl animated:YES];
    };
    [self.footerView addSubview:_galleryView];
}

#pragma mark - IBAction Methods

-(void)gotoPersonInfo
{
    [self.frostedViewController hideMenuViewController];
    MyProfileTableViewController *person=[[MyProfileTableViewController alloc]init];
    [_mainViewController.navigationController pushViewController:person animated:YES];
}

- (void)shareApp
{
    [self.frostedViewController hideMenuViewController];
    ShareViewController *ctl = [[ShareViewController alloc] init];
    ctl.shareImageUrl = @"http://a.bjwogan.com/uploads/58.jpg";
    ctl.shareLocalImageName = @"Icon";
    ctl.shareTitle = @"我干，一款派活接活神器！";
    ctl.shareContent = @"你有活儿，我来干！一款基于LBS定位功能的O2O互助服务类手机移动客户端";
    [_mainViewController.navigationController pushViewController:ctl animated:YES];
}

- (void)gotoMyWallet
{
    [self.frostedViewController hideMenuViewController];
    MyWalletViewController *ctl = [[MyWalletViewController alloc] init];
    [_mainViewController.navigationController pushViewController:ctl animated:YES];
}

- (void)gotoMyProfile
{
    MyRedMoneyVC *myRed=[[MyRedMoneyVC alloc]init];
    [self presentViewController:myRed animated:NO completion:nil];
}

- (void)gotoMessageCenter
{
    [self.frostedViewController hideMenuViewController];
    PushMessageCenterViewController *ctl = [[PushMessageCenterViewController alloc] init];
    [_mainViewController.navigationController pushViewController:ctl animated:YES];

}

-(void)gotoHelp
{
    HelpVC *help=[[HelpVC alloc]init];
    [self.frostedViewController hideMenuViewController];
    
    [_mainViewController.navigationController pushViewController:help animated:YES];
}

- (void)gotoAbout
{
    AboutViewController *ctl = [[AboutViewController alloc] init];
    [self.frostedViewController hideMenuViewController];

    [_mainViewController.navigationController pushViewController:ctl animated:YES];
}

- (void)get_version{
    
    [SVProgressHUD showWithStatus:@"正在检查新版本"];
    [SVHTTPRequest POST:@"https://itunes.apple.com/lookup?id=983842433" parameters:nil completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [SVProgressHUD dismiss];
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
            if (dict)
            {
                NSInteger resultCount = [[dict objectForKey:@"resultCount"] integerValue];
                if (resultCount == 1) {
                    NSArray *arr = [dict objectForKey:@"results"];
                    if (arr.count) {
                        NSDictionary *arrDict = arr[0];
                        if (arrDict) {
                            NSString *version = [arrDict objectForKey:@"version"];
                            NSString *locVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
                            int result = [locVersion compare:version];
                            if (result == -1)
                            {
                                NSString *appUrl = [arrDict objectForKey:@"trackViewUrl"];
                                NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
                                NSString *versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
                                if ([versionNum floatValue] < [version floatValue]) {
                                    NSString *meaasge = [NSString stringWithFormat:@"发现新版本%@，是否更新?",version];
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:meaasge delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                                    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                                        if (buttonIndex == 1) {
                                            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:appUrl]];
                                        }
                                    }];
                                } else {
                                    [SVProgressHUD showSuccessWithStatus:@"恭喜你，已经是最新版本"];
                                }
                               
                            }
                        }
                    }
                }
            }
        }
    }];
}

#pragma mark - TableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 358*HEIGHT/1136;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _headerView.userInfo = [UserManager shareUserManager].userInfo;
    return _headerView;
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
//    return 93*HEIGHT/1136;
//    if (IS_IPHONE_4) {
//        return 73*HEIGHT/1136;
//    }
    return 93*HEIGHT/1136;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeMenuCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.headerImageView.image = [UIImage imageNamed:[dic objectForKey:@"icon"]];
    cell.titleLabel.text = [dic objectForKey:@"title"];
    
    if (IS_IPHONE_4) {
        cell.titleLabel.font = [UIFont systemFontOfSize:35 * HEIGHT/1136];
    }
    for (UIView *view in cell.subviews) {
        if (view.tag == 101) {
            [view removeFromSuperview];
        }
    }
    if (indexPath.row == 2) {
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kPushUnreadNotiCacheKey]) {
            UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(125, 22.5, 5, 5)];
            tagView.tag = 101;
            tagView.layer.cornerRadius = 2.5;
            tagView.backgroundColor = [UIColor redColor];
            [cell addSubview:tagView];
        }
    }
    
    if (indexPath.row == 4) {
        NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
        NSString *versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
        NSString *text =[NSString stringWithFormat:@"v%@",versionNum];
        cell.subtitleLabel.text = text;
        cell.subtitleLabel.font=[UIFont systemFontOfSize:35*HEIGHT/1136];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self gotoMyWallet];
        
    } else if (indexPath.row == 1) {
        [self gotoMyProfile];
        
    } else if (indexPath.row == 2) {
        [self gotoMessageCenter];
        
    } else if (indexPath.row == 3) {
        [self gotoHelp];
        
    } else if (indexPath.row ==4) {
        [self gotoAbout];
    }
}

@end





