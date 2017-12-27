//
//  XMNNavigationController.m
//  XMNNavigationExample
//
//  Created by XMFraker on 16/11/24.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNNavigationController.h"
#import <objc/runtime.h>
#import "UIViewController+XMNNavigation.h"

@implementation NSArray (XMNNavigationPrivate)

- (NSArray *)xmn_map:(id(^)(id obj, NSInteger index))block {
    
    if (!block) {
        
        block = ^id(id obj ,NSInteger index){
            return obj;
        };
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [array addObject:block(obj,idx)];
    }];
    return [NSArray arrayWithArray:array];
}

- (BOOL)xmn_any:(BOOL(^)(id obj))block {
    
    if (!block || !self || !self.count) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (block(obj)) {
            ret = YES;
            *stop = YES;
        }
    }];
    return ret;
}

@end

@interface XMNContainerController ()

@property (nonatomic, strong) UINavigationController *containerNavigationController;

- (instancetype)initWithContentViewController:(__kindof UIViewController *)contentViewController;

@end

@interface XMNContainerNavigationController ()

@end

@interface XMNNavigationController () <UINavigationControllerDelegate>

@property (weak, nonatomic)   id<UINavigationControllerDelegate> xmn_delegate;
@property (copy, nonatomic)   void(^animationCompletionBlock)(BOOL finished);

@end

static inline UIViewController *XMNSafeWrapViewController(UIViewController *controller) {
    
    /** !!!warning 注意此处需要判断controller 是否已经是XMNContainerController 防止重复 */
    if (!controller || [controller isKindOfClass:[XMNContainerController class]]) {
        return controller;
    }
    return [[XMNContainerController alloc] initWithContentViewController:controller];
}

static inline UIViewController *XMNSafeUnWrapViewController(UIViewController *controller) {

    if (controller && [controller isKindOfClass:[XMNContainerController class]]) {
        
        XMNContainerController *containerC = (XMNContainerController *)controller;
        return containerC.contentViewController ? : controller;
    }
    return controller;
}

#pragma mark - XMNContainerController

@implementation XMNContainerController

- (instancetype)initWithContentViewController:(__kindof UIViewController *)contentViewController {
    
    if (self = [super init]) {
        
        self.containerNavigationController = [[XMNContainerNavigationController alloc] initWithRootViewController:contentViewController];
        [self addChildViewController:self.containerNavigationController];
        [self.containerNavigationController didMoveToParentViewController:self];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.containerNavigationController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.containerNavigationController.view];
    self.containerNavigationController.view.frame = self.view.bounds;
}

- (UIViewController *)contentViewController {
    
    return [self.containerNavigationController.viewControllers firstObject];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return [self.contentViewController preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
    
    return [self.contentViewController prefersStatusBarHidden];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return [self.contentViewController preferredStatusBarUpdateAnimation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return [self.contentViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate {
    
    return self.contentViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return self.contentViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return self.contentViewController.preferredInterfaceOrientationForPresentation;
}

- (nullable UIView *)rotatingHeaderView {
    
    return self.contentViewController.rotatingHeaderView;
}

- (nullable UIView *)rotatingFooterView {
    
    return self.contentViewController.rotatingFooterView;
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action
                                      fromViewController:(UIViewController *)fromViewController
                                              withSender:(id)sender {
    
    return [self.contentViewController viewControllerForUnwindSegueAction:action
                                                       fromViewController:fromViewController
                                                               withSender:sender];
}

- (BOOL)hidesBottomBarWhenPushed {
    
    return self.contentViewController.hidesBottomBarWhenPushed;
}

- (NSString *)title {
    
    return self.contentViewController.title;
}

- (UITabBarItem *)tabBarItem {
    
    return self.contentViewController.tabBarItem;
}

@end

#pragma mark - XMNContainerNavigationController

@implementation XMNContainerNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    
    NSAssert(rootViewController, @"rootViewController cannot be nil");
    
    if (self = [super initWithNavigationBarClass:rootViewController.xmn_navigationBarClass toolbarClass:nil]) {
        [self pushViewController:rootViewController animated:NO];
        [self setNavigationBarHidden:rootViewController.xmn_prefersNavigationBarHidden];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Weverything"
        if ([rootViewController respondsToSelector:@selector(xmn_configControllerStyle)]) {
            [rootViewController performSelector:@selector(xmn_configControllerStyle)];
        }
#pragma clang diagnostic pop
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (self.navigationController && [self.viewControllers firstObject].transferNavigationBarAttributes) {
        
        self.navigationBar.translucent     = self.navigationController.navigationBar.isTranslucent;
        self.navigationBar.tintColor       = self.navigationController.navigationBar.tintColor;
        self.navigationBar.barTintColor    = self.navigationController.navigationBar.barTintColor;
        self.navigationBar.barStyle        = self.navigationController.navigationBar.barStyle;
        self.navigationBar.backgroundColor = self.navigationController.navigationBar.backgroundColor;
        
        [self.navigationBar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault]
                                 forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setTitleVerticalPositionAdjustment:[self.navigationController.navigationBar titleVerticalPositionAdjustmentForBarMetrics:UIBarMetricsDefault]
                                                 forBarMetrics:UIBarMetricsDefault];
        
        self.navigationBar.titleTextAttributes              = self.navigationController.navigationBar.titleTextAttributes;
        self.navigationBar.shadowImage                      = self.navigationController.navigationBar.shadowImage;
        self.navigationBar.backIndicatorImage               = self.navigationController.navigationBar.backIndicatorImage;
        self.navigationBar.backIndicatorTransitionMaskImage = self.navigationController.navigationBar.backIndicatorTransitionMaskImage;
    }else {
        self.navigationBar.translucent = NO;
    }
    
    [self.view layoutIfNeeded];
}


/// ========================================
/// @name   保证叫containerNavigationController
/// 的相关方法转移到正确的navigationController上
/// ========================================

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action
                                      fromViewController:(UIViewController *)fromViewController
                                              withSender:(id)sender {
    
    if (self.navigationController) {
        return [self.navigationController viewControllerForUnwindSegueAction:action
                                                          fromViewController:self.parentViewController
                                                                  withSender:sender];
    }
    return [super viewControllerForUnwindSegueAction:action
                                  fromViewController:fromViewController
                                          withSender:sender];
}

- (NSArray<UIViewController *> *)allowedChildViewControllersForUnwindingFromSource:(UIStoryboardUnwindSegueSource *)source {
    
    if (self.navigationController) {
        return [self.navigationController allowedChildViewControllersForUnwindingFromSource:source];
    }
    return [super allowedChildViewControllersForUnwindingFromSource:source];
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated {
    
    if (self.navigationController) {
        [self.navigationController pushViewController:viewController
                                             animated:animated];
    }
    else {
        [super pushViewController:viewController
                         animated:animated];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    if (self.navigationController)
        return [self.navigationController popViewControllerAnimated:animated];
    return [super popViewControllerAnimated:animated];
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    
    if (self.navigationController)
        return [self.navigationController popToRootViewControllerAnimated:animated];
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController
                                                     animated:(BOOL)animated {
    
    if (self.navigationController)
        return [self.navigationController popToViewController:viewController
                                                     animated:animated];
    return [super popToViewController:viewController
                             animated:animated];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    
    if (self.navigationController)
        [self.navigationController setViewControllers:viewControllers
                                             animated:animated];
    else
        [super setViewControllers:viewControllers animated:animated];
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    
    if (self.navigationController)
        self.navigationController.delegate = delegate;
    else
        [super setDelegate:delegate];
}

@end

#pragma mark - XMNNavigationController

@implementation XMNNavigationController

#pragma mark - XMNNavigationController Life Cycle

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    
    self = [super initWithRootViewController:XMNSafeWrapViewController(rootViewController)];
    
    return self;
}

#pragma mark - XMNNavigationController Override Method

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super setDelegate:self];
    [super setNavigationBarHidden:YES animated:NO];
}

/**
 重写awakeFromNib 将xib中的navigationController.viewControllers 包裹下
 *
 */
- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.viewControllers = [super viewControllers];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    
    /** override 防止外部再次调用 */
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    
    NSArray *viewCs = [viewControllers xmn_map:^id(UIViewController *obj, NSInteger index) {
       
        return XMNSafeWrapViewController(obj);
    }];
    [super setViewControllers:viewCs animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [super pushViewController:XMNSafeWrapViewController(viewController) animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    return XMNSafeUnWrapViewController([super popViewControllerAnimated:animated]);
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    
    return [[super popToRootViewControllerAnimated:animated] xmn_map:^id(__kindof UIViewController *obj, NSInteger index) {
       
        return XMNSafeUnWrapViewController(obj);
    }];
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController
                                                     animated:(BOOL)animated
{
    __block UIViewController *popC = nil;
    
    /** 检测当前viewControllers 栈内是否存在viewController */
    [[super viewControllers] enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        if (XMNSafeUnWrapViewController(obj) == viewController) {
            popC = obj;
            *stop = YES;
        }
    }];

    if (popC) {
        return [[super popToViewController:popC animated:animated] xmn_map:^id(__kindof UIViewController *obj, NSInteger index) {
            return XMNSafeUnWrapViewController(obj);
        }];
    }
    return nil;
}

#pragma mark - XMNNavigationController Public Method

- (void)pushViewController:(UIViewController * __nonnull)viewController
           completionBlock:(void(^__nullable )(BOOL finished))completionBlock {
    
    if (self.animationCompletionBlock) {
        self.animationCompletionBlock(NO);
    }
    self.animationCompletionBlock = completionBlock;
    [self pushViewController:viewController animated:YES];
}

- (UIViewController * __nullable)popViewControllerWithCompletionBlock:(void(^__nullable )(BOOL finished))completionBlock {
    
    if (self.animationCompletionBlock) {
        self.animationCompletionBlock(NO);
    }
    self.animationCompletionBlock = completionBlock;
    return [self popViewControllerAnimated:YES];
}

- (NSArray<UIViewController *> * __nullable)popToViewController:(UIViewController * __nonnull)viewController
                                                completionBlock:(void(^ __nullable)(BOOL finished))completionBlock {
    
    if (self.animationCompletionBlock) {
        self.animationCompletionBlock(NO);
    }
    self.animationCompletionBlock = completionBlock;
    return [self popToViewController:viewController animated:YES];
}

- (NSArray<UIViewController *> * __nullable)popToRootViewController:(void(^ __nullable)(BOOL finished))completionBlock {
    
    if (self.animationCompletionBlock) {
        self.animationCompletionBlock(NO);
    }
    self.animationCompletionBlock = completionBlock;
    return [self popToRootViewControllerAnimated:YES];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers completionHandler:(void(^)(BOOL finished))completionHandler {
    
    NSAssert((viewControllers && viewControllers.count), @"viewControllers.count should not be empty");
    if (self.animationCompletionBlock) {
        self.animationCompletionBlock(NO);
    }
    self.animationCompletionBlock = completionHandler;
    [self setViewControllers:viewControllers animated:YES];
}

- (void)removeViewController:(__kindof UIViewController * __nonnull)viewController {
    
    [self removeViewController:viewController animated:NO];
}

- (void)removeViewController:(__kindof UIViewController * __nonnull)viewController
                    animated:(BOOL)animated {
    
    if (!viewController) {
        return;
    }

    NSMutableArray<__kindof UIViewController *> *controllers = [self.viewControllers mutableCopy];
    __block UIViewController *controllerToRemove = nil;
    [controllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (XMNSafeUnWrapViewController(obj) == viewController) {
            controllerToRemove = obj;
            *stop = YES;
        }
    }];
    
    if (controllerToRemove) {
        [controllers removeObject:controllerToRemove];
        [super setViewControllers:[controllers copy] animated:animated];
    }
}

#pragma mark - UINavigationController Delegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {

    if ([self.xmn_delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.xmn_delegate navigationController:navigationController
                        willShowViewController:viewController
                                      animated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {

    [XMNNavigationController attemptRotationToDeviceOrientation];
    
    if (self.animationCompletionBlock) {
        self.animationCompletionBlock(YES);
        self.animationCompletionBlock = nil;
    }
    
    if ([self.xmn_delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [self.xmn_delegate navigationController:navigationController
                         didShowViewController:viewController
                                      animated:animated];
    }
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    
    if ([self.xmn_delegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)]) {
        return [self.xmn_delegate navigationControllerSupportedInterfaceOrientations:navigationController];
    }
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController {
    
    if ([self.xmn_delegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)]) {
        return [self.xmn_delegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
    }
    return UIInterfaceOrientationPortrait;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    
    if ([self.xmn_delegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
        return [self.xmn_delegate navigationController:navigationController
          interactionControllerForAnimationController:animationController];
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    
    if ([self.xmn_delegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [self.xmn_delegate navigationController:navigationController
                      animationControllerForOperation:operation
                                   fromViewController:fromVC
                                     toViewController:toVC];
    }
    return nil;
}

#pragma mark - XMNNavigationController Setter

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    
    self.xmn_delegate = delegate;
}

#pragma mark - XMNNavigationController Getter

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return [super.topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate {
    
    return super.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return super.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return super.topViewController.preferredInterfaceOrientationForPresentation;
}

- (nullable UIView *)rotatingHeaderView {
    
    return super.topViewController.rotatingHeaderView;
}

- (nullable UIView *)rotatingFooterView {
    
    return super.topViewController.rotatingFooterView;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    return [self.xmn_delegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    return self.xmn_delegate;
}


- (UIViewController *)xmn_topViewController {
    
    return XMNSafeUnWrapViewController(self.topViewController);
}

- (UIViewController *)xmn_visiableController {
    
    return XMNSafeUnWrapViewController([super visibleViewController]);
}

- (NSArray *)xmn_viewControllers {
    
    return [[super viewControllers] xmn_map:^id(__kindof UIViewController *obj, NSInteger index) {
       
        return XMNSafeUnWrapViewController(obj);
    }];
    return self.viewControllers;
}

@end
