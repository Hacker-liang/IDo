//
//  GainRedMoneyVC.m
//  IDo
//
//  Created by 柯南 on 16/1/24.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "GainRedMoneyVC.h"
#import "GainRedMoneyCell.h"
@interface GainRedMoneyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) UITableView *gainRedTab;
@end

@implementation GainRedMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=APP_PAGE_COLOR;
    self.navigationItem.title = @"收到的红包";
    self.edgesForExtendedLayout=0;
     _userInfo = [UserManager shareUserManager].userInfo;
    [self initNav];
    [self creatUI];
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
    moneyLab.text=[NSString stringWithFormat:@"555.55",_userInfo.nickName];
    moneyLab.textAlignment=1;
    moneyLab.font=[UIFont systemFontOfSize:WIDTH/moneyLab.text.length];
    moneyLab.textColor=UIColorFromRGB(0xe85946);
    [self.view addSubview:moneyLab];
    
    UILabel *moneyNumLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0.4*HEIGHT, WIDTH, 0.05*HEIGHT)];
    moneyNumLab.text=[NSString stringWithFormat:@"收到的红包总数222个",_userInfo.nickName];
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
