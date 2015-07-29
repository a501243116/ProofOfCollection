//
//  CompanyInfoFromNet.h
//  VoucherCollection
//
//  Created by yongzhang on 15-2-9.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CompanyInfoFromNet : NSManagedObject

@property (nonatomic, retain) NSString * dwid;
@property (nonatomic, retain) NSNumber * kjmonth1;
@property (nonatomic, retain) NSNumber * kjmonth2;
@property (nonatomic, retain) NSNumber * kjyear1;
@property (nonatomic, retain) NSNumber * kjyear2;
@property (nonatomic, retain) NSString * ndid;
@property (nonatomic, retain) NSString * xmmc;

@end
