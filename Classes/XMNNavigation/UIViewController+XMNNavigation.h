//
//  UIViewController+XMNNavigation.h
//  XMNNavigationExample
//
//  Created by XMFraker on 17/3/14.
//  Copyright © 2017年 XMFraker. All rights reserved.
//

#import "XMNNavigationController.h"

@interface UIViewController (XMNNavigation)

/** 当前页面的navigationController
 *
 *  @warnging 注意调用self.navigationController时 返回的是XMNContainerNavigationController */
@property (strong, nonatomic, readonly, nullable) XMNNavigationController *xmn_navigationController;

/** 当前页面的自定义navigationBarClass
 * 需要自定义navigationBar 时,重写getter方法 返回自定义的navigationBarClass */
@property (strong, nonatomic, readonly, nullable) Class xmn_navigationBarClass;

/** 是否使用XMNNavigationController 上的navigationBar样式 */
@property (assign, nonatomic) BOOL transferNavigationBarAttributes;

#pragma mark - Navigation Method

/// ========================================
/// @name   自定义的一些push方法
/// ========================================

/**
 push到viewController
 
 @param viewController 需要push到的viewController
 */
- (void)pushViewController:(UIViewController * __nonnull)viewController;

/**
 push到viewController
 
 通过KVC方式 将params 中key-value键值对传入viewController中
 重写了setValue:forUndefinedKey方法, 防止key不存在导致异常
 @param viewController 需要push到的viewController
 @param params 需要设置给viewController 的参数
 */
- (void)pushViewController:(UIViewController * __nonnull)viewController
                    params:(NSDictionary * __nullable)params;

/**
 push到viewController
 
 @param viewController 需要push到的viewController
 @param removeViewC 需要从navigationController.viewControllers中移除的 viewC
 */
- (void)pushViewController:(UIViewController * __nonnull)viewController
      removeViewController:(UIViewController * __nullable)removeViewC;

/**
 push到viewController
 
 @param viewController 需要push到的viewController
 @param params 需要设置给viewController 的参数
 @param removeViewC 需要从navigationController.viewControllers中移除的 viewC
 @param completionBlock push完成后回调block
 */
- (void)pushViewController:(UIViewController * __nonnull)viewController
                    params:(NSDictionary * __nullable)params
      removeViewController:(UIViewController * __nullable)removeViewC
           completionBlock:(void(^ __nullable)(BOOL finished))completionBlock;


/// ========================================
/// @name   自定义pop方法
/// ========================================


/**
 pop回到前一个页面

 @return 被pop出去的界面
 */
- (UIViewController * __nullable)popViewController;

/**
 pop回到前一个界面

 @param completionBlock pop完成回调
 @return 被pop的界面
 */
- (UIViewController * __nullable)popViewController:(void(^ __nullable)(BOOL finished))completionBlock;


/**
 pop回到指定的界面

 @param viewController pop的指定界面
 @return pop出去的界面数组
 */
- (NSArray<UIViewController *> * __nullable)popToViewController:(UIViewController * __nonnull)viewController;

/**
 pop回到指定的界面

 @param viewController pop的指定界面
 @param completionBlock 回调block
 @return pop出去的界面数组
 */
- (NSArray<UIViewController *> * __nullable)popToViewController:(UIViewController * __nonnull)viewController
                                                    completionBlock:(void(^ __nullable)(BOOL finished))completionBlock;

- (NSArray<UIViewController *> * __nullable)popToRootViewController;
- (NSArray<UIViewController *> * __nullable)popToRootViewController:(void(^ __nullable)(BOOL finished))completionBlock;

@end
