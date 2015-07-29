//
//  CheckServer.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-12.
//  Copyright (c) 2014年 zy. All rights reserved.
//

/*
 用于获取本地局域网服务器Ip
 */

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "Reachability.h"

@protocol CheckServerDelegate <NSObject>

- (void)getIp:(NSString *)address;
- (void)endCheck;

@end

@interface CheckServer : NSObject<AsyncSocketDelegate>

@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) NSInteger count;
- (void)getServerIp;
+ (BOOL)isInWifi;
- (void)getSerVerWithIp1:(NSString *)ip1 ip2:(NSString *)ip2 ip3:(NSString *)ip3 ip4:(NSString *)ip4;

@end
