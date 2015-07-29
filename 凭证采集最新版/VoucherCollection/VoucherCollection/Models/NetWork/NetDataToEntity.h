//
//  NetDataToEntity.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-12.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetDataToEntity : NSObject

+ (NSArray *)setMyValue:(NSArray*)array1 className:(NSString *)str;
+ (id)setMyValue2:(NSDictionary *)dic className:(NSString *)str;

@end
