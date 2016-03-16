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
}

-(void)creatUI
{
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 229*HEIGHT/960)];
    image.image=[UIImage imageNamed:@"RedMoneyBgIcon"];
    [self.view addSubview:image];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(10, 25, 150, 34);
    [button setImage:[UIImage imageNamed:@"RedMoneyBackIcon"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [button setTitle:@"红包领取详情" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
    [button addTarget:self action:@selector(gotoBack)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(244*WIDTH/640, 137*HEIGHT/960, 152*WIDTH/640, 152*WIDTH/640)];
    headImage.backgroundColor=[UIColor yellowColor];
//        headImage.image=[UIImage imageNamed:@"ic_avatar_default.png"];
    headImage.layer.cornerRadius=76*WIDTH/640;
    headImage.layer.masksToBounds=YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",headURL,_redResultDic[@"picture"]]] placeholderImage:[UIImage imageNamed:@"ic_avatar_default.png"]];
    [self.view addSubview:headImage];
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headImage.frame)+20*HEIGHT/960, WIDTH, 34*HEIGHT/960)];
    nameLab.text=[NSString stringWithFormat:@"%@的红包",_redResultDic[@"name"]];
    nameLab.textAlignment=1;
    nameLab.font=[UIFont systemFontOfSize:34*HEIGHT/960];
    [self.view addSubview:nameLab];
    
    UILabel *contentLab=[[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(nameLab.frame)+20*HEIGHT/960, WIDTH-16, 40)];
    contentLab.text=[NSString stringWithFormat:@"%@",_redResultDic[@"content"]];
    contentLab.numberOfLines=0;
    contentLab.font=[UIFont systemFontOfSize:16];
    contentLab.textAlignment=NSTextAlignmentCenter;
    contentLab.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:contentLab];
    
    UILabel *moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(contentLab.frame)+78*HEIGHT/960, WIDTH, 38*HEIGHT/960)];
    moneyLab.text=@"恭喜您，获得";
    moneyLab.textAlignment=NSTextAlignmentCenter;
//    moneyLab.font=[UIFont systemFontOfSize:20*HEIGHT/960];

    
    UILabel *moneyNumLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyLab.frame)+40*HEIGHT/960, WIDTH, 80*HEIGHT/960)];
    NSString *str = [NSString stringWithFormat:@"%.2f元",[_redResultDic[@"currMoney"] floatValue]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:60*HEIGHT/960] range:NSMakeRange(0,str.length-1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xBC4E3F) range:NSMakeRange(0,str.length-1)];
    moneyNumLab.numberOfLines=0;
    moneyNumLab.textAlignment=1;
    
    UIImageView *nothingImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.3*WIDTH, 0.5*HEIGHT, 0.4*WIDTH, 0.2*WIDTH)];
    nothingImage.image=[UIImage imageNamed:@"NothingRed"];
    UILabel *nothingLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nothingImage.frame)+10, WIDTH, 30)];
    nothingLab.textAlignment=1;
    int status=[[NSString stringWithFormat:@"%@",_redResultDic[@"status"]] intValue];
    UIButton *gainMoneyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    gainMoneyBtn.frame=CGRectMake(0.5*WIDTH-110, HEIGHT-80, 220, 20);
    [gainMoneyBtn setTitle:@"已存入钱包，可直接提现" forState:UIControlStateNormal];
    [gainMoneyBtn setTitleColor:UIColorFromRGB(0x456d98) forState:UIControlStateNormal];
    [gainMoneyBtn addTarget:self action:@selector(GainCash1) forControlEvents:UIControlEventTouchUpInside];
    switch (status) {
        case 0:
            moneyNumLab.attributedText = attStr;
            [self.view addSubview:moneyLab];
            [self.view addSubview:moneyNumLab];
            [self.view addSubview:gainMoneyBtn];
            break;
        
        case 1:
            nothingLab.text=@"很遗憾红包已被抢光!";
            [self.view addSubview:nothingImage];
            [self.view addSubview:nothingLab];
            break;
            
        case 2:
             nothingLab.text=@"很遗憾红包已被抢光!";
            [self.view addSubview:nothingImage];
            [self.view addSubview:nothingLab];
            break;
            
        case 3:
            nothingLab.text=@"您已抢过!";
            [self.view addSubview:nothingLab];
            break;
        default:
            break;
    }
    
    
}

-(void)GainCash1
{
    NSLog(@"3434");
    
    MyWalletViewController *myWslletVC=[[MyWalletViewController alloc]init];
    UINavigationController *myWslletNav=[[UINavigationController alloc]initWithRootViewController:myWslletVC];
//    [self.navigationController pushViewController:myWslletNav animated:NO];
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
