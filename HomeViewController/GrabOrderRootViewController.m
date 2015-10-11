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
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollView];
    [self.galleryImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"banner_default.png"]];
    [self.scrollView addSubview:self.galleryImageView];
    
    [self addChildViewController:self.segementedController];
    [self.scrollView addSubview:self.segementedController.view];
    [self.segementedController willMoveToParentViewController:self];
    self.segementedController.view.frame = CGRectMake(0, 214, self.view.bounds.size.width, self.view.bounds.size.height-214);
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+150);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scroll2Buttom) name:kGrabShouldSroll2Buttom object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scroll2Top) name:kGrabShouldSroll2Top object:nil];
}

- (void)scroll2Buttom
{
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, 214)];

    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)scroll2Top
{
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointZero];
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)galleryImageView
{
    if (!_galleryImageView) {
        _galleryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 150)];
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
    CGFloat height = (self.scrollView.bounds.size.height - 214) + scrollView.contentOffset.y;
    _segementedController.view.frame = CGRectMake(0, _segementedController.view.frame.origin.y, _segementedController.view.bounds.size.width, height);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y > 75) {
        CGPoint point = CGPointMake(0, 150);
        [scrollView setContentOffset:point animated:YES];
        
    } else {
        [scrollView setContentOffset:CGPointZero animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");

    if (scrollView.contentOffset.y > 75) {
        CGPoint point = CGPointMake(0, 150);
        scrollView.contentOffset = point;

    } else {
        scrollView.contentOffset = CGPointZero;

    }
}


@end
