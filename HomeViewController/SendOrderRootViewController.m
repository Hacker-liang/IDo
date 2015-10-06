//
//  SendOrderRootViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "SendOrderRootViewController.h"
#import "SendOrderSegmentedViewController.h"

@interface SendOrderRootViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *galleryImageView;
@property (nonatomic, strong) SendOrderSegmentedViewController *segementedController;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SendOrderRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.galleryImageView];
    [self.galleryImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"banner_default.png"]];

    [self addChildViewController:self.segementedController];
    [self.scrollView addSubview:self.segementedController.view];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+150);
    [self.segementedController willMoveToParentViewController:self];
    self.segementedController.view.frame = CGRectMake(0, 214, self.view.bounds.size.width, self.view.bounds.size.height-214);
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

- (SendOrderSegmentedViewController *)segementedController
{
    if (!_segementedController) {
        _segementedController = [[SendOrderSegmentedViewController alloc] init];
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
