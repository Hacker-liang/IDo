//
//  RedMoneyGainDetailVC.m
//  IDo
//
//  Created by 柯南 on 16/1/24.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "RedMoneyGainDetailVC.h"
#import "MyWalletViewController.h"
@interface RedMoneyGainDetailVC ()
@property (nonatomic,strong) NSString *headStr;
@property (nonatomic,strong) NSString *nameStr;
@property (nonatomic,strong) NSString *contentStr;
@property (nonatomic,strong) NSString *moneyStr;
@end

@implementation RedMoneyGainDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=APP_PAGE_COLOR;
    self.navigationItem.title = @"红包领取详情";
    self.edgesForExtendedLayout=0;
//    [self initNav];
    [self initData];
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

-(void)initData
{
    _headStr=[NSString stringWithFormat:@"%@",_detailModel.headImage];
    _nameStr=[NSString stringWithFormat:@"%@的红包",_detailModel.name];
    _contentStr=[NSString stringWithFormat:@"%@",_detailModel.content];
    _moneyStr=[NSString stringWithFormat:@"%.2f元",[_detailModel.money floatValue]];
    
    NSLog(@"_detailDic %@\n%@\n%@\n%@\n",_headStr,_nameStr,_contentStr,_moneyStr);
}

-(void)creatUI
{
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 229*HEIGHT/960)];
    image.image=[UIImage imageNamed:@"RedMoneyBgIcon"];
    [self.view addSubview:image];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 25, 140, 34);
    [button setImage:[UIImage imageNamed:@"RedMoneyBackIcon"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [button setTitle:@"红包领取详情" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    [button addTarget:self action:@selector(gotoBack)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(244*WIDTH/640, 137*HEIGHT/960, 152*WIDTH/640, 152*WIDTH/640)];
    headImage.backgroundColor=[UIColor yellowColor];
    headImage.layer.cornerRadius=76*WIDTH/640;
    headImage.layer.masksToBounds=YES;

    [headImage sd_setImageWithURL:[NSURL URLWithString:_headStr] placeholderImage:[UIImage imageNamed:@"ic_avatar_default.png"]];
    [self.view addSubview:headImage];
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(headImage.frame)+20*HEIGHT/960, WIDTH, 34*HEIGHT/960)];
    nameLab.text=_nameStr;
    nameLab.textAlignment=1;
    nameLab.font=[UIFont systemFontOfSize:34*HEIGHT/960];
    nameLab.textColor=[UIColor blackColor];
    [self.view addSubview:nameLab];
    
    UILabel *contentLab=[[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(nameLab.frame)+20*HEIGHT/960, WIDTH-16, 90)];
    contentLab.text=_contentStr;
    contentLab.textAlignment=1;
    contentLab.numberOfLines = 0;
    contentLab.font=[UIFont systemFontOfSize:15];
    contentLab.textColor=[UIColor blackColor];
    contentLab.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:contentLab];
    
    UILabel *moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(contentLab.frame)+78*HEIGHT/960, WIDTH, 0.05*HEIGHT)];
    moneyLab.text=@"恭喜您，获得";
    moneyLab.textAlignment=1;
    moneyLab.font=[UIFont systemFontOfSize:0.03*HEIGHT];
    [self.view addSubview:moneyLab];
    
    UILabel *moneyNumLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyLab.frame)+40*HEIGHT/960, WIDTH, 80*HEIGHT/960)];
//    moneyNumLab.font=[UIFont systemFontOfSize:80*HEIGHT/960];
    NSString *str =_moneyStr;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:80*HEIGHT/960] range:NSMakeRange(0,str.length-1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(0,str.length-1)];
    moneyNumLab.attributedText=attStr;
    moneyNumLab.textAlignment=1;
    [self.view addSubview:moneyNumLab];
    
    UIButton *gainMoneyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    gainMoneyBtn.frame=CGRectMake(0, 848*HEIGHT/960, WIDTH, 30*HEIGHT/960);
    [gainMoneyBtn setTitle:@"已存入钱包，可直接提现" forState:UIControlStateNormal];
    [gainMoneyBtn setTitleColor:UIColorFromRGB(0x456d98) forState:UIControlStateNormal];
    gainMoneyBtn.titleLabel.font=[UIFont systemFontOfSize:28*HEIGHT/960];
    [gainMoneyBtn addTarget:self action:@selector(GainCash2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gainMoneyBtn];
    
}

-(void)GainCash2
{
    MyWalletViewController *myWslletVC=[[MyWalletViewController alloc]init];
//    [self.navigationController pushViewController:myWslletVC animated:NO];
    UINavigationController *myWslletNav=[[UINavigationController alloc]initWithRootViewController:myWslletVC];
    [self presentViewController:myWslletNav animated:NO completion:nil];
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
