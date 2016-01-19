//
//  RedMoneyDetailCell.m
//  IDo
//
//  Created by 柯南 on 16/1/18.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "RedMoneyDetailCell.h"

@implementation RedMoneyDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI
{
    _headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.01*HEIGHT, 0.01*HEIGHT, 0.08*HEIGHT, 0.08*HEIGHT)];
    _headImage.backgroundColor=[UIColor lightGrayColor];
    _headImage.layer.cornerRadius=0.04*HEIGHT;
    _headImage.layer.masksToBounds=YES;
    [self.contentView addSubview:_headImage];
    
    _sexImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.08*WIDTH+5, 0.08*WIDTH+5, 0.04*WIDTH, 0.04*WIDTH)];
    _sexImage.layer.cornerRadius=0.02*WIDTH;
    _sexImage.backgroundColor=[UIColor redColor];
    _sexImage.layer.masksToBounds=YES;
    [self.contentView addSubview:_sexImage];
    
    _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0.1*HEIGHT, 0.01*HEIGHT, 0.4*WIDTH, 0.04*HEIGHT)];
    [self.contentView addSubview:_timeLab];
    
    _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(0.1*HEIGHT, 0.06*HEIGHT, WIDTH-0.1*HEIGHT-10, 0.04*HEIGHT)];
    [self.contentView addSubview:_nameLab];
    
    _moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(0.8*WIDTH, 0.01*HEIGHT, 0.2*WIDTH-10, 0.04*HEIGHT)];
    [self.contentView addSubview:_moneyLab];
    
}

-(void)setModel:(RedMoneyDetailModel *)model
{
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
