//
//  ExamineDao.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-19.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamineDao : NSObject
+ (void)insertDataWithDic:(NSDictionary *)dic;
+ (NSArray *)readDataWith:(NSNumber *)dwid ndid:(NSNumber *)ndid parId:(NSString *)parId;
+ (NSArray *)readDataWith:(NSNumber *)dwid ndid:(NSNumber *)ndid;
@end
