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

@interface AppDelegate ()

@property (nonatomic, strong) HomeViewController *homeViewController;
@property (nonatomic, strong) HomeMenuViewController *leftController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveJPushMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:@"userLogout" object:nil];
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
    
    return YES;
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

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    if (application.applicationState != UIApplicationStateActive) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self receiveRemoteNotification:userInfo];
        
    }else{
        SystemSoundID myAlertSound;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"/System/Library/Audio/UISounds/sms-received1.caf"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &myAlertSound);
        AudioServicesPlaySystemSound(myAlertSound);
        [self receiveRemoteNotification:userInfo];
    }
    
    [APService handleRemoteNotification:userInfo];
    NSLog(@"RemoteNote userInfo:%@",userInfo);
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
    [mDict setObject: [UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    [mDict setObject:registrationID forKey:@"devicenumber"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response) {
        } else {
        }
    }];
}


- (void)userDidLogout
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
    NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"orderid"]];
    [[NSUserDefaults standardUserDefaults] setObject:orderId forKey:OrderidMark];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![notificationType isEqualToString:@"gettzpersonnum"] && ![notificationType isEqualToString:@"comment"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:orderId];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:OrderStatusChange];
    }
    
    if ([notificationType isEqualToString:@"gettzpersonnum"])
    {
//        if (self.viewisWhere !=GrabOrderView) {
//            if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
//                GrabOrderViewController *vc = [[GrabOrderViewController alloc] init];
//                [self.navController pushViewController:vc animated:YES];
//            }else{
//                
//            }
//            
//        }
    } else if([notificationType isEqualToString:@"scrambleorder"]) { //发单被抢通知
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
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"恭喜" message:@"对方已成功验收任务！" delegate:self cancelButtonTitle:@"稍后评价" otherButtonTitles:@"去评价", nil];
//        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                //进入去评价
//                EvaluationViewController *control = [[EvaluationViewController alloc] init];
//                control.evaluationType = 2;
//                control.orderid = orderId;
//                [self.navController pushViewController:control animated:YES];
//                
//            }else{
//                if (self.viewisWhere != HomeView) {
//                    [self.navController popToRootViewControllerAnimated:YES];
//                }
//            }
//        }];
    } else if([notificationType isEqualToString:@"askCancelOrder" ]) { //发单方 请求取消订单
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请求取消订单" message:@"您有一笔订单，发单人请求取消，请确认，如同意，资金将返回对方账户。" delegate:self cancelButtonTitle:@"不同意" otherButtonTitles:@"同意", nil];
//        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                [self.homeController agreeCancelOrderGrab:orderId];
//                if (self.viewisWhere == OrderDetailedView) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderDetNotification" object:@"4"];
//                }
//            }
//        }];
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
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"对不起，订单被取消" message:@"您有一笔订单被发单人取消" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"查看订单", nil];
//        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                if (self.viewisWhere == OrderDetailedView){
//                    if ([self.testOrder isEqualToString:orderId]) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderDetNotification" object:@"7"];
//                    }else{
//                        OrderDetailedViewController *control = [[OrderDetailedViewController alloc] init];
//                        control.orderId = orderId;
//                        control.fromType = HistoryGrab;
//                        [self.navController pushViewController:control animated:YES];
//                    }
//                }else{
//                    OrderDetailedViewController *control = [[OrderDetailedViewController alloc] init];
//                    control.orderId = orderId;
//                    control.fromType = HistoryGrab;
//                    [self.navController pushViewController:control animated:YES];
//                }
//            }else{
//                if (self.viewisWhere == OrderDetailedView){
//                    if ([self.testOrder isEqualToString:orderId]) {
//                        [self.navController popViewControllerAnimated:YES];
//                    }
//                }
//            }
//        }];
    }
}

#pragma mark - app完全对出 在推送进入
- (void)receiveRemoteNotificationStart:(NSDictionary*)userInfo
{
    NSString *notificationType = userInfo[@"type"];
    NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"orderid"]];
    NSLog(@"receiveRemoteNotificationStart 收到推送消息%@", notificationType);
    
//    if([notificationType isEqualToString:@"scrambleorder"]) { //发单被抢通知
//        OrderDetailedViewController *control = [[OrderDetailedViewController alloc] init];
//        control.orderId = orderId;
//        control.fromType = OrderIngPie;
//        [self.navController pushViewController:control animated:YES];
//    }else if([notificationType isEqualToString:@"orderpayover" ]) { //发单方已经付款完成，确定开始干活
//        OrderDetailedViewController *control = [[OrderDetailedViewController alloc] init];
//        control.orderId = orderId;
//        control.fromType = OrderIngGrab;
//        [self.navController pushViewController:control animated:YES];
//    }else if([notificationType isEqualToString:@"dept" ]) { //接单方 催款
//        OrderDetailedViewController *control = [[OrderDetailedViewController alloc] init];
//        control.orderId = orderId;
//        control.fromType = OrderIngPie;
//        [self.navController pushViewController:control animated:YES];
//    }else if([notificationType isEqualToString:@"confpay" ]) { //发单方已确认付款
//        EvaluationViewController *control = [[EvaluationViewController alloc] init];
//        control.evaluationType = 2;
//        control.orderid = orderId;
//        [self.navController pushViewController:control animated:YES];
//    }else if([notificationType isEqualToString:@"askCancelOrder" ]) { //发单方 请求取消订单 //已付款
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"不同意" otherButtonTitles:@"同意", nil];
//        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                [self.homeController agreeCancelOrderGrab:orderId];
//            }
//        }];
//    }else if([notificationType isEqualToString:@"tomemberAskCancelOrder" ]) { //接单方请求取消
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"不同意" otherButtonTitles:@"同意", nil];
//        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                [self.homeController agreeCancelOrderPie:orderId];
//            }
//        }];
//    }else if([notificationType isEqualToString:@"FrommemberAllowCancelOrder" ]) { //发单方同意取消
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//        }];
//    }else if([notificationType isEqualToString:@"allowCancelOrder" ]) { //接单方同意取消
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//        }];
//    }else if([notificationType isEqualToString:@"gettzpersonnum" ]) { //收到新订单 通知
//        GrabOrderViewController *control = [[GrabOrderViewController alloc] init];
//        [self.navController pushViewController:control animated:YES];
//    }
}

@end
