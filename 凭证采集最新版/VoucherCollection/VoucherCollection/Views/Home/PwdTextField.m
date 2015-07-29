//
//  PwdTextField.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-11.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "PwdTextField.h"

@implementation PwdTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 20, 25)];
        imageView.image = [UIImage imageNamed:@"icon_mm.png"];
        [self addSubview:imageView];
    }
    return self;
}



- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 40, bounds.origin.y + 5, bounds.size.width - 10 , bounds.size.height - 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 40, bounds.origin.y + 5, bounds.size.width - 10 , bounds.size.height - 10);
}
@end
