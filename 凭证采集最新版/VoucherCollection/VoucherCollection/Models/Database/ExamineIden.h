//
//  ExamineIden.h
//  VoucherCollection
//
//  Created by yongzhang on 14-12-23.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ExamineIden : NSManagedObject

@property (nonatomic, retain) NSNumber * hasCheck;
@property (nonatomic, retain) NSNumber * iden;
@property (nonatomic, retain) NSString * ipAddress;
@property (nonatomic, retain) NSString * parId;
@property (nonatomic, retain) NSString * parname;

@end
