//
//  NdidToTime.h
//  VoucherCollection
//
//  Created by yongzhang on 15-2-9.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"

@interface NdidToTime : NSObject

@property (nonatomic,strong) NSString *ndid;
@property (nonatomic,strong) NSString *duringTime;//时间段
@property (nonatomic,strong) NSMutableArray *childArray;
@property (nonatomic , strong) Company *company;
@property (nonatomic , assign)BOOL isSelected;
@end
