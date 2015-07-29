//
//  InputPwdController.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-11.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetBaseController.h"
@protocol InputPwdVcDelegate<NSObject>

- (void)backJsJID:(NSDictionary *)dic;

@end

@interface InputPwdController : NetBaseController

@property (nonatomic,strong) NSString *ipAddress;
@property (nonatomic,strong) id delegate;
@property (nonatomic,assign) BOOL isFirst;
@end
