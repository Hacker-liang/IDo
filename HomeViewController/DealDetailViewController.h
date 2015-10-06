//
//  TixianViewController.h
//  xianne
//
//  Created by coca on 15/6/27.
//  Copyright (c) 2015年 coca. All rights reserved.
//

//收支明细/提现明细

#import <UIKit/UIKit.h>
#import "UIPullRefreshViewController.h"

@interface DealDetailViewController : TZViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSMutableArray *dealArr;


@end
