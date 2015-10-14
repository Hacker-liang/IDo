//
//  LoginViewController.m
//  IDo
//
//  Created by liangpengshuai on 9/24/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "LoginViewController.h"
#import "APService.h"

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
    if (!_addressLabel.text) {
        [SVProgressHUD showErrorWithStatus:@"请等待定位完成"];
    }
    if ([self.phoneTextField.text isEqual:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];

        return;
    }
    
    if (![AppTools isValidateMobile:self.phoneTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];

        return;
    }
    
    if ([self.codeNumY integerValue] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请获取验证码"];

        return;
    }
    if (![self.captchaTextField.text isEqualToString:self.codeNumY]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的验证码"];

        return;
    }
    
    [SVProgressHUD show];
    NSString *address = @"1";
    NSString *url = [NSString stringWithFormat:@"%@login",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict safeSetObject:self.phoneTextField.text forKey:@"tel"];
    [mDict safeSetObject:[UserLocationManager shareInstance].districtid forKey:@"districtid"];
    [mDict safeSetObject:address forKey:@"address"];
    [mDict safeSetObject:[NSString stringWithFormat:@"%f", _location.coordinate.longitude] forKey:@"lng"];
    [mDict safeSetObject:[NSString stringWithFormat:@"%f", _location.coordinate.latitude] forKey:@"lat"];
    [mDict safeSetObject:@"2" forKey:@"devicetype"];
    [mDict safeSetObject:[APService registrationID] forKey:@"devicenumber"];
    
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
    count = 60;
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
