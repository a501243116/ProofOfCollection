//
//  PhotoGalleryCell.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-18.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoGalleryCellDelgate <NSObject>

- (void)backLongPressedIndex:(NSInteger)index;

@end

@interface PhotoGalleryCell : UITableViewCell
{
    NSMutableArray *_imageViews;
}

@property (nonatomic,strong) UILabel *companyLabel;//公司名字
@property (nonatomic,strong) UILabel *timeLabel ;//时间
@property (nonatomic,strong) UILabel *countLabel;//数目
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSArray *imagePaths;
@property (nonatomic,assign) id selfDelegate;

- (void)addGesture;


@end
