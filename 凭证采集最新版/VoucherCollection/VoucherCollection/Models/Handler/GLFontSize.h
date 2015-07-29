//
//  GLFontSize.h
//  健康饮食改
//
//  Created by rimi on 14-5-26.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLFontSize : NSObject

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(NSInteger)width;

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(NSInteger)width height:(NSInteger)height;

@end
