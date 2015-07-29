//
//  Company.h
//  VoucherCollection
//
//  Created by yongzhang on 15-2-10.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) NSString * dbName;
@property (nonatomic, retain) NSNumber * dwid;
@property (nonatomic, retain) NSString * ipAddress;
@property (nonatomic, retain) NSNumber * kjmonth1;
@property (nonatomic, retain) NSNumber * kjmonth2;
@property (nonatomic, retain) NSNumber * kjyear1;
@property (nonatomic, retain) NSNumber * kjyear2;
@property (nonatomic, retain) NSNumber * ndid;
@property (nonatomic, retain) NSString * xmmc;

@end
