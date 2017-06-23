//
//  XGCollectionViewCell.h
//  网易栏目切换
//
//  Created by 小果 on 16/8/30.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XGNewsModel;
@interface XGCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) XGNewsModel *newsModel;
@property (nonatomic, weak) UILabel *newsLab;
@property (nonatomic, weak) UIImageView *deleteV;

@end
