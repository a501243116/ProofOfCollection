//
//  ChoosePhotoCell.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-19.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoosePhotoCellDelegate <NSObject>

- (void)backCheckImgWithIndex:(NSInteger)index picIndex:(NSInteger)picIndex status:(NSInteger)status;//返回勾选图片的cell的索引和图片索引 status 0表示取消,1表示加入

@end

@interface ChoosePhotoCell : UITableViewCell
{
    UIView *_mainView;
}

@property (nonatomic,assign) id delegate;

@property (nonatomic,strong) UILabel *companyLabel;//公司名字
@property (nonatomic,strong) UILabel *timeLabel ;//时间
@property (nonatomic,strong) UILabel *countLabel;//数目
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSArray *imagePaths;
@property (nonatomic,assign) NSInteger index;

- (void)selectedAll;
- (void)cancel;

@end
