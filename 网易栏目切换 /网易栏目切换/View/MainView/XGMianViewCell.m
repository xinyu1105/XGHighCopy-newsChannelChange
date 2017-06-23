//
//  XGMianViewCell.m
//  网易栏目切换
//
//  Created by 小果 on 16/9/4.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGMianViewCell.h"
#import "XGStartView.h"
@interface XGMianViewCell ()<XGStartViewDelegate>
@property (nonatomic, strong) XGStartView *starView;
@property (nonatomic, weak) UILabel *scoreLab;
@end
@implementation XGMianViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor randomColor];
        
        UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 250, 40)];
        textLab.centerX = self.contentView.centerX;
        textLab.font = [UIFont boldSystemFontOfSize:40];
        textLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:textLab];
        self.textLab = textLab;
        
        [self createViewWithStarView];

    }
    return self;
}

#pragma mark - 创建星星界面
-(void)createViewWithStarView{
    XGStartView *starView = [[XGStartView alloc] initWithFrame:CGRectMake((ScreenW - 280)*0.5, 0, 200, 40) numberOfStars:NumberOfStarts];
    starView.centerY = self.centerY;
    starView.isAnimation = YES;
    starView.score = 0.1;
    starView.allowStar = YES;
    starView.xgDelegate = self;
    self.starView = starView;
    [self addSubview:starView];
    
    // 分值控件
    UILabel *scoreLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.starView.frame) + 20, 0, 80, 30)];
    scoreLab.centerY = self.starView.centerY;
    scoreLab.font = [UIFont boldSystemFontOfSize:25];
    scoreLab.text = [NSString stringWithFormat:@"%.1f分",self.starView.score * NumberOfStarts];
    scoreLab.textColor = [UIColor redColor];
    self.scoreLab = scoreLab;
    [self addSubview:scoreLab];
    
}

#pragma mark - 实现XGStartView的代理方法
-(void)setupStartView:(XGStartView *)startView scoreDidChange:(CGFloat)newScore{
    self.scoreLab.text = [NSString stringWithFormat:@"%.1f分",self.starView.score * NumberOfStarts];
}


@end
