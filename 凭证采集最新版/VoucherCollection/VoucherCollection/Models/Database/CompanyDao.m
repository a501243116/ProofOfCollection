//
//  CompanyDao.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-18.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "CompanyDao.h"
#import "SelectState.h"
#import "EntityOneDao.h"
#import "Company.h"
#import "NdidToTime.h"
#import "CompanyTask.h"
#import "CompanyInfoFromNet.h"
#import "CompanyInfoFromNetDao.h"
@implementation CompanyDao

+ (void)insertData:(NSArray *)dataArray
{
    SelectState *sel = [SelectState shareInstance];
    dataArray = [self backNetDataFromArray:dataArray];
    [dataArray enumerateObjectsUsingBlock:^(CompanyTask *obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        NSInteger dwidI = [obj.dwid integerValue];
        [dic setValue:[NSNumber numberWithInteger:dwidI] forKey:@"dwid"];
        NSInteger ndidI = [obj.ndid integerValue];
        [dic setValue:[NSNumber numberWithInteger:ndidI]  forKey:@"ndid"];
        CompanyInfoFromNet *info = [CompanyInfoFromNetDao readData:obj.ndid dwid:obj.dwid];
        [dic setValue:info.kjyear2 forKey:@"kjyear2"];
        [dic setValue:info.kjyear1  forKey:@"kjyear1"];
        [dic setValue:info.kjmonth1 forKey:@"kjmonth1"];
        [dic setValue:info.kjmonth2 forKey:@"kjmonth2"];
        [dic setValue:sel.ipAddress forKey:@"ipAddress"];
        [dic setValue:sel.projectName forKey:@"dbName"];
        [dic setValue:sel.dbGuid forKey:@"dbID"];
        [dic setValue:obj.xmcc forKey:@"xmmc"];
        if(![self chargeHas:obj])
        [EntityOneDao insertObjectWithParameter:dic entityName:@"Company"]; 
    }];
}

+ (BOOL)chargeHas:(CompanyTask *)obj
{
    SelectState *sel = [SelectState shareInstance];
    NSInteger dwidI = [obj.dwid integerValue];
    NSInteger ndidI = [obj.ndid integerValue];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@ && %K == %@",@"ipAddress",sel.ipAddress,@"dbID",sel.dbGuid,@"ndid",[NSNumber numberWithInteger:ndidI],@"dwid",[NSNumber numberWithInteger:dwidI]];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"Company" predicate:pre];
    if(array.count > 0) {
        return YES;
    }
    return NO;
}

+ (NSArray *)backNetDataFromArray:(NSArray *)array
{
    NSMutableArray *dataArray = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(NdidToTime *obj, NSUInteger idx, BOOL *stop) {
        [obj.childArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [dataArray addObject:obj];
            
        }];
        
    }];
    return dataArray;
}

+ (NSArray *)readDataWithIp:(NSString *)ipAddress dbID:(NSString *)dbID
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@",@"ipAddress",ipAddress,@"dbID",dbID];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"Company" predicate:pre];
    return array;
}

+ (NSArray *)readDataWithIp:(NSString *)ipAddress dbName:(NSString *)dbName
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@",@"ipAddress",ipAddress,@"dbName",dbName];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"Company" predicate:pre];
    NSSortDescriptor *descriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"kjyear1" ascending:YES];
    NSArray *descriptors = @[descriptor1];
    return [array sortedArrayUsingDescriptors:descriptors];
}

+ (BOOL)chargeHasWithNdid:(NdidToTime *)ndid
{
    SelectState *sel = [SelectState shareInstance];
     NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@",@"ipAddress",sel.ipAddress,@"dbID",sel.dbGuid,@"ndid",ndid.ndid];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"Company" predicate:pre];
    NSInteger count = 0;
    for (CompanyTask *task in ndid.childArray) {
        for (Company *com in array) {
            if ([task.dwid integerValue] == [com.dwid integerValue]) {
                count++;
                break;
            }
        }
    }
    if (array.count > 0 && count == ndid.childArray.count) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSArray *)readDataWithIp:(NSString *)ipAddress
{
    NSMutableArray *kindArray = [NSMutableArray new];//按照dbid不同进行分组
    NSMutableArray *nameArray = [NSMutableArray new];//项目名字
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@",@"ipAddress",ipAddress];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"Company" predicate:pre];
    
    [array enumerateObjectsUsingBlock:^(Company *obj, NSUInteger idx, BOOL *stop) {
        if(![self arrayHasStr:nameArray str:obj.dbName]) {
            [nameArray addObject:obj.dbName];
        }
    }];
    for(NSString *dbName in nameArray) {
     [kindArray addObject:[self readDataWithIp:ipAddress dbName:dbName]];
    }
    return kindArray;
}


+ (BOOL)arrayHasStr:(NSArray *)array str:(NSString *)str
{
    __block int i = 0;
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if(![obj isEqualToString:str]) {
            i ++;
        }
    }];
    if(i == array.count) {
        return NO;
    }
    return YES;
}

+ (BOOL)chargeHasWithNdid:(NSString *)ndid dwid:(NSNumber *)dwid
{
    SelectState *sel = [SelectState shareInstance];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@ && %K == %@",@"ipAddress",sel.ipAddress,@"dbID",sel.dbGuid,@"ndid",ndid,@"dwid",dwid];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"Company" predicate:pre];
  
    if (array.count > 0) {
        Company *company= array[0];
        NSLog(@"%@--%@",company.xmmc,company.kjyear1);
        return YES;
    } else {
        return NO;
    }
}

@end
