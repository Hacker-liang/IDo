//
//  RedGainDetailVC.m
//  IDo
//
//  Created by 柯南 on 16/1/25.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "RedGainDetailVC.h"
#import "MyWalletViewController.h"
@interface RedGainDetailVC ()

@end

@implementation RedGainDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=APP_PAGE_COLOR;
    self.navigationItem.title = @"红包领取详情";
    self.edgesForExtendedLayout=0;
    [self initNav];
    [self creatUI];
    NSLog(@"_redResultDic %@",_redResultDic);
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
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"common_icon_navigation_back_normal.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"common_icon_navigation_back_hilighted.png"] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(gotoBack)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
}

-(void)creatUI
{
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.15*HEIGHT)];
    image.image=[UIImage imageNamed:@"RedMoneyBgIcon"];
    [self.view addSubview:image];
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.4*WIDTH, 0.1*HEIGHT, 0.1*HEIGHT, 0.1*HEIGHT)];
    headImage.backgroundColor=[UIColor yellowColor];
//        headImage.image=[UIImage imageNamed:@"ic_avatar_default.png"];
    headImage.layer.cornerRadius=0.05*HEIGHT;
    headImage.layer.masksToBounds=YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",headURL,_redResultDic[@"picture"]]] placeholderImage:[UIImage imageNamed:@"ic_avatar_default.png"]];
    [self.view addSubview:headImage];
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0.22*HEIGHT, WIDTH, 30)];
    nameLab.text=[NSString stringWithFormat:@"%@的红包",_redResultDic[@"name"]];
    nameLab.textAlignment=1;
    [self.view addSubview:nameLab];
    
    UILabel *contentLab=[[UILabel alloc]initWithFrame:CGRectMake(0.1*WIDTH, 0.25*HEIGHT, 0.8*WIDTH, 0.2*HEIGHT)];
    contentLab.text=[NSString stringWithFormat:@"%@",_redResultDic[@"content"]];
    contentLab.numberOfLines=0;
    contentLab.textAlignment=1;
    [self.view addSubview:contentLab];
    
    UILabel *moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(0.1*WIDTH, 0.5*HEIGHT, 0.8*WIDTH, 0.2*HEIGHT)];
    NSString *str = [NSString stringWithFormat:@"恭喜您获得\n%@元",_redResultDic[@"currMoney"]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:35.0] range:NSMakeRange(5,str.length-6)];
    [attStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xBC4E3F) range:NSMakeRange(5,str.length-6)];
    moneyLab.numberOfLines=0;
    moneyLab.textAlignment=1;
    
    UIImageView *nothingImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.3*WIDTH, 0.5*HEIGHT, 0.4*WIDTH, 0.2*WIDTH)];
    nothingImage.image=[UIImage imageNamed:@"NothingRed"];
    UILabel *nothingLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nothingImage.frame)+10, WIDTH, 30)];
    nothingLab.text=@"很遗憾红包已被抢光!";
    nothingLab.textAlignment=1;
    int status=[[NSString stringWithFormat:@"%@",_redResultDic[@"status"]] intValue];
    switch (status) {
        case 0:
            moneyLab.attributedText = attStr;
            [self.view addSubview:moneyLab];
            break;
        
        case 1:
            break;
            
        case 2:
            [self.view addSubview:nothingImage];
            [self.view addSubview:nothingLab];
            break;
            
        case 3:
            
            break;
        default:
            break;
    }
    
    
    UIButton *gainMoneyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    gainMoneyBtn.frame=CGRectMake(0.5*WIDTH-110, HEIGHT-160, 220, 20);
    [gainMoneyBtn setTitle:@"已存入钱包，可直接提现" forState:UIControlStateNormal];
    [gainMoneyBtn setTitleColor:UIColorFromRGB(0x456d98) forState:UIControlStateNormal];
    [gainMoneyBtn addTarget:self action:@selector(GainCash) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gainMoneyBtn];
    
}

-(void)GainCash
{
    MyWalletViewController *myWslletVC=[[MyWalletViewController alloc]init];
    [self.navigationController pushViewController:myWslletVC animated:NO];
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
