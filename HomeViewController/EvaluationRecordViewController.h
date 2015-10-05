//
//  EvaluationRecordViewController.h
//  IDo
//
//  Created by YangJiLei on 15/9/5.
//  Copyright (c) 2015年 IDo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluationRecordViewController : UITableViewController
@property (nonatomic, assign) NSInteger evaluationType; //1发单人评价 2接单人评价
@property (nonatomic, strong) NSMutableArray *dataArr;

@end
