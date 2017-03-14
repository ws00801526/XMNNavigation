//
//  XMNBubbleTransition.h
//  Demo
//
//  Created by XMFraker on 16/11/28.
//  Copyright © 2016年 Fancy Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XMNBubbleTransitionMode) {
    XMNBubbleTransitionModePresent,
    XMNBubbleTransitionModeDismiss,
    XMNBubbleTransitionModePop,
};

@interface XMNBubbleTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) XMNBubbleTransitionMode mode;
@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) CGPoint startPoint;
@property (strong, nonatomic) UIColor *bubbleColor;

@end
