//
//  PhotoController.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-20.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "BaseController.h"

@protocol PhotoControllerDelegate <NSObject>

- (void)backController:(NSInteger)index;

@end

@interface PhotoController : BaseController
@property (strong, nonatomic)  UIView *mainView;
@property (assign,nonatomic) id delegate;
@property (assign,nonatomic) BOOL hasSingleToLocTem;//有单例,但还是存入临时
- (IBAction)takePhoto:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *changeFlashLabel;

- (IBAction)changeFlashButton:(id)sender;
@end
