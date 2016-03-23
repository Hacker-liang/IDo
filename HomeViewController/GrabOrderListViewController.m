//
//  GrabOrderListViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/24/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "GrabOrderListViewController.h"
#import "OrderListTableViewCell.h"
#import "OrderListModel.h"
#import "OrderDetailViewController.h"
#import "OrderListEmptyView.h"
#import "MissOrderListViewController.h"
#import "OrderManager.h"

#import "RedGainDetailVC.h"
@interface GrabOrderListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) OrderListEmptyView *emptyView;
@property (nonatomic) NSInteger currentPage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *missOrderBtn;
@property (nonatomic,strong) UIButton *gainRedMoneyBtn;
@property (nonatomic,strong) UILabel *redNumLab;

@property (nonatomic,strong) NSMutableArray *redIdList;


#pragma mark 开始抢红包信息
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *redBgView;
@property (nonatomic,strong) UIImageView *bgImageView;

@end

@implementation GrabOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _redIdList =[NSMutableArray array];
//    [self initData];
    
    _gainRedMoneyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _gainRedMoneyBtn.frame=CGRectMake(WIDTH-80, 0.1*HEIGHT, 67, 81);
    [_gainRedMoneyBtn setBackgroundImage:[UIImage imageNamed:@"GainRedMoneyIcon"] forState:UIControlStateNormal];
    [_gainRedMoneyBtn addTarget:self action:@selector(gainRedMoneyOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_gainRedMoneyBtn];
//    NSUserDefaults *redDefaults=[NSUserDefaults standardUserDefaults];
//    NSString *redCount=[redDefaults objectForKey:@"REDCOUNT"];
//    
//
//    NSString *str = [NSString stringWithFormat:@"还有%@个未抢",redCount];
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
//    
//    [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0] range:NSMakeRange(2,str.length-5)];
//    [attStr addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(2,str.length-5)];
//    _redNumLab.attributedText = attStr;
    
    _redNumLab=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-80, 0.1*HEIGHT+85, 75, 20)];
    _redNumLab.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_redNumLab];
    _currentPage = 1;
    _dataSource = [[NSMutableArray alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderListTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListCell"];
    self.tableView.backgroundColor = APP_PAGE_COLOR;
    [self.tableView.header beginRefreshing];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [self getOrderWithPage:_currentPage+1];
        [self initData];
    }];
    
    //    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        [self getOrderWithPage:_currentPage+1];
    //    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView.header selector:@selector(beginRefreshing) name:kNewOrderNoti object:nil];
    
    _missOrderBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [_missOrderBtn setTitle:@"错过\n订单" forState:UIControlStateNormal];
    _missOrderBtn.titleLabel.numberOfLines = 2;
    [_missOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_missOrderBtn addTarget:self action:@selector(gotoMissOrderList) forControlEvents:UIControlEventTouchUpInside];
    _missOrderBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    _missOrderBtn.layer.cornerRadius = 20;
    
//    _missOrderBtn.hidden = YES;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView.header beginRefreshing];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initData
{
    NSString *url1 = [NSString stringWithFormat:@"%@nearRedList",baseUrl];
    NSMutableDictionary*mDict1 = [NSMutableDictionary dictionary];
    [mDict1 safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    [mDict1 setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lng] forKey:@"lng"];
    [mDict1 setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lat] forKey:@"lat"];
//
//    [mDict1 setObject:@"39.7634" forKey:@"lat"];
//    [mDict1 setObject:@"116.331" forKey:@"lng"];
    
    [SVHTTPRequest POST:url1 parameters:mDict1 completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response) {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            if ([[dict objectForKey:@"status"] integerValue] == 30001 || [[dict objectForKey:@"status"] integerValue] == 30002) {
                if ([UserManager shareUserManager].isLogin) {
                    [UserManager shareUserManager].userInfo = nil;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"info"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoError" object:nil];
                    }];
                }
                return;
            }

//            NSLog(@"附近红包%@",dict);
            NSArray *redList=dict[@"data"];
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"李立松柯南redList 柯南%@",resultDic);
            
            _redIdList =[NSMutableArray array];

           [_redIdList addObjectsFromArray:redList];
            
//             NSLog(@"_redIdList %@",_redIdList);
            NSString *str = [NSString stringWithFormat:@"还有%lu个未抢",(unsigned long)redList.count ];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
            
            [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0] range:NSMakeRange(2,str.length-5)];
            [attStr addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(2,str.length-5)];
            _redNumLab.attributedText = attStr;
        }
    }];
    

}

-(void)gainRedMoneyOrder
{
    if (_redIdList.count==0) {
        
    }else
    {
        _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _bgView.backgroundColor=[UIColor blackColor];
        _bgView.alpha=0.7;
        [self.navigationController.view addSubview:_bgView];
        
        _redBgView=[[UIView alloc]initWithFrame:CGRectMake(60*WIDTH/640, 125*HEIGHT/960, 520*WIDTH/640, 710*HEIGHT/960)];
        _redBgView.backgroundColor=[UIColor whiteColor];
        [self.navigationController.view addSubview:_redBgView];
        
        _bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(-10, -10, 520*WIDTH/640+20, 710*HEIGHT/960+20)];
        _bgImageView.image=[UIImage imageNamed:@"RedBg"];
        [_redBgView addSubview:_bgImageView];
        
        UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame=CGRectMake(10, 10, 20, 20);
        [backBtn setBackgroundImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [_redBgView addSubview:backBtn];
        
        UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(213*WIDTH/640, 61*HEIGHT/960, 94*WIDTH/640, 94*WIDTH/640)];
        //    headImage.backgroundColor=[UIColor yellowColor];
        //    headImage.image=[UIImage imageNamed:@"ic_avatar_default.png"];
        headImage.layer.cornerRadius=47*WIDTH/640;
        headImage.layer.masksToBounds=YES;
        [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",headURL,_redIdList[0][@"picture"]]] placeholderImage:[UIImage imageNamed:@"ic_avatar_default.png"]];
        [_redBgView addSubview:headImage];
        
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 176*HEIGHT/960, 520*WIDTH/640, 36*HEIGHT/960)];
        nameLab.text=_redIdList[0][@"name"];
        nameLab.textAlignment=1;
        nameLab.font=[UIFont systemFontOfSize:25*HEIGHT/960];
        nameLab.textColor=[UIColor whiteColor];
        [_redBgView addSubview:nameLab];
        
        UILabel *contentLab=[[UILabel alloc]initWithFrame:CGRectMake(0.05*WIDTH, 257*HEIGHT/960, 520*WIDTH/640-0.1*WIDTH, 90)];
        contentLab.text=_redIdList[0][@"content"];
        contentLab.numberOfLines=0;
        contentLab.textAlignment=1;
        contentLab.font=[UIFont systemFontOfSize:15];
        contentLab.textColor=[UIColor whiteColor];
        [_redBgView addSubview:contentLab];
        
        UIButton *openRedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        openRedBtn.frame=CGRectMake(174*WIDTH/640, 440*HEIGHT/960, 175*HEIGHT/960, 175*HEIGHT/960);
        openRedBtn.layer.cornerRadius=88*HEIGHT/960;
        openRedBtn.layer.masksToBounds=YES;
        [openRedBtn setBackgroundImage:[UIImage imageNamed:@"OpenRedMoney"] forState:UIControlStateNormal];
        [openRedBtn addTarget:self action:@selector(openRedMoney) forControlEvents:UIControlEventTouchUpInside];
        [_redBgView addSubview:openRedBtn];
        
    }
}

-(void)openRedMoney
{
    NSString *url=[NSString stringWithFormat:@"%@grabRed",baseUrl];
    NSDictionary *dic=@{@"redId":_redIdList[0][@"redId"],@"memberId":[UserManager shareUserManager].userInfo.userid};
    [SVHTTPRequest POST:url parameters:dic completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response) {
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            [self closeView];
            
            NSString *str = [NSString stringWithFormat:@"还有%lu个未抢",(unsigned long)_redIdList.count ];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
            
            [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0] range:NSMakeRange(2,str.length-5)];
            [attStr addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(2,str.length-5)];
            _redNumLab.attributedText = attStr;
            RedGainDetailVC *redGainVC=[[RedGainDetailVC alloc]init];
            redGainVC.redResultDic=resultDic[@"data"];
//            [self.navigationController pushViewController:redGainVC animated:NO];
            [self presentViewController:redGainVC animated:NO completion:nil];
        }
    }];

}

-(void)closeView
{
    [_bgView removeFromSuperview];
    [_redBgView removeFromSuperview];
}


- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (OrderListEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[OrderListEmptyView alloc] initWithFrame:CGRectMake(0,30, self.view.bounds.size.width, 200) andContent:@"暂无待处理订单"];
    }
    return _emptyView;
}


- (void)setupEmptyView
{
    if (!_dataSource.count) {
        [self.emptyView removeFromSuperview];
        [self.tableView addSubview:self.emptyView];
    } else {
        [self.emptyView removeFromSuperview];
    }
}

- (void)gotoMissOrderList
{
    MissOrderListViewController *ctl = [[MissOrderListViewController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)getOrderWithPage:(NSInteger)page
{
    [OrderManager asyncLoadNearByOrderListWithPage:page pageSize:200 completionBlock:^(BOOL isSuccess, NSArray *orderList) {
        if (isSuccess) {
            _currentPage = page;
            if (_currentPage == 1) {
                [_dataSource removeAllObjects];
            }
            [_dataSource addObjectsFromArray:orderList];
//            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
//            _redIdList=[userDefaults objectForKey:@"RedMoneyList"];
////            NSLog(@"柯南RedMoneyList %@",_redIdList);
//            NSString *str = [NSString stringWithFormat:@"还有%lu个未抢",(unsigned long)_redIdList.count ];
//            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
//            
//            [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0] range:NSMakeRange(2,str.length-5)];
//            [attStr addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(2,str.length-5)];
//            _redNumLab.attributedText = attStr;
        }
        [self setupEmptyView];
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
//    [OrderManager asyncLoadNearByAllListWithPage:page pageSize:200 completionBlock:^(BOOL isSuccess, NSArray *orderList, NSDictionary *redDic) {
//        if (isSuccess) {
//            NSLog(@"主页测试%@",orderList);
//            _currentPage = page;
//            if (_currentPage == 1) {
//                [_dataSource removeAllObjects];
//            }
//            [_dataSource addObjectsFromArray:orderList];
//        }
//        [self setupEmptyView];
//        
//        [self.tableView reloadData];
//        [self.tableView.header endRefreshing];
//        [self.tableView.footer endRefreshing];
//        
//    }];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListModel *model = [self.dataSource objectAtIndex:indexPath.section];
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderListCell" forIndexPath:indexPath];
    
    cell.isGrabOrder = YES;
    cell.orderDetail = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderListModel *model = [self.dataSource objectAtIndex:indexPath.section];
    OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
    ctl.orderId = model.orderId;
    ctl.isSendOrder = NO;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 64 && [scrollView isEqual:self.tableView] && scrollView.contentOffset.y > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGrabShouldSroll2Buttom object:nil];
    } else if (scrollView.contentOffset.y < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGrabShouldSroll2Top object:nil];
    }
}


@end
