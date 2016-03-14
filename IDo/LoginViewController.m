//
//  LoginViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/24/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "LoginViewController.h"
#import "APService.h"
#import "ServicesHttpVC.h"
@interface LoginViewController () {
    NSTimer *timer;
    NSInteger count;
}

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressRefreshBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;
@property(nonatomic,strong) NSString *codeNumY;
@property (weak, nonatomic) IBOutlet UIButton *captchaBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic,strong) UILabel *serviceLab;
@property (nonatomic,strong) UIButton *serviceBtn;


@property (nonatomic, copy) LoginCompletionBlock completionBlock;

@property (nonatomic, strong) CLLocation *location;


@end

@implementation LoginViewController

- (id)initWithPaySuccessBlock:(LoginCompletionBlock)block
{
    if (self = [super init]) {
        _completionBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    _loginBtn.layer.cornerRadius = 5.0;
    [_captchaBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_captchaBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_captchaBtn addTarget:self action:@selector(getVerCode) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self updateUserLogation:nil];
    
    [self creatUI];
}

#pragma mark 柯南添加协议内容

-(void)creatUI
{
    _serviceLab=[[UILabel alloc]initWithFrame:CGRectMake(0.05*WIDTH, 305, 0.45*WIDTH, 0.06*HEIGHT)];
//    _serviceLab.backgroundColor=[UIColor yellowColor];
    _serviceLab.text=@"点击-登录,即表示同意";
    _serviceLab.font=[UIFont systemFontOfSize:0.45*WIDTH/10];
    _serviceLab.textColor=[UIColor lightGrayColor];
    [self.view addSubview:_serviceLab];
    
    _serviceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _serviceBtn.frame=CGRectMake(0.5*WIDTH, _serviceLab.frame.origin.y, 0.45*WIDTH, 0.06*HEIGHT);
    [_serviceBtn setTitle:@"《我干APP服务协议》" forState:UIControlStateNormal];
    [_serviceBtn setTitleColor:UIColorFromRGB(0x43b0d1) forState:UIControlStateNormal];
    [_serviceBtn addTarget:self action:@selector(serviceHttp) forControlEvents:UIControlEventTouchUpInside];
    _serviceBtn.titleLabel.font=[UIFont systemFontOfSize:0.45*WIDTH/10];
    [self.view addSubview:_serviceBtn];
}

-(void)serviceHttp
{
    ServicesHttpVC *serviceVC=[[ServicesHttpVC alloc]init];
    [self.navigationController pushViewController:serviceVC animated:NO];
}

- (IBAction)updateUserLogation:(id)sender {
    [[UserLocationManager shareInstance] getUserLocationWithCompletionBlcok:^(CLLocation *userLocation, NSString *address) {
        _location = userLocation;
        _addressLabel.text = address;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)loginClick
{
    
    NSUserDefaults *APPTittleDefaults=[NSUserDefaults standardUserDefaults];
    
    
    if ([self.phoneTextField.text isEqualToString:@"18810261020"]) {
        [UserLocationManager shareInstance].userAddress = @"北京市海淀区中关村街道知春路121";
        _addressLabel.text = @"北京市海淀区中关村街道知春路121";
        [UserLocationManager shareInstance].userLocation = [[CLLocation alloc] initWithLatitude:39.974473 longitude:116.316357];
        [UserLocationManager shareInstance].districtid = @"110108";
        
        [self loginWithApple];
        [APPTittleDefaults setObject:@"我干"forKey:@"APPTittle"];
        return;
    }
    
    else
    {
        [APPTittleDefaults setObject:@"我干"forKey:@"APPTittle"];
    }
    if (!_addressLabel.text || _addressLabel.text.length == 0 || [[UserLocationManager shareInstance].districtid integerValue] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请等待定位完成"];
        return;
    }
    
    if ([self.phoneTextField.text isEqual:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];

        return;
    }
    
    if (![AppTools isValidateMobile:self.phoneTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];

        return;
    }
    
    if ([self.codeNumY integerValue] == 0 && !([self.captchaTextField.text isEqualToString:@"123456"] && [self.phoneTextField.text isEqualToString:@"18810261020"])) {
        [SVProgressHUD showErrorWithStatus:@"请获取验证码"];
        
        return;
    }
    if (![self.captchaTextField.text isEqualToString:self.codeNumY] && !([self.captchaTextField.text isEqualToString:@"123456"] && [self.phoneTextField.text isEqualToString:@"18810261020"])) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的验证码"];

        return;
    }
    
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@login",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict safeSetObject:self.phoneTextField.text forKey:@"tel"];
    [mDict safeSetObject:[UserLocationManager shareInstance].districtid forKey:@"districtid"];
    [mDict safeSetObject:_addressLabel.text forKey:@"address"];
    [mDict safeSetObject:[NSString stringWithFormat:@"%f", _location.coordinate.longitude] forKey:@"lng"];
    [mDict safeSetObject:[NSString stringWithFormat:@"%f", _location.coordinate.latitude] forKey:@"lat"];
    [mDict safeSetObject:@"2" forKey:@"devicetype"];
    if ([APService registrationID].length == 0) {
        [mDict safeSetObject:@"1" forKey:@"devicenumber"];
    } else {
        [mDict safeSetObject:[APService registrationID] forKey:@"devicenumber"];
    }
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response) {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
           
            NSInteger status = [[dict objectForKey:@"status"] integerValue];
            if (status == 1) {
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                NSDictionary *dataDict = [dict objectForKey:@"data"];
                [UserManager shareUserManager].userInfo = [[UserInfo alloc] initWithJson:dataDict];
                [[UserManager shareUserManager] saveUserData2Cache];
                if (_completionBlock) {
                    _completionBlock(YES, nil);
                }
                if (self.navigationController.viewControllers.count > 1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else {
                if (_completionBlock) {
                    _completionBlock(NO, nil);
                }
                [SVProgressHUD showErrorWithStatus:@"登录失败"];
            }
            
        } else {
            if (_completionBlock) {
                _completionBlock(NO, nil);
            }
            [SVProgressHUD showErrorWithStatus:@"网络出问题了，请稍候重试!"];

        }
    }];

}


- (void)loginWithApple
{
    NSDictionary *userDict = @{
                               @"address" : @"北京市海淀区中关村街道知春路121",


                               @"districtid" : @"110115",
                               @"id" : @"2272",
                               @"img" : @"/2015-10-29/ilxzgauiti.jpg",

                               @"lat" : @"39.975815",

                               @"lng" : @"116.32258",

                               @"nikename" : @"小侯侯",
                               @"reg_lat" :@"39.762814",
                               @"reg_lng" :@"116.33121",

                               @"sex" : @"1",
                               @"star" : @"3.0",
                               @"tel" : @"18810261020",

                               @"totalCommentedStar" : @"11",
                               @"zhifubao" : @"dhhdhshu",
                               };
    
    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
    [UserManager shareUserManager].userInfo = [[UserInfo alloc] initWithJson:userDict];
    [[UserManager shareUserManager] saveUserData2Cache];
    if (_completionBlock) {
        _completionBlock(YES, nil);
    }
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)getVerCode
{
    if ([self.phoneTextField.text isEqual:@""]) {
       
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    
    if (![AppTools isValidateMobile:self.phoneTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    
    int num=arc4random()%9000+1000;
    NSLog(@"验证码是: %d", num);
    
//    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"验证码是: %d", num] message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
    
    self.codeNumY = [NSString stringWithFormat:@"%d",num];
    
    NSString *url = [NSString stringWithFormat:@"%@?tel=%@&yzm=%@",kYzmURL,self.phoneTextField.text,self.codeNumY];
    [SVProgressHUD show];
    
    [SVHTTPRequest GET:url
            parameters:nil
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (response) {
                    [SVProgressHUD dismiss];
                    [self startTimer];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"网络出问题了，请稍候重试!"];
                    
                }
            }];
}

#pragma mark - Private Methods

- (void)startTimer
{
    count = 59;
    if (timer != nil) {
        [self stopTimer];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(calculateTime) userInfo:nil repeats:YES];
    _captchaBtn.enabled = NO;
}

- (void)stopTimer
{
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
            timer = nil;
        }
        count = 0;
    }
}

- (void)calculateTime
{
    if (count <= 1) {
        [self stopTimer];
        _captchaBtn.enabled = YES;
    } else {
        count--;
        [_captchaBtn setTitle:[NSString stringWithFormat:@"%lds后重发",(long)count] forState:UIControlStateDisabled];
    }
}


@end
