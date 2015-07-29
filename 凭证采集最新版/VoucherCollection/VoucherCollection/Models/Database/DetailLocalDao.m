//
//  DetailLocalDao.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-19.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "DetailLocalDao.h"
#import "EntityOneDao.h"
#import "SelectState.h"

@implementation DetailLocalDao

+ (void)insertDataWithDic:(NSDictionary *)dic
{
    SelectState *state = [SelectState shareInstance];
    
    NSInteger pzbhI = [dic[@"pzbh"] integerValue];
    NSInteger dwidI = [state.dwid integerValue];
    NSInteger bhI = [dic[@"bh"] integerValue];
    NSInteger fjstatusI = [dic[@"fjstatus"] integerValue];
    NSInteger idenI = [dic[@"iden"] integerValue];
    NSInteger kjmonthI = [dic[@"kjmonth"] integerValue];
    NSInteger kjyearI = [dic[@"kjyearI"] integerValue];
    NSInteger ndidI = [state.ndid integerValue];
    
    
    NSMutableDictionary *dicm = [NSMutableDictionary new];
    [dicm setDictionary:dic];
    [dicm setValue:state.ipAddress forKey:@"ipAddress"];
    [dicm setValue:state.companyName forKey:@"company"];
    [dicm setValue:state.ndid forKey:@"ndid"];
    [dicm setValue:state.companyTime forKey:@"time"];
    [dicm setValue:[NSNumber numberWithInteger:dwidI] forKey:@"dwid"];
    [dicm setValue:[NSNumber numberWithInteger:pzbhI] forKey:@"pzbh"];
    [dicm setValue:[NSNumber numberWithInteger:bhI] forKey:@"bh"];
    [dicm setValue:[NSNumber numberWithInteger:fjstatusI] forKey:@"fjstatus"];
    [dicm setValue:[NSNumber numberWithInteger:idenI] forKey:@"iden"];
    [dicm setValue:[NSNumber numberWithInteger:kjmonthI] forKey:@"kjmonth"];
    [dicm setValue:[NSNumber numberWithInteger:kjyearI] forKey:@"kjyear"];
    [dicm setValue:[NSNumber numberWithInteger:ndidI] forKey:@"ndid"];
    [dicm setValue:state.sdbGuid forKey:@"dbID"];


    if([self canInsert:dicm]) {
        [EntityOneDao insertObjectWithParameter:dicm entityName:@"DetailLocal"];
    }
}

+ (void)updateDetailLocal:(CostDetailInfo *)info
{
    SelectState *state = [SelectState shareInstance];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@ && %K == %@ && %K == %@ && %K == %@",@"ipAddress",state.ipAddress,@"company",state.companyName,@"ndid",state.ndid,@"pzbh",info.pzbh,@"jzsj",info.jzsj,@"bh",info.bh];
    [EntityOneDao modifyWithEntityName:@"DetailLocal" predicate:pre modifyData:@{@"isSelected":info.isSelected}];

}

//判断是否可以插入数据
+ (BOOL)canInsert:(NSDictionary *)dic
{
    
    if([EntityOneDao isEmpty:@"DetailLocal"]) {
        return YES;
    }
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@ && %K == %@ && %K == %@",@"dbID",dic[@"dbID"],@"ipAddress",dic[@"ipAddress"],@"company",dic[@"company"],@"ndid",dic[@"ndid"],@"iden",dic[@"iden"]];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"DetailLocal" predicate:pre];
    if(array.count == 0) {
        return YES;
    }
    return NO;
    
}

+ (NSArray *)readDataWith:(NSString *)ipAddress company:(NSString *)company ndId:(NSNumber *)ndId dbID:(NSString *)dbID fetch:(NSInteger)fetch limit:(NSInteger)limit
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@ && %K == %@ && %K != %@ && %K == %@",@"ipAddress",ipAddress,@"company",company,@"ndid",ndId,@"dbID",dbID,@"cyfaname",[NSNull null],@"isSelected",@0];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"DetailLocal" predicate:pre sort:@[@"jzsj",@"pzbh"] fetch:fetch limit:limit];
    return array;
}

+ (NSArray *)readAllDataWith:(NSString *)ipAddress company:(NSString *)company ndId:(NSNumber *)ndId dbID:(NSString *)dbID fetch:(NSInteger)fetch limit:(NSInteger)limit
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@ && %K == %@ && %K != %@",@"ipAddress",ipAddress,@"company",company,@"ndid",ndId,@"dbID",dbID,@"cyfaname",[NSNull null]];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"DetailLocal" predicate:pre sort:@[@"jzsj",@"pzbh"] fetch:fetch limit:limit];
    return array;
}

+ (NSArray *)readAllDataWith:(NSString *)ipAddress company:(NSString *)company ndId:(NSNumber *)ndId dbID:(NSString *)dbID
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@ && %K == %@",@"ipAddress",ipAddress,@"company",company,@"ndid",ndId,@"dbID",dbID,@"cyfaname"];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"DetailLocal" predicate:pre sort:@[@"jzsj",@"pzbh"] fetch:0 limit:NSIntegerMax];
    return array;
}

+ (DetailLocal *)readDataWithIden:(NSNumber *)iden
{
    NSLog(@"aa");
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"iden",iden];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"DetailLocal" predicate:predicate];
    if (array.count != 0) {
        return array[0];
    }
    NSArray *array2 = [EntityOneDao readObjectWithEntityName:@"DetailLocal" predicate:nil];
    NSLog(@"%@",array2);
    for(DetailLocal *info in array2) {
        NSLog(@"%@",info.iden);
    }
    
    return nil;
}

@end
