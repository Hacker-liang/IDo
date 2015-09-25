//
//  NSMutableDictionary+MyDictionary.h
//  lvxingpai
//
//  Created by liangpengshuai on 14-7-18.
//  Copyright (c) 2014年 aizou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (MyDictionary)

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey;
@end
