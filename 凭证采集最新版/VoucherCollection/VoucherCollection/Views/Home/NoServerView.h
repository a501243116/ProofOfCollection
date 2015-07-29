//
//  NoServerView.h
//  VoucherCollection
//
//  Created by yongzhang on 15-1-19.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NOServerViewDelegate <NSObject>

- (void)refreshButtonPressed;
- (void)inputMessage:(NSString *)message1 message2:(NSString *)message2 message3:(NSString *)message3 message4:(NSString *)message4;

@end

@interface NoServerView : UIView<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic,assign) id delegate;
@property (nonatomic,strong) UIView *inputView;//背景灰色
@property (nonatomic,strong) UIView *inputIpView;//背景灰色
@property (nonatomic , strong) UILabel *tipLabel;
- (void)showInputIpView;



@end
