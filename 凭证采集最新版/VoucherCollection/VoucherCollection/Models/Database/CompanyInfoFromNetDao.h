//
//  CompanyInfoFromNet.h
//  VoucherCollection
//
//  Created by yongzhang on 15-2-9.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyInfoFromNet.h"

@interface CompanyInfoFromNetDao : NSObject

+ (void)insertDataFromCompanys:(NSArray *)componys;
+ (CompanyInfoFromNet *)readData:(NSNumber *)ndid dwid:(NSNumber *)dwid;

@end
