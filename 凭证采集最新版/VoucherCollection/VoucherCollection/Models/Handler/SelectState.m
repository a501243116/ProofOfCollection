//
//  SelectState.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-17.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "SelectState.h"
#import "IPInfoDao.h"
@implementation SelectState

+ (id)shareInstance
{
    static SelectState *selectState;
    static dispatch_once_t predicate;
    if(!selectState) {
        dispatch_once(&predicate, ^{
            selectState = [[SelectState alloc] init];
            
        });
    }
    return selectState;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *nowIp = [defaults stringForKey:@"rootUrl"];
//        nowIp = [nowIp substringWithRange:NSMakeRange(7, nowIp.length - 12)];
//        IPInfos *ipInfo = (IPInfos *)[IPInfoDao readDataByIp:nowIp];
//        _selectIpInfo = ipInfo;
    }
    return self;
}

@end
