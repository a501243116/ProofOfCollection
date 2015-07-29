//
//  SelfTPictureController.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-21.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol  TPicteruDelegate <NSObject>

- (void)readPicture:(UIImage *)image;

@end

@interface SelfTPicture : NSObject

@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureStillImageOutput *output;
@property (nonatomic,strong) AVCaptureDevice *device;
@property (nonatomic,strong) AVCaptureConnection *stillImageConnection;


@property (assign,nonatomic) id delegate;
- (void)captureStillImage;
- (NSInteger )changeFlash;

@end
