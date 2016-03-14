//
//  GainRedMoneyCell.m
//  IDo
//
//  Created by 柯南 on 16/1/24.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "GainRedMoneyCell.h"

@implementation GainRedMoneyCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _FlineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
        _FlineView.backgroundColor=APP_PAGE_COLOR;
        [self.contentView addSubview:_FlineView];
        
        _headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.01*HEIGHT, 0.01*HEIGHT, 0.08*HEIGHT, 0.08*HEIGHT)];
        _headImage.backgroundColor=[UIColor lightGrayColor];
        _headImage.layer.cornerRadius=0.04*HEIGHT;
        _headImage.layer.masksToBounds=YES;
        [self.contentView addSubview:_headImage];
        
        _sexImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.09*WIDTH+10, 0.09*WIDTH+10, 0.04*WIDTH, 0.04*WIDTH)];
        _sexImage.layer.cornerRadius=0.02*WIDTH;
        _sexImage.layer.masksToBounds=YES;
        [self.contentView addSubview:_sexImage];
        
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0.1*HEIGHT, 0.01*HEIGHT, 0.4*WIDTH, 0.04*HEIGHT)];
        _nameLab.font=[UIFont systemFontOfSize:0.03*HEIGHT];
        [self.contentView addSubview:_nameLab];
        
        _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(0.1*HEIGHT, 0.06*HEIGHT, WIDTH-0.1*HEIGHT-10, 0.04*HEIGHT)];
        _timeLab.textColor=[UIColor lightGrayColor];
        _timeLab.font=[UIFont systemFontOfSize:0.025*HEIGHT];
        [self.contentView addSubview:_timeLab];
        
        _moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(0.7*WIDTH, 0.02*HEIGHT, 0.3*WIDTH-10, 0.04*HEIGHT)];
        _moneyLab.adjustsFontSizeToFitWidth = YES;
        _moneyLab.font=[UIFont systemFontOfSize:0.03*HEIGHT];
        [self.contentView addSubview:_moneyLab];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0.11*HEIGHT-1, WIDTH, 1)];
        lineView.backgroundColor=APP_PAGE_COLOR;
        [self.contentView addSubview:lineView];
        
    }
    return self;
}

-(void)setGainRedMoneyModel:(GainRedMoneyModel *)gainRedMoneyModel
{
        _gainRedMoneyModel=gainRedMoneyModel;
    
        [_headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_gainRedMoneyModel.headImage]] placeholderImage:[UIImage imageNamed:@"ic_avatar_default.png"]];
    
        _sexImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",_gainRedMoneyModel.sexImage]];
        _nameLab.text=[NSString stringWithFormat:@"%@",_gainRedMoneyModel.name];
    double money=[_gainRedMoneyModel.money doubleValue];
        _moneyLab.text=[NSString stringWithFormat:@"%0.2f元",money];
        _timeLab.text=[NSString stringWithFormat:@"%@",_gainRedMoneyModel.time];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
