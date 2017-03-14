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
