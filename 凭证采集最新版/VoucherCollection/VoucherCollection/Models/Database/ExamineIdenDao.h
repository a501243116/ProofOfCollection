//
//  ExamineIdenDao.h
//  VoucherCollection
//
//  Created by yongzhang on 14-12-19.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamineIdenDao : NSObject

+ (void)inserDataWithDic:(NSDictionary *)parameters entityName:(NSString *)entityName;

+ (NSArray *)readDataFromIden:(NSNumber *)iden ipAddress:(NSString *)ipAddress;

+ (void)mofifyDataWithNewData:(NSDictionary *)dic ipAddress:(NSString *)ipAddress;

@end
