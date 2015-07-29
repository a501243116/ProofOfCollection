//
//  TokePhone.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-17.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "TokePhone.h"
#import "Photos.h"
#import "EntityOneDao.h"
#import "PhotosDao.h"
#import "CostDetailInfo.h"
//#import “sys/xattr.h”
#import "sys/xattr.h"

@implementation TokePhone

+ (void)insertPic:(UIImage *)image
{
    //获取单例
    SelectState *selectState = [SelectState shareInstance];
    
    //设置当前选中的IP
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:selectState.ipAddress forKey:@"ipAddress"];
    [userDefaults synchronize];
    
    //设置选中的信息路劲
    [IPInfoDao modifyIPInfo:selectState.companyName time:selectState.companyTime detail:selectState.taskDetail iden:selectState.iden];
   
    //修改单例中的数据
    selectState.selectIpInfo.company = selectState.companyName;
    selectState.selectIpInfo.time = selectState.companyTime;
    selectState.selectIpInfo.detail = selectState.taskDetail;
    NSInteger idenI = [selectState.iden integerValue];
    selectState.selectIpInfo.iden = [NSNumber numberWithInteger:idenI];
    
    //存入图片
    [self insertPicAtLoc:image];
    
    //插入图片数据库
    [self insertPhotosData];
}






//判断指定路劲是否存在
+ (void)insertPicAtLoc:(UIImage *)image
{
    SelectState *selectState = [SelectState shareInstance];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //判断
    NSString *taskPath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",selectState.selectIpInfo.ipAddress,selectState.sdbGuid,selectState.selectIpInfo.company,selectState.selectIpInfo.time,selectState.selectIpInfo.iden];
    if(![fileManager fileExistsAtPath:[self getPath:taskPath]])
    {
        [fileManager createDirectoryAtPath:[self getPath:taskPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //获取图片名字
    NSInteger count = [userDefaults integerForKey:taskPath];
    count ++;
    [userDefaults setInteger:count forKey:taskPath];
    [userDefaults synchronize];
    NSString *picName = [NSString stringWithFormat:@"pic%ld.png",(long)count];
    NSString *picPath = [NSString stringWithFormat:@"%@/%@",taskPath,picName];
    
    
    [fileManager createFileAtPath:[self getPath:picPath] contents:UIImagePNGRepresentation(image) attributes:nil];
    NSLog(@"%@",[self getPath:picPath]); 
}


 //获取文件路劲
+ (NSString *)getPath:(NSString *)str
{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *rootPath = [NSString stringWithFormat:@"Pictures/%@",str];
    NSString *filePath = [document stringByAppendingPathComponent:rootPath];
    return filePath;
}

// 插入数据库表
+ (void)insertPhotosData
{
    SelectState *selectState = [SelectState shareInstance];
    if([PhotosDao hasData:selectState.sdbGuid ipAddress:selectState.ipAddress dwid:selectState.dwid ndid:selectState.ndid iden:selectState.iden])
    {
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    NSInteger dwidI = [selectState.dwid integerValue];
    NSInteger idenI = [selectState.iden integerValue];
    NSInteger ndidI = [selectState.ndid integerValue];
    
    [dic setValue:selectState.companyName forKey:@"companyName"];
    [dic setValue:selectState.companyTime forKey:@"companyTime"];
    [dic setValue:selectState.ipAddress forKey:@"ipAddress"];
    [dic setValue:selectState.taskDetail forKey:@"taskDetail"];
    [dic setValue:[NSNumber numberWithInteger:dwidI] forKey:@"dwid"];
    [dic setValue:[NSNumber numberWithInteger:idenI]  forKey:@"iden"];
    [dic setValue:[NSNumber numberWithInteger:ndidI] forKey:@"ndid"];
    [dic setValue:@0 forKey:@"hasSure"];
    [dic setValue:selectState.thing forKey:@"thing"];
    [dic setValue:selectState.takeMoney forKey:@"takeMoney"];
    [dic setValue:selectState.sdbGuid forKey:@"dbID"];
    [dic setValue:selectState.sprojectName forKey:@"dbName"];
    
    NSLog(@"%@",dic);
    
    [EntityOneDao insertObjectWithParameter:dic entityName:NSStringFromClass([Photos class])];
}

+ (NSMutableArray *)filter:(NSMutableArray *)array
{
    SelectState *selectState = [SelectState shareInstance];
//    NSMutableArray *newArray = [NSMutableArray new];
//    for(CostDetailInfo *info in array) {
//        if(![PhotosDao hasData:selectState.sdbGuid ipAddress:selectState.ipAddress dwid:selectState.dwid ndid:selectState.ndid iden:info.iden])
//        {
//            [newArray addObject:info];
//        }
//    }
    for (int i=0; i<array.count; i++) {
        NSMutableArray *tempArr = array[i];
        for(int j=0;j<tempArr.count;j++) {
            CostDetailInfo *info = tempArr[j];
            if([PhotosDao hasData:selectState.sdbGuid ipAddress:selectState.ipAddress dwid:selectState.dwid ndid:selectState.ndid iden:info.iden])
            {
                [tempArr removeObjectAtIndex:j];
                j--;
            }
        }
        if (tempArr.count == 0) {
            [array removeObjectAtIndex:i];
            i--;
        }
    }
    return array;
}

+ (void)deleteImgWithPath:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:[self getPath:path] error:nil];
}

+ (void)deleteImgWIthFullPath:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:nil];
}

//自由拍摄,存入临时文件夹
+ (void)insertPicToTemp:(UIImage *)image
{
    //判断
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *taskPath = @"tempPic";
    if(![fileManager fileExistsAtPath:[self getPath:taskPath]])
    {
        [fileManager createDirectoryAtPath:[self getPath:taskPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //获取图片名字
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger count = [userDefaults integerForKey:taskPath];
    count ++;
    [userDefaults setInteger:count forKey:taskPath];
    [userDefaults synchronize];
    NSString *picName = [NSString stringWithFormat:@"pic%ld.png",(long)count];
    NSString *picPath = [NSString stringWithFormat:@"%@/%@",taskPath,picName];
    
    NSLog(@"%@",[self getPath:picPath]);
    [fileManager createFileAtPath:[self getPath:picPath] contents:UIImagePNGRepresentation(image) attributes:nil];
}

+ (NSDictionary *)getImagesFromTemp
{
    NSMutableArray *array = [NSMutableArray new];
    NSMutableArray *pathArray = [NSMutableArray new];
    
    NSString *str = @"tempPic";
    NSString *path = [self getPath:str];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if([[file pathExtension] isEqualToString:@"png"]) {
            NSString *childPath = [NSString stringWithFormat:@"%@/%@",path,file];
            UIImage *image = [UIImage imageWithContentsOfFile:childPath];
            [array addObject:image];
            NSString *path = [NSString stringWithFormat:@"%@/%@",str,file];
            path = [self getPath:path];
            [pathArray addObject:path];
        }
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:array forKey:@"images"];
    [dic setValue:pathArray forKey:@"paths"];
    return dic;
}

@end
