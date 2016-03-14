//
//  EvaluationViewController.m
//  IDo
//
//  Created by YangJiLei on 15/8/31.
//  Copyright (c) 2015年 IDo. All rights reserved.
//

#import "EvaluationViewController.h"
#import "ShareOrderViewController.h"

@interface EvaluationViewController ()
{
    NSString *APPTITTLE;
}
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UserInfo *userInfo;

@end

@implementation EvaluationViewController
@synthesize evaluationType,orderid,ratingBar,textView;

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSUserDefaults *APPTittleDefaults=[NSUserDefaults standardUserDefaults];
    
    APPTITTLE =[APPTittleDefaults objectForKey:@"APPTittle"];
    
    if (self.evaluationType == 1) {
        _userInfo = _orderDetail.grabOrderUser;

    }else{
        _userInfo = _orderDetail.sendOrderUser;
    }

    // Do any additional setup after loading the view.
    self.title = @"评价";
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    NSString *url = [NSString stringWithFormat:@"%@getorderdetails",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    if (_orderDetail.orderId) {
        [mDict safeSetObject:self.orderDetail.orderId forKey:@"orderid"];
    } else {
        [mDict safeSetObject:self.orderid forKey:@"orderid"];
    }
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
            if ([[dict objectForKey:@"status"] integerValue] == 30001 || [[dict objectForKey:@"status"] integerValue] == 30002) {
                if ([UserManager shareUserManager].isLogin) {
                                        [UserManager shareUserManager].userInfo = nil;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"info"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoError" object:nil];
                    }];
                }
                return;
            }
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if([tempStatus integerValue] == 1) {
                if (self.evaluationType == 1) {
                    _userInfo = [[UserInfo alloc] initWithJson:dict[@"data"][@"jiedanren"]];
                } else {
                    _userInfo = [[UserInfo alloc] initWithJson:dict[@"data"][@"member"]];
                }
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
    view.backgroundColor = APP_THEME_COLOR;
    [_scrollView addSubview:view];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth/2-30, 20, 60, 60)];
    headImage.backgroundColor = [UIColor clearColor];
    headImage.layer.masksToBounds=YES;
    headImage.layer.cornerRadius=30;    //最重要的是这个地方要设成imgview高的一半
    if (self.evaluationType == 1) {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",_userInfo.avatar]];
        [headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Icon"]];
    }else{
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",_userInfo.avatar]];
        [headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Icon"]];
    }
    [view addSubview:headImage];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 85.0f, kWindowWidth, 25)];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.font = [UIFont boldSystemFontOfSize:15];
    nameLab.textColor = COLOR(255, 255, 255);
    nameLab.textAlignment = 1;
    
    nameLab.text = _userInfo.nickName;
    [view addSubview:nameLab];
    
    UILabel * Star = [[UILabel alloc]initWithFrame:CGRectMake(0 ,145+64,kWindowWidth,20)];
    Star.text=@"星级评价";
    Star.font = [UIFont systemFontOfSize:15.0];
    Star.textAlignment = NSTextAlignmentCenter;
    Star.backgroundColor=[UIColor clearColor];
    [_scrollView addSubview:Star];
    
    self.ratingBar = [[RatingBar alloc] initWithFrame:CGRectMake(kWindowWidth/2-80, 170+64, 140, 30)];
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
    self.textView.textColor = [UIColor blackColor];
    self.textView.font = [UIFont systemFontOfSize:16];
    [_scrollView addSubview:self.textView];
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, _scrollView.bounds.size.height+10);
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.textView.frame.origin.y + 120, _scrollView.bounds.size.width-20, 40)];
    submitBtn.backgroundColor = APP_THEME_COLOR;
    submitBtn.layer.cornerRadius = 5.0;
    [submitBtn setTitle:@"提交评价" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [submitBtn addTarget:self action:@selector(Submit) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:submitBtn];

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
    if (_orderDetail.orderId) {
        [mDict safeSetObject:self.orderDetail.orderId forKey:@"orderid"];
    } else {
        [mDict safeSetObject:self.orderid forKey:@"orderid"];
    }

    [mDict setObject:[NSString stringWithFormat:@"%ld",self.ratingBar.starNumber] forKey:@"commentstar"];
    [mDict safeSetObject:self.textView.text forKey:@"commentcontent"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            if ([[dict objectForKey:@"status"] integerValue] == 30001 || [[dict objectForKey:@"status"] integerValue] == 30002) {
                if ([UserManager shareUserManager].isLogin) {
                                        [UserManager shareUserManager].userInfo = nil;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"info"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoError" object:nil];
                    }];
                }
                return;
            }
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            
            NSString *message1=[NSString stringWithFormat:@"感谢使用《%@》",APPTITTLE];
            
            if ([tempStatus integerValue] == 1) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"恭喜,已完成评价" message:message1 delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"我要去晒单", nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        ShareOrderViewController *ctl = [[ShareOrderViewController alloc] init];
                        ctl.isSender = (evaluationType == 1);
                        ctl.orderId = _orderDetail.orderId;
                        if (evaluationType == 1) {
                            ctl.userId = _orderDetail.sendOrderUser.userid;
                        } else {
                            ctl.userId = _orderDetail.grabOrderUser.userid;
                        }
                        [self.navigationController pushViewController:ctl animated:YES];
                    }
                }];
            } else {
                NSString *info = [dict objectForKey:@"info"];
                if (info) {
                    [SVProgressHUD showErrorWithStatus:info];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"发表评论失败"];
                }
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
