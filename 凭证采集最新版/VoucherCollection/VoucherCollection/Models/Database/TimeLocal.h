//
//  TimeLocal.h
//  VoucherCollection
//
//  Created by yongzhang on 15-2-10.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimeLocal : NSManagedObject

@property (nonatomic, retain) NSString * ipAddress;
@property (nonatomic, retain) NSNumber * kjMonth1;
@property (nonatomic, retain) NSNumber * kjMonth2;
@property (nonatomic, retain) NSNumber * kjYear1;
@property (nonatomic, retain) NSNumber * kjYear2;
@property (nonatomic, retain) NSNumber * ndId;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * pzfjCount;
@property (nonatomic, retain) NSNumber * taskCount;

@end
