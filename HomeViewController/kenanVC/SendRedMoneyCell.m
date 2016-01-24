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
    _headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.01*HEIGHT, 5, 40, 40)];
    _headImage.backgroundColor=[UIColor lightGrayColor];
    _headImage.layer.cornerRadius=20;
    _headImage.layer.masksToBounds=YES;
    [self.contentView addSubview:_headImage];
    
    _sexImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.08*WIDTH+5, 0.08*WIDTH+5, 10, 10)];
    _sexImage.layer.cornerRadius=5;
    _sexImage.backgroundColor=[UIColor redColor];
    _sexImage.layer.masksToBounds=YES;
    [self.contentView addSubview:_sexImage];
    
    _titleLab=[[UILabel alloc]initWithFrame:CGRectMake(20+0.1*WIDTH, 10, 0.4*WIDTH, 0.05*WIDTH-10)];
    _titleLab.backgroundColor=[UIColor lightGrayColor];
    _titleLab.font=[UIFont systemFontOfSize:0.025*HEIGHT];
    _titleLab.textColor=[UIColor whiteColor];
    [self.contentView addSubview:_titleLab];
    
    _sendNumLab=[[UILabel alloc]initWithFrame:CGRectMake(20+0.1*WIDTH, 10+0.05*WIDTH, 0.6*WIDTH, 0.05*WIDTH-10)];
    _sendNumLab.backgroundColor=[UIColor redColor];
    _sendNumLab.textColor=[UIColor lightGrayColor];
    _sendNumLab.font=[UIFont systemFontOfSize:0.025*HEIGHT];
    _sendNumLab.textColor=[UIColor whiteColor];
    [self.contentView addSubview:_sendNumLab];
    
    _lineView=[[UIView alloc]initWithFrame:CGRectMake(10, 0.1*HEIGHT-1, 0.7*WIDTH-20, 1)];
    _lineView.backgroundColor=[UIColor lightGrayColor];
    [self.contentView addSubview:_lineView];
    
    _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(0.02*HEIGHT, 0.11*HEIGHT, 0.08*HEIGHT, 0.08*HEIGHT)];
    _timeLab.numberOfLines=0;
    _timeLab.backgroundColor=[UIColor brownColor];
    _timeLab.textColor=[UIColor whiteColor];
    [self.contentView addSubview:_timeLab];
    
    _lineView1=[[UIView alloc]initWithFrame:CGRectMake(0.11*HEIGHT, 0.11*HEIGHT, 1, 0.08*HEIGHT)];
    _lineView1.backgroundColor=[UIColor lightGrayColor];
    [self.contentView addSubview:_lineView1];
    
    _contentLab=[[UILabel alloc]initWithFrame:CGRectMake(0.12*HEIGHT, 0.11*HEIGHT, 0.7*WIDTH-0.12*HEIGHT, 0.08*HEIGHT)];
    _contentLab.textColor=[UIColor lightGrayColor];
    
    _redMoneyImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.75*WIDTH, 0.025*HEIGHT, 0.2*WIDTH, 0.15*HEIGHT)];
    _redMoneyImage.backgroundColor=[UIColor lightGrayColor];
    [self.contentView addSubview:_redMoneyImage];
    
    _addressView=[[UIView alloc]initWithFrame:CGRectMake(0, 0.2*HEIGHT,1 , 0.08*HEIGHT)];
    _addressView.backgroundColor=[UIColor lightGrayColor];
    [self.contentView addSubview:_addressView];
    
    _addressImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0.02*HEIGHT,0.04*HEIGHT , 0.04*HEIGHT)];
    _addressImage.backgroundColor=[UIColor lightGrayColor];
    [_addressView addSubview:_addressImage];
    
    _addressLab=[[UILabel alloc]initWithFrame:CGRectMake(30+0.04*HEIGHT, 0.02*HEIGHT, 0.5*HEIGHT, 0.04*HEIGHT)];
    _addressLab.backgroundColor=[UIColor lightGrayColor];
    [_addressView addSubview:_addressLab];
    
    _statusLab=[[UILabel alloc]initWithFrame:CGRectMake(0.8*WIDTH-5, 0.02*HEIGHT, 0.2*WIDTH, 0.04*HEIGHT)];
    _statusLab.backgroundColor=[UIColor lightGrayColor];
    [_addressView addSubview:_statusLab];
    
}

//-(void)setMoedl:(SendRedMoneyModel *)moedl
//{
//    
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
