//
//  ComplaintViewController.h
//  IDo
//
//  Created by YangJiLei on 15/8/31.
//  Copyright (c) 2015年 IDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface ComplaintViewController : TZViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, assign) NSInteger selIndex;
@property (nonatomic, strong) UIPlaceHolderTextView *textView;

@property (nonatomic, strong) NSString *tousuId; //投诉人id
@property (nonatomic, strong) NSString *beitousuId; //被投诉人id
@end
