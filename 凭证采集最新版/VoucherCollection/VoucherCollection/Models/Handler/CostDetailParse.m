//
//  CostDetailParse.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-14.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "CostDetailParse.h"
#import "CostDetailInfo.h"

@implementation CostDetailParse

+ (NSArray *)getAllManuscript:(NSArray *)CostDetailInfos
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
   for(CostDetailInfo *info in CostDetailInfos)
   {
       int status = 1;
       for(NSString *str in array) {
           if([str isEqualToString:info.choose1]) {
               status = 0;
               break;
           }
       }
       if(status == 1) {
           if (info.choose1 != nil) {
           [array addObject:info.choose1];
            }
       }
   }
    
    for(CostDetailInfo *info in CostDetailInfos)
    {
        int status = 1;
        for(NSString *str in array) {
            if([str isEqualToString:info.choose2]) {
                status = 0;
                break;
            }
        }
        if(status == 1 && info.choose2 != nil) {
            [array addObject:info.choose2];
        }
    }
    return array;
}

@end
