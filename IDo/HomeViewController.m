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

@interface HomeViewController ()

@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIImageView *refreshImageView;

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIViewController *currentViewController;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *menu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [menu setImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
    menu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [menu addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [menu setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    _titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    [_titleBtn addTarget:self action:@selector(switchPage:) forControlEvents:UIControlEventTouchUpInside];
    [_titleBtn setTitle:@"我干     抢单" forState:UIControlStateNormal];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.titleView = _titleBtn;
    
    _refreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(42.5, 11, 15, 13)];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupContentViewContrller
{
    GrabOrderRootViewController *grabOrederCtl = [[GrabOrderRootViewController alloc] init];
    SendOrderRootViewController *sendOrderCtl = [[SendOrderRootViewController alloc] init];
    _viewControllers = @[grabOrederCtl, sendOrderCtl];
    
    UIViewController *firstCtl = [_viewControllers firstObject];
    _currentViewController = firstCtl;
    [self addChildViewController:firstCtl];
    [self.view addSubview:firstCtl.view];
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
        [_titleBtn setTitle:@"我干     派单" forState:UIControlStateNormal];
        
    } else {
        [_titleBtn setTitle:@"我干     抢单" forState:UIControlStateNormal];
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
