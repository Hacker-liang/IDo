//
//  AppDelegate.m
//  IDo
//
//  Created by liangpengshuai on 9/23/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "JSONKit.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate ()

@property (nonatomic, strong) HomeViewController *homeViewController;

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
            NSLog(@"result1111 = %@",resultDic);
            NSLog(@"result3333 = %@",[resultDic JSONString]);
            if ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000) {
//                if (self.viewisWhere == PiePayView) {
//                    [[NSNotificationCenter defaultCenter]postNotificationName:@"paySureNotification" object:nil];
//                }
            }else{
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"支付失败" message:@"支付成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
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
    
    _homeViewController = [[HomeViewController alloc] init];
    self.window.rootViewController = _homeViewController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
