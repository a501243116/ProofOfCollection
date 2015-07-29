//
//  CompanyDao.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-18.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NdidToTime.h"
@interface CompanyDao : NSObject

+ (void)insertData:(NSArray *)dataArray;
+ (NSArray *)readDataWithIp:(NSString *)ipAddress dbID:(NSString *)dbID;
+ (NSArray *)readDataWithIp:(NSString *)ipAddress dbName:(NSString *)dbName;

+ (BOOL)chargeHasWithNdid:(NdidToTime *)ndid;
+ (BOOL)chargeHasWithNdid:(NSString *)ndid dwid:(NSNumber *)dwid;
+ (NSArray *)readDataWithIp:(NSString *)ipAddress ;


@end
