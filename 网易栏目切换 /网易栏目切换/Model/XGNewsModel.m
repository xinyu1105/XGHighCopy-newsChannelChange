//
//  XGNewsModel.m
//  网易栏目切换
//
//  Created by 小果 on 16/8/30.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGNewsModel.h"

@implementation XGNewsModel

-(instancetype)initWithNewsModel:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)newsModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithNewsModel:dict];
}

+(NSMutableArray *)newsModelWithSourceName:(NSString *)sourceName{
    NSString *path = [[NSBundle mainBundle] pathForResource:sourceName ofType:@"json"];
    NSData *dataArray = [NSData dataWithContentsOfFile:path];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:dataArray options:0 error:nil];
    NSMutableArray *endArray = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        XGNewsModel *model = [XGNewsModel newsModelWithDict:dict];
        [endArray addObject:model];
    }];
    
    return endArray;

}

@end
