//
//  NSMutableAttributedString+string.h
//  VoucherCollection
//
//  Created by gu on 15/7/28.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (string)

+ (NSMutableAttributedString *)attributedColorString:(NSString *)str color:(UIColor *)color range:(NSRange)range;

@end
