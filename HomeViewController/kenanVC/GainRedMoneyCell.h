//
//  GainRedMoneyCell.h
//  IDo
//
//  Created by 柯南 on 16/1/24.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GainRedMoneyModel.h"
@interface GainRedMoneyCell : UITableViewCell

@property (nonatomic,strong) UIView *FlineView;
@property (nonatomic,strong) UIImageView *headImage;
@property (nonatomic,strong) UIImageView *sexImage;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *moneyLab;
@property (nonatomic,strong) UILabel *timeLab;


@property (nonatomic,strong) GainRedMoneyModel *gainRedMoneyModel;
@end
