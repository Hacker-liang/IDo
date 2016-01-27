//
//  SendRedMoneyDetailVC.m
//  IDo
//
//  Created by 柯南 on 16/1/26.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "SendRedMoneyDetailVC.h"
#import "SendRedMoneyDetailCell.h"
#import "SendMoneyDetailModel.h"
@interface SendRedMoneyDetailVC ()
@property (nonatomic,strong) UITableView *sendRedMoneyTab;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) NSDictionary *sendRedMoneyResultDic;
@property (nonatomic,strong) NSArray *modelList;
@property (nonatomic,strong) NSMutableArray *modelArr;

@property (nonatomic,strong) NSString *headImage;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *DetailGrabCount;
@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) NSString *moneyGrab;
@property (nonatomic,strong) NSString *totalMoney;

@property (nonatomic,strong) SendMoneyDetailModel *model;
@end

@implementation SendRedMoneyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=APP_PAGE_COLOR;
    self.navigationItem.title = @"红包领取详情";
    self.edgesForExtendedLayout=0;
    [self initNav];
    [self initArr];
    [self postSendRedDetail];
}

-(void)initNav
{
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"common_icon_navigation_back_normal.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"common_icon_navigation_back_hilighted.png"] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(gotoBack)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)gotoBack
{
    if (self.navigationController.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark init

-(void)initArr
{
    _sendRedMoneyResultDic=[NSDictionary dictionary];
    _modelList=[NSArray array];
    _modelArr=[NSMutableArray array];
}

-(void)postSendRedDetail
{
    NSString *sendRedDetailUrl=[NSString stringWithFormat:@"%@redGrabDetail",baseUrl];
    NSDictionary *sendRedDetailDic=@{@"redId":_detaileModel.redId};
    
    
    [SVHTTPRequest POST:sendRedDetailUrl  parameters:sendRedDetailDic completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        _sendRedMoneyResultDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"_sendRedMoneyResultDic %@",_sendRedMoneyResultDic);
        [self initHeadData];
        _modelList=_sendRedMoneyResultDic[@"data"][@"list"];
        _modelArr=[NSMutableArray array];
        for (int i=0; i<_modelList.count; i++) {
            _model=[[SendMoneyDetailModel alloc]initWithJson:_modelList[i]];
            [_modelArr addObject:_model];
        }
        [self creatHeadView];
        [self creatUI];
    }];
}

-(void)initHeadData
{
    _headImage=[NSString stringWithFormat:@"%@%@",headURL,_sendRedMoneyResultDic[@"data"][@"picture"]];
    _name=[NSString stringWithFormat:@"%@",_sendRedMoneyResultDic[@"data"][@"name"]];
    _content=[NSString stringWithFormat:@"%@",_sendRedMoneyResultDic[@"data"][@"content"]];
    _DetailGrabCount=[NSString stringWithFormat:@"%@",_sendRedMoneyResultDic[@"data"][@"grabCount"]];
    _count=[NSString stringWithFormat:@"%@",_sendRedMoneyResultDic[@"data"][@"count"]];
    _moneyGrab=[NSString stringWithFormat:@"%@",_sendRedMoneyResultDic[@"data"][@"moneyGrab"]];
    _totalMoney=[NSString stringWithFormat:@"%@",_sendRedMoneyResultDic[@"data"][@"totalMoney"]];
}

-(void)creatHeadView
{
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.45*HEIGHT)];
    _headView.backgroundColor=APP_PAGE_COLOR;
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.15*HEIGHT)];
    image.image=[UIImage imageNamed:@"RedMoneyBgIcon"];
    [_headView addSubview:image];
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.4*WIDTH, 0.1*HEIGHT, 0.2*WIDTH, 0.2*WIDTH)];
    headImage.backgroundColor=[UIColor yellowColor];
    headImage.layer.cornerRadius=0.1*WIDTH;
    headImage.layer.masksToBounds=YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:_headImage] placeholderImage:[UIImage imageNamed:@"ic_avatar_default.png"]];
    [_headView addSubview:headImage];
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0.11*HEIGHT+0.2*WIDTH, WIDTH, 30)];
    nameLab.text=[NSString stringWithFormat:@"%@的红包",_name];
    nameLab.textAlignment=1;
    nameLab.textColor=[UIColor blackColor];
    [_headView addSubview:nameLab];
    
    UILabel *contentLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLab.frame), WIDTH, 0.15*WIDTH)];
    contentLab.text=[NSString stringWithFormat:@"%@",_content];
    contentLab.textColor=[UIColor lightGrayColor];
    contentLab.textAlignment=1;
    contentLab.numberOfLines=0;
    [_headView addSubview:contentLab];
    
    UILabel *infoLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0.45*HEIGHT-50, WIDTH-10, 40)];
    infoLab.text=[NSString stringWithFormat:@"已领取%@/%@个,共%@/%@元",_DetailGrabCount,_count,_moneyGrab,_totalMoney];
    infoLab.textColor=UIColorFromRGB(0xa4a4a4);
    [_headView addSubview:infoLab];
    [self.view addSubview:_headView];
}

-(void)creatUI
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
