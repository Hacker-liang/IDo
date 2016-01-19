//
//  RedMoneyDetailModel.h
//  IDo
//
//  Created by 柯南 on 16/1/18.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedMoneyDetailModel : NSObject
@property (nonatomic,strong) NSString *headImage;
@property (nonatomic,strong) NSString *sexImage;
@property (nonatomic,strong) NSString *nameLab;
@property (nonatomic,strong) NSString *timeLab;
@property (nonatomic,strong) NSString *rangeLab;
@property (nonatomic,strong) NSString *moneyLab;

-(id)initWithJson:(id)json;
@end
