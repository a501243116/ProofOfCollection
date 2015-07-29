//
//  ChooseCheckCell.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-20.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseCheckCell : UITableViewCell
{
    UIView *_mainView;
}
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSArray *imagePaths;
@property (nonatomic,strong) NSNumber *iden;
@property (nonatomic,strong) NSMutableArray *selectedImages;
@property (nonatomic,strong) NSArray *paths;
@property (nonatomic,strong) NSMutableArray *selectedPaths;

- (void)selectedAll;
- (void)cancel;
@end
