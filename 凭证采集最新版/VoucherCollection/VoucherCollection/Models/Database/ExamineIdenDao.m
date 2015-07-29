//
//  ExamineIdenDao.m
//  VoucherCollection
//
//  Created by yongzhang on 14-12-19.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "ExamineIdenDao.h"

@implementation ExamineIdenDao

+ (void)inserDataWithDic:(NSDictionary *)parameters entityName:(NSString *)entityName
{
    BOOL hasData = [self hasData:parameters[@"iden"] parId:parameters[@"parId"] ipAddress:parameters[@"ipAddress"]];
    if(hasData) {
        return;
    }
    [EntityOneDao insertObjectWithParameter:parameters entityName:@"ExamineIden"];

}

//判断是否存在
+ (BOOL)hasData:(NSNumber *)iden parId:(NSString *)parId ipAddress:(NSString *)ipAddress
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@",@"iden",iden,@"parId",parId,@"ipAddress",ipAddress];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"ExamineIden" predicate:pre];
    if(array.count == 0) {
        return NO;
    }
    return YES;
}

//读数据
+ (NSArray *)readDataFromIden:(NSNumber *)iden ipAddress:(NSString *)ipAddress
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@",@"iden",iden,@"ipAddress",ipAddress];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"ExamineIden" predicate:pre];
    return array;
}

+ (void)mofifyDataWithNewData:(NSDictionary *)dic ipAddress:(NSString *)ipAddress
{
    NSNumber *iden = dic[@"iden"];
    NSString *parId = dic[@"parId"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@",@"iden",iden,@"parId",parId,@"ipAddress",ipAddress];
    [EntityOneDao modifyWithEntityName:@"ExamineIden" predicate:pre modifyData:dic];
}
@end
