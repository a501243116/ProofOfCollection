//
//  UIImageView+Scale.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-24.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "UIImageView+Scale.h"

@implementation UIImageView (Scale)
+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
