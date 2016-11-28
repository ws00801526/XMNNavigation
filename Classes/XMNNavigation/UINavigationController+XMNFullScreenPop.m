//
//  UINavigationController+XMNFullScreenPop.m
//  XMNNavigationExample
//
//  Created by XMFraker on 16/11/24.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "UINavigationController+XMNFullScreenPop.h"

#import <objc/runtime.h>


#pragma mark - UIViewController (XMNFullScreenPopPrivate)

typedef void(^XMNViewControllerWillAppearExcuteBlock)(UIViewController *viewC, BOOL animated);
@interface UIViewController (XMNFullScreenPopPrivate)

/** viewWillAppear 触发时,会执行的相关block
 *  通过block处理, 可以不必在viewWillAppear出现时每次都判断是否需要设置navigationBar.hidden
 **/
@property (copy, nonatomic)   XMNViewControllerWillAppearExcuteBlock viewWillAppearExcuteBlock;

@end

@implementation UIViewController (XMNFullScreenPopPrivate)

+ (void)load {
    
    Method originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(xmn_viewWillAppear:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)xmn_viewWillAppear:(BOOL)animated {
    
    /** 执行原有的viewWillAppear方法 */
    [self xmn_viewWillAppear:animated];
    self.viewWillAppearExcuteBlock ? self.viewWillAppearExcuteBlock(self, animated) : nil;
}

- (void)setViewWillAppearExcuteBlock:(XMNViewControllerWillAppearExcuteBlock)block {
    
    objc_setAssociatedObject(self, @selector(viewWillAppearExcuteBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (XMNViewControllerWillAppearExcuteBlock)viewWillAppearExcuteBlock {
    
    return objc_getAssociatedObject(self, _cmd);
}

@end

#pragma mark - UINavigationController (XMNFullScreenPop)
@implementation UINavigationController (XMNFullScreenPop)

+ (void)load {
    
    Method originalMethod = class_getInstanceMethod(self, @selector(pushViewController:animated:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(xmn_pushViewController:animated:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

#pragma mark - UINavigationController (XMNFullScreenPop) Method

- (void)xmn_pushViewController:(__kindof UIViewController *)viewC
                      animated:(BOOL)animated {
    
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.xmn_popGes]) {
        
        /** 给系统返回手势触发view上添加自定义返回手势 */
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.xmn_popGes];
        
        /** 解析系统自带返回手势 target,action, 转发到自定义panGes */
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.xmn_popGes.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.xmn_popGes addTarget:internalTarget action:internalAction];
        
        /** 禁止系统自带的手势返回 */
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    /** 设置需要全局改变viewController 界面上的navigationBar.hidden */
    [self xmn_prefersBarStyleForViewController:viewC];
    
    /** 执行原有的push动画效果 */
    [self xmn_pushViewController:viewC
                        animated:animated];
}

- (void)xmn_prefersBarStyleForViewController:(UIViewController *)appearingViewController {
    
    if (!self.xmn_viewControllerPerfersBarStyleEnabled) {
        /** 不允许全局处理viewController navigationBarStyle */
        return;
    }
    __weak typeof(*&self) wSelf = self;
    XMNViewControllerWillAppearExcuteBlock excuteBlock = ^(UIViewController *viewC, BOOL animated) {
        
        __strong typeof(*&wSelf) self = wSelf;
        if (self) {
            [self setNavigationBarHidden:viewC.xmn_prefersNavigationBarHidden animated:animated];
        }
    };
    
    appearingViewController.viewWillAppearExcuteBlock = excuteBlock;
    
    /** 因为在navigationController push之前, 所以通过lastObject获取当前的viewController,设置viewWillAppearExcuteBlock */
    UIViewController *disappearingViewC = self.viewControllers.lastObject;
    if (disappearingViewC && !disappearingViewC.viewWillAppearExcuteBlock) {
        disappearingViewC.viewWillAppearExcuteBlock = excuteBlock;
    }
}

#pragma mark - UINavigationController (XMNFullScreenPop) UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    /** 过滤当viewControllers 只有一个时 */
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    
    /** 过滤全局设置navigationController 禁止手势返回 */
    if (self.xmn_interactivePopDisabled) {
        return NO;
    }
    
    /** 过滤具体viewController 设置禁止手势返回 */
    UIViewController *topViewController = self.viewControllers.lastObject;
    if (topViewController.xmn_interactivePopDisabled) {
        return NO;
    }
    
    /** 忽略触发点 >= offset 的情况 */
    CGPoint touchPoint = [gestureRecognizer locationInView:topViewController.view];
    if (touchPoint.x >= topViewController.xmn_interactiveOffset) {
        
        return NO;
    }
    
    /** 忽略当手势正在进行时, 防止继续触发 */
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }

    /** 忽略当手势滑动不正确时触发 */
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return YES;
}

#pragma mark - UINavigationController (XMNFullScreenPop) Setter

- (void)setXmn_viewControllerPerfersBarStyleEnabled:(BOOL)enabled {
    
    objc_setAssociatedObject(self, @selector(xmn_viewControllerPerfersBarStyleEnabled), @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - UINavigationController (XMNFullScreenPop) Getter

- (UIPanGestureRecognizer *)xmn_popGes {
    
    UIPanGestureRecognizer *panGes = objc_getAssociatedObject(self, _cmd);
    if (!panGes) {
        panGes = [[UIPanGestureRecognizer alloc] init];
        panGes.maximumNumberOfTouches = 1;
        objc_setAssociatedObject(self, _cmd, panGes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGes;
}

- (BOOL)xmn_viewControllerPerfersBarStyleEnabled {
    
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? [number boolValue] : YES;
}

@end


#pragma mark - UIViewController (XMNFullScreenPop)

@implementation UIViewController (XMNFullScreenPop)

#pragma mark - UIViewController (XMNFullScreenPop) Setter

- (void)setXmn_interactiveOffset:(CGFloat)offset {
    
    objc_setAssociatedObject(self, @selector(xmn_interactiveOffset), @(offset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setXmn_interactivePopDisabled:(BOOL)disabled {
    
    objc_setAssociatedObject(self, @selector(xmn_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setXmn_prefersNavigationBarHidden:(BOOL)hidden {
    
    objc_setAssociatedObject(self, @selector(xmn_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - UIViewController (XMNFullScreenPop) Getter

- (BOOL)xmn_interactivePopDisabled {
    
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? [number boolValue] : NO;
}

- (BOOL)xmn_prefersNavigationBarHidden {
    
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? [number boolValue] : NO;
}

- (CGFloat)xmn_interactiveOffset {
    
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? [number floatValue] : CGRectGetWidth([UIScreen mainScreen].bounds);
}

@end
