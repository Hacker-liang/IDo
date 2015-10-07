//
//  SenderOrderViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "SenderOrderViewController.h"
#import "SendOrderDetailViewController.h"
#import "AutoSlideScrollView.h"

@interface SenderOrderViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sendOrderBtn;

@property (strong, nonatomic) AutoSlideScrollView *mainView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation SenderOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = @[@"我干,一款派活接活的神器!", @"把琐事交给别人去做\n自己去做更有价值的事情", @"全民抢单,我干,我赚!"];
    _sendOrderBtn.titleLabel.numberOfLines = 2.0;
    [_sendOrderBtn setTitle:@"立即\n派单" forState:UIControlStateNormal];
    self.view.backgroundColor = APP_PAGE_COLOR;
    _mainView = [[AutoSlideScrollView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-100, kWindowWidth, 80) animationDuration:3];
    [self.view addSubview:_mainView];
    
    NSMutableArray *viewsArray = [@[] mutableCopy];
    for (int i = 0; i < _dataSource.count; ++i) {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 80)];
        tempLabel.textAlignment = NSTextAlignmentCenter;
        tempLabel.numberOfLines = 0;
        tempLabel.textColor = [UIColor grayColor];
        tempLabel.font = [UIFont systemFontOfSize:15.0];
        tempLabel.text = _dataSource[i];
        [viewsArray addObject:tempLabel];
    }
    
    self.mainView.totalPagesCount = ^NSInteger(void){
        return viewsArray.count;
    };
    self.mainView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mainView.scrollView setContentOffset:CGPointZero];
    
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _mainView.frame = CGRectMake(0, self.view.bounds.size.height-100, kWindowWidth, 80);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendOrder:(id)sender {
    SendOrderDetailViewController *ctl = [[SendOrderDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:ctl animated:YES];
}
@end
