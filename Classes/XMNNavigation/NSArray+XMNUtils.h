//
//  NSArray+XMNUtils.h
//  XMNNavigationExample
//
//  Created by XMFraker on 16/11/24.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (XMNUtils)

/**
 执行map方法,将已有数组内数据 过滤成一个新的数组
 
 @param block 执行过滤的block
 @return 返回结果
 */
- (NSArray * __nullable)xmn_map:(id __nonnull(^ __nullable)(__nullable ObjectType obj, NSInteger index))block;


/**
 执行查询方法,判断数组内是否有符合条件的元素
 
 @param block 执行判断的block方法
 @return YES or NO
 */
- (BOOL)xmn_any:(BOOL(^ __nonnull)(__nullable ObjectType obj))block;

@end
