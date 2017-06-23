//
//  XGNewLab.m
//  网易栏目切换
//
//  Created by 小果 on 16/9/4.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGNewLab.h"

@implementation XGNewLab

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:20];
        self.userInteractionEnabled = YES;
        self.scale = 0;
    }
    return self;
}

-(void)setScale:(CGFloat)scale{
    _scale = scale;
    // 文字的颜色的变化
    self.textColor = [UIColor colorWithRed:scale green:0 blue:0 alpha:1.0];
    // 计算缩放的比率
    CGFloat minScale = 0.8;// 最小缩放比率
    CGFloat realScale = minScale + (1 - minScale) * scale;
    self.transform = CGAffineTransformMakeScale(realScale, realScale);
}
@end
