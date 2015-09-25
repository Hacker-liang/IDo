//
//  NSMutableDictionary+MyDictionary.m
//  lvxingpai
//
//  Created by liangpengshuai on 14-7-18.
//  Copyright (c) 2014年 aizou. All rights reserved.
//

#import "NSMutableDictionary+MyDictionary.h"

@implementation NSMutableDictionary (MyDictionary)

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (!anObject) {
        return;
    } else {
        [self setObject:anObject forKey:aKey];
    }
}

@end
