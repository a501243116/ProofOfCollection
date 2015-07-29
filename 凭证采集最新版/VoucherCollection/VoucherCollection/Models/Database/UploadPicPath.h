//
//  UploadPicPath.h
//  VoucherCollection
//
//  Created by yongzhang on 14-12-24.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UploadPicPath : NSManagedObject

@property (nonatomic, retain) NSString * spId;
@property (nonatomic, retain) NSString * path;

@end
