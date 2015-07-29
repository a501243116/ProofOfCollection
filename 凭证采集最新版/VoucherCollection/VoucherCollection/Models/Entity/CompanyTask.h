//
//  CompanyTask.h
//  VoucherCollection
//
//  Created by yongzhang on 15-2-9.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"

@interface CompanyTask : NSObject

@property (nonatomic,strong) NSNumber *ndid;
@property (nonatomic,strong) NSNumber *dwid;
@property (nonatomic,strong) NSString *xmcc;
@property (nonatomic , strong) Company *company;
@property (nonatomic,assign)BOOL isSelected;
@end
