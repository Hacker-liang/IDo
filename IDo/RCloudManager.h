//
//  RCloudManager.h
//  IDo
//
//  Created by liangpengshuai on 1/18/16.
//  Copyright © 2016 com.Yinengxin.xianne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCloudManager : NSObject

+ (void)getRCloudTokenWithCompletionBlock:(void (^) (BOOL isSuccess, NSString *token))completion;

@end
