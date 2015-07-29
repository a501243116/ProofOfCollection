//
//  ParseChooseTaskData.m
//  VoucherCollection
//
//  Created by yongzhang on 15-2-9.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "ParseChooseTaskData.h"
#import "NdidToTime.h"
#import "CompanyInfoFromNet.h"
#import "CompanyTask.h"
#import "Company.h"

@implementation ParseChooseTaskData

+ (NSArray *)backNdidData:(NSArray *)array
{
    NSMutableArray *tempNdids = [NSMutableArray new];
    NSMutableArray *tempTimes = [NSMutableArray new];
    
    for(NSDictionary *dic in array) {
        NSString *ndid = dic[@"ndid"];
        if([tempNdids indexOfObject:ndid] == NSNotFound) {
            [tempNdids addObject:ndid];
            NdidToTime *obj = [NdidToTime new];
            obj.ndid = ndid;
            obj.duringTime = [NSString stringWithFormat:@"%@年%@月-%@月",dic[@"kjyear1"],dic[@"kjmonth1"],dic[@"kjmonth2"]];
            obj.company = dic[@"company"];
            [tempTimes addObject:obj];
        }
    }
    
    for(NSDictionary *dic in array) {
        NSString *ndid = dic[@"ndid"];
        for(NdidToTime *obj in tempTimes) {
            if([ndid isEqual:obj.ndid]) {
                CompanyTask *task = [CompanyTask new];
                task.ndid = dic[@"ndid"];
                task.dwid = dic[@"dwid"];
                task.xmcc = dic[@"xmmc"];
                task.company = dic[@"company"];
                
                [obj.childArray addObject:task];
                break;
            }
        }
    }
    return tempTimes;
}

+ (NSMutableArray *)backDictionArrayFromObj:(NSArray *)databases;//把数据对象转换位字典对象
{
    NSMutableArray *array = [NSMutableArray new];
    for(CompanyInfoFromNet *obj in databases) {
        NSMutableDictionary *dic = [NSMutableDictionary new];

        dic[@"dwid"] = obj.dwid;
        dic[@"kjmonth1"] = obj.kjmonth1;
        dic[@"kjmonth2"] = obj.kjmonth2;
        dic[@"kjyear1"] = obj.kjyear1;
        dic[@"kjyear2"] = obj.kjyear2;
        dic[@"ndid"] = obj.ndid;
        dic[@"xmmc"] = obj.xmmc;
      
        [array addObject:dic];
    }
    return array;
}

+ (NSMutableArray *)backDictionArrayFromCompanyObj:(NSArray *)databases
{
    NSMutableArray *array = [NSMutableArray new];
    for(Company *obj in databases) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        dic[@"dwid"] = obj.dwid;
        dic[@"kjmonth1"] = obj.kjmonth1;
        dic[@"kjmonth2"] = obj.kjmonth2;
        dic[@"kjyear1"] = obj.kjyear1;
        dic[@"kjyear2"] = obj.kjyear2;
        dic[@"ndid"] = obj.ndid;
        dic[@"xmmc"] = obj.xmmc;
        dic[@"company"] = obj;
        [array addObject:dic];
    }
    return array;
}


+ (NSDictionary *)backPostionWithIndex:(NSInteger)index array:(NSArray *)array
{
    NSArray *_postions = [self backPositionWithArray:array];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < _postions.count; i ++) {
        if(index == [_postions[i] integerValue])
        {
            [dic setValue:@1 forKey:@"isHeader"];
            [dic setValue:[NSNumber numberWithInt:i] forKey:@"position"];
            break;
        }
        if(index > [_postions[_postions.count - 1] integerValue]) {
            [dic setValue:@0 forKey:@"isHeader"];
            [dic setValue:[NSNumber numberWithLong:_postions.count - 1] forKey:@"position1"];
            NSInteger last = [_postions[_postions.count - 1] integerValue];
            [dic setValue:[NSNumber numberWithLong:(index - last) ] forKey:@"position2"];
            break;
        }
        NSInteger last = [_postions[i] integerValue];
        NSInteger next = [_postions[i + 1] integerValue];
        if(index > last && index < next) {
            [dic setValue:@0 forKey:@"isHeader"];
            [dic setValue:[NSNumber numberWithInt:i] forKey:@"position1"];
            [dic setValue:[NSNumber numberWithLong:(index - last) ] forKey:@"position2"];
            break;
        }
        
    }
    return dic;
}

+ (NSArray *)backPositionWithArray:(NSArray *)array
{
    NSMutableArray *postions = [NSMutableArray new];
    int count = 0;
    for(int i = 0;i < array.count; i++)
    {
        [postions addObject:[NSNumber numberWithInt:count]];
        count ++;
        NdidToTime *childSc = array[i];
        count += childSc.childArray.count;
    }
    return postions;
}


@end
