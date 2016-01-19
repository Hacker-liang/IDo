//
//  SendRedMoneyCell.h
//  IDo
//
//  Created by 柯南 on 16/1/18.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendRedMoneyModel.h"
@interface SendRedMoneyCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImage;
@property (nonatomic,strong) UIImageView *sexImage;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *sendNumLab;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UIView *lineView1;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIImageView *redMoneyImage;


@property (nonatomic,strong) UIView *addressView;
@property (nonatomic,strong) UIImageView *addressImage;
@property (nonatomic,strong) UILabel *addressLab;

@property (nonatomic,strong) UILabel *statusLab;

@property (nonatomic,strong) SendRedMoneyModel *moedl;
@end
