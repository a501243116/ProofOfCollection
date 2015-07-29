//
//  IPInfos.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-21.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IPInfos : NSManagedObject

@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSString * ipAddress;
@property (nonatomic, retain) NSNumber * ipId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSNumber * iden;

@end
