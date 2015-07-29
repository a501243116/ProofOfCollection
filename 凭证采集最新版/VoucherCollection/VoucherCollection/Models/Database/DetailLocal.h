//
//  DetailLocal.h
//  VoucherCollection
//
//  Created by yongzhang on 15-2-12.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DetailLocal : NSManagedObject

@property (nonatomic, retain) NSNumber * bh;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * cyfaname;
@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) NSString * dffse;
@property (nonatomic, retain) NSNumber * dwid;
@property (nonatomic, retain) NSNumber * fjstatus;
@property (nonatomic, retain) NSNumber * iden;
@property (nonatomic, retain) NSString * ipAddress;
@property (nonatomic, retain) NSString * jffse;
@property (nonatomic, retain) NSString * jzsj;
@property (nonatomic, retain) NSNumber * kjmonth;
@property (nonatomic, retain) NSNumber * kjyear;
@property (nonatomic, retain) NSNumber * ndid;
@property (nonatomic, retain) NSNumber * pzbh;
@property (nonatomic, retain) NSString * pzzl;
@property (nonatomic, retain) NSString * sm;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * chouYang;
@property (nonatomic, retain) NSString * kmmc;
@property (nonatomic, retain) NSString * kmbh;
@property (nonatomic, retain) NSNumber *isSelected;//默认0选中
@end
