//
//  EntityOneDao.h
//  IOS_DEMO(Soldoros)
//
//  Created by ooo on 14-10-30.
//  Copyright (c) 2014年 Soldoros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntityOneDao : NSObject

//插入数据
+ (BOOL)insertObjectWithParameter:(NSDictionary *)parameters entityName:(NSString *)entityName;
//读取数据,根据谓词
+ (NSArray *)readObjectWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate;
//读取数据,根据谓词 排序 分页
+ (NSArray *)readObjectWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sort:(NSArray *)key fetch:(NSInteger)fetch limit:(NSInteger)limit;
//删除数据,根据谓词
+ (BOOL)deleteWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate;
//修改数据,根据谓词,以及传入的数据
+ (BOOL)modifyWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate modifyData:(NSDictionary *)dataDic;
//查看是否为空
+ (BOOL)isEmpty:(NSString *)entityName;
@end
