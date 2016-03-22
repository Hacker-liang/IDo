//
//  OrderManager.m
//  IDo
//
//  Created by liangpengshuai on 12/5/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "OrderManager.h"
#import "MissOrderModel.h"

@implementation OrderManager

+(void)asyncLoadNearByAllListWithPage:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^)(BOOL, NSArray *, NSDictionary *))completion
{
//    NSLog(@"刷新1次");
    
    NSDictionary *redResultDic=[[NSDictionary alloc]init];
        NSString *url1 = [NSString stringWithFormat:@"%@nearRedList",baseUrl];
        NSMutableDictionary*mDict1 = [NSMutableDictionary dictionary];
        [mDict1 safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
        [mDict1 setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lng] forKey:@"lng"];
        [mDict1 setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lat] forKey:@"lat"];
    
//        [mDict1 setObject:@"39.7634" forKey:@"lat"];
//        [mDict1 setObject:@"116.331" forKey:@"lng"];
    
        [SVHTTPRequest POST:url1 parameters:mDict1 completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
//            NSLog(@"还有多少个红包没有抢");
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"还有多少个红包没有抢,%@",resultDic);
            NSArray *RedMoneyList=resultDic[@"data"];
            NSUserDefaults *redDefaults=[NSUserDefaults standardUserDefaults];
            NSString *redCount=[NSString stringWithFormat:@"%lu",(unsigned long)RedMoneyList.count];
            [redDefaults setObject:redCount forKey:@"REDCOUNT"];
    
        }];
    
    
    NSString *url = [NSString stringWithFormat:@"%@getorderlist",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [mDict setObject:[NSNumber numberWithInteger:size] forKey:@"pageSize"];
    [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    [mDict setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lng] forKey:@"lng"];
    [mDict setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lat] forKey:@"lat"];
    
    //    [mDict setObject:@"39.7634" forKey:@"lat"];
    //    [mDict setObject:@"116.331" forKey:@"lng"];
    //
    
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response) {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            //            NSLog(@"柯南附近订单%@",dict);
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
            
            NSArray *tempList = dict[@"data"];
            NSLog(@"%lu",(unsigned long)tempList.count);
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if((NSNull *)tempStatus != [NSNull null] && ![tempStatus isEqualToString:@"0"]) {
                NSMutableArray *retArray = [[NSMutableArray alloc] init];
                
                
                for (NSDictionary *dic in tempList) {
                    
                    OrderListModel *order = [[OrderListModel alloc] initWithJson:dic andIsSendOrder:NO];
                    [retArray addObject:order];
                }
                
                
                
                completion(YES, retArray,redResultDic);
                
            } else {
                completion(NO, nil,redResultDic);
            }
            
        } else {
            completion(NO, nil,redResultDic);
            
        }
    }];
    
}

+ (void)asyncLoadNearByOrderListWithPage:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^)(BOOL, NSArray *))completion
{
//    NSLog(@"刷新2次");
    
    NSString *url = [NSString stringWithFormat:@"%@getorderlist",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [mDict setObject:[NSNumber numberWithInteger:size] forKey:@"pageSize"];
    [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    [mDict setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lng] forKey:@"lng"];
    [mDict setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lat] forKey:@"lat"];

//    [mDict setObject:@"39.7634" forKey:@"lat"];
//    [mDict setObject:@"116.331" forKey:@"lng"];
//    
    
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response) {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
//            NSLog(@"柯南附近订单%@",dict);
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
            
            NSArray *tempList = dict[@"data"];
            NSLog(@"%lu",(unsigned long)tempList.count);
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if((NSNull *)tempStatus != [NSNull null] && ![tempStatus isEqualToString:@"0"]) {
                NSMutableArray *retArray = [[NSMutableArray alloc] init];
                
                
            for (NSDictionary *dic in tempList) {
               
                OrderListModel *order = [[OrderListModel alloc] initWithJson:dic andIsSendOrder:NO];
                [retArray addObject:order];
            }
                
                
                
                completion(YES, retArray);

            } else {
                completion(NO, nil);
            }
            
        } else {
            completion(NO, nil);

        }
    }];
    
    NSString *url1 = [NSString stringWithFormat:@"%@nearRedList",baseUrl];
    NSMutableDictionary*mDict1 = [NSMutableDictionary dictionary];
    [mDict1 safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    [mDict1 setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lng] forKey:@"lng"];
    [mDict1 setObject:[NSString stringWithFormat:@"%f",[UserManager shareUserManager].userInfo.lat] forKey:@"lat"];
    
//    [mDict1 setObject:@"39.7634" forKey:@"lat"];
//    [mDict1 setObject:@"116.331" forKey:@"lng"];
    
    [SVHTTPRequest POST:url1 parameters:mDict1 completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
//        NSLog(@"还有多少个红包没有抢");
        if (response) {
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            //        NSLog(@"还有多少个红包没有抢,%@",resultDic);
            NSArray *RedMoneyList=resultDic[@"data"];
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setObject:RedMoneyList forKey:@"RedMoneyList"];
        }
    }];
    
}

+ (void)asyncLoadMyGrabHistoryOrderListWithPage:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^)(BOOL, NSArray *))completion
{
    NSString *url = [NSString stringWithFormat:@"%@historyqiangdan",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [mDict setObject:[NSNumber numberWithInteger:size] forKey:@"pageSize"];

    [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    
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
            NSArray *tempList = dict[@"data"];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if((NSNull *)tempStatus != [NSNull null] && ![tempStatus isEqualToString:@"0"]) {
                NSMutableArray *retArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in tempList) {
                    OrderListModel *order = [[OrderListModel alloc] initWithJson:dic andIsSendOrder:NO];
                    [retArray addObject:order];
                }
                completion(YES, retArray);
            } else {
                completion(NO, nil);
            }
        } else {
            completion(NO, nil);

        }
    }];
}

+ (void)asyncLoadMySendHistoryOrderListWithPage:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^)(BOOL, NSArray *))completion
{
    NSString *url = [NSString stringWithFormat:@"%@historyfadan",baseUrl];

    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [mDict setObject:[NSNumber numberWithInteger:size] forKey:@"pageSize"];
    
    [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    
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
            NSArray *tempList = dict[@"data"];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if((NSNull *)tempStatus != [NSNull null] && ![tempStatus isEqualToString:@"0"]) {
                NSMutableArray *retArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in tempList) {
                    OrderListModel *order = [[OrderListModel alloc] initWithJson:dic andIsSendOrder:YES];
                    [retArray addObject:order];
                }
                completion(YES, retArray);
            } else {
                completion(NO, nil);
            }
        } else {
            completion(NO, nil);
            
        }
    }];
}

+ (void)asyncLoadMyGrabInProgressOrderListWithPage:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^)(BOOL, NSArray *))completion
{
    NSString *url = [NSString stringWithFormat:@"%@orderpaidaning",baseUrl];

    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [mDict setObject:[NSNumber numberWithInteger:size] forKey:@"pageSize"];
    
    [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    
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
            NSArray *tempList = dict[@"data"];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if((NSNull *)tempStatus != [NSNull null] && ![tempStatus isEqualToString:@"0"]) {
                NSMutableArray *retArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in tempList) {
                    OrderListModel *order = [[OrderListModel alloc] initWithJson:dic andIsSendOrder:NO];
                    [retArray addObject:order];
                }
                completion(YES, retArray);
            } else {
                completion(NO, nil);
            }
        } else {
            completion(NO, nil);
        }
    }];

}

+ (void)asyncLoadMySendInProgressOrderListWithPage:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^)(BOOL, NSArray *))completion
{
    NSString *url = [NSString stringWithFormat:@"%@orderfadaning",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [mDict setObject:[NSNumber numberWithInteger:size] forKey:@"pageSize"];
    
    [mDict safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"memberid"];
    
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
            NSArray *tempList = dict[@"data"];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if((NSNull *)tempStatus != [NSNull null] && ![tempStatus isEqualToString:@"0"]) {
                NSMutableArray *retArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in tempList) {
                    OrderListModel *order = [[OrderListModel alloc] initWithJson:dic andIsSendOrder:YES];
                    [retArray addObject:order];
                }
                completion(YES, retArray);
            } else {
                completion(NO, nil);
            }
        } else {
            completion(NO, nil);
            
        }
    }];
}

+ (void)asyncLoadMissOrderListWithPage:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^)(BOOL, NSArray *))completion
{
    NSString *url = [NSString stringWithFormat:@"%@lostOrders",baseUrl];
    
//    NSString *url = [NSString stringWithFormat:@"%@lostOrders",@"http://api.aikaoen.com/?action="];

    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    if (page >= 0) {
        [mDict setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    }
    if (size>=0) {
        [mDict setObject:[NSNumber numberWithInteger:size] forKey:@"pageSize"];
    }
    UserManager *userManager = [UserManager shareUserManager];
    [mDict safeSetObject:userManager.userInfo.userid forKey:@"memberId"];
    [mDict safeSetObject:[NSNumber numberWithDouble:userManager.userInfo.lat] forKey:@"lat"];
    [mDict safeSetObject:[NSNumber numberWithDouble:userManager.userInfo.lng] forKey:@"lon"];
    
//    [mDict safeSetObject:[NSNumber numberWithFloat:39.76313] forKey:@"lat"];
//    [mDict safeSetObject:[NSNumber numberWithFloat:116.33054] forKey:@"lon"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            
            NSLog(@"错过的订单%@",dict);
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
            NSArray *tempList = dict[@"data"];
            NSString *tempStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if((NSNull *)tempStatus != [NSNull null] && ![tempStatus isEqualToString:@"0"]) {
                NSMutableArray *retArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in tempList) {
                    MissOrderModel *order = [[MissOrderModel alloc] initWithJson:dic];
                    [retArray addObject:order];
                }
                completion(YES, retArray);
            } else {
                completion(NO, nil);
            }
        } else {
            completion(NO, nil);
            
        }
    }];

}

@end
