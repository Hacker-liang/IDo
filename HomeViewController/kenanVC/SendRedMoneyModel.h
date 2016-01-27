//
//  SendRedMoneyModel.h
//  IDo
//
//  Created by 柯南 on 16/1/18.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendRedMoneyModel : NSObject
@property (nonatomic,strong) NSString *redId;
@property (nonatomic,strong) NSString *money;
@property (nonatomic,strong) NSString *grabCount;
@property (nonatomic,strong) NSString *totalCount;
@property (nonatomic,strong) NSString *moneyGrab;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *status;

-(id)initWithJson:(id)json;
@end
