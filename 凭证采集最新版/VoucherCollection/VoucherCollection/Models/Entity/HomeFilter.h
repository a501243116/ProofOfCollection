//
//  HomeFilter.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-18.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeFilter : NSObject

//用于homecontroller的过滤
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) NSString *text;

@end
