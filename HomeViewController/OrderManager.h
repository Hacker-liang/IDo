//
//  OrderManager.h
//  IDo
//
//  Created by liangpengshuai on 12/5/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderManager : NSObject

/**
 *  加载附近订单
 *
 *  @param page       从1开始
 *  @param size
 *  @param completion 
 */
+ (void)asyncLoadNearByAllListWithPage:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^) (BOOL isSuccess, NSArray *orderList,NSDictionary *redDic))completion;

+ (void)asyncLoadNearByOrderListWithPage:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^) (BOOL isSuccess, NSArray *orderList))completion;

/**
 *  加载我的抢单列表中历史订单
 *
 *  @param page
 *  @param size
 *  @param completion 
 */
+ (void)asyncLoadMyGrabHistoryOrderListWithPage:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^) (BOOL isSuccess, NSArray *orderList))completion;

/**
 *  加载我的派单列表中的历史订单
 *
 *  @param page
 *  @param size
 *  @param completion 
 */
+ (void)asyncLoadMySendHistoryOrderListWithPage:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^) (BOOL isSuccess, NSArray *orderList))completion;

/**
 *  加载我的抢单列表的进行中的订单
 *
 *  @param page
 *  @param size
 *  @param completion
 */
+ (void)asyncLoadMyGrabInProgressOrderListWithPage:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^) (BOOL isSuccess, NSArray *orderList))completion;

/**
 *  加载我的派单列表的进行中的订单
 *
 *  @param page
 *  @param size
 *  @param completion 
 */
+ (void)asyncLoadMySendInProgressOrderListWithPage:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^) (BOOL isSuccess, NSArray *orderList))completion;

/**
 *  加载错过的订单列表
 *
 *  @param page
 *  @param size
 *  @param completion
 */
+ (void)asyncLoadMissOrderListWithPage:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^) (BOOL isSuccess, NSArray *orderList))completion;


@end
