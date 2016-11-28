//
//  UINavigationController+XMNFullScreenPop.h
//  XMNNavigationExample
//  实现全屏手势返回控制功能
//  Created by XMFraker on 16/11/24.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UINavigationController (XMNFullScreenPop)

/** 全屏返回手势 */
@property (strong, nonatomic, readonly) UIPanGestureRecognizer *xmn_popGes;

/** 是否允许viewController 自定义自己的navigationBar隐藏状态 */
@property (assign, nonatomic) IBInspectable BOOL xmn_viewControllerPerfersBarStyleEnabled;

@end

@interface UIViewController (XMNFullScreenPop)

/** 是否禁止手势滑动返回效果  默认NO */
@property (assign, nonatomic) IBInspectable BOOL xmn_interactivePopDisabled;

/** 是否隐藏当前viewController 界面上的navigationControllerBar
 * @warning  需要UINavigationController.xmn_viewControllerPerfersBarStyleEnabled = YES时才会生效
 * 默认 NO*/
@property (assign, nonatomic) IBInspectable BOOL xmn_prefersNavigationBarHidden;

/** 全屏手势出发局域 距离左侧的offset  
 * 默认 [UIScreen mainScreen].bounds.size.width 当手势出发点 >= offset 时 ,不会触发手势返回*/
@property (assign, nonatomic) IBInspectable CGFloat xmn_interactiveOffset;

@end
