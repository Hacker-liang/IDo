//
//  SendMoneyDetailModel.h
//  IDo
//
//  Created by 柯南 on 16/1/26.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendMoneyDetailModel : NSObject
@property (nonatomic,strong) NSString *headImage;
@property (nonatomic,strong) NSString *sexImage;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *money;
@property (nonatomic,strong) NSString *time;

-(id)initWithJson:(id)json;
@end
