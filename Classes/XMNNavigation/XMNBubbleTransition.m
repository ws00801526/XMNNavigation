//
//  XMNBubbleTransition.m
//  Demo
//
//  Created by XMFraker on 16/11/28.
//  Copyright © 2016年 Fancy Pixel. All rights reserved.
//

#import "XMNBubbleTransition.h"

@interface XMNBubbleTransition () <UIViewControllerAnimatedTransitioning>

@property (strong, nonatomic) UIView *bubbleView;

@end

@implementation XMNBubbleTransition

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.mode = XMNBubbleTransitionModePresent;
        self.duration = .5f;
        self.bubbleColor = [UIColor whiteColor];
        
        self.bubbleView = [[UIView alloc] init];
        self.bubbleView.backgroundColor = self.bubbleColor;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = [transitionContext containerView];
    
    if (self.mode == XMNBubbleTransitionModePresent) {
        
        UIView *presentedControllerView = [transitionContext viewForKey:UITransitionContextToViewKey];
        CGPoint originCenter = presentedControllerView.center;
        CGSize originSize = presentedControllerView.frame.size;

        self.bubbleView.frame = [XMNBubbleTransition frameForBubbleView:self.startPoint
                                                             originSize:originSize
                                                           originCenter:originCenter];
        self.bubbleView.layer.cornerRadius = self.bubbleView.bounds.size.height/2.f;
        self.bubbleView.center = self.startPoint;
        self.bubbleView.transform = CGAffineTransformMakeScale(.0001, .0001);
        self.bubbleView.backgroundColor = self.bubbleColor;
        [containerView addSubview:self.bubbleView];
        
        
        presentedControllerView.center = self.startPoint;
        presentedControllerView.transform = CGAffineTransformMakeScale(.0001, .0001);
        presentedControllerView.alpha = .0f;
        [containerView addSubview:presentedControllerView];
        
        [UIView animateWithDuration:self.duration animations:^{
            
            self.bubbleView.transform = CGAffineTransformIdentity;
            presentedControllerView.transform = CGAffineTransformIdentity;
            presentedControllerView.alpha = 1.f;
            presentedControllerView.center = originCenter;
        } completion:^(BOOL finished) {
            [self.bubbleView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }else {
        UIView *returningControllerView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        CGPoint originCenter = returningControllerView.center;
        CGSize originSize = returningControllerView.bounds.size;
        
        self.bubbleView.frame = [XMNBubbleTransition frameForBubbleView:self.startPoint
                                                             originSize:originSize
                                                           originCenter:originCenter];
        self.bubbleView.layer.cornerRadius = self.bubbleView.bounds.size.height/2.f;
        self.bubbleView.center = self.startPoint;
        
        
        [containerView addSubview:[transitionContext viewForKey:UITransitionContextToViewKey]];
        [containerView addSubview:self.bubbleView];
        [containerView addSubview:returningControllerView];
        
        [UIView animateWithDuration:self.duration animations:^{
            
            self.bubbleView.transform = CGAffineTransformMakeScale(.0001, .0001);
            returningControllerView.transform = CGAffineTransformMakeScale(.0001, .0001);
            returningControllerView.center = self.startPoint;
            returningControllerView.alpha = .0f;
        } completion:^(BOOL finished) {

            [returningControllerView removeFromSuperview];
            [self.bubbleView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
    
}


- (void)setBubbleColor:(UIColor *)bubbleColor {
    
    _bubbleColor = bubbleColor;
    self.bubbleView.backgroundColor = bubbleColor;
}

+ (CGRect)frameForBubbleView:(CGPoint)startPoint
                  originSize:(CGSize)originSize
                originCenter:(CGPoint)originCenter {
    
    CGFloat lengthX = fmax(startPoint.x, originSize.width - startPoint.x);
    CGFloat lengthy = fmax(startPoint.y, originSize.height - startPoint.y);
    
    CGFloat offset = sqrt(lengthX * lengthX + lengthy * lengthy) * 2;
    return CGRectMake(0, 0, offset, offset);
}

@end
