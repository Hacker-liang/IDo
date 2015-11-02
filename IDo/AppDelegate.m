//
//  AppDelegate.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "REFrostedViewController.h"
#import "HomeMenuViewController.h"
#import "LoginViewController.h"
#import "APService.h"
#import "OrderDetailViewController.h"
#import "EvaluationViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@property (nonatomic, strong) HomeViewController *homeViewController;
@property (nonatomic, strong) HomeMenuViewController *leftController;
@property (nonatomic, copy) NSString *userId;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //如果极简SDK不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"paySuccessNotification" object:nil];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"payErrorNotification" object:nil];
            }
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
    }
    
    return YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveJPushMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushDidClose) name:kJPFNetworkDidCloseNotification object:nil];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:@"userDidLogout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoError) name:@"userInfoError" object:nil];

    [self setupHomeView];
    
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];
    [APService crashLogON];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [APService setBadge:0];
    
    _userId = [UserManager shareUserManager].userInfo.userid;
    
    return YES;
}

- (void)jpushDidClose
{
    NSLog(@"jpushDidClose");
}

- (void)get_version{
    [SVHTTPRequest POST:@"https://itunes.apple.com/lookup?id=983842433" parameters:nil completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [SVProgressHUD dismiss];
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            if (dict)
            {
                NSInteger resultCount = [[dict objectForKey:@"resultCount"] integerValue];
                if (resultCount == 1) {
                    NSArray *arr = [dict objectForKey:@"results"];
                    if (arr.count) {
                        NSDictionary *arrDict = arr[0];
                        if (arrDict) {
                            NSString *version = [arrDict objectForKey:@"version"];
                            
                            NSString *appUrl = [arrDict objectForKey:@"trackViewUrl"];
                            NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
                            NSString *versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
                            if ([versionNum compare:version] == -1) {
                                NSString *meaasge = [NSString stringWithFormat:@"发现新版本%@，是否更新?",version];
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:meaasge delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                                    if (buttonIndex == 1) {
                                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:appUrl]];
                                    }
                                }];
                            }
                        }
                    }
                }
            }
        }
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [APService setBadge:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewOrderNoti object:nil];
    if ([[UserManager shareUserManager] isLogin]) {
        [[UserLocationManager shareInstance] getUserLocationWithCompletionBlcok:^(CLLocation *userLocation, NSString *address) {
            
        }];
    }
    
}

- (void)receiveJPushMessage:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    [self receiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [APService registerDeviceToken:deviceToken];
    NSLog(@"deviceToken %@", deviceToken);
    [self resgisterToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceiveRemoteNotification %@", userInfo);
    [APService handleRemoteNotification:userInfo];
//    if (application.applicationState != UIApplicationStateActive) {
//        [self receiveRemoteNotification:userInfo];
//        
//    }else{
//        SystemSoundID myAlertSound;
//        
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"/System/Library/Audio/UISounds/sms-received1.caf"]];
//        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &myAlertSound);
//        AudioServicesPlaySystemSound(myAlertSound);
//        [self receiveRemoteNotification:userInfo];
//    }
//    
//    NSLog(@"RemoteNote userInfo:%@",userInfo);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"????????%@",error);
}


- (void)resgisterToken
{
    if (![[UserManager shareUserManager] isLogin]) {
        return;
    }
    NSString *registrationID = [APService registrationID];
    
    if (![registrationID length]) {
        return;
    }
    
    NSLog(@"registrationID = %@",registrationID);
    NSString *url = [NSString stringWithFormat:@"%@reSetDeviceNumber",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict safeSetObject: [UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    [mDict setObject:registrationID forKey:@"devicenumber"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response) {
            
        } else {
        }
    }];
}

- (void)userInfoError
{
    [self userLogout];
    if (_userId) {
        _userId = [UserManager shareUserManager].userInfo.userid;
    }
    if (_userId) {
        NSString *url = [NSString stringWithFormat:@"%@editMemberLoginStatus",baseUrl];
        
        NSMutableDictionary *mDict=  [[NSMutableDictionary alloc] init];
        [mDict safeSetObject:_userId forKey:@"memberid"];
        [mDict setObject:@"0" forKey:@"content"];
        
        [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (response) {
                NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [jsonString objectFromJSONString];
                
                NSInteger status = [[dict objectForKey:@"status"] integerValue];
                if (status == 1) {
                    _userId = nil;
                }
            }
        }];
    }
   
}

- (void)userLogout
{
    [self setupHomeView];
}

- (void)setupHomeView
{
    if ([[UserManager shareUserManager] isLogin]) {
        _homeViewController = [[HomeViewController alloc] init];
        _leftController = [[HomeMenuViewController alloc] init];
        _leftController.mainViewController = _homeViewController;
        REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:[[UINavigationController alloc] initWithRootViewController:_homeViewController] menuViewController:_leftController];
        frostedViewController.direction = REFrostedViewControllerDirectionLeft;
        frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
        frostedViewController.liveBlur = YES;
        frostedViewController.limitMenuViewSize = YES;
        self.window.rootViewController = frostedViewController;
        frostedViewController.menuViewSize = CGSizeMake(275, kWindowHeight);

    } else {
        LoginViewController *ctl = [[LoginViewController alloc] initWithPaySuccessBlock:^(BOOL success, NSString *errorStr) {
            if (success) {
                _homeViewController = [[HomeViewController alloc] init];
                _leftController = [[HomeMenuViewController alloc] init];
                _leftController.mainViewController = _homeViewController;
                REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:[[UINavigationController alloc] initWithRootViewController:_homeViewController] menuViewController:_leftController];
                frostedViewController.direction = REFrostedViewControllerDirectionLeft;
                frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
                frostedViewController.liveBlur = YES;
                frostedViewController.limitMenuViewSize = YES;
                frostedViewController.menuViewSize = CGSizeMake(275, kWindowHeight);
                self.window.rootViewController = frostedViewController;
            }
        }];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:ctl];
        
    }
   
    [self.window makeKeyAndVisible];
}

#pragma mark - app后台 在推送进入
- (void)receiveRemoteNotification:(NSDictionary*)userInfo
{
    NSLog(@"userInfo = %@",userInfo);
    NSString *notificationType = [userInfo[@"extras"] objectForKey:@"type"];
    NSString *orderId = userInfo[@"extras"][@"orderid"];
    
    if ((![UserManager shareUserManager].userInfo.isMute && ![UserManager shareUserManager].userInfo.isSendingOrder) || ![notificationType isEqualToString:@"gettzpersonnum"]) {
        SystemSoundID myAlertSound;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"/System/Library/Audio/UISounds/sms-received1.caf"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &myAlertSound);
        AudioServicesPlaySystemSound(myAlertSound);
        
        //发送本地推送
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = [userInfo objectForKey:@"content"];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertAction = @"打开";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:orderId forKey:OrderidMark];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![notificationType isEqualToString:@"gettzpersonnum"] && ![notificationType isEqualToString:@"comment"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:orderId];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:OrderStatusChange];
    }
    
    if ([notificationType isEqualToString:@"commentFromPerson"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNewRating object:nil];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"订单提醒" message:@"抢单人已经对您进行评价" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"查看订单", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if(buttonIndex == 1){
                UIViewController *ctl = _homeViewController.navigationController.viewControllers.lastObject;
                if ([ctl isKindOfClass:[OrderDetailViewController class]]) {
                    NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"orderid"]];
                    if ([((OrderDetailViewController *)ctl).orderId isEqualToString:orderId]) {
                        [((OrderDetailViewController *)ctl) updateDetailViewWithStatus:kOrderCompletion andShouldReloadOrderDetail:YES];
                        return;
                    } else {
                        OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
                        ctl.orderId = orderId;
                        ctl.isSendOrder = YES;
                        [self.homeViewController.navigationController pushViewController:ctl animated:YES];
                    }
                } else {
                    OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
                    ctl.orderId = orderId;
                    ctl.isSendOrder = YES;
                    [self.homeViewController.navigationController pushViewController:ctl animated:YES];
                }
                
            } else if(buttonIndex == 0){
                UIViewController *ctl = _homeViewController.navigationController.viewControllers.lastObject;
                if ([ctl isKindOfClass:[OrderDetailViewController class]]) {
                    NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"orderid"]];
                    if ([((OrderDetailViewController *)ctl).orderId isEqualToString:orderId]) {
                        [((OrderDetailViewController *)ctl) updateDetailViewWithStatus:kOrderCompletion andShouldReloadOrderDetail:YES];
                        return;
                    }
                }
            }
        }];
    }
    if ([notificationType isEqualToString:@"gettzpersonnum"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNewOrderNoti object:nil];
        
    } else if([notificationType isEqualToString:@"scrambleorder"]) { //发单被抢通知
        [[NSNotificationCenter defaultCenter] postNotificationName:OrderGrabStatusChange object:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:OrderPieStatusChange];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"恭喜，您已被抢单！" message:@"请在20分钟内尽快完成付款，超时订单将自动取消。" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"查看订单", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if(buttonIndex == 1){
                UIViewController *ctl = _homeViewController.navigationController.viewControllers.lastObject;
                if ([ctl isKindOfClass:[OrderDetailViewController class]]) {
                    NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"orderid"]];
                    if ([((OrderDetailViewController *)ctl).orderId isEqualToString:orderId]) {
                        [((OrderDetailViewController *)ctl) updateDetailViewWithStatus:kOrderGrabSuccess andShouldReloadOrderDetail:YES];
                        return;
                    } else {
                        OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
                        ctl.orderId = orderId;
                        ctl.isSendOrder = YES;
                        [self.homeViewController.navigationController pushViewController:ctl animated:YES];
                    }
                } else {
                    OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
                    ctl.orderId = orderId;
                    ctl.isSendOrder = YES;
                    [self.homeViewController.navigationController pushViewController:ctl animated:YES];
                }
               
            } else if(buttonIndex == 0){
                UIViewController *ctl = _homeViewController.navigationController.viewControllers.lastObject;
                if ([ctl isKindOfClass:[OrderDetailViewController class]]) {
                    NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"orderid"]];
                    if ([((OrderDetailViewController *)ctl).orderId isEqualToString:orderId]) {
                        [((OrderDetailViewController *)ctl) updateDetailViewWithStatus:kOrderGrabSuccess andShouldReloadOrderDetail:YES];
                        return;
                    }
                }
            }
        }];
        
    } else if([notificationType isEqualToString:@"orderpayover" ]) { //发单方已经付款完成，确定开始干活
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"恭喜，对方已付款" message:@"对方已付款，请按照对方要求尽快完成订单任务。" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"查看订单", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if(buttonIndex == 1){
                UIViewController *ctl = _homeViewController.navigationController.viewControllers.lastObject;
                if ([ctl isKindOfClass:[OrderDetailViewController class]]) {
                    NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"orderid"]];
                    if ([((OrderDetailViewController *)ctl).orderId isEqualToString:orderId]) {
                        [((OrderDetailViewController *)ctl) updateDetailViewWithStatus:kOrderPayed andShouldReloadOrderDetail:YES];
                        return;
                    } else {
                        OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
                        ctl.orderId = orderId;
                        ctl.isSendOrder = NO;
                        [self.homeViewController.navigationController pushViewController:ctl animated:YES];
                    }
                } else {
                    OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
                    ctl.orderId = orderId;
                    ctl.isSendOrder = NO;
                    [self.homeViewController.navigationController pushViewController:ctl animated:YES];
                }
                
            } else if(buttonIndex == 0){
                UIViewController *ctl = _homeViewController.navigationController.viewControllers.lastObject;
                if ([ctl isKindOfClass:[OrderDetailViewController class]]) {
                    NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"orderid"]];
                    if ([((OrderDetailViewController *)ctl).orderId isEqualToString:orderId]) {
                        [((OrderDetailViewController *)ctl) updateDetailViewWithStatus:kOrderGrabSuccess andShouldReloadOrderDetail:YES];
                        return;
                    }
                }
            } else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderDetNotification" object:@"1"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:OrderGrabStatusChange];
            }
        }];
        
    } else if([notificationType isEqualToString:@"dept" ]) { //接单方 催款
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"确认任务验收" message:[userInfo objectForKey:@"content"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"查看订单", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if(buttonIndex == 1){
                UIViewController *ctl = _homeViewController.navigationController.viewControllers.lastObject;
                if ([ctl isKindOfClass:[OrderDetailViewController class]]) {
                    NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"orderid"]];
                    if ([((OrderDetailViewController *)ctl).orderId isEqualToString:orderId]) {
                        [((OrderDetailViewController *)ctl) updateDetailViewWithStatus:kOrderPayed andShouldReloadOrderDetail:YES];
                        return;
                    } else {
                        OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
                        ctl.orderId = orderId;
                        ctl.isSendOrder = YES;
                        [self.homeViewController.navigationController pushViewController:ctl animated:YES];
                    }
                } else {
                    OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
                    ctl.orderId = orderId;
                    ctl.isSendOrder = YES;
                    [self.homeViewController.navigationController pushViewController:ctl animated:YES];
                }
                
            } else if(buttonIndex == 0){
                UIViewController *ctl = _homeViewController.navigationController.viewControllers.lastObject;
                if ([ctl isKindOfClass:[OrderDetailViewController class]]) {
                    NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"orderid"]];
                    if ([((OrderDetailViewController *)ctl).orderId isEqualToString:orderId]) {
                        [((OrderDetailViewController *)ctl) updateDetailViewWithStatus:kOrderPayed andShouldReloadOrderDetail:YES];
                        return;
                    }
                }
            }
        }];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderDetNotification" object:@"4"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:OrderPieStatusChange];
        
    } else if([notificationType isEqualToString:@"confpay" ]) { //发单方已确认付款
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"恭喜" message:@"对方已成功验收任务！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"去评价", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                //进入去评价
                NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"orderid"]];
                EvaluationViewController *control = [[EvaluationViewController alloc] init];
                control.evaluationType = 2;
                control.orderid = orderId;
                [self.homeViewController.navigationController pushViewController:control animated:YES];
                
            } else{
                
            }
        }];
    } else if([notificationType isEqualToString:@"askCancelOrder" ]) { //发单方 请求取消订单
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请求取消订单" message:@"您有一笔订单，发单人请求取消，请确认，如同意，资金将返回对方账户。" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"查看订单", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if(buttonIndex == 1){
                UIViewController *ctl = _homeViewController.navigationController.viewControllers.lastObject;
                if ([ctl isKindOfClass:[OrderDetailViewController class]]) {
                    NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"orderid"]];
                    if ([((OrderDetailViewController *)ctl).orderId isEqualToString:orderId]) {
                        [((OrderDetailViewController *)ctl) updateDetailViewWithStatus:kOrderPayed andShouldReloadOrderDetail:YES];
                        return;
                    } else {
                        OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
                        ctl.orderId = orderId;
                        ctl.isSendOrder = NO;
                        [self.homeViewController.navigationController pushViewController:ctl animated:YES];
                    }
                } else {
                    OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
                    ctl.orderId = orderId;
                    ctl.isSendOrder = NO;
                    [self.homeViewController.navigationController pushViewController:ctl animated:YES];
                }
                
            } else if(buttonIndex == 0){
                UIViewController *ctl = _homeViewController.navigationController.viewControllers.lastObject;
                if ([ctl isKindOfClass:[OrderDetailViewController class]]) {
                    NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"orderid"]];
                    if ([((OrderDetailViewController *)ctl).orderId isEqualToString:orderId]) {
                        [((OrderDetailViewController *)ctl) updateDetailViewWithStatus:kOrderPayed andShouldReloadOrderDetail:YES];
                        return;
                    }
                }
            }
        }];
        

        
    } else if([notificationType isEqualToString:@"tomemberAskCancelOrder" ]) { //接单方请求取消
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"不同意" otherButtonTitles:@"同意", nil];
//        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                [self.homeController agreeCancelOrderPie:orderId];
//            }
//        }];
    }else if([notificationType isEqualToString:@"FrommemberAllowCancelOrder" ]) { //发单方同意取消
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderDetNotification" object:orderId];
//        }];
    }else if([notificationType isEqualToString:@"allowCancelOrder" ]) { //接单方同意取消
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderDetNotification" object:orderId];
        }];
    }else if([notificationType isEqualToString:@"gettzpersonnum" ]) { //收到新订单 通知
//        self.homeController.isHaveGrabOrder.hidden = NO;
        
    }else if([notificationType isEqualToString:@"delorder" ]) { //发单方未付款时，单方直接取消订单
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"对不起，订单被取消" message:@"您有一笔订单被发单人取消" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"查看订单", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if(buttonIndex == 1){
                UIViewController *ctl = _homeViewController.navigationController.viewControllers.lastObject;
                if ([ctl isKindOfClass:[OrderDetailViewController class]]) {
                    NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"orderid"]];
                    if ([((OrderDetailViewController *)ctl).orderId isEqualToString:orderId]) {
                        [((OrderDetailViewController *)ctl) updateDetailViewWithStatus:kOrderCancelPayTimeOut andShouldReloadOrderDetail:YES];
                        return;
                    } else {
                        OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
                        ctl.orderId = orderId;
                        ctl.isSendOrder = NO;
                        [self.homeViewController.navigationController pushViewController:ctl animated:YES];
                    }
                } else {
                    OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
                    ctl.orderId = orderId;
                    ctl.isSendOrder = NO;
                    [self.homeViewController.navigationController pushViewController:ctl animated:YES];
                }
                
            } else if(buttonIndex == 0){
                UIViewController *ctl = _homeViewController.navigationController.viewControllers.lastObject;
                if ([ctl isKindOfClass:[OrderDetailViewController class]]) {
                    NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"orderid"]];
                    if ([((OrderDetailViewController *)ctl).orderId isEqualToString:orderId]) {
                        [((OrderDetailViewController *)ctl) updateDetailViewWithStatus:kOrderPayed andShouldReloadOrderDetail:YES];
                        return;
                    }
                }
            }
        }];
    }
}


@end
