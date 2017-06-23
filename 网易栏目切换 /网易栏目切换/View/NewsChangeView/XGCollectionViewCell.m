//
//  XGCollectionViewCell.m
//  网易栏目切换
//
//  Created by 小果 on 16/8/30.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGCollectionViewCell.h"
#import "XGNewsModel.h"
@interface XGCollectionViewCell ()

//@property (nonatomic, weak) UILabel *newsLab;

@end
@implementation XGCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        [self createWithCellSubviews];

    }
    return self;
}

#pragma mark - 创建Cell中的控件
-(void)createWithCellSubviews{
    UILabel *newsLab = [[UILabel alloc] init];
    newsLab.font = [UIFont systemFontOfSize:18];
    newsLab.textColor = [UIColor redColor];
    newsLab.textAlignment = NSTextAlignmentCenter;
    newsLab.layer.cornerRadius = 15;
    newsLab.layer.masksToBounds = YES;
    newsLab.layer.borderWidth = 0.7;
    self.newsLab = newsLab;
    [self.contentView addSubview:newsLab];
    
    UIImageView *deleteV = [[UIImageView alloc] initWithFrame:CGRectMake(-3, -5, 15, 15)];
    deleteV.hidden = YES;
    deleteV.image = [UIImage imageNamed:@"news_delete"];
    self.deleteV = deleteV;
    [self.contentView addSubview:deleteV];
}

#pragma mark - 赋值
-(void)setNewsModel:(XGNewsModel *)newsModel{
    _newsModel = newsModel;
    
    self.newsLab.text = newsModel.name;
    if (self.newsLab.text.length > 4) {
        self.newsLab.font = [UIFont systemFontOfSize:13];
    }else if (self.newsLab.text.length <= 4){
        self.newsLab.font = [UIFont systemFontOfSize:15];
    }
    self.newsLab.frame = CGRectMake(0, 0, self.width, CollectionViewCellH);

}

@end
