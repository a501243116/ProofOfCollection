//
//  NSMutableAttributedString+string.m
//  VoucherCollection
//
//  Created by gu on 15/7/28.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "NSMutableAttributedString+string.h"

@implementation NSMutableAttributedString (string)

+ (NSMutableAttributedString *)attributedColorString:(NSString *)str color:(UIColor *)color range:(NSRange)range
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:color range:range];
    return string;
}

@end
