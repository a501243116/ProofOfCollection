//
//  SelfTPictureController.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-21.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "SelfTPicture.h"
#import "SettingPlistHandler.h"
#import "UIImageView+Scale.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SelfTPicture ()
{
    SystemSoundID crash;
    NSInteger _nowFlashModel;//defalut Auto
    AVCaptureConnection *_stillImageConnection;

}

@end

@implementation SelfTPicture

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nowFlashModel = -1;
        [self initlizeCamera];
        NSURL* crashUrl = [[NSBundle mainBundle]
                           URLForResource:@"crash" withExtension:@"wav"];
        // 加载两个音效文件
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)crashUrl , &crash);
    }
    return self;
}

- (NSInteger )changeFlash
{
    _nowFlashModel ++;
    if(_nowFlashModel == 3) {
        _nowFlashModel = 0;
    }
    if([_device hasFlash]) {
        if([_device lockForConfiguration:nil]) {
            switch (_nowFlashModel) {
                case 0:
    
                    if([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
                        [_device setFlashMode:AVCaptureFlashModeOn];
                    }
                    break;
                case 1:
                    
                    if([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
                        [_device setFlashMode:AVCaptureFlashModeOff];
                    }
                    break;
                case 2:
                    
                    if([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
                        [_device setFlashMode:AVCaptureFlashModeAuto];
                    }
                    break;
        
                    
                default:
                    break;
            }

            
            [_device unlockForConfiguration];
            
        }
    }
    return  _nowFlashModel;
}

- (void)initlizeCamera
{
    //初始化相机设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    if(_device == nil) {
        return;
    }
    [_device lockForConfiguration:nil];
    _device.videoZoomFactor = 50;
    [_device unlockForConfiguration];
    
    //输入设备
    AVCaptureDeviceInput *videoIntput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    
    //输出端
    //先获取图片质量
    _output = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSeetings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,AVVideoQualityKey,@1, nil];
    [_output setOutputSettings:outputSeetings];
    
    //Session对象
    _session = [[AVCaptureSession alloc] init];
    [_session addInput:videoIntput];
    [_session addOutput:_output];
    
    AVCaptureConnection *stillImageConnection = nil;
    for (AVCaptureConnection *connection in _output.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                stillImageConnection = connection;
                break;
            }
        }}
    _stillImageConnection = stillImageConnection;
//
}

- (void)captureStillImage
{
 
    [_output captureStillImageAsynchronouslyFromConnection:_stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(imageDataSampleBuffer != nil) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            
            NSNumber *number = [SettingPlistHandler getSettingData][@"imgValue"];
            CGFloat scale = [number integerValue] / 100.0 ;
            
            CGSize initSize = image.size;
            CGSize nowSize = CGSizeMake(initSize.width * scale, initSize.height *scale);
            image = [UIImageView scale:image toSize:nowSize];
            
            if(_delegate && [_delegate respondsToSelector:@selector(readPicture:)]) {
                [_delegate readPicture:image];
            }

        }
    }];
}

@end
