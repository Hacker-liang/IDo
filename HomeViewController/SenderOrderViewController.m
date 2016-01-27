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

//kenan start
#import "SendMoneyVC.h"
#import "HowToSendVC.h"
#import "HotOrderVC.h"
//kenan end

@interface SenderOrderViewController ()
{
    NSString *APPTITTLE;
}
@property (weak, nonatomic) IBOutlet UIButton *sendOrderBtn;

@property (strong, nonatomic) AutoSlideScrollView *mainView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic,strong) UIButton *sendOrderDecBtn;
@property (nonatomic,strong) UIButton *hotOrderBtn;
@property (nonatomic,strong) UIButton *sendMoneyBtn;

@end

@implementation SenderOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    
    NSUserDefaults *APPTittleDefaults=[NSUserDefaults standardUserDefaults];
    
    APPTITTLE =[APPTittleDefaults objectForKey:@"APPTittle"];
    
    NSString *messag=[NSString stringWithFormat:@"%@,一款派活接活的神器!",APPTITTLE];
    
    NSString *messag1=[NSString stringWithFormat:@"全民抢单,%@,我赚!",APPTITTLE];
    
    _dataSource = @[messag, @"把琐事交给别人去做\n自己去做更有价值的事情",messag1];
    _sendOrderBtn.titleLabel.numberOfLines = 2.0;
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

#pragma mark 柯南修改

-(void)creatUI
{
    _sendOrderDecBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _sendOrderDecBtn.frame=CGRectMake(0.5*WIDTH-100, 0.33*HEIGHT,86 , 16);
    [_sendOrderDecBtn setBackgroundImage:[UIImage imageNamed:@"HowSendOrder"] forState:UIControlStateNormal];
    [_sendOrderDecBtn setBackgroundImage:[UIImage imageNamed:@"HowSendOrderCh"] forState:UIControlStateHighlighted];
    [_sendOrderDecBtn addTarget:self action:@selector(HowToSendOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendOrderDecBtn];
    
    _hotOrderBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _hotOrderBtn.frame=CGRectMake(0.5*WIDTH+37, 0.33*HEIGHT,63, 16);
    [_hotOrderBtn setBackgroundImage:[UIImage imageNamed:@"HotOrderIcon"] forState:UIControlStateNormal];
    [_hotOrderBtn setBackgroundImage:[UIImage imageNamed:@"HotOrderIconCh"] forState:UIControlStateHighlighted];
    [_hotOrderBtn addTarget:self action:@selector(HotOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hotOrderBtn];
    
    _sendMoneyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _sendMoneyBtn.frame=CGRectMake(0.5*WIDTH-75, 0.23*HEIGHT, 150, 35);
    [_sendMoneyBtn setBackgroundImage:[UIImage imageNamed:@"SendMoneyImage"] forState:UIControlStateNormal];
    [_sendMoneyBtn addTarget:self action:@selector(sendMoney) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendMoneyBtn];

}

-(void)HowToSendOrder
{
    HowToSendVC *howtoVC=[[HowToSendVC alloc]init];
    [self.navigationController pushViewController:howtoVC animated:NO];
}

-(void)HotOrder
{
    HotOrderVC *hotOrderVC=[[HotOrderVC alloc]init];
    [self.navigationController pushViewController:hotOrderVC animated:NO];
}

-(void)sendMoney
{
    SendMoneyVC *sendMoneyVC=[[SendMoneyVC alloc]init];
    [self.navigationController pushViewController:sendMoneyVC animated:NO];
//    [self presentViewController:sendMoneyVC animated:NO completion:nil];
}

@end
