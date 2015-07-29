//
//  IdenAlertData.h
//  VoucherCollection
//
//  Created by yongzhang on 15-2-12.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdenAlertData : NSObject

@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *kind;
@property (nonatomic,strong) NSNumber *idenCode;
@property (nonatomic,strong) NSString *chouYangStr;//抽样方案
@property (nonatomic,strong) NSMutableArray *tableData;//列表展示
@property (nonatomic,assign) CGFloat totalJie;//总共借
@property (nonatomic,assign) CGFloat totalDai;//总共贷

+ (IdenAlertData *)backDataFromArray:(NSArray *)array idenCode:(NSNumber *)idenCode;
+ (NSArray *)backPzbhArrayFromArray:(NSArray *)array;
@end
