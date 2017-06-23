//
//  XGCollectionView.h
//  网易栏目切换
//
//  Created by 小果 on 16/9/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGCollectionView : UICollectionView
// 顶部的数组
@property (nonatomic, strong) NSMutableArray *topArray;
// 底部的数组
@property (nonatomic, strong) NSMutableArray *bottomArray;
@end
