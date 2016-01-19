//
//  RedMoneyDetailCell.h
//  IDo
//
//  Created by 柯南 on 16/1/18.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedMoneyDetailModel.h"
@interface RedMoneyDetailCell : UITableViewCell
@property (nonatomic,strong) UIImageView *headImage;
@property (nonatomic,strong) UIImageView *sexImage;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *moneyLab;
@property (nonatomic,strong) RedMoneyDetailModel *model;
@end
