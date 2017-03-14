//
//  UIApplication+XMNNavigation.h
//  XMNNavigationExample
//
//  Created by XMFraker on 17/3/14.
//  Copyright © 2017年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (XMNNavigation)

/**
 *  @brief 当前window上的显示navigationController
 */
@property (weak, nonatomic, readonly, nullable)   UINavigationController *navigationController;
/**
 *  @brief 当前window显示的主要topViewController
 */
@property (weak, nonatomic, readonly, nullable)   UIViewController *topViewController;

@end
