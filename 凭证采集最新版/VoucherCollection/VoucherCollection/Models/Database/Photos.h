//
//  Photos.h
//  VoucherCollection
//
//  Created by yongzhang on 15-2-11.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photos : NSManagedObject

@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * companyTime;
@property (nonatomic, retain) NSNumber * dwid;
@property (nonatomic, retain) NSNumber * hasSure;
@property (nonatomic, retain) NSNumber * iden;
@property (nonatomic, retain) NSString * ipAddress;
@property (nonatomic, retain) NSNumber * ndid;
@property (nonatomic, retain) NSString * takeMoney;
@property (nonatomic, retain) NSString * taskDetail;
@property (nonatomic, retain) NSString * thing;
@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) NSString * dbName;

@end
