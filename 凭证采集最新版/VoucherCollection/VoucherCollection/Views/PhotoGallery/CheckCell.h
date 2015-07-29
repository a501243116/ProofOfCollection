//
//  CheckCell.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-20.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CheckCellDelegate<NSObject>

- (void)check:(UIButton *)sender;
- (void)backSelectedPicIndex:(NSInteger)index title:(NSString *)title images:(NSArray *)images paths:(NSArray *)paths iden:(NSNumber*)iden;

@end

@interface CheckCell : UITableViewCell

@property (nonatomic,assign) id delegate;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSArray *imagePaths;
@property (nonatomic,strong) UIButton *checkButton;
@property (nonatomic,strong) NSNumber *iden;
@end
