//
//  IPInfoDao.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-17.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "IPInfoDao.h"
#import "EntityOneDao.h"
#import "IPInfos.h"
//#import "IPInfo.h"

@implementation IPInfoDao

+ (void)createIPInfo:(NSString *)ipAddress computerName:(NSString *)computerName
{
    if([self haveData:ipAddress]) {
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //新建数据库IpInfo对象
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    //新建Id
    NSInteger ipId = [defaults integerForKey:@"ipId"];
    ipId ++;
    [defaults setInteger:ipId forKey:@"ipId"];
    [defaults synchronize];
    
    [dic setValue:[NSNumber numberWithInteger:ipId] forKey:@"ipId"];
    [dic setValue:ipAddress forKey:@"ipAddress"];//ip地址
    [dic setValue:computerName forKey:@"name"];//计算机名字
    [dic setValue:@"" forKey:@"company"];
    [dic setValue:@"" forKey:@"time"];
    [EntityOneDao insertObjectWithParameter:dic entityName:NSStringFromClass([IPInfos class])];
}

+ (BOOL)haveData:(NSString *)ipAddress
{
    NSPredicate  *pre = [NSPredicate predicateWithFormat:@"%K == %@",@"ipAddress",ipAddress];
    NSArray *objs = [EntityOneDao readObjectWithEntityName:@"IPInfos" predicate:pre];
    if(objs.count > 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)modifyIPInfo:(NSString *)company time:(NSString *)time detail:(NSString *)detail iden:(NSNumber *)iden
{
    SelectState *selectState = [SelectState shareInstance];
    NSNumber *ipId = selectState.selectIpInfo.ipId;
    
    BOOL success = NO;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"IPInfos"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"ipId",ipId];
    fetchRequest.predicate = predicate;
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    NSObject *obj = array[0];
    [obj setValue:company forKey:@"company"];
    [obj setValue:time forKey:@"time"];
    [obj setValue:detail forKey:@"detail"];
    NSInteger idenI = [iden integerValue];
    [obj setValue:[NSNumber numberWithInteger:idenI] forKey:@"iden"];
    NSError *error;
    success = [context save:&error];
    NSAssert(success, @"%@",error);
    return  success;
    
}

+ (NSManagedObjectContext *)managedObjectContext
{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    return appdelegate.managedObjectContext;
}

+ (NSObject *)readDataByIp:(NSString *)ipAddress
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@",@"ipAddress",ipAddress];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"IPInfos" predicate:pre];
    return array[0];
}


@end
