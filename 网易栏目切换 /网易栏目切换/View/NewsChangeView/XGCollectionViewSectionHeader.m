//
//  XGCollectionViewSectionHeader.m
//  网易栏目切换
//
//  Created by 小果 on 16/9/1.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGCollectionViewSectionHeader.h"
@interface XGCollectionViewSectionHeader ()
@property (nonatomic, assign, getter=isSelected) BOOL select;
@end
@implementation XGCollectionViewSectionHeader

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];

        [self createCollectionViewSectionHeaderWithContent];
    }
    return self;
}

#pragma mark - 创建组头的控件
-(void)createCollectionViewSectionHeaderWithContent{
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.frame = CGRectMake(10, 0, 150, self.height);
    self.titleLab = titleLab;
    [self addSubview:titleLab];
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 105, 5, 80, self.height - 10)];
    editBtn.hidden = YES;
    editBtn.layer.cornerRadius = 10;
    editBtn.layer.masksToBounds = YES;
    editBtn.layer.borderColor = [UIColor redColor].CGColor;
    editBtn.layer.borderWidth = 0.7;
    editBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.8];
    [editBtn setTitle:@"排序删除" forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [editBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.editBtn = editBtn;
    [self addSubview:editBtn];

}
-(void)editBtnClick:(UIButton *)sender{
    
  [[NSNotificationCenter defaultCenter] postNotificationName:@"editBtnClick" object:self userInfo:@{@"btnName":sender.titleLabel.text}];
}
@end
