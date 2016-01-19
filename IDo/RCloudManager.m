//
//  RCloudManager.m
//  IDo
//
//  Created by liangpengshuai on 1/18/16.
//  Copyright © 2016 com.Yinengxin.xianne. All rights reserved.
//

#import "RCloudManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"

@implementation RCloudManager

+ (void)getRCloudTokenWithCompletionBlock:(void (^)(BOOL, NSString *))completion
{
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@_%@", RONGCLOUD_IM_TOKEN_KEY, [UserManager shareUserManager].userInfo.userid]];
    if (token) {
        completion(YES, token);
        completion = nil;
    }
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendString:RONGCLOUD_IM_SECRET];
    NSInteger nonce = arc4random()%100000;
    [str appendFormat:@"%ld", nonce];
    long timestamp = [[NSDate date] timeIntervalSince1970];
    [str appendFormat:@"%ld", timestamp];
    NSString *signature = [self sha1:str];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params safeSetObject:[UserManager shareUserManager].userInfo.userid forKey:@"userId"];
    [params safeSetObject:[UserManager shareUserManager].userInfo.nickName forKey:@"name"];
    [params safeSetObject:[UserManager shareUserManager].userInfo.avatar forKey:@"portraitUri"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    [manager.requestSerializer setValue:signature forHTTPHeaderField:@"RC-Signature"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld", timestamp] forHTTPHeaderField:@"RC-Timestamp"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld", nonce] forHTTPHeaderField:@"RC-Nonce"];
    [manager.requestSerializer setValue:RONGCLOUD_IM_APPKEY forHTTPHeaderField:@"RC-App-Key"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    
    [manager POST:@"http://api.cn.ronghub.com/user/getToken.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
            NSString *token = [responseObject objectForKey:@"token"];
            if (token) {
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:[NSString stringWithFormat:@"%@_%@", RONGCLOUD_IM_TOKEN_KEY, [UserManager shareUserManager].userInfo.userid]];
                if (completion) {
                    completion(YES, token);
                }
            } else {
                if (completion) {
                    completion(NO, nil);
                }
            }
        } else {
            if (completion) {
                completion(NO, nil);
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (completion) {
            completion(NO, nil);
        }
    }];
}

+ (NSString *)sha1:(NSString *)str
{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

@end
