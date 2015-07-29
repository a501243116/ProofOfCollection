//
//  DeletePicView.m
//  VoucherCollection
//
//  Created by yongzhang on 15-1-21.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "DeletePicView.h"

@interface DeletePicView()

@end

@implementation DeletePicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeApperance];
    }
    return self;
}

- (void)initializeApperance
{
    CGFloat scaleValue = SCREEN_HEIGHT / SCREEN_WIDTH;
    CGFloat width = SCREEN_WIDTH / scaleValue;
    for (int i = 0; i < _images.count; i ++) {
    }
}

@end
