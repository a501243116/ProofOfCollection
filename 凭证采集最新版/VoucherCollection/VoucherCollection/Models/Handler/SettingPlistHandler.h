//
//  SettingPlistHandler.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-11.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingPlistHandler : NSObject

+ (void)updataSettingData:(CGFloat)imgValue isClearPic:(NSInteger)isClear isShowAlert:(NSInteger)isShow isTurn:(NSInteger)isTurn;
+ (NSMutableDictionary *)getSettingData;

@end
