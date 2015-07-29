//
//  AdScrollView.h
//  太平人寿 -张永
//
//  Created by rimi on 14-8-28.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdScrollViewDelegate <NSObject>

- (void)swipImg:(NSInteger)page;

@end

/* 自定义商品浏览主页上面滚动的广告视图 */
@interface AdScrollView : UIView


@property(nonatomic,retain) NSArray *images;
@property(nonatomic,assign) id<AdScrollViewDelegate> adDelegate;

@end
