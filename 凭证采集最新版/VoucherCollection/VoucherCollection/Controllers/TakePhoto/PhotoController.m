//
//  PhotoController.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-20.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "PhotoController.h"
#import "SelfTPicture.h"
#import "TokePhone.h"

@interface PhotoController ()<TPicteruDelegate>
{
    SelfTPicture *_tPicture;
    BOOL _nocamera;
    UIView *_hideView;//闪光视图
    AVCaptureVideoPreviewLayer *_previewLayer;
    
}

@end

@implementation PhotoController



- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"拍照";
    
    [super viewWillAppear:YES];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"图片库" forState:UIControlStateNormal];
    leftButton.bounds = CGRectMake(0, 0, 70, 25);
    [leftButton addTarget:self action:@selector(leftPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"项目选择" forState:UIControlStateNormal];
    rightButton.bounds = CGRectMake(0, 0, 100, 25);
    [rightButton addTarget:self action:@selector(rightPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeApperance];
}

- (void)leftPressed:(UIButton *)sender
{
    [_tPicture.session stopRunning];
    [self.navigationController popViewControllerAnimated:NO];
    if(_delegate && [_delegate respondsToSelector:@selector(backController:)]) {
        [_delegate backController:2];
    }

}

- (void)rightPressed:(UIButton *)sender
{
    [_tPicture.session stopRunning];
    [self.navigationController popViewControllerAnimated:NO];
    if(_delegate && [_delegate respondsToSelector:@selector(backController:)]) {
        [_delegate backController:0];
    }
}

- (void)initializeApperance
{
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -50)];
    [self.view insertSubview:_mainView atIndex:0];
    if(_tPicture == nil) {
        _tPicture  = [[SelfTPicture alloc] init];
        _tPicture.delegate = self;
        if (_tPicture.device == nil) {
            _nocamera = YES;
            [self performSelector:@selector(nocamera) withObject:nil afterDelay:1];
            return;
        }
        
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_tPicture.session];
        _previewLayer.frame = _mainView.bounds;
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        _mainView.layer.masksToBounds = YES;
        _mainView.clipsToBounds = YES;
        [_mainView.layer insertSublayer:_previewLayer atIndex:0];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_tPicture.session startRunning];
        });
    }
    
    _hideView = [[UIView alloc] initWithFrame:_mainView.frame];
    _hideView.backgroundColor = COLOR4(100, 100, 100, 1);
    _hideView.hidden = YES;
    [_mainView addSubview:_hideView];
    // 创建UIPinchGestureRecognizer手势处理器，该手势处理器激发scaleImage方法
    UIPinchGestureRecognizer* gesture = [[UIPinchGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(scaleImage:)];
    // 为imageView添加手势处理器
    _mainView.userInteractionEnabled = YES;
    [_mainView addGestureRecognizer:gesture];
  
}

- (void)scaleImage:(UIPinchGestureRecognizer*)gesture
{
    CGFloat scale = gesture.scale;
    
    //    // 根据手势处理的缩放比计算图片缩放后的目标大小
    CGSize targetSize = CGSizeMake(_previewLayer.bounds.size.width * scale ,
                                   _previewLayer.bounds.size.height * scale);
    //对太大或者太小进行判断
    if (targetSize.width < SCREEN_WIDTH) {
        targetSize.width = SCREEN_WIDTH;
        targetSize.height = SCREEN_HEIGHT - 50 - 64;
    }
    if(targetSize.width > 3 * SCREEN_WIDTH) {
        targetSize.width = 3 * SCREEN_WIDTH;
        targetSize.height = 3 * (SCREEN_HEIGHT - 50 - 64);
    }
    [_previewLayer setBounds:CGRectMake(0, 0, targetSize.width, targetSize.height)];
//    [_previewLayer setPosition:CGPointMake(targetSize.width / 2, targetSize.height / 2)];
    [_previewLayer setPosition:CGPointMake(SCREEN_WIDTH / 2, 0.5 * (SCREEN_HEIGHT - 50 - 64))];

}

- (void)nocamera
{
    [self showAlertWithMessage:@"设备不可用"];
}


- (IBAction)takePhoto:(id)sender {
    if(_nocamera) {
        [self showAlertWithMessage:@"设备不可用"];

        return;
    }
    if(_hideView.hidden == NO) {
        return;
    }
    
    [UIView animateWithDuration:2 animations:^{
        _hideView.hidden = NO;
        _hideView.alpha = 0.1;
    } completion:^(BOOL finished) {
        _hideView.hidden = YES;
        _hideView.alpha = 1;

    }];
    
    [_tPicture captureStillImage];
}

- (IBAction)changeFlashButton:(id)sender {
    NSInteger nowModel = [_tPicture changeFlash];
    
    switch (nowModel) {
        case 0:
            _changeFlashLabel.text = @"开启";
            [sender setImage:[UIImage imageNamed:@"ic_camera_top_bar_flash_torch_click"] forState:UIControlStateNormal];
            break;
        case 1:
            _changeFlashLabel.text = @"关闭";
            [sender setImage:[UIImage imageNamed:@"ic_camera_top_bar_flash_torch_normal"] forState:UIControlStateNormal];
            break;
        case 2:
            _changeFlashLabel.text = @"自动";
            [sender setImage:[UIImage imageNamed:@"ic_camera_top_bar_flash_on_click"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)readPicture:(UIImage *)image
{
    SelectState *selectState = [SelectState shareInstance];
    if(selectState.selectIpInfo && !_hasSingleToLocTem) {
    [TokePhone insertPicAtLoc:image];
    } else {
        [TokePhone insertPicToTemp:image];
    }
}

- (IBAction)switchCamera:(UIButton *)sender {
    
    [_tPicture.session beginConfiguration];
    NSArray *devices = [AVCaptureDevice devices];
    sender.selected = !sender.selected;
    AVCaptureDevice *tempPut;
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                tempPut = device;
                if (sender.selected == NO) {
                    break;
                }
            }
            else {
                tempPut = device;
                if (sender.selected == YES) {
                    break;
                }
            }
        }
    }
    AVCaptureInput* currentCameraInput = [_tPicture.session.inputs objectAtIndex:0];
    [_tPicture.session removeInput:currentCameraInput];
    AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:tempPut error:nil];
    [_tPicture.session addInput:newVideoInput];
    [_tPicture.session commitConfiguration];
}

@end
