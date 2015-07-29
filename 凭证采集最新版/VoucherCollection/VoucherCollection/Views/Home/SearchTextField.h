//
//  SearchTextField.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-11.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchTextFieldDelegate <NSObject>

- (void)searchButtonPressed;

@end

@interface SearchTextField : UITextField
@property (nonatomic,assign) id selfDelegate;

@end
