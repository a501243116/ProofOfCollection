 //
//  EntityOneDao.m
//  IOS_DEMO(Soldoros)
//
//  Created by ooo on 14-10-30.
//  Copyright (c) 2014年 Soldoros. All rights reserved.
//

#import "EntityOneDao.h"
#import "AppDelegate.h"

@interface EntityOneDao()

+ (NSManagedObjectContext *)managedObjectContext;

@end

@implementation EntityOneDao

//数据插入
+ (BOOL)insertObjectWithParameter:(NSDictionary *)parameters entityName:(NSString *)entityName
{
    BOOL success = NO;
    NSManagedObjectContext *context = [self managedObjectContext];
    //1.获取数据
    NSDictionary *info = parameters;
    //2.新建模型对象
    NSManagedObject *contact = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    for (NSString *key in info) {
        [contact setValue:info[key] forKey:key];
    }
    NSError *error = nil;
    success = [context save:&error];
    NSAssert(success, @"%@",error);
    return success;
}

//判断是否存在
+ (BOOL)chargeHas:(NSDictionary *)dic
{
    NSMutableString *formatStr = [NSMutableString new];
    for(int i = 0 ;i < dic.allKeys.count; i ++) {
        NSString *key = dic.allKeys[i];
    }
    return NO;
}

//数据的读取
+ (NSArray *)readObjectWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = predicate;
    NSArray *objects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    return objects;
}

+ (NSArray *)readObjectWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sort:(NSArray *)key fetch:(NSInteger)fetch limit:(NSInteger)limit
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    NSMutableArray *sortArr = [NSMutableArray array];
    for (NSString *str in key) {
        NSSortDescriptor* sorting = [NSSortDescriptor sortDescriptorWithKey:str ascending:YES];
        [sortArr addObject:sorting];
    }
    [fetchRequest setSortDescriptors:sortArr];
    fetchRequest.predicate = predicate;
    [fetchRequest setFetchOffset:fetch];
    [fetchRequest setFetchLimit:limit];
    NSArray *objects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    return objects;
}

+ (NSManagedObjectContext *)managedObjectContext
{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    return appdelegate.managedObjectContext;
}

//数据的删除
+ (BOOL)deleteWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate
{
    BOOL success = NO;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    fetchRequest.predicate = predicate;
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    if(array.count > 0 ) {
    for(id obj in array) {
        [context deleteObject:obj];
    }
    NSError *error;
    success = [context save:&error];
    NSAssert(success,@"%@",error);
    }
    return success;
}

//数据的修改
+ (BOOL)modifyWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate modifyData:(NSDictionary *)dataDic
{
    BOOL success = NO;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    fetchRequest.predicate = predicate;
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    NSObject *obj = array[0];
    for(NSString *key in [dataDic allKeys]) {
        [obj setValue:dataDic[key] forKey:key];
    }
    NSError *error;
    success = [context save:&error];
    NSAssert(success, @"%@",error);
    return  success;
}

//判断是否为空
+ (BOOL)isEmpty:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = nil;
    fetchRequest.fetchLimit = 1;
    NSArray *objects;
    objects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    if(objects.count == 0) {
        return YES;
    }
    return NO;
}

//修改数据


@end
