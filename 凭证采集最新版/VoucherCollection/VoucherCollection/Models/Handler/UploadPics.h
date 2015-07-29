//
//  UploadPics.h
//  VoucherCollection
//
//  Created by yongzhang on 14-12-16.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadPics : NSObject


+ (void)uploadPicsWith:(NSNumber *)iden pictures:(NSArray *)pictures ip:(NSString *)ipAddress block:(void (^)(NSInteger status))block ;
+ (void)uploadTemPics:(NSArray *)pictures block:(void(^)(NSInteger status))block;

@end
