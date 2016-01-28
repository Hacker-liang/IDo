//
//  SendRedMoneyDetailVC.h
//  IDo
//
//  Created by 柯南 on 16/1/26.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendRedMoneyModel.h"
@interface SendRedMoneyDetailVC : UIViewController
@property (nonatomic, copy) NSString *redId;
@property (nonatomic, copy) NSString *redMoney;
@property (nonatomic) BOOL isGameOver;
@property (nonatomic,strong) NSString *fromC;
@property (nonatomic,strong) SendRedMoneyModel *detaileModel;
@end
