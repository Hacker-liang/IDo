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
@property (nonatomic,strong) UIView *FlineView;
@property (nonatomic,strong)UILabel *moneyTotalLab;
@property (nonatomic,strong)UILabel *infoLab;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong) SendRedMoneyModel *sendRedModel;
@end
