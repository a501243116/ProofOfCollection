//
//  PhotosList.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-18.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotosList : NSObject

@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSString *ipAddress;
@property (nonatomic,strong) NSArray *idenArray;
@property (nonatomic,strong) NSArray *idenCountArray;
@property (nonatomic,strong) NSArray *imagePaths;
@property (nonatomic,strong) NSNumber *ndId;
@property (nonatomic,strong) NSNumber *dwid;
@property (nonatomic,strong) NSString *dbID;

@end
