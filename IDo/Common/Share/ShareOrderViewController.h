//
//  ShareViewController.h
//  IDo
//
//  Created by liangpengshuai on 12/20/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareOrderViewController : TZViewController

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic) BOOL isSender;

@end
