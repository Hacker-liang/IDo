//
//  EvaluationViewController.m
//  IDo
//
//  Created by YangJiLei on 15/8/31.
//  Copyright (c) 2015年 IDo. All rights reserved.
//

#import "EvaluationViewController.h"

@interface EvaluationViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation EvaluationViewController
@synthesize evaluationType,orderid,ratingBar,textView;

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评价";
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=Top_ButtonRect;
    [btn setTintColor:COLOR(69, 69, 69)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Submit) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:btn]];
    
    NSString *url = [NSString stringWithFormat:@"%@getorderdetails",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:self.orderDetail.orderId forKey:@"orderid"];
    if (self.evaluationType == 1){
        [mDict setObject:@"1" forKey:@"type"];
    }else{
        [mDict setObject:@"2" forKey:@"type"];
    }
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if([tempStatus integerValue] == 1) {
                [self buildView];
            }
        }
    }];
}

- (void)buildView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, 120)];
    view.backgroundColor = COLOR(10, 148, 53);
    [_scrollView addSubview:view];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth/2-30, 20, 60, 60)];
    headImage.backgroundColor = [UIColor clearColor];
    headImage.layer.masksToBounds=YES;
    headImage.layer.cornerRadius=10;    //最重要的是这个地方要设成imgview高的一半
    if (self.evaluationType == 1) {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",headURL,_orderDetail.grabOrderUser.avatar]];
        [headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Icon"]];
    }else{
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",headURL,_orderDetail.sendOrderUser.avatar]];
        [headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Icon"]];
    }
    [view addSubview:headImage];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 80.0f, kWindowWidth, 25)];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.font = [UIFont boldSystemFontOfSize:15];
    nameLab.textColor = COLOR(255, 255, 255);
    nameLab.textAlignment = 1;
    if (self.evaluationType == 1) {
        nameLab.text = _orderDetail.grabOrderUser.nickName;
    }else{
        nameLab.text = _orderDetail.sendOrderUser.nickName;
    }
    [view addSubview:nameLab];
    
    UILabel * Star = [[UILabel alloc]initWithFrame:CGRectMake(0 ,145+64,kWindowWidth,20)];
    Star.text=@"星级评价";
    Star.font = [UIFont systemFontOfSize:15.0];
    Star.textAlignment = NSTextAlignmentCenter;
    Star.backgroundColor=[UIColor clearColor];
    [_scrollView addSubview:Star];
    
    self.ratingBar = [[RatingBar alloc] initWithFrame:CGRectMake(kWindowWidth/2-90, 170+64, 140, 30)];
    [_scrollView addSubview:self.ratingBar];
    
    UILabel * plLab = [[UILabel alloc]initWithFrame:CGRectMake(0 ,210+64,kWindowWidth,20)];
    plLab.text=@"发表评论";
    plLab.font = [UIFont systemFontOfSize:15.0];
    plLab.textAlignment = NSTextAlignmentCenter;
    plLab.backgroundColor=[UIColor clearColor];
    [_scrollView addSubview:plLab];
    
    self.textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(20, 245+64, self.view.frame.size.width-40, 100)];
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor whiteColor];
    [self.textView setPlaceholder:@"请输入评价"];
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.editable = YES;
    self.textView.textColor = COLOR(98, 98, 98);
    self.textView.font = [UIFont systemFontOfSize:16];
    [_scrollView addSubview:self.textView];
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, _scrollView.bounds.size.height+10);
}

- (void)Submit
{
    NSString *testStr = self.textView.text;
    testStr = [testStr stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (testStr.length < 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"系统提示" message:@"请输入评价内容" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSString *url = @"";
    if (self.evaluationType == 1) {
        url = [NSString stringWithFormat:@"%@comment",baseUrl];
    } else{
        url = [NSString stringWithFormat:@"%@commentFromPerson",baseUrl];
    }
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:self.orderDetail.orderId forKey:@"orderid"];
    [mDict setObject:[NSString stringWithFormat:@"%ld",self.ratingBar.starNumber] forKey:@"commentstar"];
    [mDict setObject:self.textView.text forKey:@"commentcontent"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if ([tempStatus integerValue] == 1) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"恭喜,已完成评价" message:@"感谢使用《我干》" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"您的评价提交失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"您的评价提交失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark UITextDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [_scrollView setContentOffset:CGPointZero animated:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
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
