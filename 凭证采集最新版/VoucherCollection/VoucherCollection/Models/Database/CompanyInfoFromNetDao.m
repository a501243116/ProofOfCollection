//
//  CompanyInfoFromNet.m
//  VoucherCollection
//
//  Created by yongzhang on 15-2-9.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "CompanyInfoFromNetDao.h"
#import "EntityOneDao.h"


@implementation CompanyInfoFromNetDao

+ (void)insertDataFromCompanys:(NSArray *)componys
{
    [componys enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if(![self chargeHas:obj]) {
            [EntityOneDao insertObjectWithParameter:obj entityName:@"CompanyInfoFromNet"];
        }
    }];
}

+ (BOOL)chargeHas:(NSDictionary *)dic
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@",@"dwid",dic[@"dwid"],@"ndid",dic[@"ndid"]];
   NSArray *array = [EntityOneDao readObjectWithEntityName:@"CompanyInfoFromNet" predicate:pre];
    if(array.count != 0) {
        return YES;
    }
    return NO;
}

+ (CompanyInfoFromNet *)readData:(NSNumber *)ndid dwid:(NSNumber *)dwid
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@",@"ndid",ndid,@"dwid",dwid];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"CompanyInfoFromNet" predicate:pre];
    return array[0];
}
@end
