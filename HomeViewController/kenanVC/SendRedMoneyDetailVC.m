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
@interface SendRedMoneyDetailVC ()<UITableViewDelegate,UITableViewDataSource>
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
//    self.navigationItem.title = @"红包领取详情";
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
    NSDictionary *sendRedDetailDic=@{@"redId":_redId};
    
    
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
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(10, 25, 150, 34);
    [button setImage:[UIImage imageNamed:@"RedMoneyBackIcon"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [button setTitle:@"红包发放详情" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
    [button addTarget:self action:@selector(gotoBack)forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:button];
    
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
    
    int redStatus=[_sendRedMoneyResultDic[@"data"][@"status"]intValue];
    NSString *gameOverStr=_sendRedMoneyResultDic[@"data"][@"timeStr"];
    NSString *statu;
    switch (redStatus) {
        case 0:
            statu=@"已领取";
            break;
        
        case 1:
            statu=[NSString stringWithFormat:@"已过期,剩余金额%@已退回。领取",_redMoney];
            break;
            
        case 2:
            statu=[NSString stringWithFormat:@"历时%@,",gameOverStr];
            break;
        default:
            break;
    }
    
    UILabel *infoLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0.45*HEIGHT-60, WIDTH-10, 50)];
    infoLab.numberOfLines=0;
    infoLab.text=[NSString stringWithFormat:@"%@%@/%@个,共%@/%@元",statu,_DetailGrabCount,_count,_moneyGrab,_totalMoney];
    infoLab.textColor=UIColorFromRGB(0xa4a4a4);
    [_headView addSubview:infoLab];
//    [self.view addSubview:_headView];
}

-(void)creatUI
{
    _sendRedMoneyTab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    _sendRedMoneyTab.delegate=self;
    _sendRedMoneyTab.dataSource=self;
    _sendRedMoneyTab.separatorStyle=0;
    [self.view addSubview:_sendRedMoneyTab];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _model =[_modelArr objectAtIndex:indexPath.row];
    static NSString *sendRedDetailID=@"sendRedDetailID";
    SendRedMoneyDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:sendRedDetailID];
    if (!cell) {
        cell=[[SendRedMoneyDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sendRedDetailID];
        
    }
    cell.sendRedMDetail=_model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.1*HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.45*HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headView;
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
