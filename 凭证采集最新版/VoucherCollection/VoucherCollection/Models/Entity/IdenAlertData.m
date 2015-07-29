//
//  IdenAlertData.m
//  VoucherCollection
//
//  Created by yongzhang on 15-2-12.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "IdenAlertData.h"
#import "CostDetailInfo.h"
#import "NSArray+ArrayHasStr.h"

@implementation IdenAlertData

/*
 @property (nonatomic,strong) NSString *time;
 @property (nonatomic,strong) NSString *kind;
 @property (nonatomic,strong) NSNumber *idenCode;
 @property (nonatomic,strong) NSString *chouYangStr;//抽样方案
 @property (nonatomic,strong) NSArray *tableData;//列表展示
 @property (nonatomic,strong) NSNumber *totalJie;//总共借
 @property (nonatomic,strong) NSNumber *totalDai;//总共贷
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        _tableData = [NSMutableArray new];
    }
    return self;
}

+ (IdenAlertData *)backDataFromArray:(NSArray *)array idenCode:(NSNumber *)idenCode
{
    IdenAlertData *data = [IdenAlertData new];
    [array enumerateObjectsUsingBlock:^(CostDetailInfo *obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"%@----%@----%@",obj.pzbh,obj.bh,idenCode);
        if([obj.pzbh isEqualToNumber:idenCode]) {
            data.time = obj.jzsj;
            data.kind = obj.pzzl;
            data.idenCode = obj.pzbh;
            if (obj.cyfaname != nil) {
                data.chouYangStr = obj.cyfaname;
            }
//            char c = [obj.dffse characterAtIndex:0];
//            NSString *showPrice;
//            if(c == 48) {
//                showPrice = [NSString stringWithFormat:@"贷:%@",obj.jffse];
//            } else {
//                showPrice = [NSString stringWithFormat:@"借:%@",obj.dffse];
//            }
            [data.tableData addObject:obj];
            data.totalJie += [obj.jffse floatValue];
            data.totalDai += [obj.dffse floatValue];
        }

        
    }];
    return data;
}

+ (NSArray *)backPzbhArrayFromArray:(NSArray *)array
{
    NSMutableArray *pzbhArray = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(CostDetailInfo *obj, NSUInteger idx, BOOL *stop) {
        if(![NSArray arrayHasStr:obj.pzbh array:pzbhArray]) {
            [pzbhArray addObject:obj.pzbh];
        }
        
    }];
    return pzbhArray;
}

@end
