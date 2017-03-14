//
//  UIApplication+XMNNavigation.m
//  XMNNavigationExample
//
//  Created by XMFraker on 17/3/14.
//  Copyright © 2017年 XMFraker. All rights reserved.
//

#import "UIApplication+XMNNavigation.h"

#import "XMNNavigationController.h"

@implementation UIApplication (XMNNavigation)

#pragma mark - Getters

- (UINavigationController *)navigationController {
    
    if ([self.keyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)self.keyWindow.rootViewController;
    }else if ([self.keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UIViewController *selectedViewController = [(UITabBarController *)self.keyWindow.rootViewController selectedViewController];
        if ([selectedViewController isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)selectedViewController;
        }
    }
    return nil;
}

- (UIViewController *)topViewController {
    
    if (self.navigationController) {
        
        if ([self.navigationController isKindOfClass:[XMNNavigationController class]]) {
            return [(XMNNavigationController *)self.navigationController xmn_visiableController];
        }
        return self.navigationController.visibleViewController;
    }else {
        return self.keyWindow.rootViewController;
    }
}

@end
