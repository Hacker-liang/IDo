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
    _FlineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
    _FlineView.backgroundColor=APP_PAGE_COLOR;
    [self.contentView addSubview:_FlineView];
    
    _moneyTotalLab=[[UILabel alloc]initWithFrame:CGRectMake(0.05*WIDTH, 0.01*HEIGHT, 0.6*WIDTH, 0.04*HEIGHT)];
    _moneyTotalLab.font=[UIFont systemFontOfSize:0.03*HEIGHT];
    [self.contentView addSubview:_moneyTotalLab];
    
    _infoLab=[[UILabel alloc]initWithFrame:CGRectMake(0.05*WIDTH, 0.06*HEIGHT, 0.6*WIDTH, 0.04*HEIGHT)];
    _infoLab.textColor=[UIColor lightGrayColor];
    _infoLab.font=[UIFont systemFontOfSize:0.025*HEIGHT];
    [self.contentView addSubview:_infoLab];
    
    _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(0.6*WIDTH-5, 0.06*HEIGHT, 0.4*WIDTH, 0.04*HEIGHT)];
    _timeLab.textAlignment=2;
    _timeLab.font=[UIFont systemFontOfSize:0.025*HEIGHT];
    _timeLab.textColor=[UIColor lightGrayColor];
    [self.contentView addSubview:_timeLab];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_timeLab.frame), WIDTH, 1)];
    lineView.backgroundColor=APP_PAGE_COLOR;
    [self.contentView addSubview:lineView];
    
}
-(void)setSendRedModel:(SendRedMoneyModel *)sendRedModel
{
    _sendRedModel=sendRedModel;
    
    double moneyTotal=[_sendRedModel.money doubleValue];
    
    _moneyTotalLab.text=[NSString stringWithFormat:@"红包金额:%0.2f元",moneyTotal];
    
    _infoLab.text=[NSString stringWithFormat:@"%@%@/%@个,共%0.2f/%0.2f元",_sendRedModel.status,_sendRedModel.grabCount,_sendRedModel.totalCount,[_sendRedModel.moneyGrab floatValue],moneyTotal];
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
