//
//  MovePicActionSheetView.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-28.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MovePicActionSheetViewDelegate<NSObject>

- (void)overChoose;

@end

@interface MovePicActionSheetView : UIView
@property (nonatomic,strong) id delegate;
@property (nonatomic,assign) BOOL fromDetail;//从详细controller中显示

- (void)start;

@end
