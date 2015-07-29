//
//  ExamineDao.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-19.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "ExamineDao.h"
#import "SelectState.h"
#import "EntityOneDao.h"

@implementation ExamineDao
+ (void)insertDataWithDic:(NSDictionary *)dic
{
    SelectState *state = [SelectState shareInstance];
    
    NSInteger dwidI = [state.dwid integerValue];
    NSInteger ndidI = [state.ndid integerValue];
    
    NSString *parIdS = dic[@"parId"];
    
    
    NSMutableDictionary *dicm = [NSMutableDictionary new];
    [dicm setDictionary:dic];
    [dicm setValue:parIdS forKey:@"parId"];
    [dicm setValue:[NSNumber numberWithInteger:dwidI] forKey:@"dwid"];
    [dicm setValue:[NSNumber numberWithInteger:ndidI] forKey:@"ndid"];
    
    if([self canInsert:dicm]) {
        [EntityOneDao insertObjectWithParameter:dicm entityName:@"Examine"];
    }
}

//判断是否可以插入数据
+ (BOOL)canInsert:(NSDictionary *)dic
{
    
    if([EntityOneDao isEmpty:@"Examine"]) {
        return YES;
    }
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@",@"dwid",dic[@"dwid"],@"ndid",dic[@"ndid"],@"parId",dic[@"parId"] ];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"Examine" predicate:pre];
    if(array.count == 0) {
        return YES;
    }
    return NO;
    
}

+ (NSArray *)readDataWith:(NSNumber *)dwid ndid:(NSNumber *)ndid parId:(NSString *)parId
{
  NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@",@"dwid",dwid,@"ndid",ndid,@"parId",parId ];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"Examine" predicate:pre];
    return array;
}

+ (NSArray *)readDataWith:(NSNumber *)dwid ndid:(NSNumber *)ndid
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ ",@"dwid",dwid,@"ndid",ndid];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"Examine" predicate:pre];
    return array;
}
@end
