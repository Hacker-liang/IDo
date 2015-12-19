//
//  HomeViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "HomeViewController.h"
#import "REFrostedViewController.h"
#import "GrabOrderRootViewController.h"
#import "SendOrderRootViewController.h"
#import "HomeMenuViewController.h"

@interface HomeViewController ()
{
    NSString *APPTITTLE;
}
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIImageView *refreshImageView;

@property (nonatomic, strong) NSArray *ADProvince;
@property (nonatomic, strong) NSArray *ADCity;

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) GrabOrderRootViewController *grabOrederCtl;
@property (nonatomic, strong) SendOrderRootViewController *sendOrderCtl;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *APPTittleDefaults=[NSUserDefaults standardUserDefaults];
    
    APPTITTLE =[APPTittleDefaults objectForKey:@"APPTittle"];
    
    UIButton *menu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [menu setImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
    menu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [menu addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [menu setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    _titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    [_titleBtn addTarget:self action:@selector(switchPage:) forControlEvents:UIControlEventTouchUpInside];
    
    [_titleBtn setTitle:[NSString stringWithFormat:@"%@     抢单",APPTITTLE] forState:UIControlStateNormal];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.titleView = _titleBtn;
    
    
    if (APPTITTLE.length==2) {
        _refreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(42, 11, 15, 13)];
    } else {
        _refreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(72, 11, 15, 13)];
    }
    
    _refreshImageView.image = [UIImage imageNamed:@"icon_refresh.png"];
    [_titleBtn addSubview:_refreshImageView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setTitle:@"切换" forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.titleLabel.font  = [UIFont systemFontOfSize:15.0];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(switchPage:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self setupContentViewContrller];
    [self changeProfileStatusWithPageIndex:0];
    [self loadAD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupContentViewContrller
{
    _grabOrederCtl = [[GrabOrderRootViewController alloc] init];
    _sendOrderCtl = [[SendOrderRootViewController alloc] init];
    _viewControllers = @[_grabOrederCtl, _sendOrderCtl];
    
    UIViewController *firstCtl = [_viewControllers firstObject];
    _currentViewController = firstCtl;
    [self addChildViewController:firstCtl];
    [self.view addSubview:firstCtl.view];
}

- (void)loadAD
{
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    if ([UserManager shareUserManager].userInfo.provinceName) {
        [mDict safeSetObject:[UserManager shareUserManager].userInfo.provinceName forKey:@"provincename"];
        [mDict safeSetObject:[UserManager shareUserManager].userInfo.cityName forKey:@"cityname"];
    } else {
        [mDict safeSetObject:[UserLocationManager shareInstance].userProvinceName forKey:@"provincename"];
        [mDict safeSetObject:[UserLocationManager shareInstance].userCityName forKey:@"cityname"];
    }
    
    [mDict safeSetObject:@"adarea" forKey:@"action"];
    [SVHTTPRequest GET:baseServer parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {

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
            NSDictionary *adData = dict[@"data"];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if((NSNull *)tempStatus != [NSNull null] && ![tempStatus isEqualToString:@"0"]) {
                NSMutableArray *cityArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in [adData objectForKey:@"city"]) {
                    [cityArray addObject:dict];
                }
                _ADCity = cityArray;
                _grabOrederCtl.adArray = _ADCity;
                _sendOrderCtl.adArray = _ADCity;
                
                NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in [adData objectForKey:@"province"]) {
                    [provinceArray addObject:dict];
                }
                _ADProvince = provinceArray;
                ((HomeMenuViewController *)self.frostedViewController.menuViewController).adArray = _ADProvince;

            } else {

            }
        }
    }];

}

#pragma mark - IBAction Methods

- (void)showMenu
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

- (void)switchPage:(id)sender
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = NO;
    [_refreshImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    NSUInteger index = [_viewControllers indexOfObject:_currentViewController];
    [self changePage:1-index];
    if (index == 0) {
        [_titleBtn setTitle:[NSString stringWithFormat:@"%@     派单",APPTITTLE] forState:UIControlStateNormal];
        
    } else {
        [_titleBtn setTitle:[NSString stringWithFormat:@"%@     抢单",APPTITTLE] forState:UIControlStateNormal];
    }
}

- (void)changePage:(NSInteger)pageIndex
{
    UIViewController *newController = [_viewControllers objectAtIndex:pageIndex];
    
    if ([newController isEqual:_currentViewController]) {
        return;
    }
    [self changeProfileStatusWithPageIndex:pageIndex];
    [self replaceController:_currentViewController newController:newController];
}

- (void)changeProfileStatusWithPageIndex:(int)index
{
    NSString *url = [NSString stringWithFormat:@"%@setUserStatus", baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[NSString stringWithFormat:@"%d", 1-index] forKey:@"idDo"];
    [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"id"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response) {
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
            NSInteger status = [[dict objectForKey:@"status"] integerValue];
            if (status == 1) {
                if (index == 0) {
                    [UserManager shareUserManager].userInfo.isSendingOrder = NO;
                } else {
                    [UserManager shareUserManager].userInfo.isSendingOrder = YES;
                }
            } else {
            }
            
        } else {
        }
    }];
}

- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.5  options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentViewController = newController;
        }else{
            self.currentViewController = oldController;
        }
    }];
}

@end
