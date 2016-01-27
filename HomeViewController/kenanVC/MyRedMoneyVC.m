//
//  MyRedMoneyVC.m
//  IDo
//
//  Created by 柯南 on 16/1/22.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "MyRedMoneyVC.h"
#import "RedRuleVC.h"

#import "GainRedMoneyVC.h"
#import "SendRedMoneyVC.h"
@interface MyRedMoneyVC ()
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic,strong) UIImageView *image;
@end

@implementation MyRedMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=APP_PAGE_COLOR;
    self.navigationItem.title = @"我的红包";
    _userInfo = [UserManager shareUserManager].userInfo;
    [self initNav];
    [self creatUI];
    
}
- (void)gotoBack
{
    if (self.navigationController.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)initNav
{
    _image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _image.image=[UIImage imageNamed:@"GainRedBg"];
    [self.view addSubview:_image];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(10, 25, 100, 34);
    [button setImage:[UIImage imageNamed:@"RedMoneyBackIcon"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [button setTitle:@"我的红包" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, -20)];
    [button addTarget:self action:@selector(gotoBack)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-30, 30, 20, 20)];
//    [btn setTitle:@"Rule" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"RedRuleHelp"] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.titleLabel.font  = [UIFont systemFontOfSize:15.0];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rule) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)rule
{
    RedRuleVC *redRule=[[RedRuleVC alloc]init];
    UINavigationController *redNav=[[UINavigationController alloc]initWithRootViewController:redRule];
    [self presentViewController:redNav animated:NO completion:nil];
}

#pragma mark creatUI
-(void)creatUI
{
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.4*WIDTH, 0.1*HEIGHT+50, 0.2*WIDTH, 0.2*WIDTH)];
    headImage.backgroundColor=[UIColor yellowColor];
//    headImage.image=[UIImage imageNamed:@"ic_avatar_default.png"];
    headImage.layer.cornerRadius=0.1*WIDTH;
    headImage.layer.masksToBounds=YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar_default.png"]];
    [self.view addSubview:headImage];
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0.3*HEIGHT, WIDTH, 30)];
    nameLab.text=_userInfo.nickName;
    nameLab.textAlignment=1;
    nameLab.textColor=[UIColor whiteColor];
    [self.view addSubview:nameLab];
    
    UIButton *gainBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    gainBtn.frame=CGRectMake(0.1*WIDTH, 0.3*HEIGHT+50, 0.8*WIDTH, 0.08*HEIGHT);
    [gainBtn setBackgroundImage:[UIImage imageNamed:@"MyRedMoneyGainMoney"] forState:UIControlStateNormal];
    [gainBtn addTarget:self action:@selector(gainRedMoney) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gainBtn];
    
    UIButton *sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame=CGRectMake(0.1*WIDTH, 0.45*HEIGHT+50, 0.8*WIDTH, 0.08*HEIGHT);
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"MyRedMoneySendMoney"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendRedMoney) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    
    UILabel *downLab=[[UILabel alloc]initWithFrame:CGRectMake(0.1*WIDTH, HEIGHT-70, 0.8*WIDTH, 30)];
    downLab.text=@"未领取的红包,将于24小时后发起退款";
    downLab.textColor=COLOR(254, 203, 116);
    downLab.font=[UIFont systemFontOfSize:0.04*WIDTH];
    downLab.textAlignment=1;
    [self.view addSubview:downLab];
}

-(void)gainRedMoney
{
    GainRedMoneyVC *gainVC=[[GainRedMoneyVC alloc]init];
    [self presentViewController:gainVC animated:NO completion:nil];
}

-(void)sendRedMoney
{
    SendRedMoneyVC *sendVC=[[SendRedMoneyVC alloc]init];
    [self presentViewController:sendVC animated:NO completion:nil];
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
