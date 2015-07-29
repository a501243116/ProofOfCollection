//
//  HomePhotoController.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-21.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@protocol HomePhotoControllerDelegate <NSObject>

- (void)backController:(NSInteger)index;

@end

@interface HomePhotoController : BaseController
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightTopLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightBottom;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel2;
- (IBAction)changeFlash:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *changeFlashLabel;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger nowSelected;
@property (nonatomic,assign) BOOL fromBottom;//是否是点击的底部的拍照按钮

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (assign,nonatomic) id delegate;
@property (nonatomic,strong) NSString *indexTotalStr;
@property (strong, nonatomic) IBOutlet UIView *topView;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *lastButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)last:(id)sender;
- (IBAction)next:(id)sender;

- (IBAction)takePhoto:(id)sender;
@end
