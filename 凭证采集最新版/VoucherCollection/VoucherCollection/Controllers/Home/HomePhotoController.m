//
//  HomePhotoController.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-21.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "SelfTPicture.h"
#import "TokePhone.h"
#import "HomePhotoController.h"
#import "UIImageView+Scale.h"
#import "PhotosDao.h"
#import "SettingPlistHandler.h"
#import "InformationRatioController.h"
#import "CostDetailInfo.h"

@interface HomePhotoController ()<TPicteruDelegate>
{
    AVCaptureVideoPreviewLayer *_previewLayer;
    SelfTPicture *_tPicture;
    NSInteger _totalCount;
    UIView *_hideView;//闪光视图
    BOOL _nocamera;
    NSNumber *_hasOpen;//判断setting里面是否打开

}
@end

@implementation HomePhotoController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    [self initializeDataSource];
    [self initializeApperance];
}

- (void)initializeDataSource
{
    [self getTotalCountFromLoc];
}

- (void)initializeApperance
{
    //如果是从cell点击跳转,隐藏上一条,下一条按钮
    if(!_fromBottom) {
    _nextButton.hidden = YES;
    _lastButton.hidden = YES;
    }
    
    NSMutableString *title = [NSMutableString stringWithFormat:@"%@",self.selectState.taskTime];
    [title replaceOccurrencesOfString:@"/" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, title.length)];

    _titleLabel.text = title;
    _titleLabel2.text = self.selectState.taskThing;
    _rightTopLabel.text = self.selectState.indexTotalStr;
    _rightBottom.text = [NSString stringWithFormat:@"本条附件:%ld张",(long)_totalCount];
    
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
        [_mainView.layer insertSublayer:_previewLayer atIndex:0];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_tPicture.session startRunning];
        });
    }
    
    _hideView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, _mainView.bounds.size.height - 64)];
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
        targetSize.height = SCREEN_HEIGHT + 10 ;
    }
    if(targetSize.width > 3 * SCREEN_WIDTH) {
        targetSize.width = 3 * SCREEN_WIDTH;
        targetSize.height = 3 * (SCREEN_HEIGHT - 50 - 64);
    }
    [_previewLayer setBounds:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    [_previewLayer setPosition:CGPointMake(SCREEN_WIDTH / 2, 0.5 * (SCREEN_HEIGHT - 50 - 64))];
    
}

- (void)getTotalCountFromLoc
{
    _totalCount = [PhotosDao getImagesCountWithIp:self.selectState.ipAddress companyName:self.selectState.companyName time:self.selectState.companyTime iden:self.selectState.iden dbID:self.selectState.sdbGuid];
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)last:(id)sender {
    if(_nowSelected == 0) {
        [self showAlertWithMessage:@"当前已是第一条"];
        return;
    }
    _nowSelected --;
    [self setControllerTitle];
    if(_delegate && [_delegate respondsToSelector:@selector(backController:)]) {
        [_delegate backController:_nowSelected];
    }
    [self turnController];
}

- (IBAction)next:(id)sender {
    if(_nowSelected == _dataArray.count - 1) {
        [self showAlertWithMessage:@"当前已是最后一条"];
        return;
    }
    _nowSelected ++;
    if(_delegate && [_delegate respondsToSelector:@selector(backController:)]) {
        [_delegate backController:_nowSelected];
    }
    [self setControllerTitle];

    [self turnController];
}

- (void)setControllerTitle
{
    NSMutableString *title = [NSMutableString stringWithFormat:@"%@",self.selectState.taskTime];
    [title replaceOccurrencesOfString:@"/" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, title.length)];
    
    _titleLabel.text = title;
    _titleLabel2.text = self.selectState.taskThing;
    _rightTopLabel.text = self.selectState.indexTotalStr;
    [self getTotalCountFromLoc];
    _rightBottom.text = [NSString stringWithFormat:@"本条附件:%ld张",(long)_totalCount];

    
}

- (void)turnController
{
    if([_hasOpen isEqual:@0]) {
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InformationRatioController *controller = [storyboard instantiateViewControllerWithIdentifier:@"informationRatio"];
    Photos *photo = (Photos *)[PhotosDao getDataWithIp:self.selectState.ipAddress company:self.selectState.companyName time:self.selectState.companyTime iden:self.selectState.iden dbID:self.selectState.sdbGuid];
    
    NSDictionary *dic = [PhotosDao getImagesWithIp:self.selectState.ipAddress companyName:self.selectState.companyName time:self.selectState.companyTime iden:self.selectState.iden dbID:self.selectState.sdbGuid];
    controller.photo = photo;
    controller.images = dic[@"images"];
    controller.fromHome = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
    
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

- (void)nocamera
{
    [self showAlertWithMessage:@"设备不可用"];
    
}

- (void)readPicture:(UIImage *)image
{
    [TokePhone insertPic:image];
    _totalCount ++;
    _rightBottom.text = [NSString stringWithFormat:@"本条附件:%ld张",(long)_totalCount];
}

- (IBAction)changeFlash:(id)sender {
    NSInteger nowModel = [_tPicture changeFlash];
    switch (nowModel) {
        case 0:
            _changeFlashLabel.text = @"开启";
            break;
        case 1:
            _changeFlashLabel.text = @"关闭";
            break;
        case 2:
            _changeFlashLabel.text = @"自动";
            break;
            
        default:
            break;
    }
}
@end
