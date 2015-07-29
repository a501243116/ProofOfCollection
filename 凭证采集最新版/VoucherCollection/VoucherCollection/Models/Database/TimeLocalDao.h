//
//  TimeLocalDao.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-19.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeLocal.h"

@interface TimeLocalDao : NSObject
+ (void)insertDataWithDic:(NSDictionary *)dic;
+ (NSArray *)readDataWith:(NSString *)ipAddress company:(NSString *)company;
+ (void)modifyTaskCount:(NSString *)ipAddress company:(NSString *)company ndid:(NSNumber *)ndid count:(NSInteger)count;
+ (NSInteger)backCountWithIp:(NSString *)ipAddress company:(NSString *)company ndid:(NSNumber *)ndid;
+ (TimeLocal *)readDataWithIp:(NSString *)ip companyName:(NSString *)companyName time:(NSString *)time;


@end
