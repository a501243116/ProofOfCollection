//
//  TokePhoneAlertView.h
//  VoucherCollection
//
//  Created by yongzhang on 14-12-15.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TokePhoneAlertViewDelegate <NSObject>

- (void)changeButtonPressed;
- (void)takePhoneButtonPressed;

@end

@interface TokePhoneAlertView : UIView

@property (nonatomic,strong) NSString *company;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *number;

@property (nonatomic,assign) id delegate;

- (id)initWithCompany:(NSString *)company time:(NSString *)time number:(NSString *)number;
- (void)show;
@end
