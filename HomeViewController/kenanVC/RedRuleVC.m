//
//  RedRuleVC.m
//  IDo
//
//  Created by 柯南 on 16/1/21.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "RedRuleVC.h"

@interface RedRuleVC ()
@property (nonatomic,strong) NSString *lab;
@property (nonatomic,strong) NSString *lab1;
@end

@implementation RedRuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"红包规则";
    self.view.backgroundColor = APP_PAGE_COLOR;
    self.edgesForExtendedLayout=0;
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"common_icon_navigation_back_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"common_icon_navigation_back_highlight"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(goBack)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 48, 30)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    
    [self initData];
    [self creatUI];
    
    
}

- (void)goBack
{
    if (self.navigationController.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)initData
{
    _lab=@"       我干红包功能是专门面向附近的商家和个人开通的一项特殊功能。可以实现定向发红包、查收发记录和提现等功能。商家可以通过定向红包发放，向附近居民推广自己的店铺和产品。有技能的个人可以通过红包，像附近居民宣传推广自己，方便日后用我干进行接活。同时，用户也可以通过发红包进行交友和互动。";
    _lab1=@"1、红包派发完毕支付完成之后，无法取消红包发放。\n2、没领完的红包，在24小时后将自动退回到您的钱包。\n3、单个红包的金额根据您设定的总数随机生成。\n4、单个红包金额不允许为低于0.01元，红包总金额不许大于200元, 红包总数不得大于500个。\n5、同一红包发送给附近好友，附近好友只能领取一次。\n6、派发出去及领到的红包金额，可在【我的钱包】-->【收支明细】中查看。";
}
-(void)creatUI
{
    int a=(int)(WIDTH-20)/15;
    int b=(int)_lab.length/a+1;
    
    int c=(int)_lab1.length/a+2;
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, WIDTH-20, b*15)];
    lab.text=_lab;
    lab.numberOfLines=0;
    lab.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:lab];
    
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(10, 130, WIDTH-20, 25)];
    lab1.text=@"红包派发规则";
    lab1.numberOfLines=0;
    lab1.textColor=UIColorFromRGB(0xf89d46);
//    lab1.font=[UIFont systemFontOfSize:20];
    [self.view addSubview:lab1];
    
    
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(10, 160, WIDTH-20, c*15)];
    lab2.text=_lab1;
    lab2.numberOfLines=0;
    lab2.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:lab2];
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
