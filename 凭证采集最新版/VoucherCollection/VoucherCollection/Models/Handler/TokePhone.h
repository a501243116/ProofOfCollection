//
//  TokePhone.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-17.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectState.h"
#import "IPInfoDao.h"

@interface TokePhone : NSObject

+ (void)insertPic:(UIImage *)image;
+ (NSMutableArray *)filter:(NSMutableArray *)array;//过滤有凭证的附件
+ (void)deleteImgWithPath:(NSString *)path;
+ (void)deleteImgWIthFullPath:(NSString *)path;
+ (void)insertPicAtLoc:(UIImage *)image;

+ (void)insertPicToTemp:(UIImage *)image;
+ (NSDictionary *)getImagesFromTemp;//从自由拍照文件夹获取照片

@end
