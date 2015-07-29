//
//  ShowTempView.h
//  VoucherCollection
//
//  Created by yongzhang on 15-1-6.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShowTempViewDelegate<NSObject>

- (void)backLongPressedPath:(NSString *)tempClickPicPath;
- (void)backSingeleIndex:(NSInteger)index;

@end

@interface ShowTempView : UIView

@property (nonatomic,assign) id delegate;

@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSArray *imagePaths;

@end
