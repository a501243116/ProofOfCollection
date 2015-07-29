//
//  PhotosDao.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-17.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotosDao : NSObject

+ (BOOL)hasData:(NSString *)dbID ipAddress:(NSString *)ipAddress dwid:(NSNumber *)dwid ndid:(NSNumber *)ndid iden:(NSNumber *)iden;
+ (NSArray *)getDataWithListData;
+ (NSArray *)getImagesWithIp:(NSString *)ipAddress companyName:(NSString *)companyName time:(NSString *)time;
+ (NSDictionary *)getImagesWithIp:(NSString *)ipAddress companyName:(NSString *)companyName time:(NSString *)time iden:(NSNumber *)iden dbID:(NSString *)dbID;
+ (NSDictionary *)getImagesWithIp:(NSString *)ipAddress companyName:(NSString *)companyName time:(NSString *)time iden:(NSNumber *)iden;
+ (NSArray *)getDataWithIp:(NSString *)ipAddress company:(NSString *)company time:(NSString *)time dbID:(NSString *)dbID;
+ (NSArray *)getDataWithIp:(NSString *)ipAddress company:(NSString *)company time:(NSString *)time;
+ (void)deleteByIden:(NSNumber *)iden;
+ (void)deleteByIden:(NSNumber *)iden ipAddress:(NSString *)ipAddress;

//取得单个数据
+ (NSObject *)getDataWithIp:(NSString *)ipAddress company:(NSString *)company time:(NSString *)time iden:(NSNumber *)iden dbID:(NSString *)dbID;

//取得指定目录下图片张数
+ (NSInteger)getImagesCountWithIp:(NSString *)ipAddress companyName:(NSString *)companyName time:(NSString *)time iden:(NSNumber *)iden dbID:(NSString *)dbID;

+ (NSArray *)getDataComDbIdWithIp:(NSString *)ipAddress company:(NSString *)company time:(NSString *)time;


@end
