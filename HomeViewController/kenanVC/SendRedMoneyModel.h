//
//  SendRedMoneyModel.h
//  IDo
//
//  Created by 柯南 on 16/1/18.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendRedMoneyModel : NSObject
@property (nonatomic,strong) NSString *headImage;
@property (nonatomic,strong) NSString *sexImage;
@property (nonatomic,strong) NSString *titleLab;
@property (nonatomic,strong) NSString *sendNumLab;


@property (nonatomic,strong) NSString *timeLab;
@property (nonatomic,strong) NSString *contentLab;
@property (nonatomic,strong) NSString *redMoneyImage;

@property (nonatomic,strong) NSString *addressImage;
@property (nonatomic,strong) NSString *addressLab;

@property (nonatomic,strong) NSString *status;

-(id)initWithJson:(id)json;
@end
