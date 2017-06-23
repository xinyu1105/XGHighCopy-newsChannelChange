//
//  XGNewsModel.h
//  网易栏目切换
//
//  Created by 小果 on 16/8/30.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGNewsModel : NSObject

@property (nonatomic, copy) NSString *name;

-(instancetype)initWithNewsModel:(NSDictionary *)dict;

+(instancetype)newsModelWithDict:(NSDictionary *)dict;

+(NSMutableArray *)newsModelWithSourceName:(NSString *)name;
@end
