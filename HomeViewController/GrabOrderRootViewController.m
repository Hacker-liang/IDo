//
//  GrabOrderRootViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "GrabOrderRootViewController.h"
#import "GrabOrderSegmentedViewController.h"

@interface GrabOrderRootViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *galleryImageView;
@property (nonatomic, strong) GrabOrderSegmentedViewController *segementedController;
@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation GrabOrderRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.1)];
    [self.view addSubview:view];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.galleryImageView];
    
    [self addChildViewController:self.segementedController];
    [self.scrollView addSubview:self.segementedController.view];
    [self.segementedController willMoveToParentViewController:self];
    self.segementedController.view.frame = CGRectMake(0, 210, self.view.bounds.size.width, self.view.bounds.size.height-210);
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+(210-64));
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)galleryImageView
{
    if (!_galleryImageView) {
        _galleryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 210-64)];
        _galleryImageView.backgroundColor = [UIColor grayColor];
    }
    return _galleryImageView;
}

- (GrabOrderSegmentedViewController *)segementedController
{
    if (!_segementedController) {
        _segementedController = [[GrabOrderSegmentedViewController alloc] init];
    }
    return _segementedController;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.scrollView]) {
        if (scrollView.contentOffset.y > (210 - 64)) {
            CGPoint point = CGPointMake(0, 210-64);
            scrollView.contentOffset = point;
        }
    }
}

@end
