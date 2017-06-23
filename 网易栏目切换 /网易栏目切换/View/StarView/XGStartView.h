//
//  XGStartView.h
//  网易栏目切换
//
//  Created by 小果 on 16/9/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XGStartView;

@protocol XGStartViewDelegate <NSObject>

-(void)setupStartView:(XGStartView *)startView scoreDidChange:(CGFloat)newScore;

@end

@interface XGStartView : UIView
// 星星的分值, 范围为0-1, 默认为1
@property (nonatomic, assign) CGFloat score;
// 是否执行动画
@property (nonatomic, assign) BOOL isAnimation;
// 评分时是否允许不是整个星，如果是NO(就必须是整星)，如果是YES(可以不为整星)
@property (nonatomic, assign) BOOL allowStar;

@property (nonatomic, weak) id<XGStartViewDelegate> xgDelegate;

// 创建评分视图
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfstars;
@end
