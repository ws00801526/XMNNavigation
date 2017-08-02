//
//  UIViewController+XMNNavigation.m
//  XMNNavigationExample
//
//  Created by XMFraker on 17/3/14.
//  Copyright © 2017年 XMFraker. All rights reserved.
//

#import "UIViewController+XMNNavigation.h"

#import <objc/runtime.h>

@implementation UIViewController (XMNNavigation)

#pragma mark - Public Method

- (void)pushViewController:(UIViewController * __nonnull)viewController {
    
    [self pushViewController:viewController
                      params:nil
        removeViewController:nil
             completionBlock:nil];
}


- (void)pushViewController:(UIViewController *)viewController
             removeCurrent:(BOOL)removeCurrent {
    
    [self pushViewController:viewController
                      params:nil
        removeViewController:removeCurrent ? self : nil
             completionBlock:nil];
}

- (void)pushViewController:(UIViewController * __nonnull)viewController
                    params:(NSDictionary * __nullable)params {
    
    
    [self pushViewController:viewController
                      params:params
        removeViewController:nil
             completionBlock:nil];
}

- (void)pushViewController:(UIViewController * __nonnull)viewController
          removeViewController:(UIViewController * __nullable)removeViewC {
    
    [self pushViewController:viewController
                      params:nil
        removeViewController:removeViewC
             completionBlock:nil];
}

- (void)pushViewController:(UIViewController * __nonnull)viewController
                        params:(NSDictionary * __nullable)params
          removeViewController:(UIViewController * __nullable)removeViewC
               completionBlock:(void(^)(BOOL finished))completionBlock {
    
    if (!viewController) {
        /** 1. viewController不存在  不在继续执行 */
        return;
    }
    
    if (params && [params isKindOfClass:[NSDictionary class]]) {
        
        /** 2. 为viewController配置属性值 */
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [viewController setValue:obj forKey:key];
        }];
    }
    
    if (self.xmn_navigationController) {
        
        if (removeViewC) {
            
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.xmn_navigationController.xmn_viewControllers];
            [viewControllers removeObject:removeViewC];
            [viewControllers addObject:viewController];
            [self.xmn_navigationController setViewControllers:[viewControllers copy] completionHandler:completionBlock];
        }else {
            [self.xmn_navigationController pushViewController:viewController completionBlock:completionBlock];
        }
//        __weak typeof(*&self) wSelf = self;
//        [self.xmn_navigationController pushViewController:viewController completionBlock:^(BOOL finished) {
//            __strong typeof(*&wSelf) self = wSelf;
//            [self.xmn_navigationController removeViewController:removeViewC];
//            completionBlock ? completionBlock(finished) : nil;
//        }];
    }else {
        
        if (removeViewC) {
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [viewControllers removeObject:removeViewC];
            [viewControllers addObject:viewController];
            [self.navigationController setViewControllers:[viewControllers copy] animated:YES];
        }else {
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (UIViewController * __nullable)popViewController {
    
    return [self popViewController:nil];
}

- (UIViewController * __nullable)popViewController:(void(^ __nullable)(BOOL finished))completionBlock {
    
    if (self.xmn_navigationController) {
        
        return [self.xmn_navigationController popViewControllerWithCompletionBlock:completionBlock];
    }else {
        
        return [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSArray<UIViewController *> * __nullable)popToViewController:(UIViewController * __nonnull)viewController {
    
    return [self popToViewController:viewController
                         completionBlock:nil];
}


- (NSArray<UIViewController *> * __nullable)popToViewController:(UIViewController * __nonnull)viewController
                                                    completionBlock:(void(^ __nullable)(BOOL finished))completionBlock {
    
    if (self.xmn_navigationController) {
        
        return [self.xmn_navigationController popToViewController:viewController completionBlock:completionBlock];
    }else {
        
        return [self.navigationController popToViewController:viewController animated:YES];
    }
}

- (NSArray<UIViewController *> * __nullable)popToRootViewController {
    
    return [self popToRootViewController:nil];
}

- (NSArray<UIViewController *> * __nullable)popToRootViewController:(void(^ __nullable)(BOOL finished))completionBlock {
    
    if (self.xmn_navigationController) {
        
        return [self.xmn_navigationController popToRootViewController:completionBlock];
    }else {
        
        return [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Override Method

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    NSLog(@"key :%@ is undefined \n  value :%@ will be abandon",key, value);
}

#pragma mark - Setter

- (void)setTransferNavigationBarAttributes:(BOOL)transferNavigationBarAttributes {
    
    objc_setAssociatedObject(self, @selector(transferNavigationBarAttributes), @(transferNavigationBarAttributes), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -  Getter

- (XMNNavigationController *)xmn_navigationController {
    
    if (self.navigationController && [self.navigationController isKindOfClass:[XMNContainerNavigationController class]]) {
        return (XMNNavigationController *)self.navigationController.navigationController;
    }
    return nil;
}

- (Class)xmn_navigationBarClass {
    
    return nil;
}

- (BOOL)transferNavigationBarAttributes {
    
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? [number boolValue] : NO;
}


@end
