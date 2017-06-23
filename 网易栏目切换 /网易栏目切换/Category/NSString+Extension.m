//
//  NSString+Extension.m
//  XGHighimitationQQ
//
//  Created by 小果 on 16/8/15.
//  Copyright © 2016年 小果. All rights reserved.

#import "NSString+Extension.h"

@implementation NSString (Extension)
/**
 *  返回字符串占用的尺寸
 *
 *  @param font    要计算文字的字体
 *  @param maxSize 文字的最大尺寸
 *
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

@end
