//
//  TimeLocalDao.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-19.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "TimeLocalDao.h"
#import "SelectState.h"
#import "EntityOneDao.h"
#import "TimeLocal.h"
#import "AppDelegate.h"

@implementation TimeLocalDao

+ (void)insertDataWithDic:(NSDictionary *)dic
{
    NSLog(@"%@",dic);
    NSMutableDictionary *dicm = [NSMutableDictionary new];
    SelectState *state = [SelectState shareInstance];
    [dicm setDictionary:dic];
    [dicm setValue:state.ipAddress forKey:@"ipAddress"];
    if([self canInsert:dicm]) {
        [EntityOneDao insertObjectWithParameter:dicm entityName:@"TimeLocal"];
    }
}

//判断是否可以插入数据
+ (BOOL)canInsert:(NSDictionary *)dic
{
    
    if([EntityOneDao isEmpty:@"TimeLocal"]) {
        return YES;
    }
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@",@"ipAddress",dic[@"ipAddress"],@"company",dic[@"company"],@"ndId",dic[@"ndId"]];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"TimeLocal" predicate:pre];
    if(array.count == 0) {
        return YES;
    }
    return NO;
    
}

+ (NSArray *)readDataWith:(NSString *)ipAddress company:(NSString *)company
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@",@"ipAddress",ipAddress,@"company",company];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"TimeLocal" predicate:pre];
    return array;
}

+ (void)modifyTaskCount:(NSString *)ipAddress company:(NSString *)company ndid:(NSNumber *)ndid count:(NSInteger)count
{
     NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@",@"ipAddress",ipAddress,@"company",company,@"ndId",ndid];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TimeLocal"];
    fetchRequest.predicate = pre;
    NSManagedObjectContext *context = [self managedObjectContext];

    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    if(array.count > 0) {
    TimeLocal *local = array[0];
    local.taskCount = [NSNumber numberWithInteger:count];
    [context save:nil];
    }
}

+ (NSManagedObjectContext *)managedObjectContext
{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    return appdelegate.managedObjectContext;
}

+ (NSInteger)backCountWithIp:(NSString *)ipAddress company:(NSString *)company ndid:(NSNumber *)ndid
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@",@"ipAddress",ipAddress,@"company",company,@"ndId",ndid];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TimeLocal"];
    fetchRequest.predicate = pre;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    TimeLocal *local = array[0];
    return [local.taskCount integerValue];
    
}



@end
