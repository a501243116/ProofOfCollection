//
//  SelfActionSheet.m
//  VoucherCollection
//
//  Created by yongzhang on 15-1-5.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "SelfActionSheet.h"

@implementation SelfActionSheet

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    if(dataArray.count <= 2) {
        for(NSString *title in dataArray) {
            [self addButtonWithTitle:title];
        }
    } else {
        for(int i = 0; i < 2; i++) {
            [self addButtonWithTitle:_dataArray[i]];
        }
        _hasShowCount = 2;
    }
}

- (void)addMore
{
    NSInteger oldCount = _hasShowCount;
    _hasShowCount += 2;
    if(_hasShowCount > _dataArray.count) {
        _hasShowCount = _dataArray.count;
    }
    for(int i = oldCount;i < _hasShowCount;i++) {
        [self addButtonWithTitle:_dataArray[i]];
    }
}

@end
