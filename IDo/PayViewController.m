//
//  PayViewController.m
//  IDo
//
//  Created by YangJiLei on 15/8/28.
//  Copyright (c) 2015年 IDo. All rights reserved.
//

#import "PayViewController.h"
#import "AliPayTool.h"

@interface PayViewController ()

@end

@implementation PayViewController
@synthesize payTab,price,huoerbaoID,orderid;

- (id)initWithPaySuccessBlock:(PaySuccessBlock)block
{
    if (self = [super init]) {
        _paySuccessBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付";
//    Appdelegate.viewisWhere = PiePayView;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PayStatusSure) name:@"paySuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PayError) name:@"payErrorNotification" object:nil];

    
    self.payTab = [[UITableView alloc]initWithFrame:CGRectMake(0.0f,0,kWindowWidth,kWindowHeight-100) style:UITableViewStylePlain];
    self.payTab.delegate = self;
    self.payTab.dataSource = self;
    self.payTab.backgroundView = nil;
    self.payTab.backgroundColor = [UIColor clearColor];
    [AppTools clearTabViewLine:self.payTab];
    self.payTab.scrollEnabled = NO;
    self.payTab.rowHeight = 44;
    self.payTab.separatorColor = [UIColor clearColor];
    self.payTab.tableHeaderView = [self creatHeadView];
    [self.view addSubview:self.payTab];
    
    UILabel *mylable=[[UILabel alloc]initWithFrame:CGRectMake(15,kWindowHeight-50, self.view.frame.size.width-30, 40)];
    mylable.textColor=[UIColor grayColor];
    mylable.textAlignment=NSTextAlignmentCenter;
    mylable.text=@"确认支付后费用将先行支付到平台,待抢单人完成服务并由您再次确认时才能收到此费用";
    mylable.numberOfLines=0;
    mylable.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:mylable];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(10, kWindowHeight-100, self.view.frame.size.width-20, 40);
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTintColor:[UIColor whiteColor]];
    [btn setBackgroundImage:[UIImage imageNamed:@"callbtn.png"] forState:UIControlStateNormal];
    [btn setTitle:@"确认支付" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(payforSure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (UIView*)creatHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 120)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 110)];
    bgView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:bgView];

    UILabel *pirceLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, kWindowWidth, 35)];
    pirceLab.text=[NSString stringWithFormat:@"￥%@",self.price];
    pirceLab.font=[UIFont systemFontOfSize:25];
    pirceLab.textAlignment=NSTextAlignmentCenter;
    pirceLab.textColor=[UIColor colorWithRed:(48)/255.0 green:(167)/255.0 blue:(59)/255.0 alpha:1];
    [headView addSubview:pirceLab];
    
    UILabel *textLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 65, kWindowWidth, 20)];
    textLab.text=@"订单金额";
    textLab.font=[UIFont systemFontOfSize:16];
    textLab.textAlignment=NSTextAlignmentCenter;
    textLab.textColor=[UIColor grayColor];
    [headView addSubview:textLab];
    
    return headView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

-(void)tableView:(UITableView*)tableView  willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableViews dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 44)];
        bgView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:bgView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 12, 20, 20)];
        imageView.tag = 990;
        [cell addSubview:imageView];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(56.0f, 0, kWindowWidth-66, 44)];
        titleLab.tag = 991;
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = COLOR(79, 79,79);
        titleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:titleLab];
        
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:990];
    imageView.image = [UIImage imageNamed:@"ali_pay.png"];
    UILabel *titleLab = (UILabel*)[cell viewWithTag:991];
    titleLab.text = @"使用支付宝支付";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kWindowWidth, 35)];
    view.backgroundColor = [UIColor clearColor];
   
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 30)];
    titleLab.text = @"   请选择支付方式";
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = COLOR(49, 49, 49);
    [view addSubview:titleLab];
    return view;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void)payforSure
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    AliPayTool *ali=[[AliPayTool alloc]init];
    __weak PayViewController *wSelf = self;
    [ali aliPayWithProductName:@"佣金" productDescription:@"我干佣金-iOS 客户端" andAmount:self.price orderId:self.orderid orderNumber:self.orderNumber MoneyBao:price AliPayMoney:price shouKuanID:self.huoerbaoID completeBlock:^(BOOL success, NSString *errorStr) {
        [wSelf aliPayCallBackWithSuccessed:success errorString:errorStr];
    }];
}

// xuebao start
// 支付宝支付是否成功，服务器记录是否成功回调
// if success = YES 说明支付宝支付成功并且服务器记录成功，否则，支付不成功
- (void)aliPayCallBackWithSuccessed:(BOOL)success errorString:(NSString *)errorStr
{
    if (success) {
        // 确定派单推送订单成功(只是发送一个推送消息)
        [self PayStatusSure];
    }  else {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }
}

- (void)PayError
{
    [SVProgressHUD showErrorWithStatus:@"支付失败"];
}

- (void)PayStatusSure
{
    NSString *url = [NSString stringWithFormat:@"%@orderpayover",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:orderid forKey:@"orderid"];
    [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"fukuanrenid"];
    [mDict setObject:self.huoerbaoID forKey:@"shoukuanmemberid"];
    [mDict setObject:self.price forKey:@"shoukuanmembermoney"];
    [mDict setObject:@"0" forKey:@"dailiuserid"];
    [mDict setObject:@"0" forKey:@"dailiusermoney"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSString *status = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if ([status isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"恭喜你，支付成功"];
                [self backAfterPayed];
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"支付失败，请稍后再试"];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"支付失败，请稍后再试"];
        }
    }];
}


// xuebao start
-(void)backAfterPayed
{
    [self.navigationController popViewControllerAnimated:YES];
    if(self.paySuccessBlock)
    {
        self.paySuccessBlock (YES,nil);
    }
}

@end
