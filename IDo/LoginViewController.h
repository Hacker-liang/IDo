//
//  LoginViewController.h
//  IDo
//
//  Created by liangpengshuai on 9/24/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoginCompletionBlock)(BOOL success,NSString *errorStr);


@interface LoginViewController : UIViewController

- (id)initWithPaySuccessBlock:(LoginCompletionBlock)block;

@end
