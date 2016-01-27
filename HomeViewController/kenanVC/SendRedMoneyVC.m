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
    [self initNav];
    [self initArr];
    [self postSendRedMoey];
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
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.45*HEIGHT)];
    _headView.backgroundColor=APP_PAGE_COLOR;
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.15*HEIGHT)];
    image.image=[UIImage imageNamed:@"RedMoneyBgIcon"];
    [_headView addSubview:image];
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.4*WIDTH, 0.1*HEIGHT, 0.2*WIDTH, 0.2*WIDTH)];
    headImage.backgroundColor=[UIColor yellowColor];
    headImage.layer.cornerRadius=0.1*WIDTH;
    headImage.layer.masksToBounds=YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar_default.png"]];
    [_headView addSubview:headImage];
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0.11*HEIGHT+0.2*WIDTH, WIDTH, 30)];
    nameLab.text=[NSString stringWithFormat:@"%@共派出",_userInfo.nickName];
    nameLab.textAlignment=1;
    nameLab.textColor=[UIColor blackColor];
    [_headView addSubview:nameLab];
    
    UILabel *moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLab.frame), WIDTH, 0.15*WIDTH)];
    moneyLab.text=[NSString stringWithFormat:@"%@",_sendRedResultDic[@"data"][@"totalMoney"]];
    moneyLab.textColor=UIColorFromRGB(0xe85946);
    moneyLab.textAlignment=1;
    moneyLab.font=[UIFont systemFontOfSize:0.15*WIDTH];
    [_headView addSubview:moneyLab];
    
    UILabel *moneyNumLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0.45*HEIGHT-50, WIDTH, 40)];
    moneyNumLab.textAlignment=1;
    NSString *str = [NSString stringWithFormat:@"派出红包总数%@个",_sendRedResultDic[@"data"][@"count"]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0] range:NSMakeRange(6,str.length-7)];
    [attStr addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(6,str.length-7)];
    moneyNumLab.attributedText=attStr;
    [_headView addSubview:moneyNumLab];
}

-(void)creatUI
{
    _sendRedTab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    _sendRedTab.delegate=self;
    _sendRedTab.dataSource=self;
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
    return 0.45*HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.1*HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SendRedMoneyDetailVC *sendRedMoneyVC=[[SendRedMoneyDetailVC alloc]init];
    sendRedMoneyVC.detaileModel=[_modelArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:sendRedMoneyVC animated:NO];
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
