//
//  ThreeImageView.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-25.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ThreeImageViewDelegate<NSObject>

- (void)backIndex:(NSInteger)index;

@end

@interface ThreeImageView : UIScrollView

@property (nonatomic,assign) id selfDelegate;

- (id)initWithImages:(NSArray *)images frame:(CGRect)frame index:(NSInteger)index;

@end
