//
//  RCloudManager.h
//  IDo
//
//  Created by liangpengshuai on 1/18/16.
//  Copyright © 2016 com.Yinengxin.xianne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderDetailModel.h"

@interface RCloudManager : NSObject

+ (void)getRCloudTokenWithCompletionBlock:(void (^) (BOOL isSuccess, NSString *token))completion;

+ (RCloudManager *)shareInstance;

@property (nonatomic, strong) NSArray *rongCloudUserList;  //融云用户列表

- (void)startSendOrder2NearbyUserWithOrderId:(NSString *)orderId;


@end
