//
//  XGStartView.m
//  网易栏目切换
//
//  Created by 小果 on 16/9/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGStartView.h"

@interface XGStartView ()
// 黄色星星
@property (nonatomic, strong) UIView *yellowStarView;
// 灰色星星
@property (nonatomic, strong) UIView *grayStarView;
// 星星的个数
@property (nonatomic, assign) NSInteger numberOfStars;
@end
@implementation XGStartView
- (instancetype)init {
    NSAssert(NO, @"不应该在此处调用这个方法，");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame numberOfStars:NumberOfStarts];
}
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfstars{
    if (self = [super initWithFrame:frame]){
        self.numberOfStars = numberOfstars;
        [self createViewWithContent];
    }
    return self;
}

#pragma mark - 如果是用XIB或者是storyboard创建的话可以直接调用这个方法哦
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 用来记录星星的个数
        _numberOfStars = NumberOfStarts;
        // 创建视图并设置数据
        [self createViewWithContent];
    }
    return self;
}

#pragma mark - 创建视图并设置相应的数据
-(void)createViewWithContent{
    // 分值默认为1
    self.score = 1;
    // 是否执行动画，默认为NO
    self.isAnimation = NO;
    // 分值增加时，星星是否按整星加载，默认为NO
    self.allowStar = NO;
    
    // 用来存放黄色星星的View
    self.yellowStarView = [self createStarViewWithImageName:yellowStar];
    // 用来存放灰色星星的View
    self.grayStarView = [self createStarViewWithImageName:grayStar];
    
    // 先添加背景星再添加黄星
    [self addSubview:self.grayStarView];
    [self addSubview:self.yellowStarView];
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTapView:)];
    // 点击的次数
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

#pragma mark - 创建星星
- (UIView *)createStarViewWithImageName:(NSString *)imageName {
    
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.numberOfStars; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * self.width / self.numberOfStars, 0, self.width / self.numberOfStars , self.height - 5);
    
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

#pragma mark - 手势的响应方法
- (void)clickTapView:(UITapGestureRecognizer *)gesture {
    // 获取点击的位置
    CGPoint tapPoint = [gesture locationInView:self];
    // 手指的偏移
    CGFloat offset = tapPoint.x;
    // 通过点击星星的个数来计算分值
    CGFloat realScore = offset / (self.width / self.numberOfStars);
    
    CGFloat starScore = self.allowStar ? realScore : ceilf(realScore);
    
    self.score = starScore / self.numberOfStars;
}


#pragma mark - 重写分值的set方法
- (void)setScore:(CGFloat)scroe {
    // 如果计算的分值不变直接返回
    if (_score == scroe) {
        return;
    }

    if (scroe < 0) {
        _score = 0;
    } else if (scroe > 1) {
        _score = 1;
    } else {
        _score = scroe;
    }
    
    if ([self.xgDelegate respondsToSelector:@selector(setupStartView:scoreDidChange:)]) {
        [self.xgDelegate setupStartView:self scoreDidChange:scroe];
    }
    
    [self setNeedsLayout];
}

#pragma mark - 重新计算
- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak XGStartView *weakSelf = self;
    // 设置动画时间
    CGFloat animationTime = self.isAnimation ? animationDurations : 0;
    
    // 设置动画
    [UIView animateWithDuration:animationTime animations:^{
        weakSelf.yellowStarView.frame = CGRectMake(0, 0, weakSelf.width * weakSelf.score, weakSelf.height);
    }];
}


@end
