//
//  SettingPlistHandler.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-11.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "SettingPlistHandler.h"

@implementation SettingPlistHandler

//更新设置
+ (void)updataSettingData:(CGFloat)imgValue isClearPic:(NSInteger)isClear isShowAlert:(NSInteger)isShow isTurn:(NSInteger)isTurn
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:[self createPlist]];
    [dic setValue:[NSNumber numberWithFloat:imgValue] forKey:@"imgValue"];
    [dic setValue:[NSNumber numberWithFloat:isClear] forKey:@"isClear"];
    [dic setValue:[NSNumber numberWithFloat:isShow] forKey:@"isShow"];
    [dic setValue:[NSNumber numberWithInteger:isTurn] forKey:@"isTurn"];
    [dic writeToFile:[self createPlist] atomically:YES];
}

+ (NSString *)createPlist
{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [document stringByAppendingPathComponent:@"setting.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        //设置默认值
        [dic setValue:@50 forKey:@"imgValue"];
        [dic setValue:@1 forKey:@"isClear"];
        [dic setValue:@1 forKey:@"isShow"];
        [dic setValue:@1 forKey:@"isTurn"];
        [dic writeToFile:filePath atomically:YES];
    }
    return filePath;
}

//读取数据
+ (NSMutableDictionary *)getSettingData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:[self createPlist]];
    return dic;
}

@end
