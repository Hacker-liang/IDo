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
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *menu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    menu.backgroundColor = [UIColor blackColor];
    [menu addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [menu setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    _titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    _titleBtn.backgroundColor = [UIColor grayColor];
    [_titleBtn addTarget:self action:@selector(switchPage:) forControlEvents:UIControlEventTouchUpInside];
    
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
