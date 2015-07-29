//
//  PhotosList.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-18.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "PhotosList.h"

@implementation PhotosList

- (instancetype)init
{
    self = [super init];
    if (self) {
        _images = [NSMutableArray new];
    }
    return self;
}

@end
