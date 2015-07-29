//
//  Examine.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-19.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Examine : NSManagedObject

@property (nonatomic, retain) NSNumber * dwid;
@property (nonatomic, retain) NSNumber * ndid;
@property (nonatomic, retain) NSString * parId;
@property (nonatomic, retain) NSString * parMeanIng;
@property (nonatomic, retain) NSString * parName;
@property (nonatomic, retain) NSString * parValue;

@end
