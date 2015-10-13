//
//  PayViewController.h
//  IDo
//
//  Created by YangJiLei on 15/8/28.
//  Copyright (c) 2015年 IDo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PaySuccessBlock)(BOOL success,NSString *errorStr);

@interface PayViewController : TZViewController <UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UITableView *payTab;
@property(strong,nonatomic)NSString *price;
@property(strong,nonatomic)NSString *orderid;
@property(strong,nonatomic)NSString *orderNumber;

@property(strong,nonatomic)NSString * huoerbaoID;

@property(copy,nonatomic)PaySuccessBlock paySuccessBlock;

- (id)initWithPaySuccessBlock:(PaySuccessBlock)block;

@end
