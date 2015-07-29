//
//  PhotosDao.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-17.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "PhotosDao.h"
#import "EntityOneDao.h"
#import "PhotosList.h"
#import "Photos.h"

@implementation PhotosDao

+ (BOOL)hasData:(NSString *)dbID ipAddress:(NSString *)ipAddress dwid:(NSNumber *)dwid ndid:(NSNumber *)ndid iden:(NSNumber *)iden {
    //判断数据库是否有数据
   if([EntityOneDao isEmpty:@"Photos"])
   {
       return NO;
   }
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@ && %K == %@ && %K == %@",@"ipAddress",ipAddress,@"dbID",dbID,@"dwid",dwid,@"ndid",ndid,@"iden",iden ];
   NSArray *array = [EntityOneDao readObjectWithEntityName:@"Photos" predicate:pre];
    if(array.count == 0) {
        return NO;
    }
    return YES;
}

+ (NSArray *)getDataWithListData
{
    NSMutableArray *photosLists = [NSMutableArray new];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"Photos" predicate:nil];
    
    for (int i = 0; i < array.count; i ++) {
        Photos *photo = array[i];//取出每一个数据
        BOOL has = YES;
        for (int j = 0; j < photosLists.count; j ++) {//取出的数据和原来photoList中数据相比,如果存在,就不新建
            PhotosList *ph = photosLists[j];
            if([photo.ipAddress isEqualToString:ph.ipAddress] && [photo.companyName isEqualToString:ph.companyName] && [photo.companyTime isEqualToString:ph.time]) {
                has = NO;
            }
        }
        
        if(has) {
        //创建一个ph
        PhotosList *ph = [PhotosList new];
        [photosLists addObject:ph];
        ph.companyName = photo.companyName;
        ph.ipAddress = photo.ipAddress;
        ph.time = photo.companyTime;
        ph.ipAddress = photo.ipAddress;
        ph.dwid = photo.dwid;
        ph.ndId = photo.ndid;
        ph.dbID = photo.dbID;
        NSDictionary *dic = [self getImagesWithIp2:ph.ipAddress companyName:ph.companyName time:ph.time dbID:ph.dbID];
        ph.images = dic[@"images"];
        ph.imagePaths = dic[@"imagePahts"];
        ph.idenArray = dic[@"idens"];
        ph.idenCountArray = dic[@"idenCounts"];
        }
    }
    return photosLists;
}

+ (NSArray *)getImagesWithIp:(NSString *)ipAddress companyName:(NSString *)companyName time:(NSString *)time
{
    NSMutableArray *array = [NSMutableArray new];
    
    NSString *str = [NSString stringWithFormat:@"%@/%@/%@",ipAddress,companyName,time];
    NSString *path = [self getPath:str];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if([[file pathExtension] isEqualToString:@"png"]) {
            NSString *childPath = [NSString stringWithFormat:@"%@/%@",path,file];
            UIImage *image = [UIImage imageWithContentsOfFile:childPath];
            [array addObject:image];
        }
    }
    return array;
}

+ (NSDictionary *)getImagesWithIp2:(NSString *)ipAddress companyName:(NSString *)companyName time:(NSString *)time dbID:(NSString *)dbID
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSMutableArray *idens = [NSMutableArray new];
    NSMutableArray *idenCounts = [NSMutableArray new];
    NSMutableArray *images = [NSMutableArray new];
    NSMutableArray *imagePaths = [NSMutableArray new];
    
    
    //查询time下所有iden的值和图片
   NSArray *dataArray =  [self getDataComDbIdWithIp:ipAddress company:companyName time:time ];
    for(Photos *photo in dataArray) {
        [idens addObject:photo.iden];
        NSInteger count = [self getImagesCountWithIp:ipAddress companyName:companyName time:time iden:photo.iden ];
        [idenCounts addObject:[NSNumber numberWithInteger:count]];
        NSDictionary *imageAndPaths = [self getImagesWithIp:ipAddress companyName:companyName time:time iden:photo.iden ];
        [images addObjectsFromArray:imageAndPaths[@"images"]];
        [imagePaths addObjectsFromArray:imageAndPaths[@"paths"]];
        
    }
    [dic setValue:idens forKey:@"idens"];
    [dic setValue:idenCounts forKey:@"idenCounts"];
    [dic setValue:images forKey:@"images"];
    [dic setValue:imagePaths forKey:@"imagePahts"];
    
    return dic ;
}

+ (NSDictionary *)getImagesWithIp:(NSString *)ipAddress companyName:(NSString *)companyName time:(NSString *)time iden:(NSNumber *)iden dbID:(NSString *)dbID
{
    NSMutableArray *array = [NSMutableArray new];
    NSMutableArray *pathArray = [NSMutableArray new];
    
    NSString *str = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",ipAddress,dbID,companyName,time,iden];
    NSString *path = [self getPath:str];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if([[file pathExtension] isEqualToString:@"png"]) {
            NSString *childPath = [NSString stringWithFormat:@"%@/%@",path,file];
            UIImage *image = [UIImage imageWithContentsOfFile:childPath];
            if(image != nil)
                [array addObject:image];
            NSString *path = [NSString stringWithFormat:@"%@/%@",str,file];
            [pathArray addObject:path];
        }
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:array forKey:@"images"];
    [dic setValue:pathArray forKey:@"paths"];
    return dic;
}

+ (NSDictionary *)getImagesWithIp:(NSString *)ipAddress companyName:(NSString *)companyName time:(NSString *)time iden:(NSNumber *)iden
{
    NSMutableArray *array = [NSMutableArray new];
    NSMutableArray *pathArray = [NSMutableArray new];
    NSFileManager *fm = [NSFileManager defaultManager];

    NSArray *contents = [fm contentsOfDirectoryAtPath:[self getPath:ipAddress] error:nil];
    [contents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *str = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",ipAddress,obj,companyName,time,iden];
        NSString *path = [self getPath:str];
        NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
        NSString *file;
        while ((file = [dirEnum nextObject])) {
            if([[file pathExtension] isEqualToString:@"png"]) {
                NSString *childPath = [NSString stringWithFormat:@"%@/%@",path,file];
                UIImage *image = [UIImage imageWithContentsOfFile:childPath];
                if(image != nil)
                    [array addObject:image];
                NSString *path = [NSString stringWithFormat:@"%@/%@",str,file];
                [pathArray addObject:path];
            }
        }
    }];
    

    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:array forKey:@"images"];
    [dic setValue:pathArray forKey:@"paths"];
    return dic;
}


+ (NSArray *)getDataWithIp:(NSString *)ipAddress company:(NSString *)company time:(NSString *)time dbID:(NSString *)dbID
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@ && %K == %@",@"dbID",dbID,@"ipAddress",ipAddress,@"companyName",company,@"companyTime",time];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"Photos" predicate:pre];
    return array;
}

//相同dbID的数据合并
+ (NSArray *)getDataComDbIdWithIp:(NSString *)ipAddress company:(NSString *)company time:(NSString *)time
{
    NSArray *array = [self getDataWithIp:ipAddress company:company time:time];
    NSMutableArray *newArray = [NSMutableArray new];
    for(Photos *photo in array) {
        BOOL needAdd = YES;
        for(Photos *newPhoto in newArray) {
            if([newPhoto.ipAddress isEqualToString:photo.ipAddress] && [newPhoto.companyName isEqualToString:photo.companyName] && [newPhoto.companyTime isEqualToString:photo.companyTime] && ![newPhoto.dbID isEqualToString:photo.dbID] && [newPhoto.iden isEqual:photo.iden]) {
                needAdd = NO;
                break;
            }
        }
        if(needAdd) {
            [newArray addObject:photo];
        }
        
    }
    return newArray;
}

+ (NSArray *)getDataWithIp:(NSString *)ipAddress company:(NSString *)company time:(NSString *)time
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@  && %K == %@ && %K == %@",@"ipAddress",ipAddress,@"companyName",company,@"companyTime",time];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"Photos" predicate:pre];
    return array;
}

//获取文件路劲
+ (NSString *)getPath:(NSString *)str
{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *rootPath = [NSString stringWithFormat:@"Pictures/%@",str];
    NSString *filePath = [document stringByAppendingPathComponent:rootPath];
    return filePath;
}

+ (void)deleteByIden:(NSNumber *)iden
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@",@"iden",iden];
    [EntityOneDao deleteWithEntityName:@"Photos" predicate:pre];
}

+ (void)deleteByIden:(NSNumber *)iden ipAddress:(NSString *)ipAddress
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@",@"iden",iden,@"ipAddress",ipAddress];
    [EntityOneDao deleteWithEntityName:@"Photos" predicate:pre];
}

+ (NSObject *)getDataWithIp:(NSString *)ipAddress company:(NSString *)company time:(NSString *)time iden:(NSNumber *)iden dbID:(NSString *)dbID
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@ && %K == %@&& %K ==%@",@"ipAddress",ipAddress,@"companyName",company,@"companyTime",time,@"iden",iden,@"dbID",dbID];
    NSArray *array = [EntityOneDao readObjectWithEntityName:@"Photos" predicate:pre];
    if(array.count == 0) {
        return nil;
    }
    return array[0];
}

//取得指定目录下文件个数
+ (NSInteger)getImagesCountWithIp:(NSString *)ipAddress companyName:(NSString *)companyName time:(NSString *)time iden:(NSNumber *)iden
{
    __block int count = 0;
    NSFileManager *fm = [NSFileManager defaultManager];

    NSArray *array = [fm contentsOfDirectoryAtPath:[self getPath:ipAddress] error:nil];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *str = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",ipAddress,obj,companyName,time,iden];
        NSString *path = [self getPath:str];
        NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
        NSString *file;
        while ((file = [dirEnum nextObject])) {
            if([[file pathExtension] isEqualToString:@"png"]) {
                count ++;
            }
        }
    }];
    return count;
}

+ (NSInteger)getImagesCountWithIp:(NSString *)ipAddress companyName:(NSString *)companyName time:(NSString *)time iden:(NSNumber *)iden dbID:(NSString *)dbID
{
    int count = 0;
    NSString *str = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",ipAddress,dbID,companyName,time,iden];
    NSString *path = [self getPath:str];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if([[file pathExtension] isEqualToString:@"png"]) {
            count ++;
        }
    }
    return count;
}

@end
