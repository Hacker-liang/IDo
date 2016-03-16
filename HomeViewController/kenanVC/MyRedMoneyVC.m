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
//    self.navigationItem.title = @"我的红包";
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
    button.frame=CGRectMake(0, 25, 100, 34);
    [button setImage:[UIImage imageNamed:@"RedMoneyBackIcon"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [button setTitle:@"我的红包" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    [button addTarget:self action:@selector(gotoBack)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-35, 30, 20, 20)];
//    [btn setTitle:@"Rule" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"redRuleHelp"] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.titleLabel.font  = [UIFont systemFontOfSize:15.0];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn.backgroundColor=[UIColor yellowColor];
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
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(244*WIDTH/640, 137*HEIGHT/960, 152*WIDTH/640, 152*WIDTH/640)];
    headImage.backgroundColor=[UIColor yellowColor];
//    headImage.image=[UIImage imageNamed:@"ic_avatar_default.png"];
    headImage.layer.cornerRadius=76*WIDTH/640;
    headImage.layer.masksToBounds=YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar_default.png"]];
    [self.view addSubview:headImage];
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headImage.frame)+20*HEIGHT/960, WIDTH, 34*HEIGHT/960)];
    nameLab.text=_userInfo.nickName;
    nameLab.textAlignment=1;
    nameLab.textColor=[UIColor whiteColor];
    nameLab.font=[UIFont systemFontOfSize:25*HEIGHT/960];
    [self.view addSubview:nameLab];
    
    UIButton *gainBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    gainBtn.frame=CGRectMake(70*WIDTH/640, 389*HEIGHT/960, 501*WIDTH/640, 90*HEIGHT/960);
//    [gainBtn setBackgroundImage:[UIImage imageNamed:@"MyRedMoneyGainMoney"] forState:UIControlStateNormal];
    gainBtn.backgroundColor=UIColorFromRGB(0xffb22e);
    gainBtn.layer.cornerRadius=5;
    gainBtn.layer.masksToBounds=YES;
    [gainBtn setTitle:@"收到的红包" forState:UIControlStateNormal];
    [gainBtn setTitleColor:UIColorFromRGB(0xfefefe) forState:UIControlStateNormal];
    gainBtn.titleLabel.font=[UIFont systemFontOfSize:30*HEIGHT/960];
    
    [gainBtn addTarget:self action:@selector(gainRedMoney) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gainBtn];
    
    UIButton *sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame=CGRectMake(70*WIDTH/640, 541*HEIGHT/960, 501*WIDTH/640, 90*HEIGHT/960);
//    [sendBtn setBackgroundImage:[UIImage imageNamed:@"MyRedMoneySendMoney"] forState:UIControlStateNormal];
    sendBtn.backgroundColor=UIColorFromRGB(0xf9f7de);
    sendBtn.layer.cornerRadius=5;
    sendBtn.layer.masksToBounds=YES;
    [sendBtn setTitle:@"发出的红包" forState:UIControlStateNormal];
    [sendBtn setTitleColor:UIColorFromRGB(0xef4232) forState:UIControlStateNormal];
    sendBtn.titleLabel.font=[UIFont systemFontOfSize:30*HEIGHT/960];
    
    [sendBtn addTarget:self action:@selector(sendRedMoney) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    
    UILabel *downLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 876*HEIGHT/960, WIDTH, 30*HEIGHT/960)];
    downLab.text=@"未领取的红包,将于24小时后发起退款";
    downLab.textColor=COLOR(254, 203, 116);
    downLab.font=[UIFont systemFontOfSize:0.04*WIDTH];
    downLab.textAlignment=1;
    downLab.font=[UIFont systemFontOfSize:25*HEIGHT/960];
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
