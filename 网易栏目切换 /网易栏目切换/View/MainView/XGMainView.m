//
//  XGMainView.m
//  网易栏目切换
//
//  Created by 小果 on 16/9/5.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGMainView.h"
#import "XGMianViewCell.h"
#import "XGNewsModel.h"
#import "XGNewLab.h"
#import "XGCollectionView.h"

static NSString *mainID = @"mainCell";
@interface XGMainView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, weak) UICollectionView *bottomView;
// 顶部视图的文字标签模型
@property (nonatomic, strong) NSMutableArray *topA;
// 上下联动的索引
@property (nonatomic, assign) NSInteger currentSelectIndex;
// 存放顶部视图的滚动标签
@property (nonatomic, strong) NSMutableArray *newLabArray;

@property (nonatomic, strong) XGCollectionView *collection;
// 按钮的开关
@property (nonatomic, assign, getter=isOpen) BOOL open;
// 按钮
@property (nonatomic, weak) UIButton *switchbtn;
// 记录编辑按钮的状态
@property(nonatomic,assign) BOOL isEdit;
// 顶部的滚动视图
@property (nonatomic, weak) UIScrollView *topScroll;
@end
@implementation XGMainView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self createScrollWithLabel];
        
        [self createMainCollectionView];
        
        [self setupAllWithContentView];
    }
    return self;
}
-(NSMutableArray *)topA{
    if (nil == _topA) {
        _topA = [XGNewsModel newsModelWithSourceName:@"NewsBottom"];
    }
    return _topA;
}

-(NSMutableArray *)newLabArray{
    if (nil == _newLabArray) {
        _newLabArray = [NSMutableArray array];
    }
    return _newLabArray;
}

#pragma mark - 创建滚动的标签
-(void)createScrollWithLabel{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width - 25, 44)];
    [self addSubview:scroll];
    self.topScroll = scroll;
    [self createTopViewWithLabel];
}

#pragma mark - 创建Label标签
-(void)createTopViewWithLabel{
    CGFloat newLabX = 0;
    CGFloat newLabY = 0;
    CGFloat newLabW = 90;
    CGFloat newLabH = self.topScroll.height;
    for (int i = 0; i < self.topA.count; i++) {
        XGNewLab *newLab = [[XGNewLab alloc] init];
        newLab.tag = i;
        if (i == 0){
            newLab.scale = 1.0;
        }
        [self.newLabArray addObject:newLab];
        XGNewsModel *model = self.topA[i];
        newLab.text = model.name;
        newLabX = i * newLabW;
        newLab.frame = CGRectMake(newLabX, newLabY, newLabW, newLabH);
        [self.topScroll addSubview:newLab];
        // 添加点击的手势
        [newLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newLabClick:)]];
    }
    self.topScroll.contentSize = CGSizeMake(self.topA.count * newLabW, 0);
}

#pragma mark - 创建主视图
-(void)createMainCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.width, self.height - 44);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *bottomView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, self.width, self.height - 44) collectionViewLayout:layout]
    ;
    [bottomView registerClass:[XGMianViewCell class] forCellWithReuseIdentifier:mainID];
    bottomView.pagingEnabled = YES;
    bottomView.dataSource = self;
    bottomView.delegate = self;
    bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
}

#pragma mark - collectionView的数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.topA.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XGMianViewCell *mainCell = [collectionView dequeueReusableCellWithReuseIdentifier:mainID forIndexPath:indexPath];
    mainCell.contentView.backgroundColor = [UIColor randomColor];
    XGNewsModel *currnetLabModel = self.topA[indexPath.item];
    mainCell.textLab.text = currnetLabModel.name;
    return mainCell;
}

#pragma mark - 上下联动的方法
-(void)newLabClick:(UITapGestureRecognizer *)gesture{
    // 获取点击的view
    XGNewLab *newLabClick = (XGNewLab *)gesture.view;
    // 根据选中的newLab的tag值来记录当前选中的索引
    self.currentSelectIndex = newLabClick.tag;
    // 控制下面的collectionViewCell一起滚动
    CGFloat offsetX = newLabClick.tag * self.bottomView.width;
    [self.bottomView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    
    // 在滚动的同时让newLab居中显示
    [self newLabWithLocationCenter:self.bottomView];
    
}

#pragma mark - 在上下联动的是时候让选中的newLab的位置居中显示
-(void)newLabWithLocationCenter:(UIScrollView *)scrollView{
    
    self.currentSelectIndex = scrollView.contentOffset.x / scrollView.width;
    
    // 让选中的newLab居中
    XGNewLab *selectLab = self.newLabArray[self.currentSelectIndex];
    
    CGFloat scrollOffsetX = selectLab.centerX - self.bottomView.width * 0.5;
    // 需要考虑在屏幕中心左侧的newLab的位置
    if (scrollOffsetX < 0){
        scrollOffsetX = 0;
    }
    // 计算允许滚动的最大距离
    CGFloat maxScrollOffsetX = self.topScroll.contentSize.width - self.topScroll.width;
    if (scrollOffsetX > maxScrollOffsetX) {
        scrollOffsetX = maxScrollOffsetX;
    }
    
    // 让newLab所在的scrollView自行滚动
    [self.topScroll setContentOffset:CGPointMake(scrollOffsetX, 0) animated:YES];
    // 通过滚动来计算newLab的缩放比率
    for (XGNewLab *scaleLab in self.newLabArray) {
        if (scaleLab.tag == self.currentSelectIndex) {
            scaleLab.scale = 1.0;
        }else{
            scaleLab.scale = 0.0;
        }
    }
}

#pragma mark - 通过滚动的范围来计算newLab的颜色值的变化和缩放
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat value = scrollView.contentOffset.x / scrollView.width;
    if (value < 0 || value > self.newLabArray.count - 1) return;
    // 已选中newLab的左边的索引
    int leftIndex = scrollView.contentOffset.x / scrollView.width;
    int rightIndex = leftIndex + 1;
    // 右边的比率
    CGFloat rightScale = value - leftIndex;
    // 左边的比率
    CGFloat leftScale = 1 - rightScale;
    
    // 通过左右的标签来计算缩放的比率
    XGNewLab *leftLab = self.newLabArray[leftIndex];
    leftLab.scale = leftScale;
    
    if (rightIndex < self.newLabArray.count) {
        XGNewLab *rightLab = self.newLabArray[rightIndex];
        rightLab.scale = rightScale;
    }
}

#pragma mark - 当滚动视图完成最终减速的时候调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self newLabWithLocationCenter:scrollView];
}

#pragma mark - 布局整体界面
-(void)setupAllWithContentView{
    
    UIButton *switchbtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 25, 0, 25, 44)];
    [switchbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    switchbtn.backgroundColor = [UIColor redColor];
    [switchbtn setImage:[UIImage imageNamed:@"group_pay_arrow"] forState:UIControlStateNormal];
    self.switchbtn = switchbtn;
    [self addSubview:switchbtn];
    
    [self createWithBottomView];
}


#pragma mark - 设置底部视图
-(void)createWithBottomView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(80, CollectionViewCellH);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.headerReferenceSize = CGSizeMake(self.width, 30);
    XGCollectionView *collection = [[XGCollectionView alloc] initWithFrame:CGRectMake(0, 44, self.width, 0) collectionViewLayout:layout];
    collection.backgroundColor = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:0.9];
    self.collection = collection;
}

#pragma mark - 顶部视图的按钮点击事件
-(void)btnClick:(UIButton *)sender{
    
    if (self.isOpen) {
        [UIView animateWithDuration:0.5 animations:^{
            self.collection.y = 108 - self.collection.height;
            self.collection.alpha = 0.1;
            self.topScroll.hidden = NO;
            sender.imageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.collection.height = 0;
            self.open = NO;
            [UIView animateWithDuration:0.5 animations:^{
                self.topScroll.alpha = 1.0;
            }];
        }];
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.collection.y = 44;
            self.collection.alpha = 1.0;
            self.collection.height = self.height - 44;
            self.topScroll.alpha = 0.1;
            [self addSubview:self.collection];
            sender.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        } completion:^(BOOL finished) {
            self.topScroll.hidden = YES;
            self.open = YES;
            
        }];
        
    }
}

@end
