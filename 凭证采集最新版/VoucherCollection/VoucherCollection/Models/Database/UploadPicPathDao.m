//
//  UploadPicPathDao.m
//  VoucherCollection
//
//  Created by yongzhang on 14-12-24.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "UploadPicPathDao.h"
#import "EntityOneDao.h"

@implementation UploadPicPathDao

+ (BOOL)hasDataWithPath:(NSString *)path
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@",@"path",path];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"UploadPicPath" predicate:pre];
    if (array.count > 0) {
        return YES;
    }
    return NO;
}

@end
