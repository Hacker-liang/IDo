//
//  AliPayTool.h
//  xianne
//
//  Created by fengyan on 15/5/13.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

// xuebao start
typedef void(^AliPayToolBlock)(BOOL success, NSString *errorStr);
typedef void(^RequestCompleteBlock)(BOOL success, NSString *errorStr);
// xuebao end

@interface AliPayTool : NSObject
// xuebao start
// drop by xuebao
//-(NSString *)AliPayWithProductName:(NSString *)productname AndproductDescription:(NSString *)description andAmount:(NSString *)amount Orderid:(NSString *)orderid MoneyBao:(NSString *)qianbao AliPayMoney:(NSString *)aliMoney ShouKuanID:(NSString *)shoukuanID;
@property(copy,nonatomic)NSString *zhuangtai;
@property(copy,nonatomic)NSString *m_isFromAli;
// xuebao end

// xuebao start
- (void)aliPayWithProductName:(NSString *)productName
           productDescription:(NSString *)description
                    andAmount:(NSString *)amount
                      orderId:(NSString *)orderId
                      orderNumber:(NSString *)orderNumber
                     MoneyBao:(NSString *)qianbao
                  AliPayMoney:(NSString *)aliMoney
                   shouKuanID:(NSString *)shoukuanID
                completeBlock:(AliPayToolBlock)completedBlock;
// xuebao end
 

@end
