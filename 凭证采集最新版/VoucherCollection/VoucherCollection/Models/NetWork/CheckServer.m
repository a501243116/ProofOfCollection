//
//  CheckServer.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-12.
//  Copyright (c) 2014年 zy. All rights reserved.
//



#import "CheckServer.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "SelfIPAddress.h"
@implementation CheckServer

//取得内网前三段数字
- (NSString *)getSelfIp3
{
    NSInteger pointNumber = 0;//点的个数
    NSString *number = 0;//第二个点后面的数字
    
    NSInteger indexEnd = 0;
    
    NSString *selfIpAddress = [SelfIPAddress getAddress];
    for (int i = 0; i < selfIpAddress.length; i ++) {
        char c = [selfIpAddress characterAtIndex:i];
        if(c == '.') {
            pointNumber ++;
            if(pointNumber == 3) {//第三个小数点
                indexEnd = i;
                break;
            }
        }
    }
    number = [selfIpAddress substringWithRange:NSMakeRange(0,indexEnd)];
    return  number;
}

- (void)getServerIp
{
    __block BOOL hasBack = NO;//用于结束255次请求,只

   
    NSString *ip3 = [self getSelfIp3];
  
    _count = 0;
    // 创建Socket，无需回调函数函数
    for (int i = 0; i <= 255; i ++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CFSocketRef socket = CFSocketCreate(kCFAllocatorDefault
                                                , PF_INET // 指定协议族，如果该参数为0或者负数，则默认为PF_INET
                                                // 指定Socket类型，如果协议族为PF_INET，且该参数为0或负数，
                                                // 则它会默认为SOCK_STREAM，如果要使用UDP协议，则该参数指定为SOCK_DGRAM
                                                , SOCK_STREAM
                                                // 指定通信协议。如果前一个参数为SOCK_STREAM，默认使用TCP协议
                                                // 如果前一个参数为SOCK_DGRAM，默认使用UDP协议。
                                                , IPPROTO_TCP
                                                // 该参数指定下一个回调函数所监听的事件类型
                                                , kCFSocketNoCallBack
                                                , nil
                                                , NULL);
            if (socket != nil)
            {
                _count ++;
                NSLog(@"%ld",_count);
                // 定义sockaddr_in类型的变量，该变量将作为CFSocket的地址
                struct sockaddr_in addr4;
                memset(&addr4, 0, sizeof(addr4));
                addr4.sin_len = sizeof(addr4);
                addr4.sin_family = AF_INET;
                // 设置连接远程服务器的地址
                NSString *site = [NSString stringWithFormat:@"%@.%d",ip3,i];
                const char *char_content = [site cStringUsingEncoding:NSASCIIStringEncoding];
                
                addr4.sin_addr.s_addr = inet_addr(char_content);
                // 设置连接远程服务器的监听端口
                addr4.sin_port = htons(8080);
                // 将IPv4的地址转换为CFDataRef
                CFDataRef address = CFDataCreate(kCFAllocatorDefault
                                                 , (UInt8 *)&addr4, sizeof(addr4));
                // 连接远程服务器器的Socket，并返回连接的结果
                CFSocketError result = CFSocketConnectToAddress(socket
                                                                , address // 指定远程服务器的IP和端口
                                                                , 1  // 指定连接超时时长，如果该参数为负数，则把连接操作放在后台进行，
                                                                // 当_socket消息类型为kCFSocketConnectCallBack，
                                                                // 将会在连接成功或失败的时候在后台触发回调函数
                                                                );
                // 如果连接远程服务器成功
                if(result == kCFSocketSuccess)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(_delegate && [_delegate respondsToSelector:@selector(getIp:)]) {
                            [_delegate getIp:site];
                        }
                    });
                }
                CFRelease(address);
                CFRelease(socket);
                if (_count >= 250) {
                    if(!hasBack) {
                        hasBack = YES;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(_delegate && [_delegate respondsToSelector:@selector(endCheck)]) {
                                [_delegate endCheck];
                                
                            }
                        });
                    }
                }

                //                NSLog(@"%@",site);
                
            }else
            {
                _count ++;
                NSLog(@"---%ld",_count);
                if (_count >= 250) {
                    if(!hasBack) {
                        hasBack = YES;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(_delegate && [_delegate respondsToSelector:@selector(endCheck)]) {
                                [_delegate endCheck];
                                
                            }
                        });
                    }
                }

            }
            
        });
    }
}

- (void)getSerVerWithIp1:(NSString *)ip1 ip2:(NSString *)ip2 ip3:(NSString *)ip3 ip4:(NSString *)ip4
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 创建Socket，无需回调函数函数
 
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            CFSocketRef socket = CFSocketCreate(kCFAllocatorDefault
                                                , PF_INET // 指定协议族，如果该参数为0或者负数，则默认为PF_INET
                                                // 指定Socket类型，如果协议族为PF_INET，且该参数为0或负数，
                                                // 则它会默认为SOCK_STREAM，如果要使用UDP协议，则该参数指定为SOCK_DGRAM
                                                , SOCK_STREAM
                                                // 指定通信协议。如果前一个参数为SOCK_STREAM，默认使用TCP协议
                                                // 如果前一个参数为SOCK_DGRAM，默认使用UDP协议。
                                                , IPPROTO_TCP
                                                // 该参数指定下一个回调函数所监听的事件类型
                                                , kCFSocketNoCallBack
                                                , nil
                                                , NULL);
            if (socket != nil)
            {
                // 定义sockaddr_in类型的变量，该变量将作为CFSocket的地址
                struct sockaddr_in addr4;
                memset(&addr4, 0, sizeof(addr4));
                addr4.sin_len = sizeof(addr4);
                addr4.sin_family = AF_INET;
                // 设置连接远程服务器的地址
                NSString *site = [NSString stringWithFormat:@"%@",ip1];
                const char *char_content = [site cStringUsingEncoding:NSASCIIStringEncoding];
                
                addr4.sin_addr.s_addr = inet_addr(char_content);
                // 设置连接远程服务器的监听端口
                addr4.sin_port = htons(8080);
                // 将IPv4的地址转换为CFDataRef
                CFDataRef address = CFDataCreate(kCFAllocatorDefault
                                                 , (UInt8 *)&addr4, sizeof(addr4));
                // 连接远程服务器器的Socket，并返回连接的结果
                CFSocketError result = CFSocketConnectToAddress(socket
                                                                , address // 指定远程服务器的IP和端口
                                                                , 5  // 指定连接超时时长，如果该参数为负数，则把连接操作放在后台进行，
                                                                // 当_socket消息类型为kCFSocketConnectCallBack，
                                                                // 将会在连接成功或失败的时候在后台触发回调函数
                                                                );
                // 如果连接远程服务器成功
                if(result == kCFSocketSuccess)
                {
                    if(_delegate && [_delegate respondsToSelector:@selector(getIp:)]) {
                        [_delegate getIp:site];
                    }
                }
                CFRelease(address);
                CFRelease(socket);

                        if(_delegate && [_delegate respondsToSelector:@selector(endCheck)]) {
                            [_delegate endCheck];
                            
                        }
                
                NSLog(@"%@",site);
                
            }
        }];
        [queue addOperation:op];
    
}


+ (BOOL)isInWifi
{
    Reachability *rea = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([rea currentReachabilityStatus])
    {
            // 不能访问
        case NotReachable:
            return NO;
            break;
            // 使用3G/4G网络
        case ReachableViaWWAN:
            return NO;
            break;
            // 使用WiFi网络
        case ReachableViaWiFi:
            return YES;
            break;
    }
    
    return YES;
}

@end
