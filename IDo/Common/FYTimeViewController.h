//
//  FYTimeViewController.h
//  闲人帮
//
//  Created by apple  on 15/4/21.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^timeValue) (NSString *aShowTime,NSString *aTaskTime);

@interface FYTimeViewController : UIViewController
@property(nonatomic,copy)timeValue postValue;
@property(nonatomic,strong)NSString *pickedTime;
@property(nonatomic,strong)NSString * strTime;
@end
