//
//  SendRedMoneyCell.m
//  IDo
//
//  Created by 柯南 on 16/1/18.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "SendRedMoneyCell.h"

@implementation SendRedMoneyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creteUI];
    }
    return self;
}

-(void)creteUI
{
    _moneyTotalLab=[[UILabel alloc]initWithFrame:CGRectMake(0.05*WIDTH, 0.01*HEIGHT, 0.6*WIDTH, 0.04*HEIGHT)];
    [self.contentView addSubview:_moneyTotalLab];
    
    _infoLab=[[UILabel alloc]initWithFrame:CGRectMake(0.05*WIDTH, 0.06*HEIGHT, 0.6*WIDTH, 0.04*HEIGHT)];
    _infoLab.textColor=[UIColor lightGrayColor];
    [self.contentView addSubview:_infoLab];
    
    _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(0.6*WIDTH-5, 0.06*HEIGHT, 0.4*WIDTH, 0.04*HEIGHT)];
    _timeLab.textAlignment=2;
    _timeLab.textColor=[UIColor lightGrayColor];
    [self.contentView addSubview:_timeLab];
}
-(void)setSendRedModel:(SendRedMoneyModel *)sendRedModel
{
        _sendRedModel=sendRedModel;
        _moneyTotalLab.text=[NSString stringWithFormat:@"红包金额:%@元",_sendRedModel.money];
        _infoLab.text=[NSString stringWithFormat:@"已领取%@/%@个,共%@/%@元",_sendRedModel.grabCount,_sendRedModel.totalCount,_sendRedModel.grabCount,_sendRedModel.money];
        _timeLab.text=[NSString stringWithFormat:@"%@",_sendRedModel.createTime];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
