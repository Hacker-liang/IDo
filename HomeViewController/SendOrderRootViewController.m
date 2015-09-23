//
//  SendOrderRootViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "SendOrderRootViewController.h"
#import "SendOrderSegmentedViewController.h"

@interface SendOrderRootViewController ()

@property (nonatomic, strong) UIImageView *galleryImageView;
@property (nonatomic, strong) SendOrderSegmentedViewController *segementedController;

@end

@implementation SendOrderRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_galleryImageView];

    [self addChildViewController:self.segementedController];
    [self.view addSubview:self.segementedController.view];
    [self.segementedController willMoveToParentViewController:self];
    self.segementedController.view.frame = CGRectMake(0, 210, self.view.bounds.size.width, self.view.bounds.size.height-210);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIImageView *)galleryImageView
{
    if (!_galleryImageView) {
        _galleryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 210)];
        _galleryImageView.backgroundColor = [UIColor grayColor];
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

@end
