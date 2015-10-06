//
//  EvaluationViewController.h
//  IDo
//
//  Created by YangJiLei on 15/8/31.
//  Copyright (c) 2015年 IDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingBar.h"
#import "UIPlaceHolderTextView.h"

@interface EvaluationViewController : TZViewController <UITextViewDelegate>

@property (nonatomic, assign) NSInteger evaluationType; //1发单人评价 2接单人评价

@property (nonatomic, strong) NSString *orderid;
@property (nonatomic, strong) OrderDetailModel *orderDetail;
@property (nonatomic, strong) RatingBar *ratingBar;
@property (nonatomic, strong) UIPlaceHolderTextView *textView;
@end
