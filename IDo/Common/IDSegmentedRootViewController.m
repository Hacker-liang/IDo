//
//  IDSegmentedRootViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "IDSegmentedRootViewController.h"

@interface IDSegmentedRootViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) UIView *indicatorView;
//保存 切换按钮
@property (nonatomic, strong) NSArray *segmentBtns;

@property (nonatomic, strong) UIScrollView *contentView;

@end

@implementation IDSegmentedRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSegmentView];
    [self setupContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  初始化切换按钮
 */
- (void)setupSegmentView
{
    UIView *segmentPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 49)];
    segmentPanel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:segmentPanel];
    
    NSMutableArray *buttonArray = [[NSMutableArray alloc] init];
    
    float btnWidth = self.view.bounds.size.width/[_segmentedTitles count];
    float btnHeight = 49;
    float offsetX = 0;
    
    _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWidth, 2)];
    _indicatorView.backgroundColor = [UIColor orangeColor];
    [segmentPanel addSubview:_indicatorView];
    
    for (int i = 0; i < [_segmentedTitles count]; i++) {
        NSString *title = [_segmentedTitles objectAtIndex:i];
        NSString *imageNormalName = [_segmentedTitles objectAtIndex:i];
        NSString *imageSelectName = [_segmentedTitles objectAtIndex:i];
        UIButton *segmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 0, btnWidth, btnHeight)];
        [segmentBtn setTitle:title forState:UIControlStateNormal];
        [segmentBtn setImage:[UIImage imageNamed:imageNormalName] forState:UIControlStateNormal];
        [segmentBtn setImage:[UIImage imageNamed:imageSelectName] forState:UIControlStateSelected];
        [segmentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [segmentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [segmentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        [segmentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 3)];
        segmentBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        segmentBtn.tag = i;
        [segmentBtn addTarget:self action:@selector(changePageAction:) forControlEvents:UIControlEventTouchUpInside];
        [segmentPanel addSubview:segmentBtn];
        [buttonArray addObject:segmentBtn];
        offsetX += btnWidth;
        
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, 8, 0.5, 33)];
        spaceView.backgroundColor = [UIColor grayColor];
        [segmentPanel addSubview:spaceView];
    }
    _segmentBtns = buttonArray;
    _currentViewController = [_viewControllers firstObject];
}


/**
 *  设置具体内容
 */
- (void)setupContentView
{
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 49, self.view.bounds.size.width, self.view.bounds.size.height-49)];
    _contentView.pagingEnabled = YES;
    _contentView.delegate = self;
    _contentView.contentSize = CGSizeMake(self.view.bounds.size.width*_viewControllers.count, _contentView.bounds.size.height);
    _contentView.scrollEnabled = NO;
    [self.view addSubview:_contentView];
    
    CGFloat offsetX = 0;
    
    for (int i = 0; i < _viewControllers.count; i++) {
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = _contentView.bounds.size.height;
        UIViewController *ctl = [_viewControllers objectAtIndex:i];
        [self addChildViewController:ctl];
        ctl.view.frame = CGRectMake(offsetX, 0, width, height);
        [_contentView addSubview:ctl.view];
        [ctl willMoveToParentViewController:self];
        offsetX += width;
    }
}

- (void)changePageAction:(UIButton *)sender
{
    [self changePage:sender.tag];
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_contentView]) {
        CGFloat offsetX= scrollView.contentOffset.x;
        NSUInteger pageIndex = offsetX/scrollView.bounds.size.width;
        [self changePage:pageIndex];
    }
}

@end
