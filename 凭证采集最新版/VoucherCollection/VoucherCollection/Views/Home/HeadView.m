//
//  HeadView.m
//  TestThreeAgreeTableView
//
//  Created by yongzhang on 15-1-27.
//  Copyright (c) 2015年 yongzhang. All rights reserved.
//

#import "HeadView.h"
#import "SpreadClass.h"

@interface HeadView()
{
    UIButton *_bgButton;
    UILabel *_numLabel;
    UIImageView *_dropImageView;
}

@end
@implementation HeadView

+ (instancetype)headViewWithTableView:(UITableView *)tableView
{
    static NSString *headIdentifier = @"header";
    
    HeadView *headView = [tableView dequeueReusableCellWithIdentifier:headIdentifier];
    if (headView == nil) {
        headView = [[HeadView alloc] initWithReuseIdentifier:headIdentifier];
    }
    
    return headView;
}


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bgButton.imageView.contentMode = UIViewContentModeCenter;
        bgButton.imageView.clipsToBounds = NO;
        bgButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        bgButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        bgButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [bgButton addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bgButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:bgButton];
        _bgButton = bgButton;
        
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:numLabel];
        _numLabel = numLabel;
        
        _dropImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 18, 8, 14)];
        _dropImageView.image = [UIImage imageNamed:@"drop_normal.png"];
        [self addSubview:_dropImageView];
    }
    return self;
}

- (void)headBtnClick
{
    _sc.isOPen = !_sc.isOPen;
    if ([_delegate respondsToSelector:@selector(clickHeadView)]) {
        [_delegate clickHeadView];
    }
    _dropImageView.transform = _sc.isOPen ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);

}

- (void)setSc:(SpreadClass *)sc
{
    _sc = sc;
    
    [_bgButton setTitle:sc.title forState:UIControlStateNormal];
   
}

- (void)didMoveToSuperview
{
    _dropImageView.transform = _sc.isOPen ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgButton.frame = self.bounds;
    _numLabel.frame = CGRectMake(self.frame.size.width - 70, 0, 60, self.frame.size.height);
}

@end
