//
//  NSArray+XMNUtils.m
//  XMNNavigationExample
//
//  Created by XMFraker on 16/11/24.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "NSArray+XMNUtils.h"

@implementation NSArray (XMNUtils)

- (NSArray *)xmn_map:(id(^)(id obj, NSInteger index))block {
    
    if (!block) {
        
        block = ^id(id obj ,NSInteger index){
            return obj;
        };
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [array addObject:block(obj,idx)];
    }];
    return [NSArray arrayWithArray:array];
}

- (BOOL)xmn_any:(BOOL(^)(id obj))block {
    
    if (!block || !self || !self.count) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (block(obj)) {
            ret = YES;
            *stop = YES;
        }
    }];
    return ret;
}

@end
