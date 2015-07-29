//
//  IPInfoDao.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-17.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPInfos.h"
#import "SelectState.h"
#import "AppDelegate.h"

@interface IPInfoDao : NSObject

+ (void)createIPInfo:(NSString *)ipAddress computerName:(NSString *)computerName;
+ (BOOL)modifyIPInfo:(NSString *)company time:(NSString *)time detail:(NSString *)detail iden:(NSNumber *)iden;
+ (NSObject *)readDataByIp:(NSString *)ipAddress;

@end
