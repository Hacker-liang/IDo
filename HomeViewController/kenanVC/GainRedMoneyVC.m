//
//  GainRedMoneyVC.m
//  IDo
//
//  Created by 柯南 on 16/1/24.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "GainRedMoneyVC.h"
#import "GainRedMoneyCell.h"
#import "RedMoneyGainDetailVC.h"
@interface GainRedMoneyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *gainRedMoneyTab;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) NSDictionary *resultDic;
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,strong) NSArray *modelList;

@property (nonatomic,strong) GainRedMoneyModel *model;
@property (nonatomic, strong) UserInfo *userInfo;
@end

@implementation GainRedMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=APP_PAGE_COLOR;
    self.navigationItem.title = @"收到的红包";
    self.edgesForExtendedLayout=0;
    [self initNav];
    [self initArr];
    [self postGainRedMoey];
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

-(void)initArr
{
    _userInfo=[UserManager shareUserManager].userInfo;
    _modelArr =[NSMutableArray array];
    
}

-(void)postGainRedMoey
{
    NSString *gainRedListUrl=[NSString stringWithFormat:@"%@redGrabList",baseUrl];
    NSDictionary *gainRedListDic=@{@"memberId":@"21722"};
    
//    NSString *me= [UserManager shareUserManager].userInfo.userid ;
    
    [SVHTTPRequest POST:gainRedListUrl parameters:gainRedListDic completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        _resultDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"_resultDic _resultDic%@",_resultDic);
        _modelList=_resultDic[@"data"][@"list"];
        _modelArr=[NSMutableArray array];
        for (int i=0; i<_modelList.count; i++) {
            _model=[[GainRedMoneyModel alloc]initWithJson:_modelList[i]];
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
    nameLab.text=[NSString stringWithFormat:@"%@共收到",_userInfo.nickName];
    nameLab.textAlignment=1;
    nameLab.textColor=[UIColor blackColor];
    [_headView addSubview:nameLab];
    
    UILabel *moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLab.frame), WIDTH, 0.15*WIDTH)];
    NSString *moneyStr =[NSString stringWithFormat:@"%@ 元",_resultDic[@"data"][@"totalMoney"]];
    NSMutableAttributedString *attmoneyStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    
    [attmoneyStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:0.15*WIDTH] range:NSMakeRange(0,moneyStr.length-2)];
    [attmoneyStr addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(0,moneyStr.length-2)];
    //    moneyLab.text=[NSString stringWithFormat:@"%@元",_sendRedResultDic[@"data"][@"totalMoney"]];
    moneyLab.attributedText=attmoneyStr;
//    moneyLab.text=[NSString stringWithFormat:@"%@元",_resultDic[@"data"][@"totalMoney"]];
//    moneyLab.textColor=UIColorFromRGB(0xe85946);
    moneyLab.textAlignment=1;
//    moneyLab.font=[UIFont systemFontOfSize:0.15*WIDTH];
    [_headView addSubview:moneyLab];

    UILabel *moneyNumLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0.45*HEIGHT-50, WIDTH, 40)];
    moneyNumLab.textAlignment=1;
    NSString *str = [NSString stringWithFormat:@"收到的红包总数%@个",_resultDic[@"data"][@"count"]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0] range:NSMakeRange(7,str.length-8)];
    [attStr addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(7,str.length-8)];
    moneyNumLab.attributedText=attStr;
    [_headView addSubview:moneyNumLab];
}

-(void)creatUI
{
    _gainRedMoneyTab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    _gainRedMoneyTab.delegate=self;
    _gainRedMoneyTab.dataSource=self;
    [self.view addSubview:_gainRedMoneyTab];
}

#pragma mark TABLEVIEW Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _model=[_modelArr objectAtIndex:indexPath.row];
    static NSString *cellID=@"gainRedMoneyCell";
    GainRedMoneyCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =[[GainRedMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.gainRedMoneyModel=_model;
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
    return 0.11*HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RedMoneyGainDetailVC *redMoneyVC=[[RedMoneyGainDetailVC alloc]init];
    redMoneyVC.detailModel=[_modelArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:redMoneyVC animated:NO];
}

#pragma mark SYSTEM
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_gainRedMoneyTab reloadData];
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
