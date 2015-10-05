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

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIViewController *currentViewController;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *menu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [menu setImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
    menu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [menu addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [menu setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    _titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    [_titleBtn addTarget:self action:@selector(switchPage:) forControlEvents:UIControlEventTouchUpInside];
    [_titleBtn setTitle:@"我干 -- 抢单" forState:UIControlStateNormal];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.titleView = _titleBtn;
    
    [self setupContentViewContrller];
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
    NSUInteger index = [_viewControllers indexOfObject:_currentViewController];
    [self changePage:1-index];
    if (index == 0) {
        [_titleBtn setTitle:@"我干 -- 派单" forState:UIControlStateNormal];
        
    } else {
        [_titleBtn setTitle:@"我干 -- 抢单" forState:UIControlStateNormal];
    }
}

- (void)changePage:(NSInteger)pageIndex
{
    UIViewController *newController = [_viewControllers objectAtIndex:pageIndex];
    
    if ([newController isEqual:_currentViewController]) {
        return;
    }
    [self replaceController:_currentViewController newController:newController];
}

- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
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
