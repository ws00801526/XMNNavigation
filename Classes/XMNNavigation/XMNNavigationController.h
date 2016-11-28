//
//  XMNNavigationController.h
//  XMNNavigationExample
//
//  Created by XMFraker on 16/11/24.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+XMNFullScreenPop.h"

@interface XMNContainerController : UIViewController

@property (strong, nonatomic, readonly, nonnull) UIViewController *contentViewController;

@end

@interface XMNContainerNavigationController : UINavigationController

@end

@interface XMNNavigationController : UINavigationController

/** 当前的topViewController */
@property (strong, nonatomic, readonly, nullable) UIViewController *xmn_topViewController;
/** 当前可见的visiableController  == self.visiableController 已重写 */
@property (strong, nonatomic, readonly, nullable) UIViewController *xmn_visiableController;
/** 当前viewControllers栈  == self.viewControllers 已重写 */
@property (strong, nonatomic, readonly, nullable) NSArray<UIViewController *> *xmn_viewControllers;



- (void)pushViewController:(UIViewController * __nonnull)viewController
           completionBlock:(void(^__nullable )(BOOL finished))completionBlock;

- (UIViewController * __nullable)popViewControllerWithCompletionBlock:(void(^__nullable )(BOOL finished))completionBlock;

- (NSArray<UIViewController *> * __nullable)popToViewController:(UIViewController * __nonnull)viewController
                                                completionBlock:(void(^ __nullable)(BOOL finished))completionBlock;

- (NSArray<UIViewController *> * __nullable)popToRootViewController:(void(^ __nullable)(BOOL finished))completionBlock;


/**
 从已有的viewControllers中移除一个viewController

 @param viewController 需要移除的viewController
 */
- (void)removeViewController:(__kindof UIViewController * __nonnull)viewController;

/**
 从已有的viewControllers中移除一个viewController

 @param viewController 需要移除的viewController
 @param animated 是否需要动画
 */
- (void)removeViewController:(__kindof UIViewController * __nonnull)viewController
                    animated:(BOOL)animated;

@end

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
- (void)xmn_pushViewController:(UIViewController * __nonnull)viewController;


/**
 push到viewController
    
 通过KVC方式 将params 中key-value键值对传入viewController中
 重写了setValue:forUndefinedKey方法, 防止key不存在导致异常
 @param viewController 需要push到的viewController
 @param params 需要设置给viewController 的参数
 */
- (void)xmn_pushViewController:(UIViewController * __nonnull)viewController
                        params:(NSDictionary * __nullable)params;

/**
 push到viewController

 @param viewController 需要push到的viewController
 @param removeViewC 需要从navigationController.viewControllers中移除的 viewC
 */
- (void)xmn_pushViewController:(UIViewController * __nonnull)viewController
          removeViewController:(UIViewController * __nullable)removeViewC;

/**
 push到viewController

 @param viewController 需要push到的viewController
 @param params 需要设置给viewController 的参数
 @param removeViewC 需要从navigationController.viewControllers中移除的 viewC
 @param completionBlock push完成后回调block
 */
- (void)xmn_pushViewController:(UIViewController * __nonnull)viewController
                        params:(NSDictionary * __nullable)params
          removeViewController:(UIViewController * __nullable)removeViewC
               completionBlock:(void(^ __nullable)(BOOL finished))completionBlock;


/// ========================================
/// @name   自定义pop方法
/// ========================================

- (UIViewController * __nullable)xmn_popViewController;
- (UIViewController * __nullable)xmn_popViewController:(void(^ __nullable)(BOOL finished))completionBlock;

- (NSArray<UIViewController *> * __nullable)xmn_popToViewController:(UIViewController * __nonnull)viewController;
- (NSArray<UIViewController *> * __nullable)xmn_popToViewController:(UIViewController * __nonnull)viewController
                                                    completionBlock:(void(^ __nullable)(BOOL finished))completionBlock;

- (NSArray<UIViewController *> * __nullable)xmn_popToRootViewController;
- (NSArray<UIViewController *> * __nullable)xmn_popToRootViewController:(void(^ __nullable)(BOOL finished))completionBlock;

@end
