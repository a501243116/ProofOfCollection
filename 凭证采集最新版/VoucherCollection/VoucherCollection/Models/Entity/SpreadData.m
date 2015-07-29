//
//  SpreadData.m
//  TestThreeAgreeTableView
//
//  Created by yongzhang on 15-1-27.
//  Copyright (c) 2015年 yongzhang. All rights reserved.
//

#import "SpreadData.h"

@implementation SpreadData

- (id)initWithSpreedClass:(SpreadClass *)sc section:(NSInteger)section;
{
    self = [super init];
    if (self) {
        _section = section;
        _postions = [NSMutableArray new];
        int count = 0;
        for(int i = 0;i < sc.childArray.count; i++)
        {
            [_postions addObject:[NSNumber numberWithInt:count]];
            count ++;
            SpreadClass *childSc = sc.childArray[i];
            if(childSc.isOPen) {
                count += childSc.childArray.count;
            }
        }
    }
    return self;
}

- (NSDictionary *)backPostionWithIndex:(NSInteger)index
{
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

@end
