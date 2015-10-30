//
//  AliPayTool.m
//  xianne
//
//  Created by fengyan on 15/5/13.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "AliPayTool.h"

@implementation AliPayTool

/*
-(NSString *)AliPayWithProductName:(NSString *)productname AndproductDescription:(NSString *)description andAmount:(NSString *)amount Orderid:(NSString *)orderid MoneyBao:(NSString *)qianbao AliPayMoney:(NSString *)aliMoney ShouKuanID:(NSString *)shoukuanID
{
    self.m_isFromAli = @"0";
    
    if ([aliMoney isEqualToString:@"0"])
    {
//        钱包支付
        [self PayFor:orderid QianBaoMoney:qianbao AliMoney:aliMoney ShouKuanID:shoukuanID];
    }
//    支付宝支付
    else
    {
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyyMMddHHmmssSSS";
        NSString *str=[formatter stringFromDate:[NSDate date]];
        //        支付宝支付要调用的方法
        Order *order = [[Order alloc] init];
        order.partner = @"2088911038937654";
        order.seller = @"bjyinengxing@163.com";
        order.tradeNO = str; //订单ID(由商家□自□行制定)
        order.productName = productname; //商品标题
        order.productDescription = description; //商品描述
        order.amount = aliMoney; //商 品价格
        order.notifyURL = @"http://baidu.com"; //回调URL
        order.service = @"mobile.securitypay.pay";
        order.paymentType = @"1";
        order.inputCharset = @"utf-8";
        order.itBPay = @"30m";
        NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMi1hnJwDRuSzbvicTgaSNHdyyqqlBabasbUvc41U2e9c0BsUEfdZuspwrvpWVVmeBTG955j/ISYMec+LYC06tyvFlEsOgXfxuXzQ2YqfG2KdQ+YqI+OZ6dfQPN8WMxkrO4hFx+hk0IXqcoguNpJJ3op1ONKDW250FwiT/gJoHYfAgMBAAECgYAdetwmjuK9/BAP2rC6htHPUX5349ogf+9tCO5gDWEUybTV75LTG2f0fovFwf6HFqfolVjlgNYkO56I0o8oampcgRxeyfdIA1NWxjHvsVZj3ZSljVB114ryP9jwlYD49OllsxPh7RMZpJnq1FRj3R4XRLiDgjl4xakNO4Zy7Ry60QJBAOL1zAeXbdksSb0K410dE5xud0/WovKl4COFdYF+Q8dP1kGohK3hG0+nqmKCO5SEO2nxWdTQ5Wy5P3vqokkKw3MCQQDiY9xCGaHL5nSZIkfjSMRcwJFRVHkiaUbd0loeV7qdnsQIqjQqMAgLut2RqVgVVkUcVmtwh5vzeJWIq+e3IE+lAkAVHUri9eqJRr6BcM7gLcFST1CYQ96a9mWYyGS7LFT/6OSE7TmSt5uD2JRYX8dNNNQWMhbqXpjJeZ53V8fLRc4TAkEArhEGC7TVmIdLY2reRz1t7bsKgLQop3K20FuqeuYNUKAALoFftohTx2EYd6TzWwSIAu/XkCBUonE22G0EruMjGQJBANzMYG5KM/qbOyrXmQRyCjGbI6fZ1FIALMHr6FYfQEwjPXdENp0N82RR7ecKSniMLAkwIU9TJ7VI5sTv2nB6TH8=";
        
        //            应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"xianne";
        
        //将商品信息拼接成字符串
        NSString *orderSpec = [order description];
        
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        id<DataSigner> signer = CreateRSADataSigner(privateKey);
        NSString *signedString = [signer signString:orderSpec];
        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = nil;
        
        if (signedString != nil)
        {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
        }
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
         {
            NSString *str=[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
             //NSLog(@"----------aliback");
             self.m_isFromAli = @"1";
             if ([str isEqualToString:@"9000"])
             {
              
                 if ([shoukuanID isEqualToString:[UserManager shareUserManager].userInfo.userid]) {//充值
                     [self PayForAliMoney:aliMoney ShouKuanID:shoukuanID];
                 }else{
                     [self PayFor:orderid QianBaoMoney:qianbao AliMoney:aliMoney ShouKuanID:shoukuanID];
                     if ([self.zhuangtai isEqualToString:@"1"]) {
                         NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                         [notificationCenter postNotificationName:@"gotoPayedPage" object:@"AliPayTool"];
                     }
                 }
                
             }
        }];
    }
    
    return self.zhuangtai;
}
*/

-(void)PayFor:(NSString *)orderid QianBaoMoney:(NSString *)qianbao AliMoney:(NSString *)alimoney ShouKuanID:(NSString *)shoukuanID
{
    int money=[alimoney intValue]+[qianbao intValue];

     NSString *shoukuanrenid=shoukuanID;
     NSString *shoukuanmembermoney=[NSString stringWithFormat:@"%d",money];
    
    NSString *url = [NSString stringWithFormat:@"%@orderpayover",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:orderid forKey:@"orderid"];
    [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"fukuanrenid"];
    [mDict setObject:shoukuanrenid forKey:@"shoukuanmemberid"];
    [mDict setObject:shoukuanmembermoney forKey:@"shoukuanmembermoney"];
    [mDict setObject:qianbao forKey:@"qianbaomoney"];
    [mDict setObject:alimoney forKey:@"zhifubaomoney"];

    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            if ([[dict objectForKey:@"status"] integerValue] == 30001 || [[dict objectForKey:@"status"] integerValue] == 30002) {
                if ([UserManager shareUserManager].isLogin) {
                                        [UserManager shareUserManager].userInfo = nil;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"info"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoError" object:nil];
                    }];
                }
                return;
            }
            self.zhuangtai=[NSString stringWithFormat:@"%@",dict[@"status"]];
        }
        else
        {
            UIAlertView *failedAlert = [[UIAlertView alloc]initWithTitle:nil message:messageError delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [failedAlert show];
        }
        
    }];
}
/* coca start */
-(void)PayForAliMoney:(NSString *)alimoney ShouKuanID:(NSString *)shoukuanID
{
    
    NSString *url = [NSString stringWithFormat:@"%@addExtract",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:shoukuanID forKey:@"memberid"];
    [mDict setObject:alimoney forKey:@"money"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            if ([[dict objectForKey:@"status"] integerValue] == 30001 || [[dict objectForKey:@"status"] integerValue] == 30002) {
                if ([UserManager shareUserManager].isLogin) {
                                        [UserManager shareUserManager].userInfo = nil;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"info"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoError" object:nil];
                    }];
                }
                return;
            }
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:dict[@"info"] message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            UIAlertView *failedAlert = [[UIAlertView alloc]initWithTitle:nil message:messageError delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [failedAlert show];
        }

    }];
}
/* coca end */


#pragma mark add by xuebao

// xuebao start
- (void)aliPayWithProductName:(NSString *)productName
           productDescription:(NSString *)description
                    andAmount:(NSString *)amount
                      orderId:(NSString *)orderId
                  orderNumber:(NSString *)orderNumber
                     MoneyBao:(NSString *)qianbao
                  AliPayMoney:(NSString *)aliMoney
                   shouKuanID:(NSString *)shoukuanID
                completeBlock:(AliPayToolBlock)completedBlock
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyyMMddHHmmssSSS";
    NSString *str=[formatter stringFromDate:[NSDate date]];
    //        支付宝支付要调用的方法
    Order *order = [[Order alloc] init];
    order.partner = @"2088911038937654";
    order.seller = @"bjyinengxing@163.com";
    order.tradeNO = str; //订单ID(由商家□自□行制定)
    order.productName = productName; //商品标题
    order.productDescription = description; //商品描述
    order.amount = amount; //商 品价格
    order.notifyURL = @"http://baidu.com"; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMi1hnJwDRuSzbvicTgaSNHdyyqqlBabasbUvc41U2e9c0BsUEfdZuspwrvpWVVmeBTG955j/ISYMec+LYC06tyvFlEsOgXfxuXzQ2YqfG2KdQ+YqI+OZ6dfQPN8WMxkrO4hFx+hk0IXqcoguNpJJ3op1ONKDW250FwiT/gJoHYfAgMBAAECgYAdetwmjuK9/BAP2rC6htHPUX5349ogf+9tCO5gDWEUybTV75LTG2f0fovFwf6HFqfolVjlgNYkO56I0o8oampcgRxeyfdIA1NWxjHvsVZj3ZSljVB114ryP9jwlYD49OllsxPh7RMZpJnq1FRj3R4XRLiDgjl4xakNO4Zy7Ry60QJBAOL1zAeXbdksSb0K410dE5xud0/WovKl4COFdYF+Q8dP1kGohK3hG0+nqmKCO5SEO2nxWdTQ5Wy5P3vqokkKw3MCQQDiY9xCGaHL5nSZIkfjSMRcwJFRVHkiaUbd0loeV7qdnsQIqjQqMAgLut2RqVgVVkUcVmtwh5vzeJWIq+e3IE+lAkAVHUri9eqJRr6BcM7gLcFST1CYQ96a9mWYyGS7LFT/6OSE7TmSt5uD2JRYX8dNNNQWMhbqXpjJeZ53V8fLRc4TAkEArhEGC7TVmIdLY2reRz1t7bsKgLQop3K20FuqeuYNUKAALoFftohTx2EYd6TzWwSIAu/XkCBUonE22G0EruMjGQJBANzMYG5KM/qbOyrXmQRyCjGbI6fZ1FIALMHr6FYfQEwjPXdENp0N82RR7ecKSniMLAkwIU9TJ7VI5sTv2nB6TH8=";
    
    //            应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"xianne";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //            NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
    }
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
         NSString *status=[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
         if ([status isEqualToString:@"9000"])
         {
             if ([shoukuanID isEqualToString:[UserManager shareUserManager].userInfo.userid]) {//充值
                 [self chargeQianbaoForAliMoney:aliMoney shouKuanID:shoukuanID rCompleteBlock:^(BOOL success, NSString *errorStr) {
                     completedBlock(success,errorStr);
                 }];
             } else{
                 [self aliPayForOrderId:orderId qianBaoMoney:qianbao aliMoney:aliMoney shouKuanID:shoukuanID rCompletedBlock:^(BOOL success, NSString *errorStr) {
                     completedBlock(success, errorStr);
                 }];
             }
         }
         else{
             completedBlock(NO,@"支付失败");
         }
     }];
}

// 支付宝支付成功后，向服务器请求支付是否成功记录
-(void)aliPayForOrderId:(NSString *)orderId
           qianBaoMoney:(NSString *)qianbaoMoney
               aliMoney:(NSString *)alimoney
             shouKuanID:(NSString *)shoukuanID
        rCompletedBlock:(RequestCompleteBlock)completeBlock
{
    NSString *shoukuanrenid=shoukuanID;
    NSString *shoukuanmembermoney=[NSString stringWithFormat:@"%@",alimoney];
    
    NSString *url = [NSString stringWithFormat:@"%@orderpayover",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:orderId forKey:@"orderid"];
    [mDict setObject:[UserManager shareUserManager].userInfo.userid forKey:@"fukuanrenid"];
    [mDict setObject:shoukuanrenid forKey:@"shoukuanmemberid"];
    [mDict setObject:shoukuanmembermoney forKey:@"shoukuanmembermoney"];
    [mDict setObject:qianbaoMoney forKey:@"qianbaomoney"];
    [mDict setObject:alimoney forKey:@"zhifubaomoney"];
    
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            NSString *status = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if ([status isEqualToString:@"1"]) {
                completeBlock(YES, nil);
            }
            else{
                completeBlock(NO, @"失败");
            }
        }
        else
        {
            completeBlock(NO,[error localizedDescription]);
        }
        
    }];
}

// 支付宝给钱包充值
-(void)chargeQianbaoForAliMoney:(NSString *)alimoney
                     shouKuanID:(NSString *)shoukuanID
                 rCompleteBlock:(RequestCompleteBlock)completedBlock
{
    NSString *url = [NSString stringWithFormat:@"%@addExtract",baseUrl];
    NSMutableDictionary*mDict = [NSMutableDictionary dictionary];
    [mDict setObject:shoukuanID forKey:@"memberid"];
    [mDict setObject:alimoney forKey:@"money"];
    
    [SVHTTPRequest POST:url parameters:mDict completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response)
        {
            NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [jsonString objectFromJSONString];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:dict[@"info"] message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
            completedBlock(YES,nil);
        }
        else
        {
            completedBlock(NO,@"充值失败");
        }
        
    }];
}

// xuebao end
@end
