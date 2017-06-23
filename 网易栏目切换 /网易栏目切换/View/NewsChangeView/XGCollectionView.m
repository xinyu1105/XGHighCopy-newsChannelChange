//
//  XGCollectionView.m
//  网易栏目切换
//
//  Created by 小果 on 16/9/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGCollectionView.h"
#import "XGCollectionViewSectionHeader.h"
#import "XGCollectionViewCell.h"
#import "XGNewsModel.h"

static NSString *bottomID = @"bottomCell";
static NSString *sectionID = @"sectionHeader";
@interface XGCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>


//记录编辑按钮的状态
@property(nonatomic,assign) BOOL isEdit;

// collectionVeiw视图
@property (nonatomic, weak) UICollectionView *collection;
@property (nonatomic, weak) UILongPressGestureRecognizer *gesture;
@property (nonatomic, strong) XGCollectionViewSectionHeader *sectionHeader;



@end
@implementation XGCollectionView
-(NSMutableArray *)bottomArray{
    if (nil == _bottomArray) {
        _bottomArray = [XGNewsModel newsModelWithSourceName:@"NewsBottom"];
    }
    return _bottomArray;
}

-(NSMutableArray *)topArray{
    if (nil == _topArray){
        _topArray = [XGNewsModel newsModelWithSourceName:@"NewsTop"];
    }
    return _topArray;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]){
        
        self.dataSource = self;
        self.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editBtnChange:) name:@"editBtnClick" object:nil];
        
        [self registerClass:[XGCollectionViewCell class] forCellWithReuseIdentifier:bottomID];
        
        [self registerClass:[XGCollectionViewSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionID];
        if(!self.isEdit){
//        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveItem:)];
//        // 系统默认的长按时间是:0.5s
//        gesture.minimumPressDuration = 0.5;
//            self.gesture = gesture;
//            [self addGestureRecognizer:gesture];
        }else{
//            [self removeGestureRecognizer:self.gesture];
        }
    }
    return self;
}


#pragma mark - collectionView的数据源方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.topArray.count;
    }else{
        
        return self.bottomArray.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bottomID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.newsModel = self.topArray[indexPath.row];
        if (self.isEdit) {
            cell.deleteV.hidden = NO;
        }else{
            cell.deleteV.hidden = YES;
        }
    }else{
        cell.newsModel = self.bottomArray[indexPath.row];
        cell.deleteV.hidden = YES;
    }
    
    return cell;
}

#pragma mark - 设置组头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    XGCollectionViewSectionHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        sectionHeader.editBtn.hidden = NO;
        sectionHeader.titleLab.text = @"切换栏目";
        if (self.isEdit) {
            [sectionHeader.editBtn setTitle:@"完  成" forState:UIControlStateNormal];
            UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveItem:)];
            // 系统默认的长按时间是:0.5s
            gesture.minimumPressDuration = 0.5;
            self.gesture = gesture;
            [self addGestureRecognizer:gesture];

            }else{
            [sectionHeader.editBtn setTitle:@"排序删除" forState:UIControlStateNormal];
            [self removeGestureRecognizer:self.gesture];
            }
        
    }else{
        sectionHeader.editBtn.hidden = YES;
        sectionHeader.titleLab.text = @"点击添加更多栏目";
    }
    return sectionHeader;
}

#pragma mark - 可移动的Cell(数据源方法)
-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSInteger from = [sourceIndexPath item];
    NSInteger to = [destinationIndexPath item];
    // 获取要移动的Cell
    id targetAr = [self.bottomArray objectAtIndex:from];
    [self.bottomArray removeObjectAtIndex:from];
    [self.bottomArray insertObject:targetAr atIndex:to];
    
}

#pragma mark - 点击Cell响应
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        XGNewsModel *model = self.bottomArray[indexPath.item];
        [self.topArray addObject:model];
        [self.bottomArray removeObject:model];
        [self reloadData];
    }else{
        if(self.isEdit){
            XGNewsModel *deleteModel = self.topArray[indexPath.item];
            [self.topArray removeObject:deleteModel];
            [self.bottomArray addObject:deleteModel];
            [self reloadData];
        }
    }
}
#pragma mark - 手势响应事件
-(void)moveItem:(UILongPressGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            // 通过手势来获取要移动的Cell的索引
            [self beginInteractiveMovementForItemAtIndexPath:[self indexPathForItemAtPoint:[gesture locationInView:gesture.view]]];
            break;
        case UIGestureRecognizerStateChanged:
            // 更新移动的Cell的位置
            [self updateInteractiveMovementTargetPosition:[gesture locationInView:gesture.view]];
            break;
        case UIGestureRecognizerStateEnded:
            // 手势动作完成后，结束交互式移动
            [self endInteractiveMovement];
            break;
        default:
            // 取消交互运动
            [self cancelInteractiveMovement];
            break;
    }
    
}


#pragma mark - 组头编辑按钮事件
-(void)editBtnChange:(NSNotification *)noti{
    
    self.isEdit = !self.isEdit;
    [self reloadData];
}

#pragma mark - 移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
