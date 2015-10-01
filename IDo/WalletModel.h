//
//  WalletModel.h
//  IDo
//
//  Created by liangpengshuai on 10/1/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletModel : NSObject

@property (nonatomic, copy) NSString *remainingMoney;
@property (nonatomic, copy) NSString *earnMoney;
@property (nonatomic, copy) NSString *payMoney;
@property (nonatomic, copy) NSString *cashMoney;

- (id)initWithJson:(id)json;

@end
