//
//  ParseChooseTaskData.h
//  VoucherCollection
//
//  Created by yongzhang on 15-2-9.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

//解析添加公司任务网络请求数据
@interface ParseChooseTaskData : NSObject

+ (NSArray *)backNdidData:(NSArray *)array;
+ (NSDictionary *)backPostionWithIndex:(NSInteger)index array:(NSArray *)array;
+ (NSMutableArray *)backDictionArrayFromObj:(NSArray *)databases;//把数据对象转换位字典对象
+ (NSMutableArray *)backDictionArrayFromCompanyObj:(NSArray *)databases;//把Company对象转换位字典对象

@end
