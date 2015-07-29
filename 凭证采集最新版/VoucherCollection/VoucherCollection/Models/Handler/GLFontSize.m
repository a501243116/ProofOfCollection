//
//  GLFontSize.m
//  健康饮食改
//
//  Created by rimi on 14-5-26.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import "GLFontSize.h"

@implementation GLFontSize

#pragma mark --计算字符空间大小
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(NSInteger)width
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 1000)//显示的最大容量
                                       options: NSStringDrawingUsesLineFragmentOrigin //描述字符串的附加参数
                                    attributes:@{NSFontAttributeName: font}//描述字符串的参数
                                       context:nil];//上下文
    //返回值
    return rect.size;
}



+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(NSInteger)width height:(NSInteger)height
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, height)//显示的最大容量
                                       options: NSStringDrawingUsesLineFragmentOrigin //描述字符串的附加参数
                                    attributes:@{NSFontAttributeName: font}//描述字符串的参数
                                       context:nil];//上下文
    //返回值
    return rect.size;
}

@end
