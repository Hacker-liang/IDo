//
//  ContactUsViewController.m
//  IDo
//
//  Created by YangJiLei on 15/7/30.
//  Copyright (c) 2015年 IDo. All rights reserved.
//

#import "ContactUsViewController.h"

@interface ContactUsViewController ()
{
    NSString *APPTITTLE;
}
@end

@implementation ContactUsViewController

#pragma mark -
#pragma mark backClick
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APP_PAGE_COLOR;
    
    NSUserDefaults *APPTittleDefaults=[NSUserDefaults standardUserDefaults];
    
    APPTITTLE =[APPTittleDefaults objectForKey:@"APPTittle"];
    
    NSArray *arr=@[[NSString stringWithFormat:@"产品名称: %@",APPTITTLE],@"开发公司: 北京意能行科技有限公司",@"客服电话: 400-611-8091",@"商务合作: bjyinengxing@163.com",@"媒体网络: bjwogan@163.com"];
    for (int i=0; i<5; i++) {
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(40, 90+40*i, self.view.frame.size.width-30, 40)];
        lable.text=arr[i];
        lable.font=[UIFont systemFontOfSize:14];
        [self.view addSubview:lable];
    }
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
