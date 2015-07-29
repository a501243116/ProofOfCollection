//
//  DetailLocalDao.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-19.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailLocal.h"
#import "CostDetailInfo.h"

@interface DetailLocalDao : NSObject

+ (void)insertDataWithDic:(NSDictionary *)dic;
+ (NSArray *)readDataWith:(NSString *)ipAddress company:(NSString *)company ndId:(NSNumber *)ndId dbID:(NSString *)dbID fetch:(NSInteger)fetch limit:(NSInteger)limit
;

+ (NSArray *)readAllDataWith:(NSString *)ipAddress company:(NSString *)company ndId:(NSNumber *)ndId dbID:(NSString *)dbID fetch:(NSInteger)fetch limit:(NSInteger)limit;//读取抽样不为null的数据
+ (NSArray *)readAllDataWith:(NSString *)ipAddress company:(NSString *)company ndId:(NSNumber *)ndId dbID:(NSString *)dbID;//读取所有数据
+ (DetailLocal *)readDataWithIden:(NSNumber *)iden;
+ (void)updateDetailLocal:(CostDetailInfo *)info ;
@end
