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
#import "GainRedMoneyModel.h"
@interface GainRedMoneyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) UITableView *gainRedTab;
@property (nonatomic, strong) NSDictionary *gainRedResultDic;
@property (nonatomic, strong) NSMutableArray *modelList;
@property (nonatomic,strong) GainRedMoneyModel *model;
@end

@implementation GainRedMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=APP_PAGE_COLOR;
    self.navigationItem.title = @"收到的红包";
    self.edgesForExtendedLayout=0;
    [self initModelList];
     _userInfo = [UserManager shareUserManager].userInfo;
    NSString *gainRedListUrl=[NSString stringWithFormat:@"%@redGrabList",baseUrl];
    NSDictionary *gainRedListDic=@{@"memberId":@"2655"};
//    [UserManager shareUserManager].userInfo.userid
    [SVHTTPRequest POST:gainRedListUrl parameters:gainRedListDic completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        _gainRedResultDic =[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        [self setModel];
        [self creatUI];
        NSLog(@"_gainRedResultDic %@",_gainRedResultDic);
    }];
    [self initNav];
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

#pragma mark 数据匹配
-(void)initModelList
{
    _modelList=[NSMutableArray array];
}
-(void)setModel
{
    _modelList=_gainRedResultDic[@"data"][@"list"];
    for (int i=0; i<_modelList.count; i++) {
        _model=[[GainRedMoneyModel alloc]init];
        _model.headImage=[NSString stringWithFormat:@"%@%@",headURL,_modelList[i][@"picture"]];
        _model.sexImage=[NSString stringWithFormat:@"%@%@",baseUrl,_modelList[i][@"sex"]];
        _model.nameLab=[NSString stringWithFormat:@"%@%@",baseUrl,_modelList[i][@"name"]];
        _model.moneyLab=[NSString stringWithFormat:@"%@%@",baseUrl,_modelList[i][@"money"]];
        
    }
}

-(void)creatUI
{
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.15*HEIGHT)];
    image.image=[UIImage imageNamed:@"RedMoneyBgIcon"];
    [self.view addSubview:image];
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.4*WIDTH, 0.1*HEIGHT, 0.1*HEIGHT, 0.1*HEIGHT)];
    headImage.backgroundColor=[UIColor yellowColor];
    //    headImage.image=[UIImage imageNamed:@"ic_avatar_default.png"];
    headImage.layer.cornerRadius=0.05*HEIGHT;
    headImage.layer.masksToBounds=YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar_default.png"]];
    [self.view addSubview:headImage];
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0.22*HEIGHT, WIDTH, 30)];
    nameLab.text=[NSString stringWithFormat:@"%@共收到",_userInfo.nickName];
    nameLab.textAlignment=1;
    [self.view addSubview:nameLab];
    
    UILabel *moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0.25*HEIGHT, WIDTH, 0.15*HEIGHT)];
    moneyLab.text=[NSString stringWithFormat:@"%@元",_gainRedResultDic[@"data"][@"totalMoney"]];
    moneyLab.textAlignment=1;
    moneyLab.font=[UIFont systemFontOfSize:0.1*HEIGHT];
    moneyLab.textColor=UIColorFromRGB(0xe85946);
    [self.view addSubview:moneyLab];
    
    UILabel *moneyNumLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0.4*HEIGHT, WIDTH, 0.05*HEIGHT)];
    NSString *str = [NSString stringWithFormat:@"收到的红包总数%@个",_gainRedResultDic[@"data"][@"count"] ];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:0.03*HEIGHT] range:NSMakeRange(7,str.length-8)];
    [attStr addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(7,str.length-8)];
    moneyNumLab.attributedText = attStr;
    moneyNumLab.adjustsFontSizeToFitWidth = YES;
//    moneyNumLab.text=[NSString stringWithFormat:@"收到的红包总数222个",_userInfo.nickName];
    moneyNumLab.textAlignment=1;
    [self.view addSubview:moneyNumLab];
    
    _gainRedTab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0.5*HEIGHT, WIDTH, 0.5*HEIGHT-64) style:UITableViewStylePlain];
    _gainRedTab.delegate=self;
    _gainRedTab.dataSource=self;
    _gainRedTab.separatorStyle=0;
    [self.view addSubview:_gainRedTab];
}


#pragma mark UITableView DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"gainRedMoneyCell";
    GainRedMoneyCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =[[GainRedMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.11*HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RedMoneyGainDetailVC *redMoneyVC=[[RedMoneyGainDetailVC alloc]init];
    [self.navigationController pushViewController:redMoneyVC animated:NO];
}

#pragma mark SYSTEM
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_gainRedTab reloadData];
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
