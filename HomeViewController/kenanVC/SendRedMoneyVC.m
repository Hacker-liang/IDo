//
//  SendRedMoneyVC.m
//  IDo
//
//  Created by 柯南 on 16/1/24.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "SendRedMoneyVC.h"
#import "SendRedMoneyCell.h"
#import "SendRedMoneyModel.h"
#import "SendRedMoneyDetailVC.h"
@interface SendRedMoneyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UserInfo *userInfo;

@property (nonatomic,strong) UITableView *sendRedTab;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) NSDictionary *sendRedResultDic;
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,strong) NSArray *modelList;
@property (nonatomic,strong) SendRedMoneyModel *model;
@end

@implementation SendRedMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=APP_PAGE_COLOR;
    self.navigationItem.title = @"派出的红包";
    self.edgesForExtendedLayout=0;
    _userInfo = [UserManager shareUserManager].userInfo;
//    [self initNav];
    [self initArr];
    [self postSendRedMoey];
}

-(void)initNav
{
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(10, 25, 100, 34);
    [button setImage:[UIImage imageNamed:@"RedMoneyBackIcon"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [button setTitle:@"派出的红包" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, -20)];
    [button addTarget:self action:@selector(gotoBack)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
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
    _modelArr=[NSMutableArray array];
    _modelList=[NSArray array];
    _sendRedResultDic=[NSDictionary dictionary];
    _userInfo=[UserManager shareUserManager].userInfo;
}

-(void)postSendRedMoey
{
    NSString *gainRedListUrl=[NSString stringWithFormat:@"%@redSendList",baseUrl];
    NSDictionary *gainRedListDic=@{@"memberId":_userInfo.userid};
    
    //    NSString *me= [UserManager shareUserManager].userInfo.userid ;
    NSLog(@"_userInfo.userid %@",_userInfo.userid);
    
    [SVHTTPRequest POST:gainRedListUrl parameters:gainRedListDic completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        _sendRedResultDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"_sendRedResultDic _sendRedResultDic%@",_sendRedResultDic);
        _modelList=_sendRedResultDic[@"data"][@"list"];
        _modelArr=[NSMutableArray array];
        for (int i=0; i<_modelList.count; i++) {
            _model=[[SendRedMoneyModel alloc]initWithJson:_modelList[i]];
            [_modelArr addObject:_model];
        }
        [self creatHeadView];
        [self creatUI];
    }];
    
}

-(void)creatHeadView
{
    //    (70*WIDTH/640, 541*HEIGHT/960, 501*WIDTH/640, 90*HEIGHT/960)

    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 520*HEIGHT/960)];
    _headView.backgroundColor=UIColorFromRGB(0xffffff);
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 229*HEIGHT/960)];
    image.image=[UIImage imageNamed:@"RedMoneyBgIcon"];
    [_headView addSubview:image];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 25, 120, 34);
    [button setImage:[UIImage imageNamed:@"RedMoneyBackIcon"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [button setTitle:@"派出的红包" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    [button addTarget:self action:@selector(gotoBack)forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:button];
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(244*WIDTH/640, 137*HEIGHT/960, 152*WIDTH/640, 152*WIDTH/640)];
    headImage.backgroundColor=[UIColor yellowColor];
    headImage.layer.cornerRadius=76*WIDTH/640;
    headImage.layer.masksToBounds=YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar_default.png"]];
    [_headView addSubview:headImage];
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headImage.frame)+20*HEIGHT/960, WIDTH, 34*HEIGHT/960)];
    nameLab.text=[NSString stringWithFormat:@"%@共派出",_userInfo.nickName];
    nameLab.textAlignment=1;
    nameLab.font=[UIFont systemFontOfSize:34*HEIGHT/960];
    nameLab.textColor=[UIColor blackColor];
    [_headView addSubview:nameLab];
    
    UILabel *moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLab.frame)+20*HEIGHT/960, WIDTH, 88*HEIGHT/960)];
    double money=[_sendRedResultDic[@"data"][@"totalMoney"] doubleValue];
    NSString *moneyStr =[NSString stringWithFormat:@"%0.2f 元",money];
    NSMutableAttributedString *attmoneyStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    
    [attmoneyStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:60*HEIGHT/960] range:NSMakeRange(0,moneyStr.length-2)];
    [attmoneyStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0XBC4E3F) range:NSMakeRange(0,moneyStr.length-2)];
//    moneyLab.text=[NSString stringWithFormat:@"%@元",_sendRedResultDic[@"data"][@"totalMoney"]];
    moneyLab.attributedText=attmoneyStr;
//    moneyLab.textColor=UIColorFromRGB(0xe85946);
    moneyLab.textAlignment=1;
    [_headView addSubview:moneyLab];
    
    UILabel *moneyNumLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyLab.frame)+22*HEIGHT/960, WIDTH, 34*HEIGHT/960)];
    moneyNumLab.textAlignment=1;
    moneyNumLab.font=[UIFont systemFontOfSize:34*HEIGHT/960];
    NSString *str = [NSString stringWithFormat:@"派发红包总次数%@次",_sendRedResultDic[@"data"][@"count"]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:34*HEIGHT/960] range:NSMakeRange(7,str.length-8)];
    [attStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0XBC4E3F) range:NSMakeRange(7,str.length-8)];
    moneyNumLab.attributedText=attStr;
    [_headView addSubview:moneyNumLab];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,  518*HEIGHT/960, WIDTH, 1)];
    lineView.backgroundColor=APP_PAGE_COLOR;
    [_headView addSubview:lineView];
}

-(void)creatUI
{
    _sendRedTab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _sendRedTab.delegate=self;
    _sendRedTab.dataSource=self;
    _sendRedTab.separatorStyle=0;
    [self.view addSubview:_sendRedTab];
}


#pragma mark TABLEVIEW Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _model=[_modelArr objectAtIndex:indexPath.row];
    static NSString *cellID=@"gainRedMoneyCell";
    SendRedMoneyCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =[[SendRedMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.sendRedModel=_model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 520*HEIGHT/960;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.12*HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SendRedMoneyDetailVC *sendRedMoneyVC=[[SendRedMoneyDetailVC alloc]init];
    _model=[_modelArr objectAtIndex:indexPath.row];
    sendRedMoneyVC.redId=_model.redId;
    sendRedMoneyVC.fromC=@"sendRedMoney";
    sendRedMoneyVC.detaileModel=_model;
//    [self.navigationController pushViewController:sendRedMoneyVC animated:NO];
    [self presentViewController:sendRedMoneyVC animated:NO completion:nil];
}

#pragma mark SYSTEM
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_sendRedTab reloadData];
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
