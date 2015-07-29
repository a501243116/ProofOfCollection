//
//  NSArray+ArrayHasStr.m
//  VoucherCollection
//
//  Created by yongzhang on 15-2-12.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "NSArray+ArrayHasStr.h"

@implementation NSArray (ArrayHasStr)

+ (BOOL)arrayHasStr:(NSObject *)str array:(NSArray *)array
{
    BOOL has = NO;
    for(NSObject *str1 in array) {
        if ([str isEqual:str1]) {
            has = YES;
            break;
        }
    }
    return has;
}

@end
