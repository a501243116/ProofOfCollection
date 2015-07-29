//
//  CostDetailInfo.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-13.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "CostDetailInfo.h"

@implementation CostDetailInfo

- (void)setCyfaname:(NSString *)cyfaname
{
    _cyfaname = cyfaname;
    if (cyfaname.length == 0) {
        return;
    }
//    NSInteger index;
//    for (int i = 0; i < cyfaname.length; i ++) {
//        char c = [_cyfaname characterAtIndex:i];
//        if(c == '-') {
//            index = i;
//            break;
//        }
//    }
//    _choose1 = [cyfaname substringToIndex:index];
//    _choose2 = [cyfaname substringWithRange:NSMakeRange(index + 1, cyfaname.length - index -1)];
}

@end
