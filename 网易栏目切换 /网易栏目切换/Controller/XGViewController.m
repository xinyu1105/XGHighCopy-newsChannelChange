//
//  XGViewController.m
//  网易栏目切换
//
//  Created by 小果 on 16/8/30.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGViewController.h"
#import "XGMainView.h"
@interface XGViewController ()
@property (nonatomic, strong) XGMainView *mainView;
@end

@implementation XGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAllWithContentView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 布局整体界面
-(void)setupAllWithContentView{
    XGMainView *mainView  = [[XGMainView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH - 64)];
    [self.view addSubview:mainView];
    self.mainView = mainView;
}

@end
